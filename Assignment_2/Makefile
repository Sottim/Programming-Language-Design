LEX = flex
CC = gcc
EXECUTABLE = 9_A2.exe
TESTFILE = 9_A2.nc

all: $(EXECUTABLE) test

$(EXECUTABLE): 9_A2.yy.c
	$(CC) -o $(EXECUTABLE) 9_A2.yy.c 9_A2.c

9_A2.yy.c: 9_A2.l
	$(LEX) -o 9_A2.yy.c 9_A2.l

test: $(EXECUTABLE)
	./$(EXECUTABLE) < $(TESTFILE)

clean:
	rm -f 9_A2.yy.c $(EXECUTABLE)
