all:
	@echo make build
	@echo make clean

build:
	@make fiber_test

clean:
	-@rm -f fiber_test

C3C = c3c compile
EXT = ../../ext
LIBC = $(EXT)/c/*.c3
FIBER = $(EXT)/fiber/*.c3 

fiber_test: fiber_test.c3
	$(C3C) $^ $(LIBC) $(FIBER) -o $@

fiber_test.exe: fiber_test.c3
	$(C3C) $^ $(LIBC) $(FIBER) -o $@ --target windows-x64 --winsdk ~/p/msvc_sdk/x64

