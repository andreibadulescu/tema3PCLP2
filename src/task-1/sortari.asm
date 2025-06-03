section .bss
    struc node
        ; conforming to C struct (one field)
        val resd 1
        ; conforming to C struct (one field)
        next resd 1
    endstruc

section .text
global sort

;   struct node {
;    int val;
;    struct node* next;
;   };

;; struct node* sort(int n, struct node* node);
;   The function will link the nodes in the array
;   in ascending order and will return the address
;   of the new found head of the list
; @params:
;   n -> the number of nodes in the array
;   node -> a pointer to the beginning in the array
;   @returns:
;   the address of the head of the sorted list
sort:
    ; create a new stack frame
    enter 0, 0
    ; array address
    mov edi, [ebp + 12]
    ; selecting start address

    ; eax will contain the first node address
    xor eax, eax

start_loop:
    ; if eax is null, then the address was not found
    cmp eax, 0
    jne start_loop_end

    ; moving value in ebx
    mov ebx, [edi]

    ; check if node is first
    cmp ebx, 1

    ; skip if node does not store val = 1
    jne start_loop_next

    ; saving address
    mov eax, edi

start_loop_next:
    ; next node
    add edi, node_size
    jmp start_loop

start_loop_end:
    ; restoring size
    mov esi, [ebp + 8]

    ; saving first node address for return value
    push eax

    ; nodes configured counter
    mov ecx, 2

setup_loop:
    cmp ecx, esi
    ja setup_loop_end

    ; array address
    mov edi, [ebp + 12]

search_loop:
    cmp [edi], ecx
    jne search_loop_next

    ; aligning to pointer and saving addresses
    add eax, next
    mov [eax], edi
    mov eax, edi

    jmp search_loop_end

search_loop_next:
    add edi, node_size
    jmp search_loop

search_loop_end:
    ; next node
    inc ecx
    jmp setup_loop

setup_loop_end:
    pop eax
    leave
    ret

