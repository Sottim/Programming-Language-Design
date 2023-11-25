int max(int a, int b);
int min(int a, int b);
int add(int a, int b);
int subtract(int a, int b);
int multiply(int x, int y);
int divide(int x, int y);

int max(int a, int b){
    if(a > b) return a;
    return b;
}

int min(int a, int b){
    if(a > b) return b;
    return a;
}

int add(int a, int b){
    return (a+b);
}
int subtract(int a, int b){
    return a-b;
}

int multiply(int x, int y){
   int res = 0;
   int i = 0;
   for(i = 0; i < y; i = i + 1){
        res = add(res,x);
    }
    return res;
}

int divide(int x, int y){
    int a = max(x,y);
    int b = min(x,y);
    int res = 0;
    int i = 0;
    for(i = a; i > 0; i = i - b){
        res = res + 1;
    }
    return res;
}

int main() {
int x = 2;
int y = 3;
int z = 1;
int d = x*y/z;
int f = y - 2 - x%3 + 29;
int e = -2;
z  = add(x,y);
d = d + multiply(f,-e);
e = divide(x+y,x-subtract(x,y));
return 0;
}