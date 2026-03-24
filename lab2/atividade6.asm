addi x11, x0, 1
addi x12, x0, 32 
addi x13, x0, 1
sb x11, 1029(x0)

loop:
	beq x11, x12, loop #caso os leds tenham que apagar completamente ao final, alterar de loop para off
	lb x10, 1026(x0)
	andi x10, x10, 1
	beq x10, x13, on
	jal x0, loop

on:
	slli x11, x11, 1
	sb x11, 1029(x0)
	jal x0, loop

off:
	lb x10, 65(x0)
	sb x0, 1029(x0)
	jal x0, loop

halt 

HIGH: .byte 1
LOW:  .byte 0

