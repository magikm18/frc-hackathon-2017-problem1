    .text
    .globl pushlead
    .type pushlead, @function
pushlead:
    /* add lead to lead buffer */
    movq %r10, -8(%rsp)
    movq 40(%rsp), %r10
    movq %rbp, (%r10)
    leaq 8(%r10), %r10
    movq $0, (%r10)
    movq %r10, 40(%rsp)
    leaq 16(%rbp), %rbp
    movq -8(%rsp), %r10
    retq
