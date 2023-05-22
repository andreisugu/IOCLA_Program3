global get_words
global compare_func
global sort

section .text
    global compare_func
    extern strtok
    extern strcmp
    extern strlen
    extern qsort
    extern printf

section .data
    delim db 'n .,', 0 ; delimiter
    first_word dd 0
    second_word dd 0
    format db "%s ", 0


;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
compare_func:
    enter 0, 0
    
    mov ebx, [esp + 4]  ; Load pointer to ebx (first word)
    mov ecx, [esp + 8]  ; Load pointer to ecx (second word)

    ; Get the lenghts of the words
    ; xor eax, eax
    ; push ebx
    ; call strlen
    ; add esp, 4

    ; mov dword[first_word], eax
    
    ; xor eax, eax
    ; push ecx
    ; call strlen
    ; add esp, 4

    ; mov dword[second_word], eax

    ; ;  Compare the lengths
    ; mov eax, dword[first_word]
    ; mov ecx, dword[second_word]
    ; cmp eax, ecx
    ; je compare_lexicographically
    ; jg first_word_is_longer
    ; jl second_word_is_longer

; PENTRU ANDREI DIN VIITOR: RECOMAND SA FACI MANUAL FIINDCA NU MERGE DELOC STRLEN SI PIER DE NERVI IAR :)

first_word_is_longer:
    mov eax, 1
    jmp end_cmp
second_word_is_longer:
    mov eax, 0
    jmp end_cmp
compare_lexicographically:

end_cmp:
    leave
    ret

sort:
    enter 0, 0
    pusha

    mov eax, dword[ebp + 8] 	; char **words
	mov ebx, dword[ebp + 12] 	; int number_of_words
	mov edx, dword[ebp + 16] 	; int size

    mov ecx, compare_func
    push ecx
    push edx
    push ebx
    push eax
    ; Call qsort. This will modify the array in-place.
    call qsort
    ; Clean up the stack. We pushed 4 arguments, each 4 bytes.
    add esp, 16

    popa
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
; DELIMITATORI: " ,.\n"
get_words:
    enter 0, 0
    pusha

    mov byte[delim], 10

    mov eax, dword[ebp + 8] 	; char *s
	mov ebx, dword[ebp + 12] 	; char **words
	mov edx, dword[ebp + 16] 	; int number_of_words

    ; we will use strtok
    ; get first word
    push delim
    push eax
    call strtok
    add esp, 8

    ; eax = our token we will use to get the words
    ; we will have to move them to ebx manually with a loop
    ;mov dword[ebx], eax ; save the pointer to the token in words

    ; we add the word we have just got
    jmp add_word
first_loop:
    cmp eax, 0
    je end_first_loop
    ; add the word to words
add_word:
    ; ebx will become the current word pointer
    xor ecx, ecx
    mov ecx, dword[ebx]
    push ebx
    mov ebx, ecx
    xor ecx, ecx

    ; we will have to copy the word from eax to ebx
    ; we will use a loop
second_loop:
    xor ecx, ecx
    mov cl, byte[eax]
    cmp cl, 0
    je end_second_loop

    xor ecx, ecx
    mov cl, byte[eax]
    mov byte[ebx], cl

    inc eax
    inc ebx
    jmp second_loop
end_second_loop:
    ; restore ebx and go to next word pointer
    pop ebx
    add ebx, 4
next_word:
    push delim
    push 0
    call strtok
    add esp, 8
    jmp first_loop
end_first_loop:


    popa
    leave
    ret
