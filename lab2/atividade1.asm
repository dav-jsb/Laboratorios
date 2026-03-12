lw x20, a
lw x21, b
sw x20, m
lw x22, m
blt x21, x22, end1
beq x0, x0, end2
end1:
	add x22, x20, x21
end2:
	sw x22, m
halt

a: .word 0x19
b: .word 0xC
m: .word 0x0
