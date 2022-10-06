%{

%}
%%

[\t ]+		/* ignore white space */ ;

test		{ printf("%s    <- test\n", yytext); }

\"[^"]*\" {
	 printf("<<<string start>>> %s <<<string end>>> ", yytext);
	}

[a-zA-Z]+ { ECHO; /* normal default anyway */ }

\&.|\n		{ ECHO; /* normal default anyway */ }

%%

main()
{
	yylex();
}
