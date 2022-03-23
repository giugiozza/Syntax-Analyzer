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
/*TODO:
    verificar se funções e comandos estão OK
    verificar se label está certo
    trocar o conteudo de expression
    testar se está aceitando declaração de função terminada por ; - não pode
    testar se está aceitando { }
*/

program: declarationList
    ;

declarationList: varDecl declarationList
    | funDecl declarationList
    |
    ; 

varDecl: simpleVar
    | vector
    ;

funDecl: header body
    ;

simpleVar: KW_CHAR TK_IDENTIFIER ':' literal ';'
    | KW_INT TK_IDENTIFIER ':' literal ';'
    | KW_FLOAT TK_IDENTIFIER ':' fraction ';'
    ;

vector: KW_CHAR TK_IDENTIFIER '[' size ']' vectorTail
    | KW_INT TK_IDENTIFIER '[' size ']' vectorTail
    | KW_FLOAT TK_IDENTIFIER '[' size ']' vectorTail
    ;

varType: KW_CHAR
    | KW_INT
    | KW_FLOAT
    ;

fraction: LIT_INTEGER '/' LIT_INTEGER
    ;

literal: LIT_INTEGER
    | LIT_CHAR
    ;

vectorTail: ':' initialVecVal
    | ';'
    ;

initialVecVal: LIT_INTEGER anotherInitialVecVal
    | '\'' LIT_CHAR '\'' anotherInitialVecVal
    ;

anotherInitialVecVal: ' ' initialVecVal
    | ';'
    ;

size: /* inteiro positivo -> LIT_INTEGER ? */
    ;

header: varType TK_IDENTIFIER '(' parametersList ')'
    | varType TK_IDENTIFIER '(' ')'
    ;

body: cmdList
    | cmdBlock
    | 
    ;

parametersList: varType TK_IDENTIFIER anotherParameters
    ;

anotherParameters: ',' parametersList
    |
    ;

cmdBlock: '{' cmdList '}'
    ;

/* Os comandos podem ser de atribuicao, controle de fluxo, os comandos print e return
e comando vazio (comando vazio segue as mesmas regras dos demais, e se estiver
dentro da lista de comandos de um bloco, deve ser terminado por ‘;’) */
cmdList: label ':' cmdList
    | cmd ';' cmdList
    | 
    ;

cmd: attribution
    | flowControl
    | printCmd
    | returnCmd
    | cmdBlock
    | 
    ; 

label: TK_IDENTIFIER

attribution: TK_IDENTIFIER '=' expression
    | TK_IDENTIFIER '[' expression ']' '=' expression
    ;

flowControl: ifCmd
    | whileCmd cmd
// + rótulos e saltos?
    ;

printCmd: KW_PRINT printList
    ;

printList: LIT_STRING ',' printList
    | LIT_STRING
    | expression ',' printList
    | expression
    ;

returnCmd: KW_RETURN expression //expresao que dá o valor de retorno
    ;

ifCmd: KW_IF expression KW_THEN cmd
    | KW_IF expression KW_THEN cmd KW_ELSE cmd
    ;

whileCmd: KW_WHILE '(' expression ')'

expression: TK_IDENTIFIER
    ;

%%

int yyerror (){
    fprintf(stderr, "Syntax error at line %d.\n", getLineNumber());
    
    exit(3);
}