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

%token <intval> INTEGER_CONSTANT
%token <charval> CHAR_CONSTANT
%token <strval> STRING_LITERAL

%token <datatype> IDENTIFIER
%type <datatype> pointer
%type <datatype> initializer
%type <parametertype> parameter_list2
%type <datatype> declarator
%type <datatype> non_void_type_specifier
%type <datatype> internal_declaration
%type <datatype> parameter_declaration2
%type <datatype> direct_declarator

%type <attribute_exp> primary_expression
%type <attribute_exp> unary_expression
%type <attribute_unary> unary_operator
%type <attribute_exp> multiplicative_expression
%type <attribute_exp> additive_expression
%type <attribute_exp> relational_expression
%type <attribute_exp> equality_expression
%type <attribute_exp> logical_AND_expression
%type <attribute_exp> logical_OR_expression
%type <attribute_exp> conditional_expression
%type <attribute_exp> assignment_expression
%type <param_attr> argument_expression_list
%type <attribute_exp> postfix_expression
%type <attribute_exp> expression

%type <attribute_exp> block_item
%type <attribute_exp> compound_statement
%type <attribute_exp> selection_statement
%type <attribute_exp> statement
%type <attribute_exp> jump_statement
%type <attribute_exp> iteration_statement
%type <attribute_exp> expression_statement
%type <attribute_exp> block_item_list

%type <instr> M;
%type <N_attr> N;
%type <instr> O;


%start translation_unit

%%

primary_expression: ID {symbol_table_record* y = curr_table->lookup($1->name);
						if(!y)
							y = global_table->lookup($1->name);

						if(y == nullptr){
							char semantic_error[20]="Semantic Error!\n";
							cout<<"Semantic Error47!\n";
							yyerror(semantic_error);
						}

						$$.loc = y;
						$1->loc = y;

						date_types dt;
						string s = (y->type)[0];
						if(((y->type).size())>1){
							dt = FUNCTION;
							$$.type = new_node(dt,-1);
						}
						else if(y->array_ind == 1){
							dt = ARRAY;
							if(s.compare("INT")==0){
								$$.type = new_node(dt,-1);
								$$.type->up = INT_;
							}
							else if(s.compare("CHAR")==0){
								$$.type = new_node(dt,-1);
								$$.type->up = CHAR_;
							}
							else if(s.compare("INT*")==0){
								$$.type = new_node(dt,-1);
								$$.type->up = INT_PTR;
							}
							else if(s.compare("CHAR*")==0){
								$$.type = new_node(dt,-1);
								$$.type->up = CHAR_PTR;
							}
						}
						else{
							if(s.compare("INT")==0) $$.type = new_node(INT_,-1);
							else if(s.compare("INT")==0 && y->array_ind==1) $$.type = new_node(INT_PTR,-1);
							else if(s.compare("CHAR")==0) $$.type = new_node(CHAR_,-1);
							else if(s.compare("CHAR")==0 && y->array_ind==1) $$.type = new_node(CHAR_PTR,-1);
							else if(s.compare("INT*")==0) $$.type = new_node(INT_PTR,-1);
							else if(s.compare("CHAR*")==0) $$.type = new_node(CHAR_PTR,-1);
							else if(s.compare("VOID*")==0) $$.type = new_node(PTR,-1);
						}

						$$.array = $$.loc;
						$$.loc1 = 0;}
					
                    | constant {printf("primary_expression\n");}
                    | STRING_LITERAL{
							// Assign the string literal to a temporary variable
							char* temp = $1;

							// Calculate the length of the string literal
							int length = 0;
							for(int i=0; temp[i]!='\0'; i++) length++;
							length -= 2;

							// Assign the string literal to the value field
							$$.val.str_data = $1;
							$$.ind=2;

							// Create a new node of type STRING_ and assign it to the type field
							$$.type = new_node(STRING_, length);

							// Generate a temporary variable of type STRING_ and assign it to the loc field
							$$.loc = curr_table->gentemp3(STRING_, length);

							// Set the array indicator and initial value of the location
							($$.loc)->array_ind = 1;
							($$.loc)->initial_value = temp;

							// Convert the string literal to a string
							char *arg1 = new char[10];
							arg1 = temp;

							// Duplicate the name of the location and assign it to res
							char *res = strdup((($$.loc)->name).c_str());
					    }
                    | OP_PARENTHESIS expression CL_PARENTHESIS {$$ = $2;}
                    ;
					
constant: INTEGER_CONSTANT{
			// Assign the integer constant to the value field
			$$.val.int_data = $1;
			$$.ind=1;

			// Create a new node of type INT_ and assign it to the type field
			$$.type = new_node(INT_,-1);

			// Generate a temporary variable of type INT_ and assign it to the loc field
			$$.loc = curr_table->gentemp(INT_);

			// Convert the integer constant to a string
			char *arg1 = new char[10];
			sprintf(arg1,"%d",$1);

			// Duplicate the name of the location and assign it to res
			char *res = strdup((($$.loc)->name).c_str());

			// Create a new quad with the ASSIGN operation
			fields_quad x(arg1,0,res,ASSIGN,0,0,$$.loc);

			// Emit the quad
			quad_array->emit(x);
		}
        | CHAR_CONSTANT {$$.val.char_data = $1;
                            $$.ind=2;
                            $$.type = new_node(CHAR_,-1);
                            $$.loc = curr_table->gentemp(CHAR_);
                            char *arg1 = new char[10];
                            sprintf(arg1,"'%c'",$1);
                            char *res = strdup((($$.loc)->name).c_str());
                            fields_quad x(arg1,0,res,ASSIGN,0,0,$$.loc);
                            quad_array->emit(x);
						};

postfix_expression: primary_expression {primary_expression {$$ = $1;}
                        | postfix_expression OPEN_SQUARE_BRACKET expression CLOSE_SQUARE_BRACKET{
                            $$.array = $1.array;
                            $$.type = $1.type;
                            switch($1.type->down){
                                case ARRAY : 
                                    switch($1.type->up){
                                        case INT_ : $$.type->down = INT_ ;break;
                                        case CHAR_ : $$.type->down = CHAR_ ;break;
                                    }
                                    break;
                            }
                            if(!($1.loc1)){
                                $$.loc1 = curr_table->gentemp(INT_);
                                char *arg1 = strdup((($3.loc)->name).c_str());
                                char *res = strdup((($$.loc1)->name).c_str());
                                fields_quad y(arg1,0,res,ASSIGN,$3.loc,0,$$.loc1);
                                quad_array->emit(y); 
                            }
                            else{
                                char semantic_error[20]="Semantic Error!\n";
                                cout<<"Semantic Error1!\n";
                                yyerror(semantic_error);
                            }
                        }
					}

                    | postfix_expression OP_SQUARE expression CL_SQUARE {// Initialize a counter
																	int counter = 0;

																	// Look up the name in the global table and assign it to a temporary variable
																	symbol_table_record *temp = global_table->lookup((($1.loc)->name));

																	// Generate a temporary variable of the appropriate type and assign it to the loc field
																	$$.loc = curr_table->gentemp2(temp->type[(temp->type).size()-1]);

																	// Convert the location name to a string and assign it to res
																	char *res = strdup((($$.loc)->name).c_str());

																	// Convert the location name to a string and assign it to arg1
																	char *arg1 = strdup((($1.loc)->name).c_str());

																	// Convert the counter to a string and assign it to arg2
																	char *arg2 = new char[10];
																	sprintf(arg2,"%d",counter);

																	// Create a new quad with the call operation
																	fields_quad x(arg1,arg2,res,call,$1.loc,0,$$.loc);

																	// Emit the quad
																	quad_array->emit(x);

																	// Determine the data type
																	date_types dt;
																	string s = ($$.loc)->type[0];
																	if((($$.loc)->type).size()>1){
																		dt = FUNCTION;
																		$$.type = new_node(dt,-1);
																	}
																	else if(((($$.loc)->size)>1 && s.compare("CHAR")==0) || ((($$.loc)->size)>4 && s.compare("INT")==0)){
																		dt = ARRAY;
																		$$.type = new_node(dt,($$.loc)->size);
																	}
																	else{
																		if(s.compare("INT")==0) dt = INT_ ;
																		else if(s.compare("CHAR")==0) dt = CHAR_ ;
																		else if(s.compare("INT*")==0) dt = INT_PTR ;
																		else if(s.compare("CHAR*")==0) dt = CHAR_PTR ;
																		else if(s.compare("VOID*")==0) dt = PTR ;
																		$$.type = new_node(dt,-1);
																	}
																}
                    | postfix_expression OP_PARENTHESIS argument_expression_list_opt CL_PARENTHESIS {// Initialize a counter
																										int counter = 0;

																										// Look up the name in the global table and assign it to a temporary variable
																										symbol_table_record *temp_record = global_table->lookup(($1.loc)->name);

																										// Create a temporary parameter list
																										parameter_list *temp_list = $3;

																										while(temp_list){
																											string s = ((temp_list->parameter)[0].type[0]);

																											if(s.compare((temp_record->type[counter])) != 0){
																												if((temp_record->type[counter]).compare("CHAR*")==0 && s.compare("CHAR")==0 && (temp_list->parameter)[0].array_ind == 1){
																													// Nothing to do here.
																												}
																												else if((temp_record->type[counter]).compare("INT*")==0 && s.compare("INT")==0 && (temp_list->parameter)[0].array_ind == 1){
																													// Nothing to do here.
																												}
																												else{
																													global_table->print();
																													char semantic_error[20]="Semantic Error!\n";
																													cout<<"Semantic Error60!\n";
																													yyerror(semantic_error);
																												}
																											}
																											char *arg1 = strdup(((temp_list->parameter)->name).c_str());
																											fields_quad x(arg1,0,0,PARAM,temp_list->parameter,0,0);
																											quad_array->emit(x);
																											counter++;
																											temp_list = temp_list->next;
																										}

																										string s = temp_record->type[0];
																										$$.loc = curr_table->gentemp2(temp_record->type[(temp_record->type).size()-1]);
																										char *res = strdup((($$.loc)->name).c_str());
																										char *arg1 = strdup((($1.loc)->name).c_str());
																										char *arg2 = new char[10];
																										sprintf(arg2,"%d",counter);
																										fields_quad x(arg1,arg2,res,call,$1.loc,0,$$.loc);
																										quad_array->emit(x);

																										date_types dt;
																										if(s.compare("INT")==0) dt = INT_ ;
																										else if(s.compare("CHAR")==0) dt = CHAR_ ;
																										else if(s.compare("INT*")==0) dt = INT_PTR ;
																										else if(s.compare("CHAR*")==0) dt = CHAR_PTR ;
																										else if(s.compare("VOID*")==0) dt = PTR ;

																										$$.type = new_node(dt,-1);
																									}
                    | postfix_expression ARROW ID {}
                    ;

argument_expression_list: argument_expression_list :
                        assignment_expression{
                            $$ = create_param_list($1.loc);
                        }
                        | argument_expression_list COMMA assignment_expression{
                            $$ = combine_param_list($1, create_param_list($3.loc));
                        } ;


argument_expression_list_opt: argument_expression_list 
                        |
                        ;

unary_expression: postfix_expression { $$ = $1;
                            $$ = $1;
                            // cout<<"unary_expression "<<address_ind<<endl;
                            if($1.loc1 && (address_ind == 0)){
                                $$.loc = curr_table->gentemp(($1.type)->down);
                                char *arg1 = strdup((($1.array)->name).c_str());
                                char *arg2 = strdup((($1.loc1)->name).c_str());
                                char *res = strdup((($$.loc)->name).c_str());
                                fields_quad x(arg1,arg2,res,EQ_BRACKET,$1.loc,$1.loc1,$$.loc);
                                quad_array->emit(x);
                            }}
                | unary_operator unary_expression {}
                ;

unary_operator: ADDRESS {$$ = U_ADDR;}
               | MULT { $$ = U_STAR;}
               | ADD {$$ = U_PLUS;}
               | SUB {$$ = U_MINUS;}
               | EXCLAMATION {$$ = BW_U_NOT;}
               ;

multiplicative_expression: unary_expression {}
                            | multiplicative_expression MULT unary_expression {}
                            | multiplicative_expression DIV unary_expression {}
                            | multiplicative_expression PERCENT unary_expression {}
                            ;

additive_expression: multiplicative_expression {p$$ = $1;}
                    | additive_expression ADD multiplicative_expression {
									if(typecheck($1.type, $3.type)){
											$$.loc = curr_table->gentemp(($1.type)->down);
											char *arg1 = strdup((($1.loc)->name).c_str());
											char *arg2 = strdup((($3.loc)->name).c_str());
											char *res = strdup((($$.loc)->name).c_str());
											fields_quad x(arg1,arg2,res,PLUS,$1.loc,$3.loc,$$.loc);
											quad_array->emit(x);
											$$.type = $1.type;
										}
										else{
											char semantic[20]="Semantic Error!\n";
											cout<<"Semantic Error5!\n";
											yyerror(semantic);
										}}
								| additive_expression SUB multiplicative_expression {
									if(check_type($1.type, $3.type)){
				$$.loc = curr_table->generate_temp(($1.type)->down);
				char *arg1 = strdup((($1.loc)->name).c_str());
				char *arg2 = strdup((($3.loc)->name).c_str());
				char *res = strdup((($$.loc)->name).c_str());
				fields_quad x(arg1,arg2,res,MINUS,$1.loc,$3.loc,$$.loc);
				quad_array->emit(x);
				$$.type = $1.type;
			}
			else{
				char semantic_error[20]="Semantic Error!\n";
				cout<<"Semantic Error6!\n";
				yyerror(semantic_error);
			}}
                    ;
// Define the relational_expression rule in the grammar
relational_expression :
						// A relational_expression can be an additive_expression
                        additive_expression {$$ = $1;}
						// Or a relational_expression followed by a LESS_THAN operator and an additive_expression
                        | relational_expression LESS_THAN additive_expression{
							// Create a list for true labels
                            $$.TL = create_list(next_instr);
							// Duplicate the names of the locations
                            char *arg1 = strdup((($1.loc)->name).c_str());
                            char *arg2 = strdup((($3.loc)->name).c_str());
                            fields_quad x(arg1,arg2,0,goto_LT,$1.loc,$3.loc,0);
                            quad_array->emit(x);
                            $$.FL = create_list(next_instr);
                            fields_quad y(0,0,0,GOTO_,0,0,0);
                            quad_array->emit(y);
                            $$.type = new_node(BOOL_,-1);
                        }
                        | relational_expression GREATER_THAN additive_expression{
                            $$.TL = create_list(next_instr);
                            char *arg1 = strdup((($1.loc)->name).c_str());
                            char *arg2 = strdup((($3.loc)->name).c_str());
                            fields_quad x(arg1,arg2,0,goto_GT,$1.loc,$3.loc,0);
                            quad_array->emit(x);
                            $$.FL = create_list(next_instr);
                            fields_quad y(0,0,0,GOTO_,0,0,0);
                            quad_array->emit(y);
                            $$.type = new_node(BOOL_,-1);
                        }
                        | relational_expression LESS_THAN_OR_EQUAL additive_expression{
                            $$.TL = create_list(next_instr);
                            char *arg1 = strdup((($1.loc)->name).c_str());
                            char *arg2 = strdup((($3.loc)->name).c_str());
                            fields_quad x(arg1,arg2,0,goto_LTE,$1.loc,$3.loc,0);
                            quad_array->emit(x);
                            $$.FL = create_list(next_instr);
                            fields_quad y(0,0,0,GOTO_,0,0,0);
                            quad_array->emit(y);
                            $$.type = new_node(BOOL_,-1);
                        }
                        | relational_expression GREATER_THAN_OR_EQUAL additive_expression{
                            $$.TL = create_list(next_instr);
                            char *arg1 = strdup((($1.loc)->name).c_str());
                            char *arg2 = strdup((($3.loc)->name).c_str());
                            fields_quad x(arg1,arg2,0,goto_GTE,$1.loc,$3.loc,0);
                            quad_array->emit(x);
                            $$.FL = create_list(next_instr);
                            fields_quad y(0,0,0,GOTO_,0,0,0);
                            quad_array->emit(y);
                            $$.type = new_node(BOOL_,-1);
                        } ;


// Define the equality_expression rule in the grammar
equality_expression :
                        // An equality_expression can be a relational_expression
                        relational_expression {$$ = $1;}
                        // Or an equality_expression followed by an EQUAL_TO operator and a relational_expression
                        | equality_expression EQUAL_TO relational_expression{
                            // Create a list for true labels
                            $$.TL = create_list(next_instr);
                            // Duplicate the names of the locations
                            char* arg1 = strdup((($1.loc)->name).c_str());
                            char* arg2 = strdup((($3.loc)->name).c_str());
                            // Create a new quad with the EQUAL_TO operation
                            fields_quad x(arg1,arg2,0,goto_EQ,$1.loc,$3.loc,0);
                            // Emit the quad
                            quad_array->emit(x);
                            // Create a list for false labels
                            $$.FL = create_list(next_instr);
                            // Create a new quad with the GOTO operation
                            fields_quad y(0,0,0,GOTO_,0,0,0);
                            // Emit the quad
                            quad_array->emit(y);
                            // Set the type to BOOL_
                            $$.type = new_node(BOOL_,-1);
                        } 
                        // Similar rules for the NOT_EQUAL_TO operator
                        | equality_expression NOT_EQUAL_TO relational_expression{
                            // Create a list for true labels
                            $$.TL = create_list(next_instr);
                            // Duplicate the names of the locations
                            char* arg1 = strdup((($1.loc)->name).c_str());
                            char* arg2 = strdup((($3.loc)->name).c_str());
                            // Create a new quad with the NOT_EQUAL_TO operation
                            fields_quad x(arg1,arg2,0,goto_NEQ,$1.loc,$3.loc,0);
                            // Emit the quad
                            quad_array->emit(x);
                            // Create a list for false labels
                            $$.FL = create_list(next_instr);
                            // Create a new quad with the GOTO operation
                            fields_quad y(0,0,0,GOTO_,0,0,0);
                            // Emit the quad
                            quad_array->emit(y);
                            // Set the type to BOOL_
                            $$.type = new_node(BOOL_,-1);
                        } ;


logical_AND_expression :
                        equality_expression {$$ = $1;}
                        | logical_AND_expression LOGICAL_AND M equality_expression{
                            backpatch($1.TL,$3);
                            $$.FL = merge($1.FL,$4.FL);
                            $$.TL = $4.TL;
                            $$.type = new_node(BOOL_,-1);
                        } ;

logical_OR_expression :
                        logical_AND_expression {$$ = $1;} 
                        | logical_OR_expression LOGICAL_OR M logical_AND_expression{
                            backpatch($1.FL,$3);
                            $$.TL = merge($1.TL,$4.TL);
                            $$.FL = $4.FL;
                            $$.type = new_node(BOOL_,-1);         
                        } ;

conditional_expression :
                        logical_OR_expression {$$ = $1;}
                        | logical_OR_expression N QUESTION_MARK M expression N COLON M conditional_expression {
                            // Generate a temporary variable of the appropriate type and assign it to the loc field
                            $$.loc = curr_table->gentemp(($5.type)->down);
                            // Set the type
                            $$.type = $5.type;
                            // Duplicate the names of the locations
                            char *res = strdup((($$.loc)->name).c_str());
                            char *arg1 = strdup((($9.loc)->name).c_str());
                            // Create a new quad with the ASSIGN operation
                            fields_quad x(arg1,0,res,ASSIGN,$9.loc,0,$$.loc);
                            // Emit the quad
                            quad_array->emit(x);
                            // Create a list for the next instruction
                            lnode *l = create_list(next_instr);
                            // Create a new quad with the GOTO operation
                            fields_quad y(0,0,0,GOTO_,0,0,0);
                            // Emit the quad
                            quad_array->emit(y);
                            // Backpatch the next instruction
                            backpatch($6,next_instr);
                            // Duplicate the name of the location
                            res = strdup((($$.loc)->name).c_str());
                            // Duplicate the name of the location
                            arg1 = strdup((($5.loc)->name).c_str());
                            // Create a new quad with the ASSIGN operation
                            fields_quad z(arg1,0,res,ASSIGN,$5.loc,0,$$.loc);
                            // Emit the quad
                            quad_array->emit(z);
                            // Merge the list with the list for the next instruction
                            l = merge(l,create_list(next_instr));
                            // Create a new quad with the GOTO operation
                            fields_quad a(0,0,0,GOTO_,0,0,0);
                            // Emit the quad
                            quad_array->emit(a);
                            // Backpatch the next instruction
                            backpatch($2,next_instr);
                            // Convert to boolean
                            conv2Bool(&$1);
                            // Backpatch the true and false labels
                            backpatch($1.TL,$4);
                            backpatch($1.FL,$8);
                            // Backpatch the list with the next instruction
                            backpatch(l,next_instr);
                        };


assignment_expression: conditional_expression {}
                        | unary_expression EQUALS assignment_expression {}
                        ;

expression: assignment_expression {}
                        ;


declaration: type_specifier init_declarator SEMICOLON {}
                        ;

init_declarator: declarator {}
                | declarator EQUALS initilizer {}
                ;

type_specifier: VOID {}
                | CHAR {}
                | INT {}
                ;

declarator: pointer_opt direct_declarator {}
            ;

direct_declarator: ID {}
                    | ID OP_SQUARE INTEGER_CONSTANT CL_SQUARE {}
                    | ID OP_PARENTHESIS parameter_list_opt CL_PARENTHESIS {}
                    ;

pointer: MULT {}
        ;
    
pointer_opt: pointer 
            | 
            ;
        
parameter_list: parameter_declaration {}
                | parameter_list COMMA parameter_declaration {}
                ;

parameter_list_opt: parameter_list 
                    |
                    ;

parameter_declaration: type_specifier pointer_opt ID_opt {}
                        | 
                        ;

ID_opt: ID 
        | 
        ;

initilizer: assignment_expression {}
            ;


statement: compound_statement {}
            | expression_statement {}
            | selection_statement {}
            | iteration_statement {}
            | jump_statement {}
            ;

compound_statement: OP_CURLY block_item_list_opt CL_CURLY {}
                    ;

block_item_list: block_item {}
                | block_item_list block_item {}
                ;

block_item_list_opt: block_item_list 
                    | 
                    ;

block_item: declaration {}
            | statement {}
            ;

expression_statement: expression_opt SEMICOLON {}
                    ;

expression_opt: expression
                | 
                ;

selection_statement: IF OP_PARENTHESIS expression CL_PARENTHESIS statement {}
                    | IF OP_PARENTHESIS expression CL_PARENTHESIS statement ELSE statement {}
                    ;
                
iteration_statement: FOR OP_PARENTHESIS expression_opt SEMICOLON expression_opt SEMICOLON expression_opt CL_PARENTHESIS statement {}
                    ;
                
jump_statement: RET expression_opt SEMICOLON {}
;

translation_unit: external_declaration {}
                | translation_unit external_declaration {}
                ;

external_declaration: declaration {}
                    | function_defination {}
                    ;

function_defination: type_specifier declarator compound_statement {}
                    ;

%%

void yyerror(char *s) {
    printf("Error: %s on '%s'\n", s, yytext);
}






        