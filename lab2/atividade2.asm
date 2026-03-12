lw x20, a
lw x21, b
lw x22, m

blt x21, x22, end1
sub x22, x20, x21
beq x0, x0, end2

end1:
	add x22, x20, x21
end2:
	sw x22, m
halt

a: .word 0x6
b: .word 0xF
m: .word 0x0
