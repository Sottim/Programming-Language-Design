int add(int a, int b) {
    return a + b;
}

int main() {
    int i;
    int x = 10;
    int y = 20;
    char ch = 'A';
    int result;

    if (x < y) {
        result = add(x, y);
        printf("Result: %d\n", result);
    } else {
        printf("x is not less than y\n");
    }

    for (i = 0; i < 5; i= i+1) {
        printf("i: %d\n", i);
    }

    return 0;
}
