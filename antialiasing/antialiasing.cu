#include <stdio.h>
#include <time.h>
#include <cuda.h>

// kernel 
__global__ void antialiasingDevice(int *mat, int a, int b,int *res)
{
  
  int sum = 0;
  int neig = 0;
  
  int j = blockIdx.x*blockDim.x + threadIdx.x;
  int i = blockIdx.y*blockDim.y + threadIdx.y;

  if((i < a) && (j < b)){
    for (int dx = -1; dx < 2; ++dx) 
      for (int dy = -1 ; dy < 2; ++dy) {
        int ni = i + dx;
        int nj = j + dy;
        if ((ni >= 0) && (ni < a) && (nj >= 0) && (nj < b)) {
          neig++;
          sum += mat[ni * b + nj];
        }
      }
    res[i * b + j] = sum / neig;
  }
}


int main(void)
{
  int *mat_h, *res_h;           // pointers to host memory
  int *mat_d, *res_d;                 // pointer to device memory
  cudaError_t err;

  int a,b;
  scanf("%d %d", &a, &b);
  //cudaSetDevice(1);  
  // allocate arrays on host
  size_t size = a*b*sizeof(int);
  mat_h = (int *)malloc(size);
  res_h = (int *)malloc(size);
    
  for (int i = 0; i < a; ++i) {
  	for (int j = 0; j < b; ++j) {
  		scanf("%d", mat_h + (i * b + j));
  	}
  }

  // allocate array on device 
  err = cudaMalloc((void **) &mat_d, size);
  if (err != cudaSuccess)
    fprintf(stderr,"Problemas solicitando memoria para mat_d\n");
  err = cudaMalloc((void **) &res_d, size); 
  if (err != cudaSuccess)
    fprintf(stderr,"Problemas solicitando memoria para res_d\n");
  
  // copy data from host to device
  err = cudaMemcpy(mat_d, mat_h, size, cudaMemcpyHostToDevice); 
  if (err != cudaSuccess)
    fprintf(stderr,"Problemas copiando memoria a device mat_d mat_h\n");

  float blockSize = 1024;
  dim3 dimBlock (ceil(b/blockSize), ceil(a/blockSize),1);
  dim3 dimGrid (blockSize, blockSize,1);
 
  float elapsed=0;
  cudaEvent_t start, stop;

  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start, 0);

  antialiasingDevice <<< dimGrid, dimBlock >>> (mat_d, a, b, res_d);
  //cudaDeviceSynchronize();  

  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);

  cudaEventElapsedTime(&elapsed, start, stop);

  cudaEventDestroy(start);
  cudaEventDestroy(stop);
  fprintf(stderr,"The elapsed time in gpu was %.8f ms\n", elapsed);

  // Retrieve result from device and store in b_h
  err = cudaMemcpy(res_h, res_d, size, cudaMemcpyDeviceToHost);
  if (err != cudaSuccess)
    fprintf(stderr,"Problemas copiando de device a host\n");

  //print results
  for (int i = 0; i < a; ++i) {
    for (int j = 0; j < b; ++j) {
    printf("%d ", res_h[i*b + j]);
    }
    printf("\n");
    }

  // cleanup
  free(mat_h); free(res_h); cudaFree(res_d); cudaFree(mat_d);
 
}
