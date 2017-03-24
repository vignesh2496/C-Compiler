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
	int error;
%}

%token _GREAT_EQ _LESS_EQ _LOGIC_OR _LOGIC_AND _NOT_EQ _EQUAL _INCR_1 _DECR_1 _INCR_VAL _DECR_VAL _MULT_VAL _DIV_VAL _MOD_VAL _DO _ELSE _FOR _IF _INT _PRINT _SCAN _WHILE _HEADER _PREPROC _STRING _RETURN 

%union 
{
	int number;
    char *str;
}

%token<number> _CONSTANT 
%token<str> _IDENTIFIER _MAIN

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
		}
  		| declist ',' _IDENTIFIER
		{
			token = $3;
			error = insertToken(3,table);
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
		   | expression '-' expression
		   | expression '*' expression 
		   | expression '/' expression 
		   | expression '%' expression 
		   | '(' expression ')' 
		   | expression '>' expression 
		   | expression '<' expression 
		   | expression _GREAT_EQ expression 
		   | expression _LESS_EQ expression
		   | expression _NOT_EQ expression 
		   | expression _EQUAL expression 
		   | expression _LOGIC_AND expression 
		   | expression _LOGIC_OR expression
		   | expression ',' expression	
		   | _IDENTIFIER '=' expression 
		   {    
				token = $1;
				error = lookupTable();
				printErrorMessage(error);
           }
		   | _IDENTIFIER _INCR_1
		   { 
				token = $1;
				error = lookupTable();
				printErrorMessage(error);
		   }
		   | _IDENTIFIER _DECR_1
		   { 
				token = $1;
				error = lookupTable();
				printErrorMessage(error);
		   }	
		   | _IDENTIFIER
		   { 
				token = $1;
				error = lookupTable();
				printErrorMessage(error);
		   }
		   | _IDENTIFIER '(' expression ',' expression ')' 
		   { 
				token = $1;
				error = lookupTable();
				printErrorMessage(error);
		   }
		   | _CONSTANT  
		   ;

expression_statement : ';' 
					 | expression ';' 
					 ;

return_statement : _RETURN expression ';'
                 ;

io_statement : _PRINT '(' _STRING ',' expression ')' ';'
			 | _SCAN '(' _STRING ',' identifieraddr_list ')' ';'
			 ;

identifieraddr_list : identifieraddr_list ',' '&' _IDENTIFIER
					{ 
						token = $4;
						error = lookupTable();
						printErrorMessage(error);
		 		    }
					| '&' _IDENTIFIER
					{ 
						token = $2;
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
		  }
		  | if_statement '{' body '}' else_statement '{' body '}' 
		  { 
			v.push_back(s.top());
			s.pop();
			table = s.top();
		  }
		  | loop_statement '{' body '}'
          { 
			v.push_back(s.top());
			s.pop(); 
			table = s.top();
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
			   | _WHILE '(' expression ')' 
			   { 	
				    table.clear();
				    s.push(table);
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
			 }
			 ;

else_statement : _ELSE 
			   { 	
					v.push_back(s.top());
					s.pop();
			   		table.clear();
					s.push(table);
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
		case 3 : table[token].first = "INTEGER_VARIABLE"; 
	}
	s.pop();
	s.push(table);
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
				 exit(4); break;  
		case 5 : cout << endl << "ERROR 5 : Undeclared variable " << token << " at line "<< linecount << endl << endl; 
				 exit(5); break; 
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
