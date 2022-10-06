#define MAX_N 100

struct symbol {
	char* name;
	char* type;
	int array_n;
	struct symbol *array_index1,*array_index2;
} symbol_table[MAX_N];

struct symbol *symlook();