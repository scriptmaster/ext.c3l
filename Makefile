all:
	@echo "make build-all"
	@echo "make clean"
	@echo "make pull"
	@echo "make push"

build-all:
	@cd ./examples/regex && make build
	@cd ./examples/net && make build
	@cd ./examples/hash && make build
	@cd ./examples/io && make build
	@cd ./examples/fiber && make build

clean:
	@rm -rf ./build/*
	@rm -rf ./ext/*/obj
	@cd ./examples/regex && make clean
	@cd ./examples/net && make clean
	@cd ./examples/hash && make clean
	@cd ./examples/io && make clean
	@cd ./examples/fiber && make clean

push:
	@make clean
	@make pull
	@git add .
	@git commit -m "update"
	@git push origin main

pull:
	@git pull origin main
