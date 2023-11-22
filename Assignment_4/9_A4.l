/* **************************************************************/
/* ****************** TAC GENERATOR *****************************/
/* ****************** PROGRAMMABLE CALCULATOR *******************/
/* **************************************************************/
%{
#include "Parser.h"
#include "Parser.tab.h" // Bison generated file of token symbols and attributes
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
%}
ID	[A-Za-z][A-Za-z0-9]*
%%
[0]|[1-9]+[0-9]*	{
						yylval.intval = atoi(yytext); // yylval denotes the attribute of the current symbol
						return NUMBER;
					}
['\t'' ']			{
						; // ignore white space
					}
{ID}				{
						yylval.symp = symlook(yytext); // return symbol pointer
						return NAME;
					}
"$"					{
						return 0; // end of input
					}
'\n'|.				{ return yytext[0]; }
%%
int yywrap() {
	return 0;
}


/* ********************************************************/
/* ****************** SIMPLE CALCULATOR *******************/
/* ********************************************************/
/*
%{
#include "Parser.tab.h" // Bison generated file of token symbols and attributes
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
%}
%%
[0]|[1-9]+[0-9]*	{ 
						yylval.intval = atoi(yytext); // yylval denotes the attribute of the current symbol
						return NUMBER;
					}
['\t'' ']			{
						; // ignore white space 
					}
"$"					{
						return 0; // end of input
					}
'\n'|.				{ return yytext[0]; }
%%
int yywrap() {
	return 0;
}
*/