//此程序为个人作品，无抄袭，无转载
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void print(int flag,int com){
    printf("%d %d\n",flag,com);
}


int main(){
    int year;
    scanf("%d", &year);
    if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        printf("1");//是
    }else {
        printf("0");
    }
    return 0;
}
