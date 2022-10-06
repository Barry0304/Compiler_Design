%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "st_lib.h"

int yylex();
void yyerror(const char *s);
FILE* f_out=NULL;

int i =0 ;
int symbol_n = 0;
int temp_n = 1;
int label_n=1;
int label_stack_n=0;
int label_stack[10]={0};

char op[4][5]={"ADD", "SUB", "MUL", "DIV"};

struct symbol *declare_temp();
struct symbol *gen_operation(struct symbol *left, int op, struct symbol *right);
struct symbol *negative(struct symbol *num);
struct symbol *int_n(int n);
struct symbol *float_n(float n);
struct symbol *variable(struct symbol *var);
struct symbol *array(struct symbol *arr,struct symbol *ind);

void create_label();
void end_label();
void store_var(struct symbol *var, struct symbol *expr);
void start_prog(char prog_name[]);
void end_prog(char prog_name[]);
void set_symbol_array_n(int array_n);
void set_symbol_type(int n,char type[10]);
void declare_variable(int n);
void next_step(struct symbol *var,int to_dt, struct symbol *expr,struct symbol *step);
void endline();
%}

%union {
	int my_int;
	float my_float;
	char* my_str;
	struct symbol *symbol;
};

%token PROGRAM BEGIN_ END SEMICOLON
%token DECLARE AS COMMA LEFT_CB RIGHT_CB FLOAT INTEGER
%token ASSIGN PLUS MINUS MUL DIV 
%token FOR TO DOWNTO STEP LEFT_P RIGHT_P FOREND
%token <my_int> INT_N
%token <my_float> FLOAT_N
%token <symbol> NAME
%type <my_int> varlist to_dt
%type <my_str> vartype
%type <symbol> assign expression mulexp primary step

%%
Prog:
	PROGRAM NAME{
		symbol_n++;
		start_prog($2 ->name);
	}
	BEGIN_ statement_list END{
		end_prog($2->name);
		printf("Complie Success\n");
	};

statement_list:	statement
	|	statement_list statement
	;

statement :	assign  SEMICOLON
	| vardeclare  SEMICOLON
	| forloop
	;

assign: NAME ASSIGN expression {store_var($1,$3);}
	;

expression:	expression PLUS mulexp	{ $$= gen_operation($1, 0, $3); }
	|	expression MINUS mulexp	{ $$= gen_operation($1, 1, $3); }
	|	mulexp	{ $$ = $1; }
	;

mulexp: mulexp MUL primary { $$= gen_operation($1, 2, $3); }
	|	mulexp DIV primary { $$= gen_operation($1, 3, $3); }
	|	primary { $$ = $1; }
	;

primary: LEFT_P expression RIGHT_P { $$ = $2; }
	|	MINUS primary { $$ = negative($2); }
	|	NAME {$$=$1;}
	|	NAME LEFT_CB expression RIGHT_CB{ $$ = array($1,$3); }
	|	INT_N { $$ = int_n($1); }
	|	FLOAT_N { $$ = float_n($1); }
	;


vardeclare : DECLARE varlist AS vartype{
		printf("%d\n",$2);
		set_symbol_type($2,$4);
		declare_variable($2);
	};

varlist : var{
		$$ = 1;
	}
	|	varlist COMMA var{
		$$ = $1 + 1;
	}
	;

var : NAME{
		set_symbol_array_n(0);
		symbol_n++;
	}
	|	NAME LEFT_CB INT_N RIGHT_CB{
		set_symbol_array_n($3);
		symbol_n++;
	}
	;

vartype : INTEGER{
			$$ = "Integer";
		}
		|	FLOAT{
			$$ = "Float";
		}
		;

forloop : FOR LEFT_P assign to_dt expression step RIGHT_P {
		create_label();
	}
	statement_list FOREND{
		next_step($3, $4, $5, $6);
		end_label();
	}
	;

step:STEP expression{ $$=$2; }
    |{ $$=NULL; };

to_dt : TO{ $$=1; }
  	| DOWNTO{ $$=0; };
%%

int main(){
	f_out = fopen("code.micro_ex","w");
	yyparse();
	fclose(f_out);
	return 0;
}

void start_prog(char prog_name[]){
	fprintf(f_out,"\tSTART %s\n",prog_name);
}
void end_prog(char prog_name[]){
	fprintf(f_out, "\tHALT %s\n", prog_name);
}

void store_var(struct symbol *var, struct symbol *expr) {
	const char temp[6]={"Float"};
	if(strcmp(var->type,temp)==0){
		fprintf(f_out, "\tF_STORE %s,%s\n", expr->name, var->name);
	}
	else{
		fprintf(f_out, "\tI_STORE %s,%s\n", expr->name, var->name);
	}
}

struct symbol *declare_temp(){
	char sym[10]={};
	sprintf(sym, "T&%d", temp_n);
	temp_n++;
	symbol_n++;
	return (struct symbol *)symlook(sym);
}

struct symbol *variable(struct symbol *var){
	return var;
}

struct symbol *array(struct symbol *arr,struct symbol *ind){
	if(arr->array_index1==NULL){
		arr->array_index1=ind;
	}
	else{
		arr->array_index2=ind;
	}
	return arr;
}

struct symbol *gen_operation(struct symbol *left, int op_n, struct symbol *right) {
	struct symbol *temp=declare_temp();
	temp->type="Integer";
	if(strcmp(left->type,temp->type)!=0 || strcmp(right->type,temp->type)!=0){
		temp->type="Float";
	}

	char temp_left_name[50],temp_right_name[50];
	strcpy( temp_left_name, left->name);
	strcpy( temp_right_name, right->name);
	if(left->array_n != 0 ){
		sprintf(temp_left_name, "%s[%s]", temp_left_name,left->array_index1->name);
		left->array_index1 = NULL;
	}
	if(left == right){
		sprintf(temp_right_name, "%s[%s]", temp_right_name,right->array_index2->name);
		left->array_index2 = NULL;
	}
	else if(right->array_n != 0 ){
		sprintf(temp_right_name, "%s[%s]", temp_right_name,right->array_index1->name);
		right->array_index1 = NULL;
	}
	
	fprintf(f_out, "\t%c_%s %s,%s,%s\n", temp->type[0], op[op_n], temp_left_name, temp_right_name, temp->name);
	return temp;
}

struct symbol *negative(struct symbol *num) {
	char temp_name[50];
	strcpy( temp_name, num->name);
	if(num->array_n != 0 ){
		sprintf(temp_name, "%s[%s]", temp_name,num->array_index1->name);
		num->array_index1 = NULL;
	}

	struct symbol *temp=declare_temp();
	temp->type=num->type;
	fprintf(f_out, "\t%c_UMINUS %s,%s\n", temp->type[0], temp_name, temp->name);
	return temp;
}

struct symbol *int_n(int n){
	char val[50];
	sprintf(val, "%d", n);
	struct symbol *symp =symlook(val);
	if(symp == &symbol_table[symbol_n]){
		symbol_n++;
	}
	symp->type="Integer";
	return symp;
}

struct symbol *float_n(float n){
	char val[50];
	sprintf(val, "%f", n);
	struct symbol *symp = symlook(val);
	if(symp == &symbol_table[symbol_n]){
		symbol_n++;
	}
	symp->type="Float";
	return symp;
}

void set_symbol_array_n(int array_n){
	symbol_table[symbol_n].array_n = array_n;
}

void set_symbol_type(int n,char *type){
	for(i = symbol_n - n ; i < symbol_n ; i++){
		symbol_table[i].type = strdup(type) ;
	}
}

void declare_variable(int n){
	for(i = symbol_n - n ; i < symbol_n ; i++){
		if(symbol_table[i].array_n == 0){
			fprintf(f_out,"\tDeclare %s, %s\n",symbol_table[i].name,symbol_table[i].type);
		}
		else{
			fprintf(f_out,"\tDeclare %s, %s_array,%d\n",symbol_table[i].name,symbol_table[i].type,symbol_table[i].array_n);
		}
	}
}

void  next_step(struct symbol *var,int to_dt, struct symbol *expr,struct symbol *step){
	if(step==NULL){
		fprintf(f_out, "\t%s %s\n", to_dt?"INC":"DEC", var->name);
	}
	else {
		struct symbol *temp=declare_temp();
		fprintf(f_out, "\tI_%s %s,%s,%s\n", to_dt?"ADD":"SUB", var->name, step->name, temp->name);
		fprintf(f_out, "\tI_STORE %s,%s\n", temp->name, var->name);
	}
	fprintf(f_out, "\tI_CMP %s,%s\n", var->name, expr->name);
	fprintf(f_out, "\tJLE lb&%d\n", label_stack[label_stack_n-1]);
}

void create_label(){
	label_stack[label_stack_n]=label_n;
	label_stack_n++;
	fprintf(f_out, "lb&%d:", label_n);
	label_n++;
}

void end_label(){
	label_stack_n --;
}

void endline(){
	fprintf(f_out, "\n");
}

struct symbol *symlook(char *s){
	struct symbol *symp;
	int i;
	for(symp = symbol_table; symp < &symbol_table[MAX_N]; symp++) {
		if(symp->name && !strcmp(symp->name, s)){
			return symp;
		}
		if(!symp->name) {
			symp->name = strdup(s);
			symp->array_n = 0;
			return symp;
		}
	}
	yyerror("Too many symbols");
	exit(1);
}