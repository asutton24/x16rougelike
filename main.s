ram_init:
	lda #$81
	sta $7F
	lda #$0
	tay
	sta $7E
resetting_projectiles:
	lda #$0
	sta ($7E),y
	jsr next_projectile
	lda $7E
	cmp #$80
	bne resetting_projectiles
	rts
start:
	jsr ram_init
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
	lda #$5
	jsr set_room_base
	jsr clear_room
	ldx #$0
	ldy #$0
	jsr init_player_pos
	jmp main_loop_init
