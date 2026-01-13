set_projectile_base:
	asl
	asl
	asl
	sta $7E
	lda #$81
	sta $7F
	rts
next_projectile:
	lda $7E
	and #$F8
	clc
	adc #$8
	sta $7E
	rts
find_available_projectile:
	lda #$0
	tay
	sta $7E
	lda #$81
	sta $7F
find_avail_proj_loop:
	lda ($7E),y
	clc
	beq found_avail_proj
	jsr next_projectile
	bpl find_avail_proj_loop
	sec
found_avail_proj:
no_avail_proj:
	rts
create_projectile:
;pos in xy, char in r1, lifetime in a, velocity in r0, type in r2l
	pha
	tya
	pha
	jsr find_available_projectile
	pla
	tay
	pla
	bcs no_avail_proj
	pha
	tya
	ldy #$2
	sta ($7E),y
	txa
	dey
	sta ($7E),y
	dey
	lda $6
	sta ($7E),y
	ldy #$5
	lda $2
	sta ($7E),y
	iny
	lda $3
	sta ($7E),y
	ldy #$2
	lda ($7E),y
	tay
	jsr get_point
	ldy #$3
	lda $2
	cmp #$0
	beq invalid_creation_point
	cmp #$18
	beq invalid_creation_point
	sta ($7E),y
	iny
	lda $3
	sta ($7E),y
	lda $4
	sta $2
	lda $3
	sta $2
	ldy #$2
	lda ($7E),y
	tay
	jsr plot_point
	ldy #$7
	pla
	sta ($7E),y
	rts
invalid_creation_point:
	pla
projectile_not_active:
	rts
projectile_update:
	ldy #$0
	lda ($7E),y
	beq projectile_not_active
	iny
	lda ($7E),y
	tax
	iny
	lda ($7E),y
	tay
	jsr get_point
	lda $2
	pha
	lda $3
	pha
	ldy #$3
	lda ($7E),y
	sta $2
	iny
	lda ($7E),y
	sta $3
	ldy #$2
	lda ($7E),y
	tay
	jsr plot_point
	ldy #$7
	lda ($7E),y
	beq proj_no_longer_exists
	ldy #$1
	lda ($7E),y
	ldy #$5
	clc
	adc ($7E),y
	ldy #$1
	sta ($7E),y
	iny
	lda ($7E),y
	ldy #$6
	clc
	adc ($7E),y
	ldy #$2
	sta ($7E),y
	pha
	dey
	lda ($7E),y
	tax
	pla
	tay
	jsr get_point
	lda $3
	cmp #$0
	beq proj_no_longer_exists
	lda $2
	cmp #$18
	beq proj_no_longer_exists
	tya
	pha
	ldy #$3
	lda $2
	sta ($7E),y
	iny
	lda $3
	sta ($7E),y
	pla
	tay
	pla
	sta $3
	pla
	sta $2
	jsr plot_point
	ldy #$7
	lda ($7E),y
	sec
	sbc #$1
	sta ($7E),y
	rts
proj_no_longer_exists:
	pla
	pla
	lda #$0
	tay
	sta ($7E),y
	rts
update_all_projectiles:
	lda #$81
	sta $7F
	lda #$0
	sta $7E
keep_updating_projectiles:
	jsr projectile_update
	jsr next_projectile
	lda $7E
	cmp #$80
	bne keep_updating_projectiles
	rts
