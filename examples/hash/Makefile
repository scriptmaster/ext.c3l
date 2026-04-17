all:
	@echo make build
	@echo make clean

build:
	make murmurtest
	make cityexample

clean:
	-@rm -f murmurtest
	-@rm -f cityexample

C3C = c3c compile
EXT = ../../ext
LIBC = $(EXT)/c/*.c3
HASH = $(EXT)/hash/*.c3

TARGET ?= linux
ifeq ($(TARGET),winrel)
	T = --target windows-x64 -Os
else ifeq ($(TARGET),win)
	T = --target windows-x64
else
	T =
endif

murmurtest: murmurtest.c3
	$(C3C) $^ $(LIBC) $(HASH) -o $@ $(T)

cityexample: cityexample.c3
	$(C3C) $^ $(LIBC) $(HASH) -o $@ $(T)
