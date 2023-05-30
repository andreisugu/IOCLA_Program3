global get_words
global sort

section .data
	delim db ' .,', 10, 0       ; delimiter for strtok in get_words
	decision dd 0                ; used for storing return value of our compare function

section .text
	extern strtok
	extern strcpy
	extern strcmp
	extern strlen
	extern qsort

;; compare_len_lexico(const void *a, const void *b)
; will be used for qsort
; words compared by 1. length 2. lexicographically
; a == b => return 0
; a < b => return - 1
; a > b => return 1
compare_len_lexico:
	enter 0, 0
	pusha
	; store the words in edi and esi
	mov edi, dword[ebp + 8]
	mov esi, dword[ebp + 12]

	; call strlen for the second word
	; we do the second first to avoid having to swap eax with edx later on
	push dword[esi]
	call strlen
	add esp, 4
	mov edx, eax                 ; we use edx to temporarily store the second word's length

	; we have to make sure edx remains unchanged after the call
	push edx

	; call strlen for the first word
	push dword[edi]
	call strlen
	add esp, 4

	pop edx

	; we subtract the lengths
	sub eax, edx
	cmp eax, 0
	je strcmp_equal
	jmp store_decision

strcmp_equal:
	; if the lengths are equal, compare with strcmp
	push dword[esi]
	push dword[edi]
	call strcmp
	add esp, 8

store_decision:
	mov dword[decision], eax

end_compare:
	popa                         ; this will restore the registers, including eax
	mov eax, dword[decision]     ; we will use the global variable to restore our return value
	leave
	ret

;; sort(char * * words, int number_of_words, int size)
; we will use qsort to sort the words, using the compare function made previously
sort:
	enter 0, 0
	pusha

	mov eax, dword[ebp + 8]      ; char ** words
	mov ebx, dword[ebp + 12]     ; int number_of_words
	mov edx, dword[ebp + 16]     ; int size

	; Call qsort with compare function compare_len_lexico
	mov ecx, compare_len_lexico
	push ecx
	push edx
	push ebx
	push eax
	call qsort
	add esp, 16

	popa
	leave
	ret

;; get_words(char * s, char * * words, int number_of_words)
; separates the words and stores them in the 'words' array
; 'number_of_words' is self describing
get_words:
	enter 0, 0
	pusha

	mov eax, dword[ebp + 8]      ; char *s
	mov ebx, dword[ebp + 12]     ; char ** words
	mov edx, dword[ebp + 16]     ; int number_of_words

	; we will use strtok
	; get first word
	push delim
	push eax
	call strtok
	add esp, 8

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

	; we will use strcpy to copy the word from eax to ebx
	push eax
	push ebx
	call strcpy
	add esp, 8

	pop ebx
	add ebx, 4
next_word:
    ; get the next word from strtok
	push delim
	push 0
	call strtok
	add esp, 8
	jmp first_loop
end_first_loop:
	popa
	leave
	ret
