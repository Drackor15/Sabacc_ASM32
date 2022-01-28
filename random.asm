segment .data

segment .bss

segment .text
;************* EXTERNALS *******************;
extern	fopen
extern	srand
extern	rand
extern	time

;*************CUSTOM FUNCS******************;

; Returns a random int from 0 to the integer provided - 1
ranged_random:
	push	ebp
	mov	ebp, esp

	; Seed with "Random" value
	push	0
	call	time
	add	esp, 4
	push	eax
	call	srand
	add	esp, 4

	; get random value
	call	rand

	; Modulate & Return Random eax = (rand() % x) where x is our range
	cdq
	mov	ebx, [ebp + 8]
	idiv	ebx
	mov	eax, edx	; move remainder to return val

	mov	esp, ebp
	pop 	ebp
	ret
