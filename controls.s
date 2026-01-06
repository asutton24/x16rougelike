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
