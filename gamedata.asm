segment .data

	; Pots
	pot_sabacc	dd	20
	pot_hand	dd	20

	; Player Variables
	player_credits	dd	1000

	; NPC Variables
	npc1_credits	dd	1000
	npc2_credits	dd	1000
	npc3_credits	dd	1000

	; Test STRs
	cards_str	db	"Card %d is: %d",10,0
	counters_str	db	"Counter %d is: %d",10,0

segment .bss

; there are 76 cards in Sabacc numbers 1-15 are coins, 16-30 are flasks,
; 31-45 are staves, 46-60 are sabers, 61 & 62 are Idiots, 63 & 64 are The Queen,
; 65 & 66 are Endurance, 67 & 68 are Balance, 69 & 70 are Demise,
; 71 & 72 are Moderation, 73 & 74 are The Evil One, & 75 & 76 are The Star


; This is the array for all player hands
; In this game we have a hand limit of 8
; With 4 players game_hands is divided into 4 chunks
game_hands		resd	32

; This is the array for the number of cards in each hand
; 1 is the player's hand & the subsequent indices correlates
; to each respective npc
player_cards		resd	4

segment .text
;************* EXTERNALS *******************;
extern	ranged_random
extern	printf		; Used for testing

;*************CUSTOM FUNCS******************;

; Initializes Player Hands at the Start of a Hand. This function operates under
; the assumption that all players have already drawn 2 cards and are ready to bet.
init_hand:
	push	ebp
	mov	ebp, esp

	; calls draw_card twice for each player
	mov	esi, 0
	top_init_hand:
	cmp	esi, 2
	jge	end_init_hand

		push	1	; player
		call	draw_card
		add	esp, 4

		push	2	; npc1
		call	draw_card
		add	esp, 4

		push	3	; npc2
		call	draw_card
		add	esp, 4

		push	4	; npc3
		call	draw_card
		add	esp, 4

	inc		esi
	jmp		top_init_hand
	end_init_hand:

	mov	esp, ebp
	pop 	ebp
	ret

; Draws a card for the specified player
draw_card:
	push	ebp
	mov	ebp, esp

	; Call Ranged Random
	push	77
	call	ranged_random
	add	esp, 4

	sub	esp, 4
	mov	DWORD [ebp - 4], eax		; store random

	; If check_hands returns 1, then random = inc random % 77 & check again
	top_check_draw:
	call	check_hands
	cmp	eax, 1
	jne	not_in_hands
		mov	eax, DWORD [ebp - 4]
		inc	eax
		cdq
		mov	ebx, 77
		idiv	ebx
		mov	DWORD [ebp - 4], edx
	jmp	top_check_draw
	not_in_hands:

	; If random = 0, then random = 1 & jump to top of if structure
	top_check_iszero:
	cmp	DWORD [ebp - 4], 0
	jne	not_zero
		mov	DWORD [ebp - 4], 1
	jmp	top_check_draw
	not_zero:


	; Once card is valid, put card in specified player hand
	;mov	eax, DWORD [ebp - 4]				; Store new card

	mov	ebx, DWORD [ebp + 8]					; Player ID
	sub	ebx, 1

	mov	ecx, DWORD [player_cards + ebx * 4]		; Player Hand Counter
	mov	eax, 4
	mul	ecx
	mov	ecx, eax

	mov	eax, 32
	mul	ebx
	mov	ebx, eax

	mov	eax, DWORD [ebp - 4]					; Store new card

	mov	DWORD [game_hands + ebx + ecx], eax		; Put New Card in

	add	esp, 4

	mov	ebx, DWORD [ebp + 8]
	sub	ebx, 1

	add	DWORD [player_cards + ebx * 4], 1		; Increase Size of Hand Counter

	mov	esp, ebp
	pop	ebp
	ret

; Looks for the given card in the game_hands array if it exists in the array
; return 1 on true, 0 on false
check_hands:
	push	ebp
	mov	ebp, esp

	mov	ebx, 0	; loop counter
	mov	eax, 0	; card counter
	top_check_hands:
	cmp	ebx, 32
	jge	end_check_hands

		mov	ecx, DWORD [game_hands + ebx * 4]
		cmp	ecx, DWORD [ebp + 8]
		jne	skipcounter_check_hands
		inc	eax
		jmp	end_check_hands
		skipcounter_check_hands:

	inc	ebx
	jmp	top_check_hands
	end_check_hands:

	mov	esp, ebp
	pop 	ebp
	ret

; Pays a penalty from the given player's credits into the Sabacc Pot
; The amount payed is equivalent to the current Hand Pot
pay_penalty:
	push	ebp
	mov	ebp, esp

	mov	ebx, DWORD [ebp + 8]	; Player ID
	mov	ecx, DWORD [ebp + 12]	; Hand Pot

	mov	eax, 4
	mul	ebx
	mov	ebx, eax
	add	ebx, 16

	sub	DWORD [ebp + ebx], ecx	; Credits of the Given Player ID
	add	DWORD [ebp + 16], ecx	; Add Hand Pot to Sabacc Pot

	mov	esp, ebp
	pop	ebp
	ret

; *********** TESTING FUNCS ***************;

; A test function to see if card values are stored properly
print_cards:
	push	ebp
	mov	ebp, esp

	mov	esi, 0
	top_print_cards:
	cmp	esi, 32
	jge	end_print_cards

		push	DWORD [game_hands + esi * 4]
		push	esi
		push	cards_str
		call	printf
		add	esp, 12

	add	esi, 1
	jmp	top_print_cards
	end_print_cards:

	mov	esp, ebp
	pop	ebp
	ret

; A test function to see if card values are stored properly
print_card_counters:
	push	ebp
	mov	ebp, esp

	mov	esi, 0
	top_print_counters:
	cmp	esi, 4
	jge	end_print_counters

		push	DWORD [player_cards + esi * 4]
		push	esi
		push	counters_str
		call	printf
		add	esp, 12

	add	esi, 1
	jmp	top_print_counters
	end_print_counters:

	mov	esp, ebp
	pop	ebp
	ret
