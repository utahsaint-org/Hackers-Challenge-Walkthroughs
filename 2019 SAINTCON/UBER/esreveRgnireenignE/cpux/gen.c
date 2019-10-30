
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <err.h>

int
main() {
	int fd;
	unsigned char k, c;
	ssize_t r;

	fd = open("/dev/urandom", O_RDONLY, 0);
	if (fd == -1)
		err(1, "/dev/urandom");

	printf("xorstuff:\n");
	for (;;) {
		r = read(fileno(stdin), &k, sizeof(k));
		if (r == 0)
			break;
		if (r == -1)
			err(1, "read stdin");

		r = read(fd, &c, sizeof(c));
		if (r == 0)
			errx(1, "eof on urandom?!");
		if (r == -1)
			err(1, "read urandom");
		k = k ^ c;
		printf("\t.byte 0x%02x, 0x%02x\n", k, c);
	}

	r = read(fd, &k, sizeof(k));
	if (r == 0)
	  errx(1, "eof on urandom?!");
	if (r == -1)
	  err(1, "read urandom");

	printf("\t.byte 0x%02x, 0x%02x\n", k, k);

	close(fd);
	return (0);
}
