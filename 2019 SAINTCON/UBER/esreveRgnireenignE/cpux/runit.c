
#include <sys/mman.h>
#include <fcntl.h>
#include <err.h>
#include <stdio.h>

int
main(int argc, char *argv[]) {
	void *buf;
	void (*fun)(void);
	int fd;

	if (argc != 2) {
		fprintf(stderr, "%s file\n", argv[0]);
		return (1);
	}

	if ((fd = open(argv[1], O_RDONLY)) == -1)
		err(1, "open %s", argv[1]);

	buf = mmap(NULL, 4096, PROT_READ|PROT_WRITE|PROT_EXEC,
			MAP_FILE|MAP_PRIVATE, fd, 0);
	if (buf == MAP_FAILED)
		err(1, "mmap");
	fun = buf;
	fun();
	return (1);
}

