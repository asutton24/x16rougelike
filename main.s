start:
	jsr screen_init
	lda #$0
	pha
plot_loop:
	ldx #$F
	ldy #$F
	pla
	clc
	adc #$1
	pha
	sec
	sbc #$1
	sta $2
	sta $3
	jsr plot_point
	ldx #$3C
	stx $61
	jsr clock
	jmp plot_loop
forever:
	jmp forever
clock:
	jsr wait_one_jiffy
	ldx $61
	dex
	stx $61
	bne clock
	rts	
