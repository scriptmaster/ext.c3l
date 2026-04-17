all:
	@echo make build
	@echo make clean

build:
	@make fiber_test

clean:
	-@rm -f *.exe *.pdb
	-@rm -f fiber_test

C3C = c3c compile
EXT = ../../ext
LIBC = $(EXT)/c/*.c3
FIBER = $(EXT)/fiber/*.c3 
MEM = $(EXT)/mem/*.c3 $(EXT)/debug/*.c3
LIBS = $(FIBER) $(MEM) $(LIBC)

TARGET ?= linux
ifeq ($(TARGET),winrel)
	T = --target windows-x64 -Os
else ifeq ($(TARGET),win)
	T = --target windows-x64
else
	T =
endif

fiber_test: fiber_test.c3
	$(C3C) $^ $(LIBS) -o $@ $(T)
