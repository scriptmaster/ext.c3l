all:
	@echo "make build-all"
	@echo "make clean"
	@echo "make pull"
	@echo "make push"

build-all:
	@make udpserver
	@make udpclient
	@make tcpserver
	@make tcpclient

tcpclient:
	@c3c compile examples/tcpclient.c3 ext/net/tcp*.c3 ext/libc/*.c3 -o build/tcpclient
	# c3c compile examples/tcpclient.c3 ext/net/tcp*.c3 ext/libc/*.c3 -o build/tcpclient --target windows-x64 --winsdk ~/p/msvc_sdk/x64

tcpserver:
	@c3c compile examples/tcpserver.c3 ext/net/tcp*.c3 ext/libc/*.c3 -o build/tcpserver

udpclient:
	@c3c compile examples/udpclient.c3 ext/net/udp*.c3 ext/libc/*.c3 -o build/udpclient

udpserver:
	@c3c compile examples/udpserver.c3 ext/net/udp*.c3 ext/libc/*.c3 -o build/udpserver

clean:
	@rm -rf ./build/*
	@rm -rf ./ext/*/obj

push:
	@make clean
	@make pull
	@git add .
	@git commit -m "update"
	@git push origin main

pull:
	@git pull origin main
