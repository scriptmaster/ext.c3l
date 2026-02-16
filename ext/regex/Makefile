all:
	@echo make build
	@echo make clean

build:
	@make slre
	@make slre_test
	@make regex_test
	@make regex_example

clean:
	-@rm -f slre
	-@rm -f slre_test
	-@rm -f regex_test
	-@rm -f regex_example


slre: slre.c slre_test.c
	cc slre.c slre_test.c -o slre

slre_test: slre.c3 slre_test.c3
	c3c compile slre.c3 slre_test.c3 ../libc/*.c3 -o slre_test

regex_test: regex.c3 regex_test.c3
	c3c compile slre.c3 regex.c3 regex_test.c3 ../libc/*.c3 -o regex_test

regex_example: regex.c3 regex_example.c3
	c3c compile slre.c3 regex.c3 regex_example.c3 ../libc/*.c3 -o regex_example


