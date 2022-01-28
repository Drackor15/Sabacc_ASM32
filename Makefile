NAME=SABACC

all: SABACC

clean:
	rm -rf SABACC SABACC.o
	rm -rf render render.o
	rm -rf gamedata gamedata.o
	rm -rf random random.o

SABACC: SABACC.asm
	nasm -f elf -F dwarf -g SABACC.asm
	nasm -f elf -F dwarf -g render.asm
	nasm -f elf -F dwarf -g gamedata.asm
	nasm -f elf -F dwarf -g random.asm
	gcc -no-pie -g -m32 -o SABACC SABACC.o
	cp SABACC //mnt/c/ImagiSpark/games/Sabacc_ASM32/ ; cp Rules.txt //mnt/c/ImagiSpark/games/Sabacc_ASM32/ ; cp Menu.txt //mnt/c/ImagiSpark/games/Sabacc_ASM32/ ; cp Table.txt //mnt/c/ImagiSpark/games/Sabacc_ASM32/
