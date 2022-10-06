#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]){
    int i =0 ;
    int line_n = atoi(argv[1]);
    char text1[]="#include<stdio.h>\n\nint main(){\n\tchar c[3]=\"0;\n\t";
    char text2[]="printf(";
    char text3[]=");";
    char text4[]="\n\tprintf(\"\\\"\");\n\treturn 0;\n}\n";
    FILE *fp = NULL;
    fp = fopen("big.c", "w+");
    fprintf(fp,"%s", text1);
    for(i =0 ;i < line_n ;i++){
        fprintf(fp,"%s", text2);
        fprintf(fp,"%d", i);
        fprintf(fp,"%s", text3);
    }
    fprintf(fp,"%s", text4);
    fclose(fp);
    return 0;
}
