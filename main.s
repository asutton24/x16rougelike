start:
	jsr screen_init
	jsr rand_init
	lda #$0
	jsr set_room_base
	jsr allocate_room
	jsr draw_room_exterior
	lda #$1
	jsr set_room_base
	jsr allocate_room
	jsr draw_room_exterior	
	lda #$2
	jsr set_room_base
	jsr allocate_room
	jsr draw_room_exterior	
	lda #$3
	jsr set_room_base
	jsr allocate_room
	jsr draw_room_exterior	
	lda #$4
	jsr set_room_base
	jsr allocate_room
	jsr draw_room_exterior
	ldx #$0
	ldy #$0
	jsr init_player_pos
	jmp wait_for_no_presses
forever:
	jsr are_buttons_pressed
	bcc forever
	jsr make_player_move
wait_for_no_presses:
	jsr are_buttons_pressed
	bcs wait_for_no_presses
	jmp forever
