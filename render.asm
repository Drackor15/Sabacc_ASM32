segment .data

	; CMDS
	mode_r			db	"r",0
	raw_mode_on_cmd		db	"stty raw -echo",0
	raw_mode_off_cmd	db	"stty -raw echo",0
	cat_menu_cmd		db	"cat /mnt/c/ImagiSpark/games/Sabacc_ASM32/Menu.txt",0
	cat_rules_cmd		db	"cat /mnt/c/ImagiSpark/games/Sabacc_ASM32/Rules.txt",0
	cat_table_cmd		db	"cat /mnt/c/ImagiSpark/games/Sabacc_ASM32/Table.txt",0

	clear_screen_text	db	"clear",0

	; RENDER STRs
	pot_sabacc_str		db	"             SABACC POT: %6d                        ",0
	pot_hand_str		db	"HAND POT: %6d",10,10,0

	player_name		db	"     You - Credits: %d   HoloCards: %d      ",0
	npc1_name		db	"Trigger - Credits: %d   Holocards: %d",10,0
	npc2_name		db	10,"     Rax - Credits: %d   HoloCards: %d      ",0
	npc3_name		db	"Sleeps - Credits: %d   HoloCards: %d",10,0

	step3_str		db	"(1) Bet, (2) Fold from Hand, (3) Fold from Game",10,0
	foldG_str		db	"Folding From This Game...",10,0
	foldH_str		db	"Folding From This Hand, You Pay a Penalty of %d into the Sabacc Pot...",10,0
	interference_str	db	"A shift is about to occur. Do you want to put a card in the interference feild? Y or N"
	shift_str		db	"Shifting Cards...",0
	betcall_str		db	"(1) Raise Bets, (2) Call?, (3) Fold from Game",0	; For steps 5 & 8
	call_query_str		db	"Do you call?",0
	step6_str1		db	"(1) Draw Card, (2) Discard, (3) Fold from Game",0
	step6_str2		db	"(1) Draw Card, (2) Fold from Game",0
	end_hand_str		db	"",0
	end_game_str		db	"You finished the game with %d Credits!",10,0

segment .bss

	buff			resb	25

segment .text
;************* EXTERNALS *******************;
extern	system
extern	putchar
extern	printf

;*************CUSTOM FUNCS******************;

raw_mode_on:
	push	ebp
	mov	ebp, esp

	push	raw_mode_on_cmd
	call	system
	add	esp, 4

	mov	esp, ebp
	pop	ebp
	ret

raw_mode_off:
	push	ebp
	mov	ebp, esp

	push	raw_mode_off_cmd
	call	system
	add	esp, 4

	mov	esp, ebp
	pop	ebp
	ret

; MENUS ****************************

render_menu:
	push	ebp
	mov	ebp, esp

	; clear screen of previous text
	push	clear_screen_text
	call	system
	add	esp, 4

	; print chars from Menu.txt
	push	cat_menu_cmd
	call	system
	add	esp, 4

	; print newline
	push	0x0a
	call	putchar
	add	esp, 4

	mov	esp, ebp
	pop	ebp
	ret

render_rules:
	push	ebp
	mov	ebp, esp

	; clear screen of previous text
	push	clear_screen_text
	call	system
	add	esp, 4

	; print chars from Rules.txt
	push	cat_rules_cmd
	call	system
	add	esp, 4

	; print newline
	push	0x0a
	call	system
	add	esp, 4

	mov	esp, ebp
	pop	ebp
	ret

; GAME Board********************
render_game:
	push	ebp
	mov	ebp, esp

	; clear screen of previous text
	push	clear_screen_text
	call	system
	add	esp, 4

	; Print Sabacc Pot
	mov	eax, DWORD [ebp + 12]
	push	DWORD [eax]
	push	pot_sabacc_str
	call	printf
	add	esp, 8

	; Print Hand Pot
	mov	eax, DWORD [ebp + 8]
	push	DWORD [eax]
	push	pot_hand_str
	call	printf
	add	esp, 8

	; Print Player Data
	mov	eax, DWORD [ebp + 44]
	push	eax
	mov	eax, DWORD [ebp + 16]
	push	DWORD [eax]
	push	player_name
	call	printf
	add	esp, 12

	; Print NPC1 Data
	mov	eax, DWORD [ebp + 40]
	push	eax
	mov	eax, DWORD [ebp + 20]
	push	DWORD [eax]
	push	npc1_name
	call	printf
	add	esp, 12

	; Print Table
	push	cat_table_cmd
	call	system
	add	esp, 4

	; Print NPC2 Data
	mov	eax, DWORD [ebp + 36]
	push	eax
	mov	eax, DWORD [ebp + 24]
	push	DWORD [eax]
	push	npc2_name
	call	printf
	add	esp, 12

	; Print NPC3 Data
	mov	eax, DWORD [ebp + 32]
	push	eax
	mov	eax, DWORD [ebp + 28]
	push	DWORD [eax]
	push	npc3_name
	call	printf
	add	esp, 12

	mov	esp, ebp
	pop	ebp
	ret

; MESSAGES & NOTIFICATIONS*****
render_fold_game:
	push	ebp
	mov	ebp, esp

	push	foldG_str
	call	printf
	add	esp, 4

	mov	eax, DWORD [ebp + 16]
	push	DWORD [eax]
	push	end_game_str
	call	printf
	add	esp, 8

	mov	esp, ebp
	pop	ebp
	ret

render_fold_hand:
	push	ebp
	mov	ebp, esp

	mov	eax, DWORD [ebp + 8]
	push	DWORD [eax]
	push	end_hand_str
	call	printf
	add	esp, 8

	mov	esp, ebp
	pop	ebp
	ret

