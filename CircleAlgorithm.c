#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>
#define MAX_POINTS 16

// What needs to be done:
// Given some data, you need to run an algorithm to iterate through the data and create slices
// Create struct: contains slice number
// Useful numbers: Slices = 0 to 624, Layer = 0 to 4, Point number = 0 to 49,999

// Assumption: Data is given such that you start with one point in the innermost layer
// and from there you go clockwise/anticlockwise till you cover all the points.
// Repeat process for every layer around same location if not in same line

int slicecapacity, slicetracker, layertracker = 0;
int n = 10000;

typedef struct infocache {
    int slice;
    int layer;
    int pointnumber;
    int coordinates;
} ic;

void assign(int input[n]){

    int i, j, temp;
    struct ic mycaches[n];

    //use bubble sort on input array
    for (i = 0; i < n; i++){
      for (j = i + 1; j < n; j++){
         if (input[i] > input[j]){
            a = input[i];
            input[i] = input[j];
            input[j] = a;
         }
      }
   }

    for(i = 0; i < n; i++){
    //reset slice capacity and slice number if needed
    if(slicecapacity >= MAX_POINTS){
        slicecapacity = 0;
        slicetracker++;
    }
    mycaches[i] -> pointnumber = i;
    mycaches[i] -> slice = slicetracker;
    mycaches[i] -> coordinates = input[i]
    slicecapacity++;
    }
    return;
}

int main(int argc, char* argv[]){
    return 0;
}
