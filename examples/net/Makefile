all:
	@echo make build
	@echo make clean

build:
	make tcpserver
	make tcpclient
	make udpserver
	make udpclient

clean:
	-@rm -f tcpserver
	-@rm -f tcpclient
	-@rm -f udpclient
	-@rm -f udpclient

C3C = c3c compile
EXT = ../../ext
LIBC = $(EXT)/c/*.c3
NET = $(EXT)/net/*.c3

TARGET ?= linux
ifeq ($(TARGET),winrel)
	T = --target windows-x64 -Os
else ifeq ($(TARGET),win)
	T = --target windows-x64
else
	T =
endif

tcpclient: tcpclient.c3
	$(C3C) $^ $(LIBC) $(NET) -o $@ $(T)

udpclient: udpclient.c3
	$(C3C) $^ $(LIBC) $(NET) -o $@ $(T)

tcpserver: tcpserver.c3
	$(C3C) $^ $(LIBC) $(NET) -o $@ $(T)

udpserver: udpserver.c3
	$(C3C) $^ $(LIBC) $(NET) -o $@ $(T)

