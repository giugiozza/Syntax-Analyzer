// Giulia Giozza, 2022

%{	
	#include "y.tab.h"
	#include "hash.c"
	int Running = 1;
	int lineNumber = 1;
	int isRunning(void);
	int getLineNumber(void);
	void initMe(void);
%}

%x COMMENT

%%

	/* IGNORES BLANKS AND TABS */
[ \t]

	/* LINE CONTROL */
"\n"    ++lineNumber;

	/* SPECIAL CHARACTERS */
[\,\;\:\(\)\[\]\{\}\+\-\*\/\<\>\=]    return yytext[0];

	/* RESERVED WORDS */
"char"		return KW_CHAR;
"int"		return KW_INT;
"float"		return KW_FLOAT;
"if"		return KW_IF;
"then"		return KW_THEN;
"else"		return KW_ELSE;
"while"		return KW_WHILE;
"goto"		return KW_GOTO;
"read"		return KW_READ;
"print"		return KW_PRINT;
"return"    return KW_RETURN;

	/* COMPOUND OPERATORS */
"<="    return OPERATOR_LE;
">="    return OPERATOR_GE;
"=="    return OPERATOR_EQ;
"!="    return OPERATOR_DIF;

	/* INTEGERS LITERALS */
[0-9]+   {hashInsert(yytext, LIT_INTEGER); return LIT_INTEGER;}

	/* STRING */
\"([^"\\\n]|\\.)*\"	{hashInsert(yytext, LIT_STRING); return LIT_STRING;}

	/* CHARACTER */
\'(\\.|[^'\n\t])'	{hashInsert(yytext, LIT_CHAR); return LIT_CHAR;}

	/* IDENTIFIERS */
[-_a-z]+   {hashInsert(yytext, TK_IDENTIFIER); return TK_IDENTIFIER;}

	/* COMMENTS */
\\\\.*
\\\*	{ BEGIN(COMMENT); }

<COMMENT>\*\\	{ BEGIN(INITIAL); }
<COMMENT>"\n"   { ++lineNumber; }
<COMMENT>.

	/* ERRO */
.   return TOKEN_ERROR;

%%

#include "y.tab.c"
#include "main.c"

int isRunning(void){
    return Running;
}

int yywrap(){
	Running = 0;
	return 1;
}

int getLineNumber(void){
    return lineNumber;
}

void initMe(void){
    hashInit();
}
