section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	; declare global vars here
	
section .text
	global pwd
	;; void pwd(char **directories, int n, char *output)
	; Adauga in parametrul output path - ul rezultat din
	; parcurgerea celor n foldere din directories
	
pwd:
	enter 0, 0
	pusha
	
	mov eax, dword[ebp + 8]      ; directories
	mov ebx, dword[ebp + 12]     ; n
	mov edx, dword[ebp + 16]     ; output
	
	; we go trough all directiories
	xor ecx, ecx ; start with 0, current directory
parser:
	; directories end check
	cmp ecx, ebx
	je parser_end

	; "." and ".." cases verify
	; either case should start with a '.'
	mov esi, [eax + ecx * 4]
	cmp byte[esi], '.'
	je directory_changer
	
	; we can safely add the directory to output, as well as a '/'
	mov byte[edx], '/'
	inc edx

	; add the name to the output with esi
	mov esi, dword[eax + ecx * 4]

	push ecx ; save current position
	xor ecx, ecx
word_copy:
	cmp byte[esi], 0
	je word_copy_end ; reaching the end of current word
	mov cl, byte[esi] ; copy character by character
	mov byte[edx], cl
	inc edx
	inc esi
	jmp word_copy
word_copy_end:
	pop ecx
continue_parser:
	inc ecx
	jmp parser
	
directory_changer:
	cmp byte[esi + 1], '.'
	je delete_last
	jmp continue_parser
	
delete_last:
	; we check if we can move anymore left
	cmp edx, dword[ebp + 16]
	je continue_parser
	; we check if we have reached '/'
	cmp byte[edx], '/'
	je delete_last_end
	mov byte[edx], 0 ; delete the last character
	dec edx	; move left
	jmp delete_last
	
delete_last_end:
	mov byte[edx], 0 ; delete the '/' character at the end
	jmp continue_parser

parser_end:
	mov byte[edx], '/' ; final slash
	inc edx
	
	popa
	leave
	ret
