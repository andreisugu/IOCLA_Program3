section .text
	global reverse_vowels
	extern printf
	extern strchr
	;; void reverse_vowels(char * string)
	; Cauta toate vocalele din string - ul `string` si afiseaza - le
	; in ordine inversa. Consoanele raman nemodificate.
	; Modificare se va face in - place
reverse_vowels:
	push ebp                     ; enter substitute using only push and pop
	push esp
	pop ebp
	pusha
	
	push dword[ebp + 8]          ; get the string * from the stack
	pop eax
	
first_loop:
	cmp byte[eax], 0             ; check if we reached the end of the string
	je first_loop_stop
	
	push dword[eax]              ; move the value of eax on the stack
	pop edx                      ; and then pop it into edx. Now dl has the current character
	
	inc eax                      ; we can move to the next character already, and we don't need to write it twice
	
	; check if the current character is a vowel
	cmp dl, 'a'
	je vowel
	cmp dl, 'e'
	je vowel
	cmp dl, 'i'
	je vowel
	cmp dl, 'o'
	je vowel
	cmp dl, 'u'
	je vowel
	
	jmp first_loop
	
vowel:
	push dword[eax - 1]          ; move the vowel on the stack
	jmp first_loop
	
first_loop_stop:
	
	push dword[ebp + 8]          ; get the string * from the stack
	pop eax
second_loop:
	cmp byte[eax], 0
	je second_loop_stop
	
	push dword[eax]
	pop edx
	
	inc eax
	
	cmp dl, 'a'
	je found_vowel
	cmp dl, 'e'
	je found_vowel
	cmp dl, 'i'
	je found_vowel
	cmp dl, 'o'
	je found_vowel
	cmp dl, 'u'
	je found_vowel
	
	jmp second_loop
	
found_vowel:
	push dword[eax - 1]
	pop edx                      ; eax - 1
	pop ecx                      ; last vowel
	
	sub ecx, edx
	add byte[eax - 1], cl
	jmp second_loop
second_loop_stop:
	
	popa
	push ebp                     ; leave substitute using only push and pop
	pop esp
	pop ebp
	ret
