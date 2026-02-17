all:
	@echo make build
	@echo make clean

build:
	@make cfile_example

clean:
	-@rm -f cfile_example

C3C = c3c compile
EXT = ../../ext
LIBC = $(EXT)/libc/*.c3
IO = $(EXT)/io/*.c3 

cfile_example: cfile_example.c3
	$(C3C) $^ $(LIBC) $(IO) -o $@


