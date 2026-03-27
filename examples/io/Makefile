all:
	@echo make build
	@echo make clean

build:
	@make cfile_example
	@make scan_dir

clean:
	-@rm -f cfile_example
	-@rm -f x 
	-@rm -f scan_dir

C3C = c3c compile
EXT = ../../ext
LIBC = $(EXT)/c/*.c3
IO = $(EXT)/io/*.c3 

cfile_example: cfile_example.c3
	$(C3C) $^ $(LIBC) $(IO) -o $@

scan_dir: scan_dir.c3
	$(C3C) $^ $(LIBC) $(IO) -o $@



