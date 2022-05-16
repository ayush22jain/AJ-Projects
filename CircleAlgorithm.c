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

int slicecapacity = 0;

typedef struct infocache {
    int slice;
    int layer;
    int pointnumber;
} ic;

void assign(ic *pointinfo){
    return;
}