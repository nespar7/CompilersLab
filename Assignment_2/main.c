#include "myl.h"

int main(){
    int n, stop_inp = 1;
    float f;

    printStr("##### Integer Testing ######\n");

    while(stop_inp){
        printStr("\nEnter an integer: ");
        readInt(&n);
        printStr("The Entered integer is: ");
        printInt(n);

        printStr("\nContinue testing?(1 - yes, 0 - no): ");
        readInt(&stop_inp);
    }

    stop_inp = 1;

    printStr("\n##### Floating Point Number Testing ######\n");

    while(stop_inp){
        printStr("\nEnter a floating point number: ");
        readFlt(&f);
        printStr("The Entered float is: ");
        printFlt(f);

        printStr("\nContinue testing?(1 - yes, 0 - no): ");
        readInt(&stop_inp);
    }
}