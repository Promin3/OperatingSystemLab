
extern choose	

[section .data]	

num1st		dd	3
num2nd		dd	4

[section .text]	

global _start	; 我们必须导出 _start 这个入口，以便让链接器识别。
global myprint	; 导出这个函数为了让 bar.c 使用

_start:
	push	dword [num2nd]	; `.
	push	dword [num1st]	;  |
	call	choose		;  | choose(num1st, num2nd);
	add	esp, 8		
	mov	ebx, 0
	mov	eax, 1		; sys_exit
	int	0x80		; 系统调用

myprint:
	mov	edx, [esp + 8]	; len
	mov	ecx, [esp + 4]	; msg
	mov	ebx, 1
	mov	eax, 4		; sys_write
	int	0x80		; 系统调用
	ret
	; /

