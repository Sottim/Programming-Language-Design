build: 
	bison 9_A3.y --defines=9_A3.tab.h -o 9_A3.tab.c
	flex -o lex.yy.c 9_A3.l
	gcc -o parser lex.yy.c 9_A3.tab.c 9_A3.c -Werror

test: build
	./parser < 9_A3.nc

clean: 
	rm -f 9_A3.tab.c 9_A3.tab.h lex.yy.c parser