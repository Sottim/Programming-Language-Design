#include "9_A4_translator.h"

FILE* fptr;
char* currentFunction;

typedef struct symbol_table_record {
    int size;
    int offset;
    struct symbol_table_record* nested_table;
    char* name;
    char** type;
    char* initial_value;
    int array_ind;
} symbol_table_record;

void assign(symbol_table_record* this, symbol_table_record* x) {
    this->name = x->name;
    this->type = x->type;
    this->initial_value = x->initial_value;
    this->size = x->size;
    this->offset = x->offset;
    this->nested_table = x->nested_table;
    this->array_ind = x->array_ind;
}

void print_record(symbol_table_record* this) {
    FILE* outputStream;
    outputStream = fopen("../" + currentFunction + ".txt", "a");
    fprintf(outputStream, "%s\t", this->name);
    if(this->type == NULL) {
        fprintf(outputStream, "undefined\t");
    } else {
        for(int i = 0; i < sizeof(this->type)/sizeof(this->type[0]) - 1; i++) {
            fprintf(outputStream, "%s", this->type[i]);
            if(i != sizeof(this->type)/sizeof(this->type[0]) - 2) {
                fprintf(outputStream, "^");
            } else {
                fprintf(outputStream, "->");
            }
        }
        if(this->type != NULL) {
            fprintf(outputStream, "%s\t", this->type[sizeof(this->type)/sizeof(this->type[0]) - 1]);
        }
    }
    if(this->initial_value == NULL) {
        fprintf(outputStream, "0\t");
    } else {
        fprintf(outputStream, "%s\t", this->initial_value);
    }
    fprintf(outputStream, "%d\t%d\t", this->size, this->offset);
    if(this->nested_table != NULL) {
        fprintf(outputStream, "%s\t", this->nested_table->name);
    } else {
        fprintf(outputStream, "null\t");
    }
    fprintf(outputStream, "%d\n", this->array_ind);
    fclose(outputStream);
}

typedef struct symbol_table {
    symbol_table_record* list;
    int size;
    int curr_size;
} symbol_table;

symbol_table* create_symbol_table(int capacity) {
    symbol_table* table = (symbol_table*)malloc(sizeof(symbol_table));
    table->list = (symbol_table_record*)malloc(capacity * sizeof(symbol_table_record));
    table->size = capacity;
    table->curr_size = 0;
    return table;
}

symbol_table_record* lookup(symbol_table* this, char* t) {
    for(int i = 0; i < this->curr_size; i++) {
        if(strcmp(t, this->list[i].name) == 0) {
            return &(this->list[i]);
        }
    }
    return NULL;
}

void insert(symbol_table* this, symbol_table_record* x) {
    if(this->curr_size == 0) {
        x->offset = 0;
    } else {
        x->offset = this->list[this->curr_size - 1].size + this->list[this->curr_size - 1].offset;
    }
    this->curr_size++;
    this->list[this->curr_size - 1] = *x;
}

symbol_table_record* gentemp(symbol_table* this, date_types temp) {
    char s[20];
    sprintf(s, "t%d", temp_count);
    temp_count++;
    int temp_size = 0;
    symbol_table_record* x = (symbol_table_record*)malloc(sizeof(symbol_table_record));
    switch(temp) {
        case INT_ : temp_size = size_of_int; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "INT"; break;
        case CHAR_ : temp_size = size_of_char; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "CHAR"; break;
        case INT_PTR : temp_size = size_of_pointer; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "INT*"; break;
        case CHAR_PTR : temp_size = size_of_pointer; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "CHAR*"; break;
        case PTR : temp_size = size_of_pointer; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "VOID*"; break;
    }
    x->name = s;
    x->size = temp_size;
    int curr_offset = 0;
    if(this->curr_size != 0) {
        curr_offset = this->list[this->curr_size - 1].offset;
    }
    x->offset = curr_offset + temp_size;
    insert(this, x);
    return &(this->list[this->curr_size - 1]);
}

symbol_table_record* gentemp2(symbol_table* this, char* temp) {
    char s[20];
    sprintf(s, "t%d", temp_count);
    temp_count++;
    int temp_size = 0;
    symbol_table_record* x = (symbol_table_record*)malloc(sizeof(symbol_table_record));
    if(strcmp(temp, "INT") == 0) {
        temp_size = size_of_int; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "INT";
    } else if(strcmp(temp, "CHAR") == 0) {
        temp_size = size_of_char; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "CHAR";
    } else if(strcmp(temp, "INT*") == 0) {
        temp_size = size_of_pointer; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "INT*";
    } else if(strcmp(temp, "CHAR*") == 0) {
        temp_size = size_of_pointer; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "CHAR*";
    } else {
        temp_size = size_of_pointer; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "VOID*";
    }
    x->name = s;
    x->size = temp_size;
    int curr_offset = 0;
    if(this->curr_size != 0) {
        curr_offset = this->list[this->curr_size - 1].offset;
    }
    x->offset = curr_offset + temp_size;
    insert(this, x);
    return &(this->list[this->curr_size - 1]);
}



symbol_table_record* gentemp3(symbol_table* this, date_types temp, int val) {
    char s[20];
    sprintf(s, "t%d", temp_count);
    temp_count++;
    int temp_size = 0;
    symbol_table_record* x = (symbol_table_record*)malloc(sizeof(symbol_table_record));
    switch(temp) {
        case INT_ : temp_size = size_of_int; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "INT"; break;
        case CHAR_ : temp_size = size_of_char; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "CHAR"; break;
        case INT_PTR : temp_size = size_of_pointer; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "INT*"; break;
        case CHAR_PTR : temp_size = size_of_pointer; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "CHAR*"; break;
        case PTR : temp_size = size_of_pointer; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "VOID*"; break;
        case STRING_ : temp_size = val*size_of_char; x->array_ind = 1; x->type = (char**)malloc(sizeof(char*)); x->type[0] = "CHAR"; break;
    }
    x->name = s;
    x->size = temp_size;
    int curr_offset = 0;
    if(this->curr_size != 0) {
        curr_offset = this->list[this->curr_size - 1].offset;
    }
    x->offset = curr_offset + temp_size;
    insert(this, x);
    return &(this->list[this->curr_size - 1]);
}

void print(symbol_table* this) {
    currentFunction = this->name;
    if(strcmp(this->name, "global") == 0) {
        currentFunction = "global";
    }
    for(int i = 0; i < this->curr_size; i++) {
        print_record(&(this->list[i]));
    }
    for(int i = 0; i < this->curr_size; i++) {
        if(this->list[i].nested_table != NULL) {
            currentFunction = this->list[i].nested_table->name;
            print(this->list[i].nested_table);
        }
    }
}

typedef struct fields_quad {
    char* arg1;
    char* arg2;
    char* res;
    quad_data_types op;
    symbol_table_record* arg1_loc;
    symbol_table_record* arg2_loc;
    symbol_table_record* res_loc;
} fields_quad;

fields_quad* create_fields_quad(char* arg1_f, char* arg2_f, char* res_f, quad_data_types op_f, symbol_table_record* arg1_loc_f, symbol_table_record* arg2_loc_f, symbol_table_record* res_loc_f) {
    fields_quad* quad = (fields_quad*)malloc(sizeof(fields_quad));
    quad->arg1 = arg1_f;
    quad->arg2 = arg2_f;
    quad->res = res_f;
    quad->op = op_f;
    quad->arg1_loc = arg1_loc_f;
    quad->arg2_loc = arg2_loc_f;
    quad->res_loc = res_loc_f;
    return quad;
}

void destroy_fields_quad(fields_quad* this) {
    free(this);
}

void assign_fields_quad(fields_quad* this, fields_quad* x) {
    this->arg1 = x->arg1;
    this->arg2 = x->arg2;
    this->res = x->res;
    this->op = x->op;
    this->arg1_loc = x->arg1_loc;
    this->arg2_loc = x->arg2_loc;
    this->res_loc = x->res_loc;
}

void print_fields_quad(fields_quad* this, int line) {
    if(this->arg2) {
        switch(this->op) {
            case PLUS : fprintf(fptr, "%3d) %s = %s + %s\n", line, this->res, this->arg1, this->arg2); break;
            case MINUS : fprintf(fptr, "%3d) %s = %s - %s\n", line, this->res, this->arg1, this->arg2); break;
            case INTO : fprintf(fptr, "%3d) %s = %s * %s\n", line, this->res, this->arg1, this->arg2); break;
            case DIV : fprintf(fptr, "%3d) %s = %s / %s\n", line, this->res, this->arg1, this->arg2); break;
            case PERCENT : fprintf(fptr, "%3d) %s = %s %% %s\n", line, this->res, this->arg1, this->arg2); break;
            case SL : fprintf(fptr, "%3d) %s = %s << %s\n", line, this->res, this->arg1, this->arg2); break;
            case SR : fprintf(fptr, "%3d) %s = %s >> %s\n", line, this->res, this->arg1, this->arg2); break;
            case LT : fprintf(fptr, "%3d) %s = %s < %s\n", line, this->res, this->arg1, this->arg2); break;
            case LTE : fprintf(fptr, "%3d) %s = %s <= %s\n", line, this->res, this->arg1, this->arg2); break;
            case GT : fprintf(fptr, "%3d) %s = %s > %s\n", line, this->res, this->arg1, this->arg2); break;
            case GTE : fprintf(fptr, "%3d) %s = %s >= %s\n", line, this->res, this->arg1, this->arg2); break;
            case EQ : fprintf(fptr, "%3d) %s = %s == %s\n", line, this->res, this->arg1, this->arg2); break;
            case NEQ : fprintf(fptr, "%3d) %s = %s != %s\n", line, this->res, this->arg1, this->arg2); break;
            case BW_AND : fprintf(fptr, "%3d) %s = %s & %s\n", line, this->res, this->arg1, this->arg2); break;
            case BW_XOR : fprintf(fptr, "%3d) %s = %s ^ %s\n", line, this->res, this->arg1, this->arg2); break;
            case BW_INOR : fprintf(fptr, "%3d) %s = %s | %s\n", line, this->res, this->arg1, this->arg2); break;
            case LOG_AND : fprintf(fptr, "%3d) %s = %s && %s\n", line, this->res, this->arg1, this->arg2); break;
            case LOG_OR : fprintf(fptr, "%3d) %s = %s || %s\n", line, this->res, this->arg1, this->arg2); break;
            case goto_LT : fprintf(fptr, "%3d) if %s < %s goto %s\n", line, this->arg1, this->arg2, this->res); break;
            case goto_LTE : fprintf(fptr, "%3d) if %s <= %s goto %s\n", line, this->arg1, this->arg2, this->res); break;
            case goto_GT : fprintf(fptr, "%3d) if %s > %s goto %s\n", line, this->arg1, this->arg2, this->res); break;
            case goto_GTE : fprintf(fptr, "%3d) if %s >= %s goto %s\n", line, this->arg1, this->arg2, this->res); break;
            case goto_EQ : fprintf(fptr, "%3d) if %s == %s goto %s\n", line, this->arg1, this->arg2, this->res); break;
            case goto_NEQ : fprintf(fptr, "%3d) if %s != %s goto %s\n", line, this->arg1, this->arg2, this->res); break;
            case call : fprintf(fptr, "%3d) %s = call %s , %s\n", line, this->res, this->arg1, this->arg2); break;
            case EQ_BRACKET : fprintf(fptr, "%3d) %s = %s[%s]\n", line, this->res, this->arg1, this->arg2); break;
            case BRACKET_EQ : fprintf(fptr, "%3d) %s[%s] = %s\n", line, this->arg1, this->arg2, this->res); break;
            case STAR_BRACKET_EQ : fprintf(fptr, "%3d) *%s[%s] = %s\n", line, this->arg1, this->arg2, this->res); break;
            case STAR_EQ_BRACKET : fprintf(fptr, "%3d) %s = *%s[%s]\n", line, this->res, this->arg1, this->arg2); break;
            case EQ_ADDR_BRACKET : fprintf(fptr, "%3d) %s = &%s[%s]\n", line, this->res, this->arg1, this->arg2); break;
            case ADDR_BRACKET_EQ : fprintf(fptr, "%3d) %s[%s] = &%s\n", line, this->arg1, this->arg2, this->res); break;
        }
    }
	else{
		switch(this->op){
			case U_PLUS : fprintf(fptr,"%3d) %s = %s\n",line,this->res,this->arg1);
						break;
			case U_MINUS : fprintf(fptr,"%3d) %s = -%s\n",line,this->res,this->arg1);
						break;
			case BW_U_NOT : fprintf(fptr,"%3d) %s = ~%s\n",line,this->res,this->arg1);
						break;
			case U_NEGATION : fprintf(fptr,"%3d) %s = !%s\n",line,this->res,this->arg1);
						break;
			case U_ADDR : fprintf(fptr,"%3d) %s = &%s\n",line,this->res,this->arg1);
						break;
			case U_STAR : fprintf(fptr,"%3d) %s = *%s\n",line,this->res,this->arg1);
						break;
			case ASSIGN : fprintf(fptr,"%3d) %s = %s\n",line,this->res,this->arg1);
						break;
			case STAR_EQUAL : fprintf(fptr,"%3d) *%s = %s\n",line,this->res,this->arg1);
						break;
			case GOTO_ : fprintf(fptr,"%3d) goto %s\n",line,this->res);
						break;
			case IF_GOTO : fprintf(fptr,"%3d) if %s goto %s\n",line,this->arg1,this->res);
						break;
			case IF_FALSE_GOTO : fprintf(fptr,"%3d) ifFalse %s goto %s\n",line,this->arg1,this->res);
						break;
			case PARAM : fprintf(fptr,"%3d) param %s\n",line,this->arg1);
						break;
			case RETURN_EXP : fprintf(fptr,"%3d) return %s\n",line,this->arg1);
						break;
			case RETURN_ : fprintf(fptr,"%3d) return\n",line);
						break;
			case Function : fprintf(fptr,"%3d) %s : \n",line,arg1);
						break;
		}
	}
}

void quadArray::fill_dangling_goto(int index, int data){
	char *temp = new char[10];
	sprintf(temp,"%d",data);
	((this->quad_Table)[index]).res = temp;
}

void backpatch(lnode *l, int data){
	lnode *temp = l;
	while(temp){
		quad_array->fill_dangling_goto(temp->index_list,data);
		temp = temp->next;
	}
}

void conv2Bool(attribute_expression *E){
	if(((E->type)->down) != BOOL_){
		E->FL = makelist(next_instr);
		char *arg1 = strdup(((E->loc)->name).c_str());
		char *arg2 = new char[10];
		sprintf(arg2,"0");
		fields_quad x(arg1,arg2,0,goto_EQ,E->loc,0,0);
		quad_array->emit(x);
		E->TL = makelist(next_instr);
		fields_quad y(0,0,0,GOTO_,0,0,0);
		quad_array->emit(y);
	}
}

int typecheck(tNode *t1, tNode *t2){
	if(!t1 && !t2) return 1;
	if(!t1) return 0;
	if(!t2) return 0;
	return (t1->down == t2->down) && typecheck(t1->r,t2->r);
}

int compute_width(tNode *temp){
	if(!temp) return 0;
	int width = 1;
	while(temp){
		switch(temp->down){
			case ARRAY : 
						switch(temp->up){
							case INT_ : width *= 4;break;
							case CHAR_ : width *=1;break;
						}
						break;
			case INT_ : width *= 4;
						break;
			case DOUBLE_ : width *= 8;
						break;
			case CHAR_ : width *= 1;
						break;
			case PTR : width *= 4;
						break;
		}
		if(temp->down == PTR)
			break;
		temp = temp->r;
	}
	return width;
}

parameter_list *make_param_list(symbol_table_record *p){
	parameter_list *temp = new parameter_list;
	temp->parameter = p;
	temp->next = 0;
	return temp;
}

parameter_list *merge_param_list(parameter_list *l1, parameter_list *l2){
	if(!l1) return l2;
	if(!l2) return l1;
	parameter_list *temp = l1;
	while(temp->next)
		temp = temp->next;
	temp->next = l2;
	return l1;
}

void __construct_quad_list(int n){
	if(MAX_SIZE>0)
	{
		int quadArrayList[n/2];
	}
	else
	{
		printf("Error: Maximum Size should be greater than 0");
	}
}

void construct_quad_list(int n){
	if(MAX_SIZE>0)
	{
		 __construct_quad_list(n+1);
	}
	else
	{
		printf("Error: Maximum Size should be greater than 0");
	}
}

string converter(date_types temp){
	switch(temp){
		case INT_ : return "INT";
		case CHAR_ : return "CHAR";
		case INT_PTR : return "INT*";
		case CHAR_PTR : return "CHAR*";
		case PTR : return "VOID*";
	}
	return "";
}

symbol_table* global_table;
symbol_table* curr_table;
quadArray *quad_array = 0;
int next_instr = 0;
int temp_count = 0;
tNode *t = 0;
int address_ind = 0;
int main(){

	global_table = new symbol_table(10000);
	global_table->name = "global";
	curr_table = global_table;
	construct_quad_list(100);
  	quad_array = new quadArray(100000);
	fptr = fopen("../three_address_input.txt","w");
	
    int val=yyparse();
	if(!val)
		printf("Success: Parsing Done\n");
	else
		printf("Error: Parsing not Done\n");
    printf("+---------------------------------------+\n");
	global_table->print();
	cout<<endl;
	quad_array->print_quadArray();
	fclose(fptr);
	return 0;
}







