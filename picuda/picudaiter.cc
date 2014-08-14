using namespace std;
#include<bits/stdc++.h>

const int W = 1000000;
int main() {

  random_device rd;
  mt19937 gen(rd());
  uniform_real_distribution<> dis();
  int count = 0;
  for (int i = 0; i < W; ++i) {
    double x = dis(gen);
    double y = dis(gen);
    if (x*x + y*y <= 1.0) {
      count++;
    }
  }
  double prob = count / (double) W; 
  printf("%.10lf\n", 4.0 * prob);
  return 0;
}
