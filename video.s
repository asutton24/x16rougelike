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
draw_room_outline:
;room in main ptr
	ldy #$1
	lda ($7E),y
	tax
	iny
	lda ($7E),y
	pha
	lda #$E
	sta $3
	lda #$18
	sta $2
	iny
	iny
	lda ($7E),y
	pha
	dey
	lda ($7E),y
	tay
	pla
	jsr plot_vertical
	pla
	jsr plot_horizontal
	ldy #$2
	txa
	clc
	adc ($7E),y
	iny
	iny
	tax
	lda ($7E),y
	pha
	dey
	lda ($7E),y
	tay
	pla
	dex
	jsr plot_vertical
	tya
	ldy #$4
	clc
	adc ($7E),y
	tax
	dey
	dey
	lda ($7E),y
	pha
	dey
	lda ($7E),y
	pha
	txa
	tay
	pla
	tax
	pla
	dey
	jsr plot_horizontal
	rts
