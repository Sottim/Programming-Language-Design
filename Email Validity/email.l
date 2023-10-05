%{
    // Don't need stdio.h for printf here
%}


NAME [a-z]+
DOT \.
AT \@
US _
BATCH {US}(ug|asp|yif|mls|phd)([2-9][3-9]|[3-9][0-9])
DES {US}(tf|ra|ga)
DOMAIN ashoka{DOT}edu{DOT}in
ALDOMAIN alumni{DOT}{DOMAIN}
EMAIL ({NAME}{DOT}{NAME}({BATCH}|{DES})?{AT}{DOMAIN}|{NAME}{DOT}{NAME}{AT}{ALDOMAIN})

%{
   enum yytokentype {
    NAME = 2,
    DOT = 3,
    AT = 4,
    US = 5,
    BATCH = 6,
    DES = 7,
    DOMAIN = 8,
    ALDOMAIN = 9,
    EMAIL = 10,
   };

   int yylval;
%}

%%
{NAME}      {
            printf("<NAME, %s>", yytext);
            return NAME;
    }
{DOT}       {
            printf("<DOT, %s>", yytext);
            return DOT;
    }
{US}        {
            printf("<US, %s>", yytext);
            return US;
    }
{BATCH}     { 
            printf("<BATCH, %s>", yytext);
            return BATCH;
    }
{DES}       {
            printf("<DES, %s>", yytext);
            return DES;
    }
{AT}        {
            printf("<AT, %s>", yytext);
            return AT;
    }
{DOMAIN}    {
            printf("<DOMAIN, %s>", yytext);
            return DOMAIN;
    }
{ALDOMAIN}  {
            printf("<ALDOMAIN, %s>", yytext);
            return ALDOMAIN;
    }
{EMAIL}     {
            printf("<EMAIL, %s>", yytext);
            return EMAIL;
    }
.           {
            printf("Invalid Input : %s", yytext);
            return yywrap();
    }
%%

int yywrap(){
    return 1;
}

int main(){
    int tok;
    while(tok = yylex()){
        printf(", Token ID : %d\n", tok);
    }
    return 0;
}