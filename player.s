init_player_pos:
;pos in xy
	stx $8000
	sty $8001
	jsr get_point
	lda $2
	sta $8002
	lda $3
	sta $8003
	lda #$0
	sta $2
	lda #$1
	sta $3
	jmp plot_point
update_player_pos:
;new pos in xy
	txa
	pha
	tya
	pha
	ldx $8000
	ldy $8001
	lda $8002
	sta $2
	lda $8003
	sta $3
	jsr plot_point
	pla
	tay
	pla
	tax
	jmp init_player_pos
invalid_player_move:
	rts
make_player_move:
	jsr get_dpad_direction
	cmp #$0
	beq invalid_player_move
	ldx $8000
	ldy $8001
	cmp #$8
	bne not_move_up
	dey
	jmp valid_player_move
not_move_up:
	cmp #$4
	bne not_move_down
	iny
	jmp valid_player_move
not_move_down:
	cmp #$2
	bne not_move_left
	dex
	jmp valid_player_move
not_move_left:
	inx
valid_player_move:
	jsr get_point
	lda $2
	cmp #$18
	beq invalid_player_move
	jmp update_player_pos
what_room_am_i_in:
	lda #$0
	sta $7E
	lda #$BE
	sta $7F
	ldx #$0
am_i_in_this_room:
	ldy #$0
	lda ($7E),y
	bne could_be_in_room
	lda #$FF
	rts
could_be_in_room:
	ldy #$1
	lda $8000
	sec
	sbc ($7E),y
	iny
	cmp ($7E),y
	bcs player_not_in_room
	iny
	lda $8001
	sec
	sbc ($7E),y
	iny
	cmp ($7E),y
	bcs player_not_in_room
	txa
	rts
player_not_in_room:
	jsr next_room
	inx
	jmp am_i_in_this_room
