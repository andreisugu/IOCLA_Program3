global get_words
global compare_func
global sort

section .data
    delim db ' .,', 10, 0 ; delimiter
    rasp dd 0
    first_word dd 0
    second_word dd 0
    format db "%s ", 0

section .text
    global compare_func
    extern strtok
    extern strcpy
    extern strcmp
    extern strlen
    extern qsort

; compare_func(const void *a, const void *b)
;  functia de comparare pentru qsort
;  returneaza 0 daca a == b
;  returneaza < 0 daca a < b
;  returneaza > 0 daca a > b
;  a si b sunt pointeri la cuvinte
compare_func:
    push ebp
	mov ebp, esp
	pusha
    
    mov ebx, [ebp + 8] 	    ; first word
    mov edx, [ebp + 12] 	; second word
    
    ; we will compare the length of the words manually
    xor ecx, ecx
length_loop:
    xor eax, eax
    mov al, [ebx + ecx]
    cmp al, 0
    je end_first_worse
    xor eax, eax
    mov al, [edx + ecx]
    cmp al, 0
    je end_second_worse
    inc ecx
    jmp length_loop
end_first_worse:
    mov dword[rasp], 1
    jmp end_length_loop
end_second_worse:
    mov dword[rasp], 0
end_length_loop:
    popa
    mov eax, dword[rasp]
    mov esp, ebp
    pop ebp
    ret

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
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
    push eax
    push ebx
    call strcpy
    add esp, 8

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
