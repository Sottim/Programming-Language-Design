#ifndef __PARSER_H
#define __PARSER_H

/* Symbol Table */
typedef struct symtab {
	char *name;
	int value;
} symboltable;

symboltable *symlook(char *);

#define NSYMS 20
extern symboltable symtab[]; // -> Declaration

/* TAC generation support */
symboltable *gentemp();

void emit_binary(
	char *s1,  // Result
	char *s2,  // Arg 1
	char c,    // Operator
	char *s3); // Arg 2

void emit_unary(
	char *s1, // Result
	char *s2, // Arg 1
	char c);  // Operator

void emit_copy(
	char *s1,  // Result
	char *s2); // Arg 1

/* Support for Lazy TAC generation through Quad array */
typedef enum {
	PLUS = 1,
	MINUS,
	MULT,
	DIV,
	UNARYMINUS,
	COPY,
} opcodeType;

typedef struct quad_tag {
	opcodeType op;
	char *result, *arg1, *arg2;
} quad;

quad *new_quad_binary(opcodeType op1, char *s1, char *s2, char *s3);

quad *new_quad_unary(opcodeType op1, char *s1, char *s2);

void print_quad(quad* q);
#endif // __PARSER_H