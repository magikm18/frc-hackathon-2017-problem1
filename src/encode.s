    .text
    .globl encode
    .type encode, @function
    /* precondition: column, row, level are pushed onto stack */
    /* postcondition: offset in rax; stack unaltered; rax, rdx, rdi destroyed */
encode:
    /* calculate the offset for given column, row, and level */
    lea 1(%rcx), %rax
    mul %r8
    inc %rax
    mulq 8(%rsp)
    lea 1(%rcx), %rdi
    xchg %rax, %rdi
    mulq 16(%rsp)
    lea (%rdi,%rax), %rax
    add 24(%rsp), %rax
    ret
