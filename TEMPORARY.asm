section .data
    vowels db 'aeiou', 0 ; vowels to check

section .text
    global reverse_vowels
    extern strchr

;; void reverse_vowels(char *string)
reverse_vowels:
    ;; Save registers
    pusha

    ;; First pass: find vowels and push onto stack
    mov eax, [esp+36] ; load address of string
first_pass:
    push eax ; save current pointer
    push byte [eax] ; push character onto stack
    push 4 ; strchr expects a int (4 bytes) not a char
    pop ecx ; get char into ecx
    add esp, 4 ; correct stack after push
    push eax ; push pointer for strchr
    push vowels ; push vowels for strchr
    call strchr
    add esp, 8 ; correct stack after call
    test eax, eax ; check if strchr found a vowel
    jz not_a_vowel ; if not a vowel, skip
    push ecx ; if it's a vowel, push it onto the stack
not_a_vowel:
    pop eax ; restore pointer
    inc eax ; next character
    cmp byte [eax], 0 ; check for end of string
    jne first_pass ; if not end of string, continue

    ;; Second pass: replace vowels with those from the stack
    mov eax, [esp+36] ; load address of string
second_pass:
    push eax ; save current pointer
    push byte [eax] ; push character onto stack
    push 4 ; strchr expects a int (4 bytes) not a char
    pop ecx ; get char into ecx
    add esp, 4 ; correct stack after push
    push eax ; push pointer for strchr
    push vowels ; push vowels for strchr
    call strchr
    add esp, 8 ; correct stack after call
    test eax, eax ; check if strchr found a vowel
    jz not_a_vowel_second_pass ; if not a vowel, skip
    pop eax ; pop vowel from stack
    push byte [esp] ; save original character
    pop byte [esp+4] ; replace vowel in string
    jmp continue_second_pass
not_a_vowel_second_pass:
    pop eax ; restore pointer
continue_second_pass:
    inc eax ; next character
    cmp byte [eax], 0 ; check for end of string
    jne second_pass ; if not end of string, continue

    ;; Restore registers and return
    popa
    ret
