%{
#include <stdio.h>
/* C Declarations and Definitions */
%}
/* Regular Expression Definitions */

/* Keyword */
CHAR 				"char"
ELSE				"else"
FOR 				"for"
IF 					"if"
INT 				"int"
RET 				"return"
VOID 				"void"

/* Identifier */
IDENTIFIER 			[a-zA-Z][a-zA-Z0-9]*

/* Constants */
INTEGER_CONSTANT 	(\+|-)?[1-9][0-9]*|(0)[0-9]*?
CHARACTER_CONSTANT 	'([^'\\]|\\[\\'\"?abfnrtv])'

/* String Literal */
STRING_LITERAL 		["][^\"\\\n][\n]*(\\0)?([^\"\\\n]*[\n]*)?["]

/* Punctuator */
PUNCTUATOR			(\[|\]|\(|\)|\{|\}|->|&|\*|\+|-|\/|%|!|\?|<|>|<=|>=|==|!=|&&|\|\||=|\:|;|\,)

/* Comments */
MULTI_LINE_COMM		(\/\*)[^(\*\/)]*(\*\/)
SINGLE_LINE_COMM 	\/\/[^\n]*

/* Whitespace */
WS					[ \t\n]

/* Definitions of Rules \& Actions */
%%

{CHAR} 					{ printf("<KEYWORD, char>"); /*Keyword Rule*/}
{ELSE} 					{ printf("<KEYWORD, else>");/* Keyword Rule */ }
{FOR}					{ printf("<KEYWORD, for>"); /* Keyword Rule */}
{IF} 					{ printf("<KEYWORD, if>"); /* Keyword Rule */}
{INT} 					{ printf("<KEYWORD, int>"); /* Keyword Rule */}
{RET} 					{ printf("<KEYWORD, return>"); /* Keyword Rule */}
{VOID} 					{ printf("<KEYWORD, void>"); /* Keyword Rule */}
{IDENTIFIER}			{ printf("<IDENTIFIER, %s>", yytext); /* Identifier Rule */ }
{INTEGER_CONSTANT} 		{ printf("<INTEGER CONSTANT,%s>",yytext);/* Literal Rule */ }
{CHARACTER_CONSTANT} 	{ printf("<CHARACTER CONSTANT,%s>",yytext);/* Literal Rule */ }
{STRING_LITERAL} 		{ printf("<STRING LITERAL,%s>", yytext);/* Literal Rule */ } 
{PUNCTUATOR} 			{ printf("<PUNCTUATOR,%s>", yytext); /* Statement Rule */ }
{MULTI_LINE_COMM} 		{ printf("<MULTI LINE COMMENT, %s>", yytext);/* Multiple Comment Rule */ }
{SINGLE_LINE_COMM} 		{ printf("<SINGLE LINE COMMENT, %s>", yytext);/* Single Comment Rule */ }
{WS}        			{ /* Ignore white-space */ }
.						{ printf("<INVALID TOKEN>"); exit(1); }

%%

int yywrap() {
    return 1;
}
