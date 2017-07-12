%{
	#include <bits/stdc++.h>
	
	using namespace std;

	string token;
	stack <map<string,pair<string,int> > > s;
	stack <map<string,pair<string,int> > > t;
	vector <map<string,pair<string,int> > > v;
	map<string,pair<string,int> > table;

	int lookupTable();	
	int insertToken(int TOKENID, map<string,pair<string,int> > &);
	void dispSymbolTable();
	void printErrorMessage(int);
	
    extern FILE* yyin;
	extern int yylex();
	extern int linecount; 
	extern int commentflag;
	extern void yyerror(const char*);
	int error,counter = 0,label = 0;
	
	// By default all are off
	bool arrayMisuseFlag = false;
	bool funcMisuseFlag = false;
	bool mainMisuseFlag = false;
	bool varMisuseFlag = false;
%}

%token _GREAT_EQ _LESS_EQ _LOGIC_OR _LOGIC_AND _NOT_EQ _EQUAL _INCR_1 _DECR_1 _INCR_VAL _DECR_VAL _MULT_VAL _DIV_VAL _MOD_VAL _DO _ELSE _FOR _IF _INT _PRINT _SCAN _WHILE _HEADER _PREPROC _STRING _RETURN 

%union 
{
	int number;
    char *str;
}

%token<number> _CONSTANT 
%token<str> _IDENTIFIER _MAIN

%type<str> expression 

%start global

%left ','
%right '=' _INCR_VAL _DECR_VAL _MULT_VAL _DIV_VAL MOD_VAL
%left _LOGIC_AND _LOGIC_OR
%left '>' '<' _GREAT_EQ _LESS_EQ 
%left _EQUAL _NOT_EQ 
%left '+' '-'
%left '*' '/' '%'
%left '(' ')' _INCR_1 _DECR_1

%%

global : _PREPROC _HEADER funcdec 
       ;

funcdec : funcdec_ mainfunc
	    | funcdec_ mainfunc funcdec_ 
		| mainfunc funcdec_
		| mainfunc
        ;

mainfunc :  main '{' body '}'
		 { 
			v.push_back(s.top());
			s.pop();
			table = s.top();		
		 }
		 ;

funcdec_ : functiondec '{' body '}' 
		 { 
			v.push_back(s.top());
			s.pop(); 
			table = s.top();
		 }
		 | declaration
		 | funcdec_ functiondec '{' body '}' 
         { 
			v.push_back(s.top());
			s.pop();
			table = s.top();
		 }
		 | funcdec_ declaration 
		 ;

declaration : _INT declist ';' 
            ;
	
declist : declist ',' _IDENTIFIER '=' expression 
		{
			token = $3;
			error = insertToken(3,table);
			printErrorMessage(error);
			
			printf("%s = %s\n",$3,$5);
		}
  		| declist ',' _IDENTIFIER
		{
			token = $3;
			error = insertToken(3,table);
			printErrorMessage(error);
		} 
		| declist ',' _IDENTIFIER '[' expression ']'
		{
			token = $3;
			error = insertToken(4,table);
			printErrorMessage(error);
		}
		| _IDENTIFIER '[' expression ']'
		{
			token = $1;
			error = insertToken(4,table);
			printErrorMessage(error);
		}
		| _IDENTIFIER             
		{
			token = $1;
			error = insertToken(3,table);
			printErrorMessage(error);
		}		 
		| _IDENTIFIER '=' expression 
		{
			token = $1;
			error = insertToken(3,table);
			printErrorMessage(error);
			
		  	printf("%s = %s\n",$1,$3);
		}	
		;

main  : _INT _MAIN '(' ')' 
	  {
		 token = $2;
		 error = insertToken(2,table);
		 printErrorMessage(error);
	
		 table.clear();
     	 s.push(table);
	  }
      ;

functiondec : _INT _IDENTIFIER '(' _INT _IDENTIFIER ','  _INT _IDENTIFIER ')'
			{
				token = $2;
				error = insertToken(1,table);
				printErrorMessage(error);

				table.clear();
				s.push(table); 

				token = $5;
				error = insertToken(3,table);
				printErrorMessage(error);

				token = $8;
				error = insertToken(3,table);
				printErrorMessage(error);
			}
            ;

body : declaration | statement
     | body declaration 
	 | body statement 
     ;    

expression : expression '+' expression 
			{
		   		char var[100];
		  		printf("t%d = %s + %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   } 
		   | expression '-' expression
		   {
		   		char var[100];
		  		printf("t%d = %s - %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   } 
		   | expression '*' expression 
		   {
		   		char var[100];
		  		printf("t%d = %s * %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   } 
		   | expression '/' expression 
		   {
		   		char var[100];
		  		printf("t%d = %s / %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   } 
		   | expression '%' expression 
		   {
		   		char var[100];
		  		printf("t%d = %s mod %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   } 
		   | '(' expression ')' 
		   {
		   		char var[100];
		  		printf("t%d = %s\n",counter,$2);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   } 
		   | expression '>' expression 
		   {
		   		char var[100];
		  		printf("t%d = %s > %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   } 
		   | expression '<' expression 
		   {
		   		char var[100];
		  		printf("t%d = %s < %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   } 
		   | expression _GREAT_EQ expression 
		   {
		   		char var[100];
		  		printf("t%d = %s >= %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   } 
		   | expression _LESS_EQ expression
		   {
		   		char var[100];
		  		printf("t%d = %s <= %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   } 
		   | expression _NOT_EQ expression 
		   {
		   		char var[100];
		  		printf("t%d = %s != %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   } 
		   | expression _EQUAL expression
		   {
		   		char var[100];
		  		printf("t%d = %s == %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   } 
		   | expression _LOGIC_AND expression 
		   {
		   		char var[100];
		  		printf("t%d = %s && %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   }
		   | expression _LOGIC_OR expression
		   {
		   		char var[100];
		  		printf("t%d = %s || %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   }
		   | expression ',' expression	
		   {
		   		char var[100];
		  		printf("t%d = %s , %s\n",counter,$1,$3);
		  		sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
		   }
		   | _IDENTIFIER '=' expression 
		   {    
				token = $1;
				// Set possible error flags
				mainMisuseFlag = true;
				funcMisuseFlag = true;
				arrayMisuseFlag = true;
				error = lookupTable();
				printErrorMessage(error);
				printf("%s = %s\n",$1,$3);
				$$ = $1;
           }
           | _IDENTIFIER '[' expression ']' '=' expression
           {
           		token = $1;
           		// Set possible error flags
				mainMisuseFlag = true;
				funcMisuseFlag = true;
				varMisuseFlag = true;
				error = lookupTable();
				printErrorMessage(error);
				
				printf("%s[%s] = %s",$1,$3,$6);
				$$ = $6;
           }
		   | _IDENTIFIER _INCR_1
		   { 
				token = $1;
				// Set possible error flags
				mainMisuseFlag = true;
				funcMisuseFlag = true;
				arrayMisuseFlag = true;
				error = lookupTable();
				printErrorMessage(error);
				printf("t%d = %s + 1\n%s = t%d\n",counter,$1,$1,counter);
				$$ = $1;
				counter++;
		   }
		   | _IDENTIFIER _DECR_1
		   { 
				token = $1;
				// Set possible error flags
				mainMisuseFlag = true;
				funcMisuseFlag = true;
				arrayMisuseFlag = true;
				error = lookupTable();
				printErrorMessage(error);
				printf("t%d = %s - 1\n%s = t%d\n",counter,$1,$1,counter);
				$$ = $1;
				counter++;
		   }	
		   | _IDENTIFIER
		   { 
				token = $1;
				// Set possible error flags
				mainMisuseFlag = true;
				funcMisuseFlag = true;
				arrayMisuseFlag = true;
				error = lookupTable();
				printErrorMessage(error);
				$$ = $1;
		   }
		   | _IDENTIFIER '[' expression ']'
		   { 
				token = $1;
				// Set possible error flags
				varMisuseFlag = true;
				mainMisuseFlag = true;
				funcMisuseFlag = true;
				error = lookupTable();
				printErrorMessage(error);
				
				char var[100];
				printf("t%d = %s[%s]\n",counter,$1,$3);
				sprintf(var,"t%d",counter);
		  		$$ = var;
		  		counter++;
				
		   }
		   | _IDENTIFIER '(' expression ',' expression ')' 
		   { 
			 	token = $1;
				// Set possible error flags
				mainMisuseFlag = true;
				varMisuseFlag = true;
				arrayMisuseFlag = true;
				error = lookupTable();
				printErrorMessage(error);
				
				printf("CALL %s(%s,%s)\n",$1,$3,$5); 
		   }
		   | _CONSTANT  
		   { 
		   		char stringnum[100];
		   		sprintf(stringnum,"%d",$1);
		   		$$ = stringnum;
		   }
		   ;

expression_statement : ';' 
					 | expression ';' 
					 ;

return_statement : _RETURN expression ';'
                 ;

io_statement : _PRINT '(' _STRING ',' expression ')' ';'
			 {
			 	printf("PRINT %s\n",$5);
			 }
			 | _SCAN '(' _STRING ',' identifieraddr_list ')' ';'
			 ;

identifieraddr_list : identifieraddr_list ',' '&' _IDENTIFIER
					{ 
						token = $4;
						// Set possible error flags
						mainMisuseFlag = true;
						funcMisuseFlag = true;
						arrayMisuseFlag = true;
						error = lookupTable();
						printErrorMessage(error);
		 		    }
					| '&' _IDENTIFIER
					{ 
						token = $2;
						// Set possible error flags
						mainMisuseFlag = true;
						funcMisuseFlag = true;
						arrayMisuseFlag = true;
						error = lookupTable();
						printErrorMessage(error);
		   		    }
		   		    | identifieraddr_list ',' '&' _IDENTIFIER '[' expression ']'
		   		    { 
						token = $4;
						// Set possible error flags
						mainMisuseFlag = true;
						funcMisuseFlag = true;
						varMisuseFlag = true;
						error = lookupTable();
						printErrorMessage(error);
		 		    }
		 		    | '&' _IDENTIFIER '[' expression ']'
					{ 
						token = $2;
						// Set possible error flags
						mainMisuseFlag = true;
						funcMisuseFlag = true;
						varMisuseFlag = true;
						error = lookupTable();
						printErrorMessage(error);
		   		    }
					;

statement : expression_statement
		  | if_statement '{' body '}' 
		  { 
			v.push_back(s.top());
			s.pop();
			table = s.top(); 
			
			printf("LABEL L%d:\n",label);
			label++;
		  }
		  | if_statement '{' body '}' { printf("GOTO L%d\n",label + 1); } else_statement '{' body '}' 
		  { 
			v.push_back(s.top());
			s.pop();
			table = s.top();
			
			printf("LABEL L%d:\n",label);
			label++;
		  }
		  | loop_statement '{' body '}' 
          { 
			v.push_back(s.top());
			s.pop(); 
			table = s.top();
			
			printf("GOTO L%d\nLABEL L%d:\n",label - 2,label);
			label++;
		  }
 		  | do_statement '{' body '}' _WHILE '(' expression ')' ';' 
          { 
			v.push_back(s.top());
			s.pop();
			table = s.top();
		  }
		  | return_statement 
		  | io_statement
		  ;

loop_statement : _FOR '(' expression_statement expression_statement ')' 
			   { 	
					table.clear();
					s.push(table);
			   }
			   | _FOR '(' expression_statement expression_statement expression ')' 
			   { 	
				    table.clear();
				    s.push(table);
			   }
			   | _WHILE { printf("LABEL L%d:\n",label); label++; } '(' expression ')' 
			   { 	
				    table.clear();
				    s.push(table);
				    
				    printf("IF %s == TRUE THEN L%d ELSE L%d\nLABEL L%d:\n",$4,label,label + 1,label);
					label++;
			   }
			   ;

do_statement : _DO 
			 { 	
				table.clear();
				s.push(table);
			 }
			 ; 

if_statement : _IF '(' expression ')' 
			 { 	
				table.clear();
				s.push(table);
				
				printf("IF %s == TRUE THEN L%d ELSE L%d\nLABEL L%d:\n",$3,label,label + 1,label);
				label++;
			 }
			 ;

else_statement : _ELSE 
			   { 	
					v.push_back(s.top());
					s.pop();
			   		table.clear();
					s.push(table);
					
					printf("LABEL L%d:\n",label);
					label++;
			   }
	    	   ;

%%

// Insert token
int insertToken(int TOKENID, map<string,pair<string,int> > &table)
{
	if(table.find(token)!=table.end())
		return 4;

	switch(TOKENID)
	{
		case 1 : table[token].first = "FUNCTION"; break;
		case 2 : table[token].first = "MAIN_FUNCTION"; break;
		case 3 : table[token].first = "INTEGER_VARIABLE"; break;
		case 4 : table[token].first = "INTEGER_ARRAY"; break;
	}
	s.pop();
	s.push(table);
	return 0;
}

void resetFlags()
{
	arrayMisuseFlag = false;
	funcMisuseFlag = false;
	mainMisuseFlag = false;
	varMisuseFlag = false;
}

// Check type
int checkType(map<string, pair<string, int > > temp)
{
	if(funcMisuseFlag && temp[token].first == "FUNCTION")
	{
		resetFlags();
		return 6;
	}
	if(mainMisuseFlag && temp[token].first == "MAIN_FUNCTION")
	{
		resetFlags();
		return 7;
	}
	if(varMisuseFlag && temp[token].first == "INTEGER_VARIABLE")
	{
		resetFlags();
		return 8;
	}
	if(arrayMisuseFlag && temp[token].first == "INTEGER_ARRAY")
	{
		resetFlags();
		return 9;
	}
	resetFlags();
	return 0;
} 

// Look up table
int lookupTable()
{
	bool flag = true;
	while(!s.empty())
	{
		// Assigning temporary map to the top of the stack(current scope)
		map<string, pair<string, int > > temp = s.top();
		if(temp.find(token) != temp.end())
		{
			// Checking type mismatch
			if(error = checkType(temp))
				return error;
				
			// Turn misuse off if there is no misuse
			arrayMisuseFlag = false;
			flag = false;
			break;
		}
		// Popping the current scope block
		s.pop();
		// Storing current scope map in some temporary stack
		t.push(temp);
	}
	while(!t.empty())
	{
		s.push(t.top());
		t.pop();
	}
	if(flag)
		return 5;
	else
		return 0;
}

// Display symbol table
void dispSymbolTable()
{
	int i;
	cout<<endl<<endl<<"SYMBOL TABLE"<<endl<<endl;
	for(i = 0 ; i < v.size() ; i++)
	{
		map<string,pair<string,int> >::iterator it;
		for(it = v[i].begin() ; it != v[i].end() ; it++)
		{
			(it->second).second = i;
			cout << "< " << it->first << " , " << (it->second).first << " , " << (it->second).second << " >" << endl;
		}
	}
} 	

// Display error
void printErrorMessage(int errorcode)
{
	switch(errorcode)
	{
		case 4 : cout << endl << "ERROR 4 : Redeclaring variable " << token << " at line "<< linecount << endl << endl; 
				 printf("\nPARSING FAILED!\n\n\n"); exit(4); break;  
		case 5 : cout << endl << "ERROR 5 : Undeclared variable " << token << " at line "<< linecount << endl << endl; 
				 printf("\nPARSING FAILED!\n\n\n"); exit(5); break; 
		case 6 : cout << endl << "ERROR 6 : Type mismatch for function " << token << " at line "<< linecount << endl << endl; 
				 printf("\nPARSING FAILED!\n\n\n"); exit(6); break;
		case 7 : cout << endl << "ERROR 7 : Type mismatch for " << token << " at line "<< linecount << endl << endl; 
				 printf("\nPARSING FAILED!\n\n\n"); exit(7); break;
		case 8 : cout << endl << "ERROR 8 : Type mismatch for integer variable " << token << " at line "<< linecount << endl << endl; printf("\nPARSING FAILED!\n\n\n"); exit(8); break;
		case 9 : cout << endl << "ERROR 9 : Type mismatch for integer array " << token << " at line "<< linecount << endl << endl; printf("\nPARSING FAILED!\n\n\n"); exit(9); break;		 
	}
}

int main(int argc, char *argv[])
{
	FILE* SRC;
	printf("\nLEXICAL AND SYNTACTICAL ANALYSIS\n");
	printf("--------------------------------\n\n");
	if (argc == 2 && (SRC = fopen(argv[1],"r")))
        	yyin = SRC;
	else if(SRC == NULL)
	{
		printf("File not found\n");
		exit(0);
	}
	table.clear();
	s.push(table);
	if(!yyparse())
		printf("\nPARSING PASSED!\n"); 
	else
		printf("\nPARSING FAILED!\n"); 
	fclose(SRC);

	if(commentflag)
	{
		printf("\nERROR 2 : Comment not closed\n"); 
		exit(2);
	}

	v.push_back(s.top());
	s.pop();
	dispSymbolTable();
	if(s.empty())
		printf("\nStack empty!\n");
	return 0;
}

void yyerror(const char *msg)
{
	printf("\nSYNTAX ERROR at line %d\n",linecount);
}
