#input: i, j, g, h
#output: f
#
#if (i == j){
#	f = g + h;
#}
#
#else{
#	f = g - h;
#}
lw x10, i
lw x11, j
lw x12, g
lw x13, h
lw x14, f

beq x10, x11, end1
sub x14, x12, x13
beq x0, x0, end2
end1:
	add x14, x12, x13
end2:
	sw x14, f
halt

i: .word 0x1
j: .word 0x2
g: .word 0x3
h: .word 0x2
f: .word 0x0
#valores arbitrarios:
# i = 1;
# j = 2;
# g = 3;
# h = 2;


