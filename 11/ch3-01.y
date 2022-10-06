%token NAME NUMBER
%%
statement:	NAME '=' expression
	|	expression		{ printf("= %d\n", $1); }
	;

expression:	expression '+' expression	{ $$ = $1 + $3; }
	|	expression '-' expression	{ $$ = $1 - $3; }
	|	NUMBER			{ $$ = $1; }
	;
