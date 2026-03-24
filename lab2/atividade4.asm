addi x11, x0, 24

loop:
	lb x10, 0(x11)
	sb x10, 1024(x0)
	addi x11, x11, 1
	bne x11, x0, loop

halt

str1: .string "Hello World"
