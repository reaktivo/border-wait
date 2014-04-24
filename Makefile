all:
		mkdir -p lib
		./node_modules/.bin/coffee --compile --bare --output lib/ src/

clean:
		rm -rf lib

.PHONY: all