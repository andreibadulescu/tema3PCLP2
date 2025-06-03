section .text
extern calloc
extern free
global check_palindrome
global composite_palindrome

check_palindrome:
    ; FUNCTION IS USING EDI
    ; SAVING VALUE FOR CALLEE

    ; create a new stack frame
    enter 0, 0
    ; CDECL
    push ebx
    push edi

    ; pointer to string
    mov edi, [ebp + 8]

    ; string length
    mov edx, [ebp + 12]

    ; RHS index
    dec edx
    ; LHS index
    mov ecx, 0

loop_check_palindrome:
    ; checking chars until we reach the half
    cmp ecx, edx
    jge successful_check_palindrome

    ; extracting chars
    mov eax, [edi + ecx]
    mov ebx, [edi + edx]

    ; checking if chars are equal
    cmp al, bl
    jne failed_check_palindrome

    ; next pair of chars
    inc ecx
    dec edx
    jmp loop_check_palindrome

failed_check_palindrome:
    ; returning false
    xor eax, eax
    jmp exit_check_palindrome

successful_check_palindrome:
    ; returning true
    mov eax, 1

exit_check_palindrome:
    pop edi
    pop ebx
    leave
    ret



composite_palindrome:
    ; create a new stack frame
    enter 0, 0
    ; CDECL
    push ebx

    ; size of char
    push dword 1

    ; buffer size
    push dword 151

    ; allocating space on heap for result
    call calloc
    mov esi, eax

    ; allocating space on heap for work array
    call calloc
    mov edi, eax

    ; deallocating stack space for params
    add esp, 8

    ; char *array[]
    mov ebx, [ebp + 8]
    ; array size
    mov ecx, [ebp + 12]
    dec ecx

    ; invocating backtracking function
    push ecx

    ; index of word array
    push dword 0

    push ebx

    call backtracking

    ; deallocating stack space for params
    add esp, 12


    ; deallocating space on heap for work array
    push edi
    call free

    ; deallocating stack space for param
    add esp, 4

    ; returning result array
    mov eax, esi
    pop ebx
    leave
    ret



backtracking:
    ; FUNCTION IS NOT CDECL COMPLIANT
    push ebp
    mov ebp, esp

    ; edx represents the word array
    mov edx, [ebp + 8]
    ; ebx represents the word index (indexed from 0)
    mov ebx, [ebp + 12]
    ; ecx represents the word array size
    mov ecx, [ebp + 16]

    ; composite string created
    ; checking if palindrome
    cmp ebx, ecx
    jg backtracking_check_result

    ; adding new word to string
    ; computing string length
    push edi
    call string_length
    ; deallocating stack space for param
    add esp, 4

    ; computing "paste" address
    lea eax, [edi + eax]
    push eax

    ; word array address
    mov edx, [ebp + 8]
    ; word index
    mov ebx, [ebp + 12]
    ; computing "source" address
    mov eax, [edx + 4 * ebx]
    push eax

    ; copying word
    call string_copy

    ; removing only "source" address from stack, retaining "paste" address
    add esp, 4

    ; word array size
    push dword[ebp + 16]
    ; word index
    mov ebx, [ebp + 12]
    inc ebx
    push ebx
    ; word array address
    push dword[ebp + 8]

    call backtracking
    ; deallocating stack space for params
    add esp, 12

    pop eax
    ; placing a \0 at the end of the old string
    mov byte[eax], 0

    ; word array size
    push dword[ebp + 16]
    ; word index
    mov ebx, [ebp + 12]
    inc ebx
    push ebx
    ; word array address
    push dword[ebp + 8]

    call backtracking
    ; deallocating stack space for params and leaving
    add esp, 12

    jmp backtracking_end

backtracking_check_result:
    ; computing string length
    push edi
    call string_length
    ; deallocating param from stack
    add esp, 4

    ; checking if palindrome
    push eax
    push edi
    call check_palindrome
    ; deallocating params from stack
    add esp, 8

    ; 1 -- not a palindrome
    ; 0 -- is palindrome
    cmp eax, 1
    jne backtracking_end

    ; checking if new string is longer / smaller
    ; lexicographically compared to current result
    push esi
    push edi
    call word_comparison
    ; deallocating params from stack
    add esp, 8

    ; 1 -- should be saved
    ; 0 -- do not save
    cmp eax, 1
    jne backtracking_end

    ; copying new string
    push esi
    push edi
    call string_copy
    ; deallocating params from stack
    add esp, 8

backtracking_end:
    leave
    ret



string_length:
    push ebp
    mov ebp, esp

    ; pointer to char array
    mov ecx, [ebp + 8]

    ; char count
    xor eax, eax

loop_string_length:
    mov edx, [ecx]

    ; searching for \0
    cmp dl, 0
    je end_string_length

    inc eax
    inc ecx
    jmp loop_string_length

end_string_length:
    leave
    ret



string_copy:
    push ebp
    mov ebp, esp
    push ebx

    ; char counter
    mov ebx, 0

    ; double pointer to source char array
    mov eax, [ebp + 8]
    ; double pointer to destination char array
    mov edx, [ebp + 12]

loop_string_copy:
    ; extracting current char
    mov ecx, [eax]

    ; checking if string has ended
    cmp cl, 0
    je end_string_copy

    ; duplicating char
    mov [edx], cl
    inc ebx

    ; incrementing addresses
    inc edx
    inc eax
    jmp loop_string_copy

end_string_copy:
    ; adding \0 string terminator
    mov byte[edx], 0
    mov eax, ebx
    pop ebx
    leave
    ret



word_comparison:
    push ebp
    mov ebp, esp
    push ebx

    ; LHS pointer to char array
    mov eax, [ebp + 8]
    ; RHS pointer to char array
    mov ebx, [ebp + 12]

length_word_comparison:
    ; extracting chars
    mov ecx, [eax]
    mov edx, [ebx]

    ; checking if LHS ended
    cmp cl, 0
    je assess_result_word_comparison

    ; checking if RHS ended
    cmp dl, 0
    je ret1_word_comparison

    ; next chars
    inc eax
    inc ebx
    jmp length_word_comparison

assess_result_word_comparison:
    ; checking if RHS ended
    cmp dl, 0
    jne retneg1_word_comparison

    ; checking lexicographically

    ; LHS pointer to char array
    mov eax, [ebp + 8]
    ; RHS pointer to char array
    mov ebx, [ebp + 12]

loop_word_comparison:
    ; extracting chars
    mov ecx, [eax]
    mov edx, [ebx]

    ; comparing chars
    cmp cl, dl
    jg retneg1_word_comparison
    jl ret1_word_comparison

    ; chars are equal
    cmp cl, 0
    je ret0_word_comparison

    inc eax
    inc ebx
    jmp loop_word_comparison

retneg1_word_comparison:
    ; LHS < RHS
    mov eax, -1
    jmp end_word_comparison

ret1_word_comparison:
    ; LHS > RHS
    mov eax, 1
    jmp end_word_comparison

ret0_word_comparison:
    ; LHS == RHS
    xor eax, eax

end_word_comparison:
    pop ebx
    leave
    ret



sort_words:
    ; instruction was not used for solving the task
    ; FUNCTION IS USING ESI / EDI
    push ebp
    mov ebp, esp

    ; CDECL
    push ebx

    ; array length
    mov ecx, [ebp + 12]
    dec ecx

    ; char * array[]
    mov eax, [ebp + 8]

    ; moving to end of array
    lea eax, [eax + 4 * ecx]

loop_sort_words:
    ; selection sort (inverted)
    cmp ecx, 1
    jl exit_sort_words

    ; next pointer from array
    lea ebx, [eax - 4]

    ; edx counter for selection
    mov edx, ecx
    dec edx

small_loop_sort_words:
    ; checking if there are elements that can be selected
    cmp edx, 0
    jl exit_small_loop_sort_words

    ; CDECL
    push eax
    push ecx
    push edx

    ; pushing args for comparison call
    push ebx
    push eax

    call word_comparison

    ; deallocating stack for arguments
    add esp, 8

    pop edx
    pop ecx

    ; checking result
    cmp eax, 0
    pop eax
    jge decrement_small_loop_sort_words

    ; swapping pointers
    mov esi, [eax]
    mov edi, [ebx]
    mov [eax], edi
    mov [ebx], esi

decrement_small_loop_sort_words:
    ; check next element
    dec edx

    ; prev address
    sub ebx, 4
    jmp small_loop_sort_words

exit_small_loop_sort_words:
    ; decreasing addresses
    dec ecx

    ; prev address
    sub eax, 4
    jmp loop_sort_words

exit_sort_words:
    pop ebx
    leave
    ret
