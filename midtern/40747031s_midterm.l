%{
#include <string.h>

%}
%%

BEGIN|bigin {
	printf("Token number =1, value is \"%s\"\n",yytext);
}

END|end {
	printf("Token number =2, value is \"%s\"\n",yytext);
}

READ|read {
	printf("Token number =3, value is \"%s\"\n",yytext);
}

WRITE|write {
	printf("Token number =4, value is \"%s\"\n",yytext);
}

IF|if {
	printf("Token number =25, value is \"%s\"\n",yytext);
}

THEN|then {
	printf("Token number =26, value is \"%s\"\n",yytext);
}

ELSE|else {
	printf("Token number =27, value is \"%s\"\n",yytext);
}

ENDIF|endif {
	printf("Token number =28, value is \"%s\"\n",yytext);
}

FOR|for {
	printf("Token number =29, value is \"%s\"\n",yytext);
}

TO|to {
	printf("Token number =30, value is \"%s\"\n",yytext);
}

ENDFOR|endfor {
	printf("Token number =31, value is \"%s\"\n",yytext);
}

WHILE|while {
	printf("Token number =32, value is \"%s\"\n",yytext);
}

ENDWHILE|endwhile {
	printf("Token number =33, value is \"%s\"\n",yytext);
}

DECLARE|declare {
	printf("Token number =34, value is \"%s\"\n",yytext);
}

AS|as {
	printf("Token number =35, value is \"%s\"\n",yytext);
}

INTEGER|integer {
	printf("Token number =36, value is \"%s\"\n",yytext);
}

REAL|real {
	printf("Token number =37, value is \"%s\"\n",yytext);
}

ScanEof {
	printf("Token number =38, value is \"%s\"\n",yytext);
}

[a-zA-Z_][a-zA-Z0-9_]* {
	printf("Token number =5, value is \"%s\"\n",yytext);
}

[0-9]+ {
	printf("Token number =6, value is \"%s\"\n",yytext);
}

([0-9]*\.[0-9]+) {
	printf("Token number =7, value is \"%s\"\n",yytext);
}

-?(([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?) {
	printf("Token number =8, value is \"%s\"\n",yytext);
}

\"[^"\n]*["\n] {
	printf("Token number =9, value is \"%s\"\n",yytext);
}

"(" {
	printf("Token number =10, value is \"%s\"\n",yytext);
}

")" {
	printf("Token number =11, value is \"%s\"\n",yytext);
}

";" {
	printf("Token number =12, value is \"%s\"\n",yytext);
}

"," {
	printf("Token number =13, value is \"%s\"\n",yytext);
}

":=" {
	printf("Token number =14, value is \"%s\"\n",yytext);
}

"+" {
	printf("Token number =15, value is \"%s\"\n",yytext);
}

"-" {
	printf("Token number =16, value is \"%s\"\n",yytext);
}

"*" {
	printf("Token number =17, value is \"%s\"\n",yytext);
}

"/" {
	printf("Token number =18, value is \"%s\"\n",yytext);
}

"!=" {
	printf("Token number =19, value is \"%s\"\n",yytext);
}

">" {
	printf("Token number =20, value is \"%s\"\n",yytext);
}

"<" {
	printf("Token number =21, value is \"%s\"\n",yytext);
}

">=" {
	printf("Token number =22, value is \"%s\"\n",yytext);
}

"<=" {
	printf("Token number =23, value is \"%s\"\n",yytext);
}

"==" {
	printf("Token number =24, value is \"%s\"\n",yytext);
}

" "|\t|\&.|\n {
	;
}

.	{
	printf("lexical error, value is \"%s\"\n",yytext); 
}



%%

main()
{
	yylex();
	printf("End of the execution\n");
}
