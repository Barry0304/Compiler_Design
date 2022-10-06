%{
#include "y.tab.h"
extern int yylval;
%}

%%
[ \t]+                  ;

\%\%[^(\r?\n)]*\r?\n    ;

\r?\n                   ;

,										{ return COMMA; }

\[										{ return LEFT; }

\]										{ return RIGHT; }

[0-9]+									{ return NUMBER; }

;										{ return SEMICOLON; }

[Pp][Rr][Oo][Gg][Rr][Aa][Mm]			{ return PROGRAM; }

[Bb][Ee][Gg][Ii][Nn]					{ return BEGIN_; }

[Dd][Ee][Cc][Ll][Aa][Rr][Ee]			{ return DECLARE; }

[Aa][Ss]								{ return AS; }

[Ii][Nn][Tt][Ee][Gg][Ee][Rr]			{ return INTEGER; }

[Ee][Nn][Dd]							{ return END; }

[Ff][Ll][Oo][Aa][Tt]					{ return FLOAT; }

[a-zA-Z][a-zA-Z0-9]*(_[a-zA-Z0-9]+)*	{ return NAME; }

.	{return 0;}

%%

