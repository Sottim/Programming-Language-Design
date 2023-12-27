#ifndef __PARSER_H
#define __PARSER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_SIZE 10000

extern int next_instr, temp_count, address_ind;

enum quad_data_types {DEFAULT_, PLUS, MINUS, INTO, DIV, PERCENT, U_PLUS, U_MINUS, BW_U_NOT, U_NEGATION, 
				SL, SR, LT, LTE, GT, GTE, EQ, NEQ, BW_AND, BW_XOR, PARAM, RETURN_EXP, RETURN_, Function,
  				BW_INOR, LOG_AND, LOG_OR, goto_LT, goto_LTE, goto_GT, goto_GTE, goto_EQ, goto_NEQ, call,
    			EQ_BRACKET,EQ_ADDR_BRACKET, BRACKET_EQ, U_ADDR, U_STAR, ASSIGN, GOTO_, IF_GOTO, IF_FALSE_GOTO, STAR_EQUAL, STAR_BRACKET_EQ,STAR_EQ_BRACKET,ADDR_BRACKET_EQ};

enum date_types { ARRAY, PTR, FUNCTION, VOID_, CHAR_, INT_, DOUBLE_, BOOL_, STRING_, INT_PTR, CHAR_PTR};

typedef struct lnode{
    int index_list;
    struct lnode *next;
}lnode;

typedef struct tNode{
	date_types up;
    date_types down;
    int* l;
    struct tNode *r;
}tNode;
extern tNode *t;

typedef struct symbol_table_record{
    char* name;
    char** type;
    char* initial_value;
    int size;
    int offset;
	int array_ind;
    struct symbol_table *nested_table;
}symbol_table_record;

typedef struct symbol_table{
    symbol_table_record *list;
    int size;
	int curr_size; 
    int curr_offset;
	char* name;
	int return_ind;
}symbol_table;

typedef struct parameter_list{
	symbol_table_record *parameter;
	struct parameter_list *next;
}parameter_list;

typedef struct fields_quad{
	char *arg1;
	char *arg2;
	char *res;
	quad_data_types op;
	symbol_table_record *arg1_loc;
	symbol_table_record *arg2_loc;
	symbol_table_record *res_loc;
}fields_quad;

typedef struct quadArray{
	fields_quad *quad_Table;
}quadArray;

typedef union attribute{										
	int int_data;
	double double_data;
	char char_data;
	char* str_data;
}attribute;

typedef struct attribute_expression{                                                
	symbol_table_record *loc;
	lnode *TL;
	lnode *FL;
	lnode *NL;
	tNode *type;
	symbol_table_record *array;
	symbol_table_record *loc1;												
	attribute val;
    int ind;
	int pointer_ind;
}attribute_expression;

typedef struct data_type{
    char* name;
    char* type;
    int pointer_indicator;
    int size;
    char* value;
	symbol_table_record *loc;
	int array_ind;
}data_type;

typedef struct parameter_type{
    char** parameters;
    char** names;
}parameter_type;

tNode *new_node(date_types , int);
tNode *merge_node(tNode *, tNode *);
lnode *makelist(int);
lnode *merge(lnode *, lnode *);
void backpatch(lnode *, int);
int typecheck(tNode *,tNode *);
void conv2Bool(attribute_expression *);
parameter_list *make_param_list(symbol_table_record *);
parameter_list *merge_param_list(parameter_list *, parameter_list *);
int compute_width(tNode *);
char* converter(date_types temp);

extern symbol_table *global_table;
extern symbol_table *curr_table;
extern quadArray *quad_;

#endif
