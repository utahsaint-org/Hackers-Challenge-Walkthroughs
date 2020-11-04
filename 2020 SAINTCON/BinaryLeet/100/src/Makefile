
FILE = secure_door

build: clean compile link

compile:
	nasm -f elf64 ${FILE}.asm -o ${FILE}.o

link:
	ld ${FILE}.o -o ${FILE}

clean:
	rm -f *.o; rm -f ${FILE};
