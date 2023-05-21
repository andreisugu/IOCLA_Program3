%include "../include/io.mac"
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
	; we will use ecx to go through the directories
	xor ecx, ecx
first_loop:
	; if we finished iterating through the directories, exit
	cmp ecx, ebx
	je end_first_loop
	
	; we check for "." and ".."
	; if we find them, we modify the directories array to reflect the changes
	cmp dword[eax + ecx * 4], curr
	je curr_dir
	cmp dword[eax + ecx * 4], back
	je back_dir

	; because its neither "." nor "..", we simply continue
	inc ecx
	jmp first_loop

curr_dir:
	; because its the current dir, we move the entire eax array one position to the left
	; we also decrement ebx
	mov edi, eax
	mov esi, eax
	add esi, 4
	mov ecx, ebx
	sub ecx, 1
	rep movsd
	dec ebx
	jmp first_loop

back_dir:
	; because its the parent dir, we move the entire eax array two positions to the left
	; we also decrement ebx twice
	mov edi, eax
	mov esi, eax
	add esi, 8
	mov ecx, ebx
	sub ecx, 2
	rep movsd
	sub ebx, 2
	jmp first_loop

	; we finished iterating through the directories
end_first_loop:
	; now we iterate again and simply add the names of the directories to output with "/"
	; we will use ecx to go through the directories
	xor ecx, ecx
second_loop:
	; if we finished iterating through the directories, exit
	cmp ecx, ebx
	je end_second_loop

	; we add "/" to output
	mov byte[edx], '/'
	inc edx

	; we add the name of the directory to output
	; we copy each character of the name to output
	; we will use esi to go through the name
	mov esi, dword[eax + ecx * 4]
third_loop:
	; if we finished iterating through the name, exit
	cmp byte[esi], 0
	je end_third_loop

	; we copy the character to output
	mov al, byte[esi]
	mov byte[edx], al
	inc edx
	inc esi
	jmp third_loop

end_third_loop:


	; we increment ecx and continue
	inc ecx
	jmp second_loop

end_second_loop:

	popa
	leave
	ret