screen_init:
	lda #$0
	jsr screen_mode
	lda #$11
;Do not edit 9F22!
	sta $9F22
clear_screen:
	lda #$0
	sta $9F20
	lda #$B0
	sta $9F21
clr_scr_loop:
	jsr clear_line
	inc $9F21
	lda $9F21
	cmp #$EC
	bne clr_scr_loop
	rts
clear_line:
	lda #$0
	sta $9F20
clr_line_loop:
	lda #$0
	sta $9F23
	lda $9F20
	cmp #$A0
	bne clr_line_loop
	rts
plot_point:
;position in x and y, char in r0l, color in r0h
	txa
	asl
	sta $9F20
	tya
	clc
	adc #$B0
	sta $9F21
	lda $2
	sta $9F23
	lda $3
	sta $9F23
	rts
