#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "9_A4_translator.h"

symboltable symtab[NSYMS];	// -> Definition

extern void yyerror(char *s);

symboltable *symlook(char *s) {
	symboltable *sp;
	for (sp = symtab; sp < &symtab[NSYMS]; sp++) {
		/* is it already here? */
		if (sp->name &&
			!strcmp(sp->name, s))
			return sp;
		if (!sp->name) {
			/* is it free */
			sp->name = strdup(s);
			return sp;
		}
		/* otherwise continue to next */
	}
	yyerror("Too many symbols");
	exit(1); /* cannot continue */
} /* symlook */

/* Generate temporary variable */
symboltable *gentemp() {
	static int c = 0; /* Temp counter */
	char str[10]; /* Temp name */
	/* Generate temp name */
	sprintf(str, "t%02d", c++);
	/* Add temporary to symtab */
	return symlook(str);
}

/* Output 3-address codes */
void emit_binary(
	char *s1, // Result
	char *s2, // Arg 1
	char c,   // Operator
	char *s3) // Arg 2
{
	/* Assignment with Binary operator */
	printf("\t%s = %s %c %s\n", s1, s2, c, s3);
}

void emit_unary(
	char *s1, // Result
	char *s2, // Arg 1
	char c)   // Operator
{
	/* Assignment with Unary operator */
	printf("\t%s = %c %s\n", s1, c, s2);
}

void emit_copy(
	char *s1, // Result
	char *s2) // Arg 1
{
	/* Simple Assignment */
	printf("\t%s = %s\n", s1, s2);
}

quad *new_quad_binary(opcodeType op1, char *s1, char *s2, char *s3) {
	quad *q = (quad *)malloc(sizeof(quad));
	q->op = op1;
	q->result = strdup(s1);
	q->arg1 = strdup(s2);
	q->arg2 = strdup(s3);
	return q;
}

quad *new_quad_unary(opcodeType op1, char *s1, char *s2) {
	quad *q = (quad *)malloc(sizeof(quad));
	q->op = op1;
	q->result = strdup(s1);
	q->arg1 = strdup(s2);
	q->arg2 = 0;
	return q;
}

void print_quad(quad* q) {
	if ((q->op <= DIV) && (q->op >= PLUS)) { // Binary Op
		printf("%s = %s ", q->result, q->arg1);
		switch (q->op) {
			case PLUS: printf("+"); break;
			case MINUS: printf("-"); break;
			case MULT: printf("*"); break;
			case DIV: printf("/"); break;
		}
		printf(" %s\n", q->arg2);
	}
	else
	if (q->op == UNARYMINUS) // Unary Op
		printf("%s = - %s\n", q->result, q->arg1);
	else // Copy
		printf("%s = %s\n", q->result, q->arg1);
}