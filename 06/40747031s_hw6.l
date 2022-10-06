%{
#include <string.h>
%}
%%

[\t ]+		/* ignore white space */ ;

test		{ printf("%s    <- test\n", yytext); }

\"[^"\n]*["\n] {
	if(yytext[strlen(yytext)-1]!='"'){
		printf("%s<<<it doesn't have a close quotation mark>>>\n", yytext);
	}
	else{
		printf("%s<<<it is a correct quoted string>>> ", yytext);
	}
}

[a-zA-Z]+ { ECHO; /* normal default anyway */ }

\&.|\n		{ ECHO; /* normal default anyway */ }

%%

main()
{
	yylex();
}
