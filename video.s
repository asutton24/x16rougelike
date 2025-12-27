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
xy_to_vram:
	txa
	asl
	sta $9F20
	tya
	clc
	adc #$B0
	sta $9F21
	rts
plot_point:
;position in x and y, char in r0l, color in r0h
	jsr xy_to_vram
plot_at_vram:
	lda $2
    sta $9F23
	lda $3
	sta $9F23
	rts
plot_horizontal:
;pos in x/y, length in a, char in r0l, color in r0h
	pha
	jsr xy_to_vram
plot_hori_loop:
	jsr plot_at_vram
	pla
	sec
	sbc #$1
	pha
	bne plot_hori_loop
	pla
	rts
plot_vertical:
    pha
	jsr xy_to_vram
plot_vert_loop:
	jsr plot_at_vram
	dec $9F20
	dec $9F20
	inc $9F21
	pla
	sec
	sbc #$1
	pha
	bne plot_vert_loop
	pla
	rts
get_point:
;position in x and y, char stored in r0l, color in r0h
	txa
	asl
	sta $9F20
	tya
	clc
	adc #$B0
	sta $9F21
	lda $9F23
	sta $2
	lda $9F23
	sta $2

