%{
	#include <stdio.h>
%}

%token PROGRAM NAME BEGIN_ END DECLARE AS SEMICOLON INTEGER FLOAT NUMBER COMMA LEFT RIGHT

%%
Prog: PROGRAM NAME BEGIN_ statement_list END	{ printf("Complie Success\n"); };

statement_list:	statement SEMICOLON
	|	statement_list statement SEMICOLON
	;

statement :	vardeclare;

vardeclare : DECLARE varlist AS vartype{
	printf
} ;

varlist :var
	|	varlist COMMA var
	;

vartype :	INTEGER
		|	FLOAT
		;

var : NAME
	|	NAME LEFT NUMBER RIGHT
	;