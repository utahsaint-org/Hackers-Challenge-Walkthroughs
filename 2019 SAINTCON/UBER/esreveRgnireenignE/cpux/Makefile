
all: dist.tar.gz runit

dist.tar.gz: challenge hint
	tar cf - challenge hint | gzip -9 > $@

challenge: bin
	m68k-linux-gnu-objcopy -I elf32-m68k -O binary $< $@

bin: bin.o
	m68k-linux-gnu-ld -o $@ $@.o
	m68k-linux-gnu-objdump -d $@.o

bin.o: bin.s key.s
	m68k-linux-gnu-as -o $@ bin.s

key.s: gen
	echo -n 'ctf{segagenesis4eva}' | ./gen > $@

gen: gen.c
	$(CC) -Wall -Werror -o $@ $<

runit: runit.c
	m68k-linux-gnu-gcc -Wall -g -static -o runit runit.c
	qemu-m68k -cpu m68030 ./runit ./challenge && echo ""

clean:
	rm -f key.s gen bin challenge dist.tar.gz bin.o runit

