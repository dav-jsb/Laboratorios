lw x1, a
lw x2, b
sw x1, m
lw x3, m
blt x2, x3, end1
beq x0, x0, end2
end1:
	add x3, x1, x2
end2:
	sw x3, m
halt

a: .word 0x19
b: .word 0xC
m: .word 0x0
