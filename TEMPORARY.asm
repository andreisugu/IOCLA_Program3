section .data
    ; declare global vars here

section .text
global reverse_vowels

;; void reverse_vowels(char *string)
; Search for all the vowels in the string `string' and display them
; in reverse order. The consonants remain unchanged.
; Modification will be made in-place
reverse_vowels:
	push ebp
	mov ebp, esp
	pusha
    push esi        ; Preserve the value of esi on the stack
    push edi        ; Preserve the value of edi on the stack

    mov esi, eax    ; eax contains the address of the string
    mov edi, esi    ; Set edi to the same address as esi

    xor ecx, ecx    ; Clear ecx register (used as a counter)

loop_start:
    cmp esi, edi    ; Compare esi and edi
    jge loop_end    ; Jump to loop_end if esi >= edi

    mov al, byte [esi]     ; Load character at esi into al
    cmp al, 'a'            ; Compare al with 'a' (lower bound)
    jl next_iteration      ; Jump to next_iteration if al < 'a'

    cmp al, 'z'            ; Compare al with 'z' (upper bound)
    jg next_iteration      ; Jump to next_iteration if al > 'z'

    cmp al, 'a'            ; Compare al with 'a' (lower bound)
    je is_vowel            ; Jump to is_vowel if al == 'a'

    cmp al, 'e'            ; Compare al with 'e'
    je is_vowel            ; Jump to is_vowel if al == 'e'

    cmp al, 'i'            ; Compare al with 'i'
    je is_vowel            ; Jump to is_vowel if al == 'i'

    cmp al, 'o'            ; Compare al with 'o'
    je is_vowel            ; Jump to is_vowel if al == 'o'

    cmp al, 'u'            ; Compare al with 'u'
    jne next_iteration     ; Jump to next_iteration if al != 'u'

is_vowel:
    mov bl, byte [edi]     ; Load character at edi into bl
    cmp bl, 'a'            ; Compare bl with 'a' (lower bound)
    jl next_iteration      ; Jump to next_iteration if bl < 'a'

    cmp bl, 'z'            ; Compare bl with 'z' (upper bound)
    jg next_iteration      ; Jump to next_iteration if bl > 'z'

    cmp bl, 'a'            ; Compare bl with 'a' (lower bound)
    je perform_swap        ; Jump to perform_swap if bl == 'a'

    cmp bl, 'e'            ; Compare bl with 'e'
    je perform_swap        ; Jump to perform_swap if bl == 'e'

    cmp bl, 'i'            ; Compare bl with 'i'
    je perform_swap        ; Jump to perform_swap if bl == 'i'

    cmp bl, 'o'            ; Compare bl with 'o'
    je perform_swap        ; Jump to perform_swap if bl == 'o'

    cmp bl, 'u'            ; Compare bl with 'u'
    jne next_iteration     ; Jump to next_iteration if bl != 'u'

perform_swap:
    xchg byte [esi], byte [edi]   ; Swap the characters at esi and edi

next_iteration:
    inc esi               ; Increment esi
    dec edi               ; Decrement edi
    jmp loop_start        ; Jump back to loop_start

loop_end:
    pop edi        ; Restore the value of edi from the stack
    pop esi        ; Restore the value of esi from the stack

	popa
	leave
    ret
