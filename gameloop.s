main_loop_init:
main_game_loop:
	jsr RDTIM
	sta $3E
wait_for_frame_top:
	jsr RDTIM
	cmp $3E
	beq wait_for_frame_top
	sta $3E
wait_for_player_input:
	jsr are_buttons_pressed
	bcc wait_for_frame_top
	jsr make_player_move
wait_for_no_presses:
	jsr RDTIM
	sec
	sbc $3E
	sec
	sbc #$8
	beq main_game_loop
	jsr are_buttons_pressed
	bcs wait_for_no_presses
	bcc main_game_loop
