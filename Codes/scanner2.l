%{
	#include <stdlib.h>
 	#include <math.h>
	#include <ctype.h>
	#include <stdio.h>
	#include "y.tab.h"
	int linecount = 1;
	int commentflag = 0;
%}

DIGIT [0-9]
HEADER <[a-zA-Z]+\.h>
PREPROCESSOR #include
SINGLE_LINE_COMMENT \/\/.*
START_MULTI_LINE \/\*
STRING \".+\"
VARNAME [_a-zA-Z][_a-zA-Z0-9]* 
INVALID_IDENTIFIER {DIGIT}+[_a-zA-Z]+[_a-zA-Z0-9]* 

%s startComment

%%
 
{SINGLE_LINE_COMMENT} { 
							//printf("%s : COMMENTS at line %d\n",yytext,linecount);
					  }
					  
{START_MULTI_LINE} 	{
						BEGIN startComment; 
						//printf("START COMMENT at line %d\n",linecount);
						commentflag = 1;
					}
					
<startComment>\n 	{
						linecount++;
					}
					
<startComment>\*\/	{
						BEGIN 0; 
						//printf("END COMMENT at line %d\n",linecount); 
						commentflag = 0;
					}
<startComment>[^(*/|\n)]*	;

{PREPROCESSOR} { 
					//printf("%s : PREPROCESSOR DIRECTIVE at line %d\n",yytext,linecount);
					return _PREPROC;
			   }
			   
{STRING} { 
			//printf("%s : STRING\n",yytext);
			return _STRING;
		 }

"="	{
		//printf("%s : ASSIGNMENT at line %d\n ",yytext,linecount);
		return '=';
	}

"+"	{
		//printf("%s : ADD at line %d\n",yytext,linecount);
		return '+';
	}

"-"	{
		//printf("%s : SUBTRACT at line %d\n",yytext,linecount);
		return '-';
	}

"*" {
		//printf("%s : MULTIPLY at line %d\n",yytext,linecount);
		return '*';
	}

"/" {
		//printf("%s : DIVIDE at line %d\n",yytext,linecount);
		return '/';
	}

"%" {
		//printf("%s : MODULO at line %d\n",yytext,linecount);
		return '%';
	}

"++"	{
			//printf("%s : INCREMENT at line %d\n",yytext,linecount);
			return _INCR_1;
		}

"--"	{
			//printf("%s : DECREMENT at line %d\n",yytext,linecount);
			return _DECR_1;
		}

"+=" 	{
			//printf("%s : ADD_ASSIGN at line %d\n",yytext,linecount);
			return _INCR_VAL;
		}

"-="	{
			//printf("%s : SUB_ASSIGN at line %d\n",yytext,linecount);
			return _DECR_VAL;
		}

"*=" 	{
			//printf("%s : MULT_ASSIGN at line %d\n",yytext,linecount);
			return _MULT_VAL;
		}

"/="	{
			//printf("%s : DIV_ASSIGN at line %d\n",yytext,linecount);
			return _DIV_VAL;
		}

"%="	{
			//printf("%s : MOD_ASSIGN at line %d\n",yytext,linecount);
			return _MOD_VAL;
		}

"=="	{
			//printf("%s : EQUAL at line %d\n",yytext,linecount);
			return _EQUAL;
		}

">="	{
			//printf("%s : GREAT_EQ at line %d\n",yytext,linecount);
			return _GREAT_EQ;
		}

"<="	{
			//printf("%s : LESS_EQ at line %d\n",yytext,linecount);
			return _LESS_EQ;
		}

"!="	{
			//printf("%s : NOT_EQ at line %d\n",yytext,linecount);
			return _NOT_EQ;
		}

">"	{
		//printf("%s : GREAT at line %d\n",yytext,linecount);
		return '>';
	}

"<"	{
		//printf("%s : LESS at line %d\n",yytext,linecount);
		return '<';
	}

"?"	{
		//printf("%s : CONDITIONAL at line %d\n",yytext,linecount);
		return '?';
	}

"&"	{
		//printf("%s : REFERENCE/BIT_AND at line %d\n",yytext,linecount);
		return '&';
	}

"|"	{
		//printf("%s : BIT_OR at line %d\n",yytext,linecount);
		return '|';
	}

"||"	{
			//printf("%s : LOGIC_OR at line %d\n",yytext,linecount);
			return _LOGIC_OR;
		}

"&&"	{
			//printf("%s : LOGIC_AND at line %d\n",yytext,linecount);
			return _LOGIC_AND;
		}

"!"	{
		//printf("%s : NEGATE at line %d\n",yytext,linecount);
		return '!';
	}

":"	{
		//printf("%s : COLON at line %d\n",yytext,linecount);
		return ':';
	}

";"	{
		//printf("%s : SEMICOLON at line %d\n",yytext,linecount);
		return ';';
	}

","	{
		//printf("%s : COMMA at line %d\n",yytext,linecount);
		return ',';
    }

"{"	{
		//printf("%s : OPEN_BRACE at line %d\n",yytext,linecount);
		return '{';
	}

"}"	{
		//printf("%s : CLOSE_BRACE at line %d\n",yytext,linecount);
		return '}';
	}

"("	{
		//printf("%s : OPEN_PAREN at line %d\n",yytext,linecount);
		return '(';
	}

")" {
		//printf("%s : CLOSE_PAREN at line %d\n",yytext,linecount);
		return ')';
	}
	
"["	{
		//printf("%s : OPEN_RECT at line %d\n",yytext,linecount);
		return '[';
	}

"]" {
		//printf("%s : CLOSE_RECT at line %d\n",yytext,linecount);
		return ']';
	}

"do" {
		//printf("%s : DO at line %d\n",yytext,linecount);
		return _DO;
	}

"else" {
			//printf("%s : ELSE at line %d\n",yytext,linecount);
			return _ELSE;
		}

"for" {
		//printf("%s : FOR at line %d\n",yytext,linecount);
		return _FOR;
	}

"if" {
		//printf("%s : IF at line %d\n",yytext,linecount);
		return _IF;
	}

"int"	{
			//printf("%s : INT at line %d\n",yytext,linecount);
			return _INT;
		}

"main"	{
			//printf("%s : MAIN at line %d\n","main",linecount);
			yylval.str = strdup(yytext);
			return _MAIN;
		}

"printf" {
			//printf("%s : PRINT at line %d\n",yytext,linecount);
			return _PRINT;
		}

"return" {
			//printf("%s : RETURN at line %d\n",yytext,linecount);
			return _RETURN;
		} 

"scanf"	{
			//printf("%s : SCAN at line %d\n",yytext,linecount);
			return _SCAN;
		}

"while" {
			//printf("%s : WHILE at line %d\n",yytext,linecount);
			return _WHILE;
		}

{HEADER}	{
				//printf("%s : HEADER FILE at line %d\n",yytext,linecount);
				return _HEADER;
			}

{VARNAME}	{
				//printf("%s : VARIABLE NAME at line %d\n",yytext,linecount);
				yylval.str = strdup(yytext);
				return _IDENTIFIER;
			}

{DIGIT}+	{
				//printf("%s : NUMBER at line %d\n",yytext,linecount);
				yylval.number = atoi(yytext);
				return _CONSTANT;
			}

{INVALID_IDENTIFIER} { printf("\nERROR 3 : Invalid identifier name at line %d\n",linecount); exit(3);}

\n linecount++;
[ \t]+ ;
.	{ printf("\nERROR 1 : No match found at line %d\n",linecount); exit(1);}

%%

