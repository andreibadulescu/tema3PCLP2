section .text
global kfib

kfib:
    ; create a new stack frame
    enter 0, 0

    ; index of queried element
    mov esi, [ebp + 8]

    ; series type (K variable)
    mov edi, [ebp + 12]

    ; checking for known values
    cmp esi, edi
    jl ret0_kfib
    je ret1_kfib

    ; computing lower bound
    mov edx, esi
    sub edx, edi

    ; computing upper bound
    dec esi

    xor eax, eax

query_elements_kfib:
    cmp esi, edx
    jl end_kfib

    ; saving registers
    push eax
    push esi
    push edx

    ; querying elements
    push dword[ebp + 12]
    push esi

    ; computing elements
    call kfib
    mov ecx, eax

    ; restoring stack frame
    add esp, 8

    ; restoring registers
    pop edx
    pop esi
    pop eax
    add eax, ecx

    ; loop conditions
    dec esi
    jmp query_elements_kfib

ret0_kfib:
    xor eax, eax
    jmp end_kfib

ret1_kfib:
    ; return 1 for n == k
    mov eax, 1

end_kfib:
    leave
    ret

