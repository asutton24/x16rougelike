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
	jsr xy_to_vram
	lda $9F23
	sta $2
	lda $9F23
	sta $3
	rts
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
draw_room_doors:
	lda #$2B
	sta $2
	lda #$D
	sta $3
	ldy #$2
	lda ($7E),y
	dey
	lsr
	clc
	adc ($7E),y
	tax
	iny
	iny
	lda ($7E),y
	tay
	jsr plot_point
	tya
	ldy #$4
	adc ($7E),y
	tay
	dey
	jsr plot_point
	ldy #$4
	lda ($7E),y
	dey
	lsr
	clc
	adc ($7E),y
	pha
	pha
	dey
	dey
	lda ($7E),y
	tax
	pla
	tay
	jsr plot_point
	ldy #$2
	clc
	txa
	adc ($7E),y
	tax
	dex
	pla
	tay
	jmp plot_point
draw_room_exterior:
	jsr draw_room_outline
	jmp draw_room_doors
clear_room_interior:
	lda #$0
	sta $2
	sta $3
draw_floor_shortcut:
	ldy #$1
	lda ($7E),y
	iny
	clc
	adc ($7E),y
	sec
	sbc #$2
	tax
	iny
	iny
	lda ($7E),y
	sec
	sbc #$2
	pha
	dey
	lda ($7E),y
	clc
	adc #$1
	tay
clear_room_int_loop:
	pla
	pha
	jsr plot_vertical
	dex
	tya
	pha
	ldy #$1
	txa
	cmp ($7E),y
	beq room_clear_finished
	pla
	tay
	jmp clear_room_int_loop
room_clear_finished:
	pla
	pla
	rts
draw_room_floor:
	lda #$2E
	sta $2
	lda #$F
	sta $3
	jmp draw_floor_shortcut
draw_room_interior:
	jsr draw_room_floor
	rts
