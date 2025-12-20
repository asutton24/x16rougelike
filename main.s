start:
	jsr rand_init
	lda #$5
	jsr rand_int
	sta $40
	lda #$5
	jsr rand_int
	sta $41
	lda #$5
	jsr rand_int
	sta $42
	lda #$5
	jsr rand_int
	sta $43
	lda #$5
	jsr rand_int
	sta $44
	rts
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
