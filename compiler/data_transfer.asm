PUSH_I 0b1          // Coloca 1 na pilha
PUSH_I 0b0000000010 // Coloca 2 na pilha
PUSH_I 0x4          // Coloca 4 na pilha
PUSH_I 8            // Coloca 8 na pilha
POP 0x4             // Desempilha (data=8) para memória (addr=4)
POP 0x005           // Desempilha (data=4) para memória (addr=5)
POP 0x007           // Desempilha (data=2) para memória (addr=7)
POP 0b1111          // Desempilha (data=1) para memória (addr=15)
PUSH 0b00000000100  // Empilha    (data=8)   da memória (addr=4) 
PUSH 15             // Empilha    (data=1)   da memória (addr=15) 
PUSH 0x5            // Empilha    (data=4)   da memória (addr=5) 
PUSH 7              // Empilha    (data=2)   da memória (addr=7) 
