%{
	#include<stdio.h>
	#include<string.h>
	void printResult(const char * keyword){
		printf("( %s , %d , %s )\n", keyword ,yylineno, yytext);
	}
%}
%option yylineno
ANNOTATION (\/\*([^*]|[\r\n]|(\*+([^\*\/]|[\r\n])))*\*+\/)|(\/\/.*)
ILLEGALANNO (\/\*)|(\*\/)
TYPE int|float
STRUCT struct
RETURN return
IF if
ELSE else
WHILE while
HEX 0[Xx][0-9A-Za-z]*
OCTAL 0[0-9A-Za-z]+
SCIENNUM [+-]?[0-9]+(\.[0-9]+)?[eE][+\-0-9a-zA-Z]*
INT [+-]?[0-9]+
FLOAT [+-]?[0-9]+"."[0-9]+
ID [A-Za-z_][A-Za-z_0-9]*
SEMI ;
COMMA ,
ASSIGNOP =
RELOP >|<|>=|<=|==|!=
PLUS "+"
MINUS -
STAR "*"
DIV "/"
AND &&
OR "||"
DOT "."
NOT "!"
LP "("
RP ")"
LB "["
RB "]"
LC "{"
RC "}"

%%
{ANNOTATION} {printResult("ANNOTATION");}
{ILLEGALANNO} { printf("Error Type A at line %d : Can't identify symbol %s.\n",yylineno, yytext);}
{TYPE} {printResult("TYPE");}
{STRUCT} {printResult("STRUCT"); }
{RETURN} { printResult("RETURN");}
{IF} { printResult("IF");}
{ELSE} { printResult("ELSE");}
{WHILE} { printResult("WHILE"); }
{SCIENNUM} {
	char * point = NULL;
	int tag = 0;
	point = strchr(yytext, 'e');
	if (point == NULL) {
		point = strchr(yytext, 'E');
	}
	if (point != NULL) {
		point = point + sizeof(char);
		if (*point == '+' || *point == '-') {
			while (*(point = point + sizeof(char)) != '\0'){
				if (*point > '0' && *point <'9') {
				} else {
					printf("Error type A at line %d: Can't indentify Scientific number %s\n",yylineno,yytext);
					tag = 1;
					break;
				}
			}
		} else {
			printf("Error type A at line %d: Can't indentify Scientific number %s\n",yylineno,yytext);
		tag = 1;
		}
	}
	if (tag == 0) {
		printResult("SCIENNUM");
	}
}
{HEX} { 
	int len = strlen(yytext);
	int i;
	int tag = 0;
	if (len <= 2) {
		tag = 1;
		printf("Error type A at line %d:Can't indentify Hexadecimal number %s\n",yylineno,yytext);
	}
	for (i=2; i<len; i++){
		if (!isxdigit(yytext[i])) {
			printf("Error type A at line %d: Can't indentify Hexadecimal number %s\n",yylineno,yytext);
			tag = 1;	
			break;
		}
	}	
	if (tag == 0) {
		printResult("HEX");
	}
}
{OCTAL} {
	int len = strlen(yytext);
	int i;
	int tag = 0;
	for (i=1; i<len; i++){
		if (yytext[i]<'0' || yytext[i]>'9'){
			printf("Error type A at line %d: Can't identify Octal number %s\n",yylineno,yytext);
			tag = 1;	
			break;
		}
	}
	if (tag == 0) {
		printResult("OCT");
	}
}
{INT} { printResult("INT");}
{FLOAT} { printResult("FLOAT");}
{ID} { printResult("ID");}
{SEMI} { printResult("SEMI");}
{COMMA} { printResult("COMMA");}
{ASSIGNOP} { printResult("ASSIGNOP");}
{RELOP} { printResult("RELOP");}
{PLUS} { printResult("PLUS");}
{MINUS} { printResult("MINUS");}
{STAR} { printResult("STAR");}
{DIV} { printResult("DIV");}
{AND} { printResult("AND");}
{OR} { printResult("OR");}
{DOT} { printResult("DOT");}
{NOT} { printResult("NOT");}
{LP} { printResult("LP");}
{RP} { printResult("RP");}
{LB} { printResult("LB");}
{RB} { printResult("RB");}
{LC} { printResult("LC");}
{RC} { printResult("RC");}
[\t]+ {}
[ ]+ {}
\n {}
. { printf("Error type A at line %d: Mysterious character '%s'.\n",yylineno,yytext); }
%%

void main(int argc, char ** argv){

	if (argc > 1){
		if (!(yyin = fopen(argv[1],"r"))){
			perror(argv[1]);
			return 1;
		}
	}
	while (yylex()!=0){
		return 0;
	}
}

int yywrap(){
	return 1;
}

