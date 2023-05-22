section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	; declare global vars here

section .text
	global pwd
	extern printf
	extern strchr
	extern strcat
;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories

pwd:
	enter 0, 0
	pusha

	mov eax, dword[ebp + 8] 	; directories
	mov ebx, dword[ebp + 12] 	; n
	mov edx, dword[ebp + 16] 	; output

	; we go through each directory
	; for each directory, we add to output "/" and the name of the directory
	xor ecx, ecx
first_loop:
	; if we finished iterating through the directories, exit
	cmp ecx, ebx
	je end_first_loop
	
	; we check for "." and ".."
	; if we find them, we modify accordingly
	; save ebx
	push ebx
	xor ebx, ebx
	; we check if the directory is "." or ".."
	mov esi, [eax + ecx * 4]
	mov bl, byte[esi]
	cmp bl,  '.'
	je action_decider
	; restore ebx
	pop ebx
	; because its neither "." nor "..", we add the name of the directory to output
	; we also add "/" to output
	mov byte[edx], '/'
	inc edx
	; we add the name of the directory to output
	; we will use esi to go through the name
	mov esi, dword[eax + ecx * 4]
	; save ecx
	push ecx
	xor ecx, ecx
	second_loop:
		; if we finished iterating through the name, exit
		cmp byte[esi], 0
		je end_second_loop
	
		; we copy the character to output
		mov cl, byte[esi]
		mov byte[edx], cl
		inc edx
		inc esi
		jmp second_loop
	end_second_loop:
	; we continue
	; restore ecx
	pop ecx
continue_first_loop:
	inc ecx
	jmp first_loop

action_decider:
	mov bl, byte[esi + 1]
	cmp bl, '.'
	je back_dir
	jmp curr_dir

curr_dir:
	; because its the current dir, we do nothing
	; restore ebx
	pop ebx
	jmp continue_first_loop

back_dir:
	; because its the parent dir, remove the last directory from output
	; restore ebx
	pop ebx
	jmp move_left

move_left:
	; we check if we can move anymore left
	cmp edx, dword[ebp + 16]
	je continue_first_loop
	; we check if we have reached '/'
	push ebx
	xor ebx, ebx
	mov bl, byte[edx]
	cmp bl, '/'
	je end_move_left
	pop ebx
	mov byte[edx], 0
	dec edx
	jmp move_left

end_move_left:
	pop ebx
	; also eliminte the '/'
	mov byte[edx], 0
	; we continue
	jmp continue_first_loop
 
	; we finished iterating through the directories
end_first_loop:
	; add a final "/"
	mov byte[edx], '/'
	inc edx

	popa
	leave
	ret