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

tcpclient: tcpclient.c3
	$(C3C) $^ $(LIBC) $(NET) -o $@

udpclient: udpclient.c3
	$(C3C) $^ $(LIBC) $(NET) -o $@

tcpserver: tcpserver.c3
	$(C3C) $^ $(LIBC) $(NET) -o $@

udpserver: udpserver.c3
	$(C3C) $^ $(LIBC) $(NET) -o $@

