#include <stdio.h>
#include <time.h>
#include <cuda.h>
#include <curand_kernel.h>
#define CL 2000000LL

// kernel 
__global__ void picuda(double *res, long long W, curandState *states) {
  long long i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < W) {

    double ans = 0; 
    unsigned int seed = (unsigned int) (clock() * i);
    curand_init(seed, 0, 0, states + i);
    for (long long j = 0; j < CL; ++j) {
      //curandState s; // seed a random number generator 
      double x = curand_uniform_double(states + i); 
      double y = curand_uniform_double(states + i); 
      double bound = 1.0;
      ans += ((x*x + y*y) <= bound) ? 1 : 0;
    }
    res[i] = 4.0 * ans / (double) CL;
  }
}


int main(void) {
  double *res_h;           // pointers to host memory
  double *res_d;           // pointer to device memory
  cudaError_t err;
  const long long W = 64048LL;
  size_t size = W*sizeof(double);
  res_h = (double *)malloc(size);


  err = cudaMalloc((void **) &res_d, size); 
  if (err != cudaSuccess)
    fprintf(stderr,"Problemas solicitando memoria para res_d\n");
  
  float blockSize = 1024;
  dim3 dimBlock (ceil(W/blockSize), 1, 1);
  dim3 dimGrid (blockSize, 1, 1);
  curandState *devStates; 
  cudaMalloc( (void **)&devStates, W * sizeof(curandState) );
 
  picuda <<< dimGrid, dimBlock >>> (res_d, W, devStates);

  // Retrieve result from device and store in b_h
  err = cudaMemcpy(res_h, res_d, size, cudaMemcpyDeviceToHost);
  if (err != cudaSuccess)
    fprintf(stderr,"Problemas copiando de device a host\n");

  //print results
  double ans = 0;
  for (long long i = 0; i < W; ++i) {
    ans += res_h[i];
  }

  printf("Pi's value : %.10lf\n",  ans / W);
  // cleanup
  free(res_h);
  cudaFree(res_d);

  return 0;
}
