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
forever:
	jmp forever
