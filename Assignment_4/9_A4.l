%{

/* C Declarations and Definitions */
#include "9_A3.tab.h"

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
ID			[a-z_A-Z][a-zA-Z_0-9]*

/* Constants */
INTEGER_CONSTANT 	0|[1-9][0-9]*
CHAR_CONSTANT 	[']([^\'\\\n]|[\'\"?\\abfnrtv])*[']

/* String Literal */
STRING_LITERAL 		["]([^\"\\\n]|[\'\"?\\abfnrtv])*["]

/* Comments */
MULTI_LINE_COMM		(\/\*)[^(\*\/)]*(\*\/)
SINGLE_LINE_COMM 	\/\/[^\n]*

/* Whitespace */
WS					[ \s\t\n]


/* Definitions of Rules \& Actions */

%%

{CHAR} 					{return CHAR;}
{ELSE} 					{return ELSE;}
{FOR}					{return FOR;}
{IF} 					{return IF;}
{INT} 					{return INT;}
{RET} 					{return RET;}
{VOID} 					{return VOID;}
{ID}			        {// Create a new data_type object
							yylval.datatype = new data_type();
							// Assign the string yytext to the name attribute of the first element in yylval.datatype
							(yylval.datatype)[0].name = strdup(yytext);
							// Return the constant IDENTIFIER
							return IDENTIFIER;
						}

{INTEGER_CONSTANT} 		{return INTEGER_CONSTANT;}
{CHAR_CONSTANT} 	    {	// Assign the second character of yytext to yylval.charval
    						yylval.charval = yytext[1];
							// Return the constant CHAR_CONSTANT
    						return CHAR_CONSTANT;
						}
{STRING_LITERAL} 		{// Duplicate the string yytext and assign it to yylval.strval
    						yylval.strval = strdup(yytext);
							// Return the constant STRING_LITERAL
    						return STRING_LITERAL;
						}

"["             {return OP_SQUARE;}
"]"             {return CL_SQUARE;}
"("        {return OP_PARENTHESIS;}
")"        {return CL_PARENTHESIS;}
"{"              {return OP_CURLY;}
"}"              {return CL_CURLY;}
"->"                 {return ARROW;}
"&"               {return ADDRESS;}
"*"                  {return MULT;}
"+"                   {return ADD;}
"-"                   {return SUB;}
"/"                   {return DIV;}
"%"               {return PERCENT;}
"!"           {return EXCLAMATION;}
"?"          {return QUESTIONMARK;}
"<"                    {return LT;}
">"                    {return GT;}
"<="                   {return LEQ;}
">="                   {return GEQ;}
"=="                    {return EQ;}
"!="                   {return NEQ;}
"&&"                   {return AND;}
"||"                    {return OR;}
"="                {return EQUALS;}
":"                 {return COLON;}
";"             {return SEMICOLON;}
","                 {return COMMA;}

{MULTI_LINE_COMM} 		{ /* Ignore-Multi-Line-Comment */ }
{SINGLE_LINE_COMM} 		{ /*Ignore-Single-Line-Comment */ }
{WS}        			{ /* Ignore white-space */ }
.						{}

%%

int yywrap() {
    return 1;
}