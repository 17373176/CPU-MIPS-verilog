//此程序为个人作品，无抄袭，无转载
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int a[8][8];
int vis[8]={0};//标记数组
int flag=0;
int n, m;
void dfs(int i,int j){
    if(j==1){
        int k=0;//记录访问个数
        for(j=2; j<=n;j++)
            if(vis[j]==1) k++;
        if(k==n-1) flag=1;
    }else{
        vis[j]=1;//访问标记
        int q;
        for(q=1; q<=n;q++)
            if(a[j][q]!=0&&vis[q]==0){//与顶点j存在边
                dfs(j,q);
                vis[q]=0;//标记清零
            }
    }
    return;
}
int main(){
    scanf("%d%d", &n, &m);
    int i,j;//i代表边数
    for(i=1; i<=m; i++){
        int u,v;
        scanf("%d%d",&u, &v);
        a[u][v]=1;
        a[v][u]=1;
    }
    if(n==1 && m>=1) flag=1;//是,第一种条件，1个顶点存在自环
    else if(n==2 && m>=2) flag=1;
    else if(n!=2){
        //从顶点1开始
        for(j=1; j<=n;j++)
            if(a[1][j]!=0&&vis[j]==0){//与顶点1存在边
                dfs(1,j);
                vis[j]=0;
                if(flag==1) break;//直接跳转输出
            }
    }
    //直接跳转输出
    if(flag) printf("1");
    else printf("0");
    return 0;
}
