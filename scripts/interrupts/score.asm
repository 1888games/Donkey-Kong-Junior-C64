SCORE:{


	KeyScore: .byte 10, 10
	UnlockScore: .byte 20
	JumpScore: .byte 1
	Value: .byte 0, 0, 0	// H M L
	.label Amount = TEMP1

	ScoreToAdd: .byte 0


	Reset:{

		lda #ZERO
		sta Value
		sta Value + 1
		sta Value + 2

		jsr Draw
		rts

	}



	AddToScore:{

		lda ScoreToAdd
		clc
		adc Amount
		sta ScoreToAdd
		rts


	}

	JumpEnemy: {

		lda JumpScore
		sta Amount
		jsr AddToScore
		rts

	}

	UnlockSection: {

		lda KeyScore
		sta Amount
		jsr AddToScore
		rts

	}

	UnlockCage:{

		lda UnlockScore
		sta Amount
		jsr AddToScore
		rts

	}


	CheckScoreToAdd:{

		lda ScoreToAdd
		beq Finish

		dec ScoreToAdd
		lda #ONE
		jsr Add

		Finish:

		rts


	}

	Add: {

		sta Amount
		sed
		clc
		lda Value
		adc Amount
		sta Value
		lda Value+1
		adc #ZERO
		sta Value+1
		lda Value+2
		adc #ZERO
		sta Value+2
		cld
		jsr Draw
		jsr SID.ScoreSound
		rts


	}


	Draw:{

		ldy #5	// screen offset, right most digit
		ldx #ZERO	// score byte index

		ScoreLoop:

			lda Value,x
			pha
			and #$0f	// keep lower nibble
			jsr PlotDigit
			pla
			lsr
			lsr
			lsr	
			lsr // shift right to get higher lower nibble
			jsr PlotDigit
			inx 
			cpx #3
			bne ScoreLoop

			rts

		PlotDigit: {

			clc
			adc #236
			sta SCREEN_RAM + 148, y
			dey
			rts


		}



		rts


	}



}