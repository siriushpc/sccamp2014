
/**
 *
 * @author Pedro Velho (SC-Camp 2014)
 * @date 12/08/2014
 * 
 * This is a simple program to generate input files for the sencond
 * challange. To be an interesting problem the best is to have hugh files. 
 * However, to test the program is possible to use smaller problems.
 *
 * EXAMPLES:
 *
 * To generate a random file with 200x200 pixels
 *
 *  $ ./generate 200 200 test1.input
 *
 * To generate a random file with 3x3 pixels
 *
 *  $ ./generate 3 3 test2.input
 *
 */
#include<stdio.h>
#include<stdlib.h>

int main(int argc, char **argv){
  FILE *output;
  unsigned int width, height;
  unsigned int i, j;

  printf("%d\n\n", argc);

  //need at least 3 arguments plus the program name, if have a different number of 
  //arguments show the help message and exit.
  if(argc != 4){
    fprintf(stderr, "Usage:\n\t./generate <width> <height> <output_file>\n\n");
    exit(1);
  }
  
  //convert input paramenters width (first) and height (second)
  width = atoi(argv[1]);
  height = atoi(argv[2]);


  //open the file to write if there is a problem abort execution
  output = fopen(argv[3], "w");
  if(output == NULL){
    fprintf(stderr, "Can't open file %200s\n", argv[3]);
    exit(1);
  }

  //to comply with the problem input, put first on the file
  //the width and height info
  fprintf(output, "%d %d\n", width, height); 

  //generate random pixels
  for(i=0; i<width; i++){
    for(j=0; j< height; j++){
      //generate a number between 0 and 255
      fprintf(output, "%d ", rand() % (255 + 1));
    }
    fprintf(output, "\n");
  }

  //close the file
  fclose(output);
}


