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
	bne dont_tunnel
	lda #$F
	sta $8003
	lda #$23
dont_tunnel:
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
	clc
	sbc ($7E),y
	iny
	pha
	lda ($7E),y
	sec
	sbc #$2
	sta $2
	pla
	cmp $2
	bcs player_not_in_room
	iny
	lda $8001
	clc
	sbc ($7E),y
	iny
	pha
	lda ($7E),y
	sec
	sbc #$2
	sta $2
	pla
	cmp $2
	bcs player_not_in_room
	txa
	rts
player_not_in_room:
	jsr next_room
	inx
	jmp am_i_in_this_room
create_player_projectile:
	lda #$0
	sta $2
	sta $3
	jsr get_shooting_direction
	cmp #$0
	beq no_proj_to_create
	ldx $8000
	ldy $8001
	cmp #$8
	bne player_proj_not_up
	dey
	lda #$FF
	sta $3
	jmp player_proj_set
player_proj_not_up:
	cmp #$4
	bne player_proj_not_down
	iny
	lda #$1
	sta $3
	jmp player_proj_set
player_proj_not_down:
	cmp #$2
	bne player_proj_not_left
	dex
	lda #$FF
	sta $2
	jmp player_proj_set
player_proj_not_left:
	cmp #$1
	bne no_proj_to_create
	inx
	lda #$1
	sta $2
player_proj_set:
	lda #$1
	sta $6
	sta $5
	lda #$2F
	sta $4
	lda #$3
	jsr create_projectile
no_proj_to_create:
	rts
player_update:
	jsr what_room_am_i_in
	pha
	jsr make_player_move
	jsr what_room_am_i_in
	sta $60
	pla
	cmp $60
	beq same_enviornment
	cmp #$FF
	beq dont_unload_room
	jsr unload_room
dont_unload_room:
	lda $60
	cmp #$FF
	beq dont_load_room
	jsr load_room
	ldx $8000
	ldy $8001
	jsr init_player_pos
dont_load_room:
same_enviornment:
	jsr create_player_projectile
	rts
