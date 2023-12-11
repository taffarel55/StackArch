// Salva um valor n em MEM[0] para calcular fib(n)
PUSH_I 5
POP 0

// Coloca na Memória os valores de fib(1) e fib(2)
PUSH_I 1
POP 1
PUSH_I 1
POP 2

// Calcula quantas iterações falta para fib(n)
PUSH_I 2
PUSH 0
SUB
POP 0
