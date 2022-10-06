%{
#include <string.h>
#include "y.tab.h"
#include "st_lib.h"
%}

%%
[ \t]+                  ;

\%\%[^(\r?\n)]*\r?\n    ;

\r?\n                   ;

,										{ return COMMA; }

\[										{ return LEFT_CB; }

\]										{ return RIGHT_CB; }

"("                                     { return LEFT_P; }
    
")"                                     { return RIGHT_P; }

":="	                                { return ASSIGN; }

"+"                                     { return PLUS; }

"-"                                     { return MINUS; }

"*"                                     { return MUL; }

"/"                                     { return DIV; }

;										{ return SEMICOLON; }

[0-9]+									{ yylval.my_int = atoi(yytext); return INT_N; }

([0-9]*\.[0-9]+)|([0-9]+\.[0-9]*)	{ yylval.my_float = atof(yytext); return FLOAT_N; }

[Pp][Rr][Oo][Gg][Rr][Aa][Mm]			{ return PROGRAM; }

[Bb][Ee][Gg][Ii][Nn]					{ return BEGIN_; }

[Dd][Ee][Cc][Ll][Aa][Rr][Ee]			{ return DECLARE; }

[Aa][Ss]								{ return AS; }

[Ee][Nn][Dd]							{ return END; }

[Ii][Nn][Tt][Ee][Gg][Ee][Rr]			{ return INTEGER; }

[Ff][Ll][Oo][Aa][Tt]					{ return FLOAT; }

[Ee][Nn][Dd][Ff][Oo][Rr]	            { return FOREND; }

[Ff][Oo][Rr]                        	{ return FOR; }

[Tt][Oo]	                            { return TO; }

[Dd][Oo][Ww][Nn][Tt][Oo]	            { return DOWNTO; }

[Ss][Tt][Ee][Pp]                        { return STEP; }

[Ww][Hh][Ii][Ll][Ee]                     { return WHILE; }

[Ee][Nn][Dd][Ww][Hh][Ii][Ll][Ee]        { return WHILEEND; }

[a-zA-Z][a-zA-Z0-9]*(_[a-zA-Z0-9]+)*	{ 
    struct symbol *sp=symlook(yytext);
    yylval.symbol = sp;
    return NAME; }

.	{return 0;}

%%

