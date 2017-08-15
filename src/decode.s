    .text
    .globl decode
    .type decode, @function
    /* precondition: offset in rax */
    /* postcondition: column in rdx; row in rax; level pushed onto stack; rdi, rsi destroyed */
decode:
    /* calculate the column, row, and level for a given offset */
    mov (%rsp), %rdi
    mov %rax, %rsi
    lea 1(%rcx), %rax
    mul %r8
    inc %rax
    xchg %rax, %rsi
    div %rsi
    mov %rax, (%rsp)
    mov %rdx, %rax
    lea 1(%rcx), %rsi
    mov $0, %rdx
    div %rsi
    jmp %rdi
