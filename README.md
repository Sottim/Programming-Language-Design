# PLDI

In a series of four assignments we intend to implement a compiler for a C-like language. To keep the problem tractable, we present a very small subset nanoC of C that is easy to manage and yet has most of the key flavours of C. It is framed based on C99 as standardized in International Standard ISO/IEC
9899:1999 (E). We present an overview of this language in Section 1. This gives most notions of its syntax and semantics. The details its lexical and syntactic specifications, framed by stripping down C99 standard,
is presented in Section 2. Finally a few example programs in the language are given in Section 3.

The implementation of the compiler for nanoC is split into 4 assignments as follows: 


1. Assignment 2: Lexical Analyzer for nanoC using Flex. The lexical grammar specification is given. 
## To run the code: 
Clone the programs contained in Assignment_2 folder.
In the terminal run : flex 9_A2.l which will create a .lex.yy.c file.

Then run: 
gcc lex.yy.c 9_A2.c which will create a a.out executable.

Finally run the command - Make all
('Make all' will take the test code written in 9_A2.nc which contains the test code of binary search and automate the process the tokenization of the program code present in 9_A2.nc). The automation happens due the code written in the Makefile.


2. Assignment 3: Parser for nanoC using Bison. 


3. Assignment 4: Machine-Independent Code Generator for nanoC using syntax-directed translation with Bison. Three-Address (intermediate) Code (TAC) used as target of translation is explained here.


4. Assignment 5: Target Code Generator for nanoC by simple code generation by table lookup. The target processor is taken to be x86 and a subset of its assembly language is presented here for use.