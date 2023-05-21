%include "../include/io.mac"

section .data
	; declare global vars here

	; Domnul Sugubete Andrei, in Assembly (NASM x86) puteti folosi cu incredere
	; urmatorii registri: eax, ebx, ecx, edx, esi, edi

	; Ne auzim pentru al doilea task la ora 21:00. Mult spor si pauza placuta.a

	; DE ADAUGAT COMENTARII SCHIMBA CHESTII ETC
section .text
	global reverse_vowels
	extern printf
	extern strchr
;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place
reverse_vowels:
	; shenanigans
	push ebp
	push esp
	pop ebp
    pusha

	push dword[ebp + 8]
	pop eax

initial_traversal: ; poate refacem for ul
	cmp byte[eax], 0x0 ;schimba maybe cu 0
	je end_initial_traversal

	push dword[eax]
	pop edx

	cmp dl, 'a' ; poate cu edx
	je vowel
	cmp dl, 'e'
	je vowel
	cmp dl, 'i'
	je vowel
	cmp dl, 'o'
	je vowel
	cmp dl, 'u'
	je vowel

	inc eax
	jmp initial_traversal

vowel:
	push dword[eax]
	inc eax
	jmp initial_traversal

end_initial_traversal:

	push dword[ebp + 8]
	pop eax

second_traversal:
	cmp byte[eax], 0x0
	je end_second_traversal

	push dword[eax]
	pop edx

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

equal:
	inc eax
	jmp second_traversal

found_vowel:
	push dword[eax]
	pop edx
	pop ecx

	cmp edx, ecx

	sub ecx, edx
	add byte[eax], cl
	jmp equal

end_second_traversal:
	; reset ebp
	popa
	push ebp
	pop esp
	pop ebp
    ret  		; echivalent cu pop esp


