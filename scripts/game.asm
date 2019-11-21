MAIN: {

#import "lookups/zeropage.asm"

BasicUpstart2(Entry)

#import "lookups/labels.asm"
#import "lookups/vic.asm"
#import "lookups/sid.asm"
#import "lookups/registers.asm"
#import "interrupts/irq.asm"
#import "setup/macros.asm"
#import "setup/maploader.asm"
#import "interrupts/monkey.asm"
#import "interrupts/key.asm"
#import "interrupts/cage.asm"
#import "interrupts/score.asm"
#import "interrupts/lives.asm"
#import "interrupts/enemies.asm"

PerformFrameCodeFlag: .byte $00
GameCounter:		.byte 5, 25
GameTickFlag:	.byte $00

Entry:
		

		jsr IRQ.DisableCIA
		jsr REGISTERS.BankOutKernalAndBasic
		jsr VIC.SetupRegisters
		jsr VIC.SetupColours
		jsr SID.Initialise
		jsr MAPLOADER.DrawMap
		jsr KEY.Initialise
		jsr MONKEY.Initialise
		jsr IRQ.SetupInterrupts
		jsr Random.init


		jsr NewGame

		//ldy #ZERO
		//jsr ENEMIES.Spawn

		// ldy #ZERO
		// jsr ENEMIES.Spawn

		// ldy #ONE
		// jsr ENEMIES.Spawn
		
		jmp MainLoop



NewGame: {

		jsr SCORE.Reset
		jsr LIVES.Reset
 		jsr ENEMIES.Reset

		rts
	
}


MainLoop: {

		lda PerformFrameCodeFlag
		beq GameTick
		dec PerformFrameCodeFlag
		jmp FrameCode
}

CheckWhetherToUpdateScore: {

		lda ZP_COUNTER
		and #3
		bne NoScoreAdd

		jsr SCORE.CheckScoreToAdd

		NoScoreAdd:
			jmp MainLoop
}


FrameCode: {
		
		inc ZP_COUNTER

		jsr CheckWhetherToUpdateScore

}	



GameTick: {
	
		lda GameTickFlag
		beq MainLoop
		dec GameTickFlag

		jsr KEY.Update
		jsr CAGE.Update
		jsr ENEMIES.Update

		lda KEY.Active
		beq Finish

		jsr Random
		cmp #50
		bcc DoZero
		cmp #205
		bcs Finish

		ldy #ONE
		jsr ENEMIES.Spawn
		jmp Finish

		DoZero:
			ldy #ZERO
		 	jsr ENEMIES.Spawn

		Finish:
		
		lda MONKEY.DisableControl
		bne MainLoop

		jsr SID.TickSound
		jmp MainLoop
}


Random: {
        lda seed
        beq doEor
        asl
        beq noEor
        bcc noEor
    doEor:    
        eor #$1d
        eor $dc04
        eor $dd04
    noEor:  
        sta seed
        rts
    seed:
        .byte $62


    init:
        lda #$ff
        sta $dc05
        sta $dd05
        lda #$7f
        sta $dc04
        lda #$37
        sta $dd04

        lda #$91
        sta $dc0e
        sta $dd0e
        rts
}


#import "setup/assets.asm"

} 