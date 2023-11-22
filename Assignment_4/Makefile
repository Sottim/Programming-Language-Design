.SUFFIXES: 

parser: Parser.y Parser.c Lexer.l
	bison -d Parser.y
	flex -o lex.yy.c Lexer.l
	gcc Parser.c Parser.tab.c lex.yy.c -lfl -Werror -o parser

build: parser

test: parser
	./parser < Test.calc