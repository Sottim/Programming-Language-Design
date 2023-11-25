%{

/* C declaration and definations */
#include <stdio.h>
extern int yylex();
void yyerror(char *s);
extern char* yytext;

%}

%token ID
%token VOID
%token INT
%token CHAR
%token INTEGER_CONSTANT
%token CHAR_CONSTANT
%token STRING_LITERAL
%token OP_PARENTHESIS
%token CL_PARENTHESIS
%token OP_SQUARE
%token CL_SQUARE
%token OP_CURLY
%token CL_CURLY
%token ARROW
%token ADDRESS
%token ADD
%token SUB
%token MULT
%token EXCLAMATION
%token DIV
%token PERCENT
%token LT
%token GT 
%token LEQ 
%token GEQ 
%token EQ
%token NEQ
%token EQUALS 
%token AND
%token OR
%token QUESTIONMARK 
%token COLON 
%token COMMA
%token SEMICOLON
%token IF
%token ELSE
%token FOR
%token RET

%start translation_unit

%%

primary_expression: ID {printf("primary_expression\n");}
                    | constant {printf("primary_expression\n");}
                    | STRING_LITERAL {printf("primary_expression\n");}
                    | OP_PARENTHESIS expression CL_PARENTHESIS {printf("primary_expression\n");}
                    ;
constant: INTEGER_CONSTANT
        | CHAR_CONSTANT
        ;

postfix_expression: primary_expression {printf("postfix_expression\n");}
                    | postfix_expression OP_SQUARE expression CL_SQUARE {printf("postfix_expression\n");}
                    | postfix_expression OP_PARENTHESIS argument_expression_list_opt CL_PARENTHESIS {printf("postfix_expression\n");}
                    | postfix_expression ARROW ID {printf("postfix_expression\n");}
                    ;

argument_expression_list: assignment_expression {printf("argument_expression_list\n");}
                        | argument_expression_list COMMA assignment_expression {printf("argument_expression_list\n");}
                        ;

argument_expression_list_opt: argument_expression_list 
                        |
                        ;

unary_expression: postfix_expression {printf("unary_expression\n");}
                | unary_operator unary_expression {printf("unary_expression\n");}
                ;

unary_operator: ADDRESS {printf("unary_operator\n");}
               | MULT {printf("unary_operator\n");}
               | ADD {printf("unary_operator\n");}
               | SUB {printf("unary_operator\n");}
               | EXCLAMATION {printf("unary_operator\n");}
               ;

multiplicative_expression: unary_expression {printf("multiplicative_expression\n");}
                            | multiplicative_expression MULT unary_expression {printf("multiplicative_expression\n");}
                            | multiplicative_expression DIV unary_expression {printf("multiplicative_expression\n");}
                            | multiplicative_expression PERCENT unary_expression {printf("multiplicative_expression\n");}
                            ;

additive_expression: multiplicative_expression {printf("additive_expression\n");}
                    | additive_expression ADD multiplicative_expression {printf("additive_expression\n");}
                    | additive_expression SUB multiplicative_expression {printf("additive_expression\n");}
                    ;

relational_expression: additive_expression {printf("relational_expression\n");}
                    | relational_expression LT additive_expression {printf("relational_expression\n");}
                    | relational_expression GT additive_expression {printf("relational_expression\n");}
                    | relational_expression LEQ additive_expression {printf("relational_expression\n");}
                    | relational_expression GEQ additive_expression {printf("relational_expression\n");}
                    ;

equality_expression: relational_expression {printf("equality_expression\n");}
                    | equality_expression EQ relational_expression {printf("equality_expression\n");}
                    | equality_expression NEQ relational_expression {printf("equality_expression\n");}
                    ;

logical_AND_expression: equality_expression {printf("logical_AND_expression\n");}
                        | logical_AND_expression AND equality_expression{printf("logical_AND_expression\n");}
                        ;

logical_OR_expression: logical_AND_expression {printf("logical_OR_expression\n");}
                        | logical_OR_expression OR logical_AND_expression {printf("logical_OR_expression\n");}
                        ;

conditional_expression: logical_OR_expression {printf("conditional_expression\n");}
                        | logical_OR_expression QUESTIONMARK expression COLON conditional_expression {printf("conditional_expression\n");}
                        ;

assignment_expression: conditional_expression {printf("assignment_expression\n");}
                        | unary_expression EQUALS assignment_expression {printf("assignment_expression\n");}
                        ;

expression: assignment_expression {printf("expression\n");}
                        ;


declaration: type_specifier init_declarator SEMICOLON {printf("declaration\n");}
                        ;

init_declarator: declarator {printf("init_declarator\n");}
                | declarator EQUALS initilizer {printf("init_declarator\n");}
                ;

type_specifier: VOID {printf("type_specifier\n");}
                | CHAR {printf("type_specifier\n");}
                | INT {printf("type_specifier\n");}
                ;

declarator: pointer_opt direct_declarator {printf("declarator\n");}
            ;

direct_declarator: ID {printf("direct_declarator\n");}
                    | ID OP_SQUARE INTEGER_CONSTANT CL_SQUARE {printf("direct_declarator\n");}
                    | ID OP_PARENTHESIS parameter_list_opt CL_PARENTHESIS {printf("direct_declarator\n");}
                    ;

pointer: MULT {printf("pointer\n");}
        ;
    
pointer_opt: pointer 
            | 
            ;
        
parameter_list: parameter_declaration {printf("parameter_list\n");}
                | parameter_list COMMA parameter_declaration {printf("parameter_list\n");}
                ;

parameter_list_opt: parameter_list 
                    |
                    ;

parameter_declaration: type_specifier pointer_opt ID_opt {printf("parameter_declaration\n");}
                        | 
                        ;

ID_opt: ID 
        | 
        ;

initilizer: assignment_expression {printf("initilizer\n");}
            ;


statement: compound_statement {printf("statement\n");}
            | expression_statement {printf("statement\n");}
            | selection_statement {printf("statement\n");}
            | iteration_statement {printf("statement\n");}
            | jump_statement {printf("statement\n");}
            ;

compound_statement: OP_CURLY block_item_list_opt CL_CURLY {printf("compound_statement\n");}
                    ;

block_item_list: block_item {printf("block_item_list\n");}
                | block_item_list block_item {printf("block_item_list\n");}
                ;

block_item_list_opt: block_item_list 
                    | 
                    ;

block_item: declaration {printf("block_item\n");}
            | statement {printf("block item\n");}
            ;

expression_statement: expression_opt SEMICOLON {printf("expression_statement\n");}
                    ;

expression_opt: expression
                | 
                ;

selection_statement: IF OP_PARENTHESIS expression CL_PARENTHESIS statement {printf("selection_statement\n");}
                    | IF OP_PARENTHESIS expression CL_PARENTHESIS statement ELSE statement {printf("selection_statement\n");}
                    ;
                
iteration_statement: FOR OP_PARENTHESIS expression_opt SEMICOLON expression_opt SEMICOLON expression_opt CL_PARENTHESIS statement {printf("iteration_statement\n");}
                    ;
                
jump_statement: RET expression_opt SEMICOLON {printf("jump_statement\n");}
;

translation_unit: external_declaration {printf("translation_unit\n");}
                | translation_unit external_declaration {printf("translation_unit\n");}
                ;

external_declaration: declaration {printf("external_declaration\n");}
                    | function_defination {printf("external_declaration\n");}
                    ;

function_defination: type_specifier declarator compound_statement {printf("function_defination\n");}
                    ;

%%

void yyerror(char *s) {
    printf("Error: %s on '%s'\n", s, yytext);
}






        