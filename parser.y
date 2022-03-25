%token KW_CHAR
%token KW_INT
%token KW_FLOAT

%token KW_IF
%token KW_THEN
%token KW_ELSE
%token KW_WHILE
%token KW_GOTO
%token KW_READ
%token KW_PRINT
%token KW_RETURN

%token OPERATOR_LE
%token OPERATOR_GE
%token OPERATOR_EQ
%token OPERATOR_DIF

%token TK_IDENTIFIER

%token LIT_INTEGER
%token LIT_CHAR
%token LIT_STRING

%token TOKEN_ERROR

/* precedence rules */
%left '<' '>' OPERATOR_EQ OPERATOR_DIF OPERATOR_LE OPERATOR_GE
%left '+' '-'
%left '*' '/'
 
%{

int yyerror ();

%}

%%

program: declarationList
    ;

declarationList: varDecl declarationList
    | funDecl declarationList
    |
    ;

varDecl: simpleVar
    | vector
    ;

funDecl: header cmd
    ;

simpleVar: KW_CHAR TK_IDENTIFIER ':' literal ';'
    | KW_INT TK_IDENTIFIER ':' literal ';'
    | KW_FLOAT TK_IDENTIFIER ':' fraction ';'
    ;

 vector: KW_CHAR TK_IDENTIFIER '[' LIT_INTEGER ']' ';'
    | KW_CHAR TK_IDENTIFIER '[' LIT_INTEGER ']' initialVecVal ';'
    | KW_INT TK_IDENTIFIER '[' LIT_INTEGER ']' ';'
    | KW_INT TK_IDENTIFIER '[' LIT_INTEGER ']' initialVecVal ';'
    | KW_FLOAT TK_IDENTIFIER '[' LIT_INTEGER ']' ';'
    | KW_FLOAT TK_IDENTIFIER '[' LIT_INTEGER ']' initialVecVal ';'
    ;

literal: LIT_CHAR
    | LIT_INTEGER
    ;

fraction: LIT_INTEGER '/' LIT_INTEGER
    ;

initialVecVal: ':' LIT_INTEGER moreVecVal
    | ':' LIT_CHAR moreVecVal
    ;
    
moreVecVal: LIT_INTEGER moreVecVal
    | LIT_CHAR moreVecVal
    | 
    ;

header: KW_CHAR TK_IDENTIFIER '(' parametersList ')'
    | KW_CHAR TK_IDENTIFIER '(' ')'
    | KW_INT TK_IDENTIFIER '(' parametersList ')'
    | KW_INT TK_IDENTIFIER '(' ')'
    | KW_FLOAT TK_IDENTIFIER '(' parametersList ')'
    | KW_FLOAT TK_IDENTIFIER '(' ')'
    ;

parametersList: KW_FLOAT TK_IDENTIFIER anotherParameters
    | KW_INT TK_IDENTIFIER anotherParameters
    | KW_CHAR TK_IDENTIFIER anotherParameters
    ;

anotherParameters: ',' parametersList
    |
    ;

cmd: returnCmd
    | printCmd
    | flowControl
    | cmdBlock
    | 
    ;

cmdBlock: '{' cmdBlockList '}'
    ;

cmdBlockList: cmd ';'
    | cmd ';' cmdBlockList
    | label
    ;

label: TK_IDENTIFIER ':'
    ;

returnCmd: KW_RETURN expression //expression that gives the return value
    ;

printCmd: KW_PRINT printList
    ;

printList: LIT_STRING
    | LIT_STRING ',' printList
    | expression
    | expression ',' printList
    ;

flowControl: KW_GOTO TK_IDENTIFIER // label name
    ;

expression: TK_IDENTIFIER
    | aritmethicExpression
    | KW_READ
    | funCall
    ;

aritmethicExpression: literal
    | '(' aritmethicExpression ')'
    | TK_IDENTIFIER '[' aritmethicExpression ']' //TK_IDENTIFIER '[' integerExpression ']'
    | aritmethicExpression '+' aritmethicExpression
    | aritmethicExpression '-' aritmethicExpression
    | aritmethicExpression '*' aritmethicExpression
    | aritmethicExpression '/' aritmethicExpression
    | aritmethicExpression '>' aritmethicExpression
    | aritmethicExpression '<' aritmethicExpression
    | aritmethicExpression OPERATOR_EQ aritmethicExpression
    | aritmethicExpression OPERATOR_DIF aritmethicExpression
    | aritmethicExpression OPERATOR_LE aritmethicExpression
    | aritmethicExpression OPERATOR_GE aritmethicExpression
    ;

funCall: TK_IDENTIFIER '(' argList ')'
    ;

argList: expression argListCont
    ;

argListCont: ',' argList
    |
    ;

%%

int yyerror (){
    fprintf(stderr, "Syntax error at line %d.\n", getLineNumber());
    
    exit(3);
}