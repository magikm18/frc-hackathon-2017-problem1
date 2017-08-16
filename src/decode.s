    .text
    .globl decode
    .type decode, @function
    /* precondition: offset in rax */
    /* postcondition: column in rdx; row in rax; level pushed onto stack; rdx, rdi, rsi destroyed */
decode:
    /* calculate the column, row, and level for a given offset */
    movq (%rsp), %rdi
    movq %rax, %rsi
    leaq 1(%rcx), %rax
    mulq %r8
    incq %rax
    xchgq %rax, %rsi
    divq %rsi
    movq %rax, (%rsp)
    movq %rdx, %rax
    leaq 1(%rcx), %rsi
    movq $0, %rdx
    divq %rsi
    jmpq *%rdi
