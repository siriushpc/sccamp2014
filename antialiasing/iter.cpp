using namespace std;
#include<bits/stdc++.h>
#define D(x) cout<< #x " = "<<(x)<<endl


int dx[] = {0,0,0,1,1,1,-1,-1,-1};
int dy[] = {-1,0,1,-1,0,1,-1,0,1};
const int MN = 10001;
int mat[MN][MN];
int res[MN][MN];
int a,b;

int main(){
  cin>>a>>b;

  for (int i = 0; i < a; ++i) {
    for (int j = 0; j < b; ++j) {
      cin>>mat[i][j];
      res[i][j] = 0;
    }
  }


clock_t cpu_startTime, cpu_endTime;

double cpu_ElapseTime=0;
cpu_startTime = clock();
  for (int i = 0; i < a; ++i) {
    for (int j = 0; j < b; ++j) {
      int sum = 0;
      int neig = 0;
      for (int k= 0; k < 9; ++k) {
        int x = i + dx[k];
        int y = j + dy[k];
        if (x >= 0 and x < a and y >= 0 and y < b) {
          neig++;
          sum += mat[x][y];
        }
      }
      res[i][j] = sum / neig;
    }
  }

cpu_endTime = clock();

cpu_ElapseTime = ((cpu_endTime - cpu_startTime)/(double)CLOCKS_PER_SEC);

fprintf(stderr,"el tiempo es %.19lf \n",cpu_ElapseTime);

  for (int i = 0; i < a; ++i) {
    for (int j = 0; j < b; ++j) {
      cout<<res[i][j]<<" ";
    }
    cout<<endl;
  }
  return 0;
}
