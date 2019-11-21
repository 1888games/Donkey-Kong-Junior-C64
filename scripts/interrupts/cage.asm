CAGE:{

	Frames: 	.byte 88, 85, 89, 90
	XPos:		.byte 82, 62, 62, 85
	YPos:		.byte 65, 65, 88, 88
	Pointers:	.byte 0, 5, 6 , 7
	PointerOne: .byte 0, 4

	EnableFlags:	.byte %00000001, %00100000,%01000000,%10000000
	OneFlags: 		.byte %00000001, %00010000
	CurrentFlag: 	.byte %10000000

	SectionsUnlocked: .byte 0
	ShowUnlockedSections: .byte 0
	FlashCounter: .byte 2, 2
	SectionUnlocked: .byte 0,0,0,0

	.label FinalSection = SectionUnlocked + 3
	.label MouthCharacterID = 167
	.label SmileCharacter = 254
	.label SadCharacter = 18

	LockCage: {

		lda #ZERO
		sta SectionUnlocked
		sta SectionUnlocked + 1
		sta SectionUnlocked + 2
		sta SectionUnlocked + 3

		lda #ZERO
		sta SectionsUnlocked

		jsr Sad

	}


	Sad:{

		lda #SadCharacter
		ldx #MouthCharacterID
		sta SCREEN_RAM, x
		rts

	}

	Smile:{

		lda #SmileCharacter
		ldx #MouthCharacterID
		sta SCREEN_RAM, x
		rts

	}

	Reset:{

	
		lda #ZERO	
		sta ShowUnlockedSections
		sta Pointers
		ldx #ZERO
		lda OneFlags,x
		sta EnableFlags
		lda FlashCounter + 1
		sta FlashCounter

		rts


	}

	Draw:{

		ldx #3

		lda VIC.SPRITE_ENABLE
		ora #%11110000
		sta VIC.SPRITE_ENABLE

		lda VIC.SPRITE_MSB
		and #%00001111
		sta VIC.SPRITE_MSB

		lda MONKEY.GoingForKey
		bne EndLoop

		NotGoingForKey:

		lda VIC.SPRITE_ENABLE
		ora #%11100001
		sta VIC.SPRITE_ENABLE



		Loop:

			lda SectionsUnlocked
			cmp #4
			beq TurnOff

			lda SectionUnlocked, x
			beq TurnOn
			lda ShowUnlockedSections
			bne TurnOn

			TurnOff:

			lda Pointers, x
			rol
			tay
			lda #ZERO
			sta VIC.SPRITE_0_X, y
			jmp FinishSection



		TurnOn:

		
			ldy Pointers, x
			lda Frames, x
			clc
			adc #64
			sta SPRITE_POINTERS, y
			lda #BLACK
			sta VIC.SPRITE_COLOR_0, y
			lda Pointers, x
			rol
			tay
			lda XPos, x
			sta VIC.SPRITE_0_X, y
			lda YPos, x
			sta VIC.SPRITE_0_Y, y
			//lda EnableFlags, x
			//sta CurrentFlag
			//lda #11111111
		//	ora #CurrentFlag
			//sta VIC.SPRITE_ENABLE




		FinishSection:

			cpx #ZERO
			beq EndLoop
			dex
			jmp Loop


		EndLoop:

			rts





	}


	Update:{

		dec FlashCounter
		beq Switch
		jmp CheckMonkeyPosition

		Switch:

		
			lda FlashCounter + 1
			sta FlashCounter

			lda ShowUnlockedSections
			beq TurnOn
			dec ShowUnlockedSections
			jmp CheckMonkeyPosition

			TurnOn:

			inc ShowUnlockedSections

		CheckMonkeyPosition:
			ldx MONKEY.AtCage
			lda PointerOne, x
			sta Pointers
			lda OneFlags, x
			sta EnableFlags

			lda ShowUnlockedSections
		
			rts



	}

}