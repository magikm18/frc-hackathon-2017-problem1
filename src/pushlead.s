    .text
    .globl pushlead
    .type pushlead, @function
pushlead:
    /* add lead to lead buffer */
    mov %r10, -8(%rsp)
    mov 40(%rsp), %r10
    mov %rbp, (%r10)
    lea 8(%r10), %r10
    movq $0, (%r10)
    mov %r10, 40(%rsp)
    lea 16(%rbp), %rbp
    mov -8(%rsp), %r10
    ret
