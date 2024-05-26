MVI R1, 10
MVI R2, 20

// bunch of NOP operations to avoid any potential 
// data hazard during instruction pipelining
ORR R1, R1, R1
ORR R1, R1, R1
ORR R1, R1, R1
ORR R1, R1, R1
ORR R1, R1, R1

ADD R1, R1, R2
HLT

