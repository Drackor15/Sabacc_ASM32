%include "render.asm"
%include "gamedata.asm"
%include "random.asm"

segment .data

segment .bss

segment .text
	global  main
	extern	getchar
	extern	printf

main:
	push	ebp
	mov	ebp, esp
	; ********** CODE STARTS HERE **********

	; MENUS *********************

	; Main Menu
	menu_loop:

		call	raw_mode_off

		; Print Menu.txt
		call	render_menu

		; Get User Input
		call	raw_mode_on
		call	getchar

		; Menu Switch Case
		cmp	eax, 27
		je	program_end
		cmp	eax, '2'
		je	rules_loop
		cmp	eax, '1'
		je	init_board

	jmp	menu_loop

	; Rules Menu
	rules_loop:

		call	raw_mode_off

		; Print Rules.txt
		call	render_rules

		; Get User Input
		call	raw_mode_on
		call	getchar

		; Menu Switch Case
		cmp	eax, 27
		je	menu_loop

	jmp	rules_loop

	; GAMEPLAY *****************************

	; Initialize Game Board for 1st time
	init_board:

		call	raw_mode_off

		; Initialize Game Variables
		call	init_hand

		;call	print_cards				;TESTING FUNC
		;call	print_card_counters		;TESTING FUNC

		; Pushes Each Player's Card Counter onto Stack
		; Player 1 is +44 on Stack
		; NPC1 is +40 on Stack
		; NPC2 is +36 on Stack
		; NPC3 is +32 on Stack
		mov	esi, 0
        top_push_counters:
        cmp	esi, 4
        jge	end_push_counters

        	push    DWORD [player_cards + esi * 4]

        add	esi, 1
        jmp	top_push_counters
        end_push_counters:

		push	npc3_credits	; +28 on Stack
		push	npc2_credits	; +24 on Stack
		push	npc1_credits	; +20 on Stack
		push	player_credits	; +16 on Stack
		push	pot_sabacc		; +12 on Stack
		push	pot_hand		; +8  on Stack
		call	render_game

	; Start Another Hand
	jmp	play_hand
	start_hand:
		call	raw_mode_off
		call	init_hand
		call	render_game

	; Play Hand/Round
	play_hand:

		; dont forget raw mode on/off

		; Step 3
		; Print Step 3 Actions
		; Check if Player bets (& how much) (only once), folds (pay penalty), or Full Folds (leaves game with money)
		push	step3_str
		call	printf
		add		esp, 4

		call	raw_mode_on
		step3_loop:
			call	getchar

			; step 3 switch case
			cmp	eax, '3'
			je	fold_game
			cmp	eax, '2'
			je	fold_hand
			cmp	eax, '1'
			je	bet3

			jmp	step3_loop

		fold_game:
			call	raw_mode_off
			call	render_fold_game
			jmp	program_end

		fold_hand:
			call	render_fold_hand

			;push	1		; Player ID
			;call	pay_penalty
			;add		esp, 4

			; Call function to determine random ai winner for this hand?
			; if so, print a message alerting the player which ai won

			jmp	start_hand

		bet3:
			

		; Step 4
		; Print shifting notification
		; call shift_cards

		; Step 5
		; print Step 5 Actions
		; Check if player raises bets (only once)
		; query call to player if yes then execute call procedure for ai/game, else run query to each npc
		; if call is yes (mark players involved, call shift, reveal hands, execute call rules along w/ end game/hand rules)
		; else run call query for each ai

		; Step 6
		; print Step 6 Actions
		; draw up to 7 cards (the 8th slot is saved for draws)
		; a player may then discard one card if their card count is greater than 2

		; Step 7
		; Print shifting notification
		; call shift_cards

		; Step 8
		; print Step 8 Actions
		; same as Step 5

		; Step 9
		; print shifting notification
		; call shift_cards

		; Step 10
		; print end of hand notification
		; reveal all player cards & totals
		; check each player's hand & assign them a hidden marker value to determine who wins
		; if a player has an idiot's array mark them as 1, if they have have a pure sabacc mark them as 2, if they have a weak sabacc, mark them as 3
		; if the total of each players' marker is 0 then the highest absolute valued hand wins & that player has the hand pot added to their credits, then 10 is subbed from each player's credit score (if 10 cannot be subbed from someone they are out of the game), 20 is added to the sabacc pot & the game jmps to the beginning of the hand (most likely innit_board)
		; if more than 1 player has the highest winning hand, then they each draw a card and however meets the conditions of the tie rules gets the pot (or splits it to each player who ties again) & the game ends
		; if only 1 player has the highest winning hand, then add both pots to their credits & end the game

	program_end:
	call	raw_mode_off

	; Push Game Variables off of Stack
	add	esp, 40

	; *********** CODE ENDS HERE ***********
	mov	eax, 0
	mov	esp, ebp
	pop	ebp
	ret
