//此程序为个人作品，无抄袭，无转载
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


int main(){
    int n,m;
    scanf("%d%d", &n, &m);
    int a[50][50];//每个元素占一个字
    int i, j;
    for(i = 1; i<=n; i++)
        for(j=1; j<=m; j++)
            scanf("%d", &a[i][j]);//输入矩阵
    for(i = n; i>0; i--){
        for(j=m; j>0; j--){
            if(a[i][j]!=0) printf("%d %d %d\n", i, j, a[i][j]);
        }
    }
    return 0;
}
