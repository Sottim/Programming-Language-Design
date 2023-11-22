/* **************************************************************/
/* ****************** TAC GENERATOR (QUAD ARRAY) ****************/
/* ****************** AMBIGUOUS GRAMMAR *************************/
/* **************************************************************/
%{ // C Declarations and Definitions
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "Parser.h"

extern int yylex();

void yyerror(char *s);
void printrule(char *s);

quad *qArray[NSYMS]; // Store of Quads
int quadPtr = 0; // Index of next quad

%}
%union { // Placeholder for a value
	int intval;
	symboltable *symp;
}

%token <intval> NUMBER
%token <symp> NAME
%type <symp> expression

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%%
list_of_statements: statement
{ printrule("L -> S"); }
;
list_of_statements: list_of_statements statement
{ printrule("L -> L S"); }
;
statement: NAME '=' expression ';'
{ 
	qArray[quadPtr++] = new_quad_unary(COPY, $1->name, $3->name);
	printrule("S -> id = E"); 
}
;
expression: expression '+' expression
{
	$$ = gentemp();
	qArray[quadPtr++] = new_quad_binary(PLUS, $$->name, $1->name, $3->name);
	printrule("E -> E + E");
}
| expression '-' expression
{
	$$ = gentemp();
	qArray[quadPtr++] = new_quad_binary(MINUS, $$->name, $1->name, $3->name);
	printrule("E -> E - E");
}
| expression '*' expression
{
	$$ = gentemp();
	qArray[quadPtr++] = new_quad_binary(MULT, $$->name, $1->name, $3->name);
	printrule("E -> E * E");
}
| expression '/' expression
{
	$$ = gentemp();
	qArray[quadPtr++] = new_quad_binary(DIV, $$->name, $1->name, $3->name);
	printrule("E -> E / E");
}
| '(' expression ')'
{ $$ = $2; printrule("E -> (E)"); }
| '-' expression %prec UMINUS
{
	$$ = gentemp();
	qArray[quadPtr++] = new_quad_unary(UNARYMINUS, $$->name, $2->name);
	printrule("E -> -E");
}
| NUMBER
{
	$$ = gentemp();
	char num_s[10];
	sprintf(num_s, "%d", $1);
	qArray[quadPtr++] = new_quad_unary(COPY, $$->name, num_s);
	printrule("E -> num");
}
| NAME
{ $$ = $1; printrule("E -> id"); }
;
%%
void yyerror(char *s) {
	printf("%s\n", s);
}
void printrule(char *s) {
	FILE *fp = fopen("Trace.txt", "a");
	if (fp) {
		fprintf(fp, "%s\n", s);
	}
	fclose(fp);
}
int main() {
	yyparse();
	for (int i = 0; i < quadPtr; i = i + 1)
		print_quad(qArray[i]);
	
	return 0;
}

/* **************************************************************/
/* ****************** TAC GENERATOR *****************************/
/* ****************** AMBIGUOUS GRAMMAR *************************/
/* **************************************************************/
/*
%{ // C Declarations and Definitions
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "Parser.h"
extern int yylex();
void yyerror(char *s);
void printrule(char *s);
%}
%union { // Placeholder for a value
	int intval;
	symboltable *symp;
}
%token <intval> NUMBER
%token <symp> NAME
%type <symp> expression

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%%
list_of_statements: statement
{ printrule("L -> S ."); }
;
list_of_statements: list_of_statements statement
{ printrule("L -> L S ."); }
;
statement: NAME '=' expression ';'
{ 
	emit_copy($1->name, $3->name); 
	printrule("S -> id = E"); 
}
;
expression: expression '+' expression
{ 
	$$ = gentemp();
	emit_binary($$->name, $1->name, '+', $3->name);
	printrule("E -> E + E");
}
| expression '-' expression
{
	$$ = gentemp();
	emit_binary($$->name, $1->name, '-', $3->name);
	printrule("E -> E - E");
}
| expression '*' expression
{
	$$ = gentemp();
	emit_binary($$->name, $1->name, '*', $3->name);
	printrule("E -> E * E");
} 
| expression '/' expression
{
	$$ = gentemp();
	emit_binary($$->name, $1->name, '/', $3->name);
	printrule("E -> E / E");
}
| '(' expression ')'
{ $$ = $2; printrule("E -> (E)"); }
| '-' expression %prec UMINUS
{
	$$ = gentemp();
	emit_unary($$->name, $2->name, '-');
	printrule("E -> -E");
}
| NUMBER
{
	$$ = gentemp();
	char num_s[10];
	sprintf(num_s, "%d", $1);
	emit_copy($$->name, num_s);
	printrule("E -> num");
}
| NAME
{ $$ = $1; printrule("E -> id"); }
;
%%
void yyerror(char *s) {
	printf("%s\n", s);
}
void printrule(char *s) {
	FILE *fp = fopen("Trace.txt", "a");
	if (fp) {
		fprintf(fp, "%s\n", s);
	}
	fclose(fp);
	//	printf("%s\n", s);
}
int Parser_main() {
	yyparse();

	return 0;
}
*/
/* **************************************************************/
/* ****************** PROGRAMMABLE CALCULATOR *******************/
/* ****************** AMBIGUOUS GRAMMAR *************************/
/* **************************************************************/
/*
%{ // C Declarations and Definitions
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "Parser.h"
extern int yylex();
void yyerror(char *s);
void printrule(char *s);
%}
%union { // Placeholder for a value
	int intval;
	struct symtab *symp;
}
%token <intval> NUMBER
%token <symp> NAME
%type <intval> expression

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%%
list_of_statements: marker statement '.'
{ printrule("L -> S ."); }
;
list_of_statements: list_of_statements statement '.'
{ printrule("L -> L S ."); }
;
statement: NAME '=' expression
{ $1->value = $3; printrule("S -> id = E"); }
| expression
{ printf("= %d\n", $1); printrule("S -> E"); }
;
expression: expression '+' expression
{ $$ = $1 + $3; printrule("E -> E + E"); }
| expression '-' expression
{ $$ = $1 - $3; printrule("E -> E - E"); }
| expression '*' expression
{ $$ = $1 * $3; printrule("E -> E * E"); }
| expression '/' expression
{
	if ($3 == 0)
	yyerror("divide by zero");
	else
		$$ = $1 / $3;
	printrule("E -> E / E");
}
| '(' expression ')'
{ $$ = $2; printrule("E -> (E)"); }
| '-' expression %prec UMINUS
{ $$ = -$2; printrule("E -> -E"); }
| NUMBER
{ printrule("E -> num"); }
| NAME
{ $$ = $1->value; printrule("E -> id"); }
;
marker:
{
	FILE *fp = fopen("Trace.txt", "w");
	fclose(fp);
}
%%
void yyerror(char *s) {
	printf("%s\n", s);
}
void printrule(char *s) {
	FILE *fp = fopen("Trace.txt", "a");
	if (fp) {
		fprintf(fp, "%s\n", s);
	}
	fclose(fp);
	//	printf("%s\n", s);
}
int Parser_main() {
	yyparse();

	return 0;
}
*/

/* **************************************************************/
/* ****************** PROGRAMMABLE CALCULATOR *******************/
/* ****************** UNAMBIGUOUS GRAMMAR ***********************/
/* **************************************************************/
/*
%{ // C Declarations and Definitions
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "Parser.h"
extern int yylex();
void yyerror(char *s);
void printrule(char *s);
%}
%union { // Placeholder for a value
	int intval;
	struct symtab *symp;
}
%token <intval> NUMBER
%token <symp> NAME
%type <intval> expression
%type <intval> term
%type <intval> factor
%%
list_of_statements: marker statement '.'  
{ printrule("L -> S ."); }
;
list_of_statements: list_of_statements statement '.' 
{ printrule("L -> L S ."); }
;
statement: NAME '=' expression
{ $1->value = $3; }
| expression
{ printf("= %d\n", $1); printrule("S -> E"); }
;
expression: expression '+' term
{ $$ = $1 + $3; printrule("E -> E + T"); };
| expression '-' term
{ $$ = $1 - $3; printrule("E -> E - T"); }
| term
{ printrule("E -> T"); }
;
term: term '*' factor
{ $$ = $1 * $3; printrule("T -> T * F"); }
| term '/' factor
{
	if ($3 == 0)
		yyerror("divide by zero");
	else
		$$ = $1 / $3;
	printrule("T -> T / F");
}
| factor
{ printrule("T -> F"); }
;
factor: '(' expression ')'
{ $$ = $2; printrule("F -> (E)"); }
| '-' factor
{ $$ = -$2; printrule("F -> -F"); }
| NUMBER
{ printrule("F -> num"); }
| NAME
{ $$ = $1->value; printrule("F -> id"); }
;
marker:
{
	FILE *fp = fopen("Trace.txt", "w");
	fclose(fp);
}
%%
	void yyerror(char *s) {
		printf("%s\n", s);
	}
void printrule(char *s) {
	FILE *fp = fopen("Trace.txt", "a");
	if (fp) {
		fprintf(fp, "%s\n", s);
	}
	fclose(fp);
	//	printf("%s\n", s);
}
int Parser_main() {
	yyparse();

	return 0;
}
*/

/* **************************************************************/
/* ****************** SIMPLE CALCULATOR *************************/
/* ****************** UNAMBIGUOUS GRAMMAR ***********************/
/* **************************************************************/
/*
%{ // C Declarations and Definitions
#include <string.h>
#include <stdio.h>
extern int yylex();
void yyerror(char *s);
void printrule(char *s);
%}
%union { // Placeholder for a value
	int intval;
}
%token <intval> NUMBER
%type <intval> expression
%type <intval> term
%type <intval> factor
%%
statement_list: statement_list statement '.' { printrule("L -> L S ."); }
	;
statement_list: statement '.'  { printrule("L -> S ."); }
	;
statement: expression { printf("= %d\n", $1); printrule("S -> E"); }
	;
expression: expression '+' term 
	{ $$ = $1 + $3; printrule("E -> E + T"); };
	| expression '-' term 
	{ $$ = $1 - $3; printrule("E -> E - T"); }
	| term 
	{ printrule("E -> T"); }
	;

term: term '*' factor
    { $$ = $1 * $3; printrule("T -> T * F"); }
	| term '/' factor
	{
		if ($3 == 0)
			yyerror("divide by zero");
		else 
			$$ = $1 / $3;
		printrule("T -> T / F");
	}
	|
	factor 
	{ printrule("T -> F"); }
	;

factor: '(' expression ')' 
    { $$ = $2; printrule("F -> (E)"); }
	| '-' factor 
	{ $$ = -$2; printrule("F -> -F"); }
	| NUMBER 
	{ printrule("F -> num"); }
	;
%%
void yyerror(char *s) {
	printf("%s\n", s);
}
void printrule(char *s) {
	printf("%s\n", s);
}
int Parser_main() {
	yyparse();

	return 0;
}
*/