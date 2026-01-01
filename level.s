set_room_base:
	clc
	ror
	ror
	ror
	sta $7E
	lda #$BE
	adc #$0
	sta $7F
	rts
align_to_room_base:
	lda $7E
	and #$C0
	sta $7E
	rts
next_room:
	clc
	lda $7E
	adc #$40
	sta $7E
	lda $7F
	adc #$0
	sta $7F
	rts
make_dummy_room:
	lda #$8
	jsr rand_int
	clc
	adc #$5
	ldy #$2
	sta ($7E),y
	lda #$8
	jsr rand_int
	clc
	adc #$5
	ldy #$4
	sta ($7E),y
	lda #$4A
	sec
	ldy #$2
	sbc ($7E),y
	jsr rand_int
	ldy #$1
	clc
	adc #$3
	sta ($7E),y 
	lda #$2C
	sec
	ldy #$4
	sbc ($7E),y
	jsr rand_int
	ldy #$3
	clc
	adc #$3
	sta ($7E),y
	rts
check_room_validity:
	jsr swap_ptrs
	lda #$BE
	sta $7F
	lda #$0
	sta $7E
room_check_loop:
	jsr ptrs_equal
	bne do_room_check
	jsr swap_ptrs
	clc
	rts
do_room_check:
	ldy #$4
	ldx #$3
room_check_copy:
	lda ($7C),y
	sta $2,x
	lda ($7E),y
	sta $6,x
	dex
	dey
	bne room_check_copy
	jsr next_room
	jsr rectangle_collide
	bcc room_check_loop
	jsr swap_ptrs
	sec
	rts
allocate_room:
	jsr make_dummy_room
	jsr check_room_validity
	bcs allocate_room
	rts
