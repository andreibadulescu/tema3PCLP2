section .text
global sort
global get_words
global comparison_function
extern qsort

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor
;  dupa lungime si apoi lexicografix
sort:
    ; create a new stack frame
    enter 0, 0

    ; CDECL
    push ebx

    ; pointer to array of char *
    mov eax, [ebp + 8]

    ; word count
    mov ebx, [ebp + 12]

    ; size of element (sizeof(char *))
    mov ecx, [ebp + 16]

    ; pushing args on stack for CDECL standard call
    ; comparison_function is the comparison method
    push comparison_function
    push ecx
    push ebx
    push eax

    ; calling qsort (CDECL)
    call qsort

    ; deallocating stack space for args
    add esp, 16

    pop ebx
    xor eax, eax
    leave
    ret

comparison_function:
    push ebp
    mov ebp, esp

    ; saving registers (CDECL standard)
    push ebx

    ; address of first pointer
    mov eax, [ebp + 8]

    ; address of second pointer
    mov ebx, [ebp + 12]

    ; retrieving address of char arrays
    mov eax, [eax]
    mov ebx, [ebx]

comparison_function_length:
    ; saving current characters
    mov ecx, [eax]
    mov edx, [ebx]

    ; checking if LHS string has ended
    cmp cl, 0
    je assess_length

    ; LHS string did not end
    cmp dl, 0
    je comparison_function_ret1

    inc eax
    inc ebx
    jmp comparison_function_length

assess_length:
    ; checking if RHS string has ended
    cmp dl, 0
    jne comparison_function_ret0

    ; LHS and RHS have the same length

comparison_function_length_end:
    ; address of first pointer
    mov eax, [ebp + 8]

    ; address of second pointer
    mov ebx, [ebp + 12]

    ; retrieving address of char arrays
    mov eax, [eax]
    mov ebx, [ebx]

comparison_function_lexicographic:
    ; saving current characters
    mov ecx, [eax]
    mov edx, [ebx]

    ; comparing current characters from the given strings
    cmp cl, dl

    ; first string is greater lexigographically
    jl comparison_function_ret0

    ; second string is greater lexigographically
    jg comparison_function_ret1

    ; both strings contain to this point the same characters
    ; checking for \0
    cmp cl, 0
    je comparison_function_ret1

    ; moving addresses to the next character
    inc eax
    inc ebx

    jmp comparison_function_lexicographic

comparison_function_ret0:
    ; elements are in the right order
    mov eax, 0
    jmp comparison_function_end

comparison_function_ret1:
    ; elements must be swapped
    mov eax, 1

comparison_function_end:
    pop ebx
    leave
    ret



;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    ; create a new stack frame
    enter 0, 0

    ; pointer to text
    mov eax, [ebp + 8]

    ; pointer to array of char *
    mov ecx, [ebp + 12]

copy_word_addresses:
    ; copying address of current word
    mov [ecx], eax

    ; moving to next element of char * array
    add ecx, 4

skip_readable_characters:
    mov edx, [eax]

    ; searching for NULL
    cmp dl, 0
    je end_get_words

    ; searching for " "
    cmp dl, 32
    je skip_separators

    ; searching for ","
    cmp dl, 44
    je skip_separators

    ; searching for "."
    cmp dl, 46
    je skip_separators

    ; searching for "\n"
    cmp dl, 10
    je skip_separators

    inc eax
    jmp skip_readable_characters

skip_separators:
    mov edx, [eax]

    ; checking if char is not alphanumeric
    cmp dl, 48
    jge copy_word_addresses

    ; replacing separator with \0
    xor dl, dl
    mov [eax], edx
    inc eax
    jmp skip_separators

end_get_words:
    xor eax, eax
    pop ebx
    leave
    ret

