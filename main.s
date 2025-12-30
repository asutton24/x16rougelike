start:
	jsr screen_init
	jsr rand_init
	lda #$0
	jsr set_room_base
	jsr allocate_room
	jsr draw_room_outline	
	lda #$1
	jsr set_room_base
	jsr allocate_room
	jsr draw_room_outline	
	lda #$2
	jsr set_room_base
	jsr allocate_room
	jsr draw_room_outline	
	lda #$3
	jsr set_room_base
	jsr allocate_room
	jsr draw_room_outline	
	lda #$4
	jsr set_room_base
	jsr allocate_room
	jsr draw_room_outline	
forever:
	jmp forever
