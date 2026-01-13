get_player_input:
;carry is set if a physical controller is used
	lda #$1
    jsr joystick_get
    pha
    tya
	beq use_controller_input
	pla
	lda #$0
	jsr joystick_get
	clc
	jmp invert_input
use_controller_input:
    pla
	sec
	jmp invert_input
are_buttons_pressed:
	jsr get_player_input
	cmp #$0
	bne something_pressed
	txa
	and #$F0
	cmp #$0
	bne something_pressed
	clc
something_pressed:
	rts
invert_input:
	pha
	txa
	eor #$FF
	tax
	pla
	eor #$FF
	rts
get_dpad_direction:
;0 for none (or more than one), 8 for up, 4 for down, 2 for left, 1 for right
	jsr get_player_input
	and #$F
	cmp #$8
	beq valid_dpad
	cmp #$4
	beq valid_dpad
	cmp #$2
	beq valid_dpad
	cmp #$1
	beq valid_dpad
	lda #$0
valid_dpad:
	rts
get_shooting_direction:
;0 for none (or more than one), 8 for up, 4 for down, 2 for left, 1 for right
	jsr get_player_input
	bcs check_abxy_controller
	tay
	txa
	cmp #$40
	bne not_keyboard_s
	lda #$8
	rts
not_keyboard_s:
	cmp #$80
	bne not_keyboard_x
	lda #$4
	rts
not_keyboard_x:
	tya
	cmp #$80
	bne not_keyboard_z
	lda #$2
	rts
not_keyboard_z:
	txa
	cmp #$10
	bne not_any_shooting
	lda #$1
	rts
not_any_shooting:
	lda #$0
	rts
check_abxy_controller:
	tay
	txa
	cmp #$40
	bne not_controller_x
	lda #$8
	rts
not_controller_x:
	tya
	cmp #$80
	bne not_controller_b
	lda #$4
	rts
not_controller_b:
	cmp #$40
	bne not_controller_y
	lda #$2
	rts
not_controller_y:
	txa
	cmp #$80
	bne not_any_shooting
	lda #$1
	rts
