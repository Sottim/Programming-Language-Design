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
IDENTIFIER 			[a-z_A-Z][a-zA-Z_0-9]*

/* Constants */
INTEGER_CONSTANT 	0|[1-9][0-9]*
CHARACTER_CONSTANT 	[']([^\'\\\n]|[\'\"?\\abfnrtv])*[']

/* String Literal */
S_CHAR              [^"\n]
STRING_LITERAL 		\"{S_CHAR}*\"

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
{MULTI_LINE_COMM} 		{ printf("MULTI LINE COMMENT\n"); }
{SINGLE_LINE_COMM} 		{ printf("SINGLE LINE COMMENT\n");}
{WS}        			{ /* Ignore white-space */ }
.						{ printf("<INVALID TOKEN>"); exit(1); }

%%

int yywrap() {
    return 1;
}
