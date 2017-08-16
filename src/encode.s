    .text
    .globl encode
    .type encode, @function
    /* precondition: column, row, level are pushed onto stack */
    /* postcondition: offset in rax; stack unaltered; rax, rdx, rdi destroyed */
encode:
    /* calculate the offset for given column, row, and level */
    leaq 1(%rcx), %rax
    mulq %r8
    incq %rax
    mulq 8(%rsp)
    leaq 1(%rcx), %rdi
    xchgq %rax, %rdi
    mulq 16(%rsp)
    leaq (%rdi,%rax), %rax
    addq 24(%rsp), %rax
    retq
