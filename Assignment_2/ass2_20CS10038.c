#include "myl.h"
#define BUFF 100
#include <stdio.h>

// Function to print a string stored at *s
int printStr(char *s){
    int bytes = 0;

    // set bytes to number of chars encountered befire
    while(s[bytes] != '\0') bytes++;

    // storing the string s in the array c
    char c[bytes];

    int i = 0;
    while(s[i] != '\0') {
        c[i] = s[i];
        i++;
    }

    // Inline assembly code to call with
    // %rdi = 1
    // %rsi = c
    // %rdx = bytes
    // %eax = 1
    // prints "bytes" number of bytes starting from c
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(c), "d"(bytes)
    );

    // return the number of bytes printed
    return bytes;
}

// Function to store integer read in stdin to n
int readInt(int *n){
    *n = 0;                             // Set n to 0 initially
    int i = 0;
    char buff[1];                       // use buff array to read each byte from stdin
    int mult = 1;                       // sign multiplier
    int is_err = 0;

    while(1){
        // Inline assembly code to call with
        // %rdi = 0
        // %rsi = buff
        // %rdx = 1
        // %eax = 0
        // reads one character from stdin into buff
        __asm__ __volatile__ (
            "movl $0, %%eax \n\t"
            "movq $0, %%rdi \n\t"
            "syscall \n\t"
            :
            :"S"(buff), "d"(1)
        );

        char read = buff[0];

        // if the read character is a whitespace character, stop reading
        if(read == ' ' || read == '\n' || read == '\t') break;
        // if the first character is '-', set sign multiplier to -1
        if(i == 0 && read == '-'){
            mult = -1;
        }
        else{
            // if the read character is not in 0-9 range, set is_err to 1
            if(read < '0' || read > '9') {
                *n = 0;
                is_err = 1;
            }
            else{
                *n = *n * 10 + (int)(read - '0');   // update n after reading
            }
        }
        i++;
    }

    // if there is error, set n to 0 and return ERR
    if(is_err == 1){
        *n = 0;
        return ERR;
    }

    // multiplying by sign bit
    *n = *n * mult;
    return OK;
}

// Function to print an integer n
int printInt(int n){
    char buff[BUFF], zero = '0';                // buff stores the integer as a string
    int i = 0, j = 0, k, bytes;

    // if n is zero, print zero
    if(n == 0) buff[i++] = zero;
    else{
        // if n < 0, set first element to '-' and make n positive
        if(n < 0){
            buff[i++] = '-';
            n = -n;
        }

        // store digits of n in reverse order
        while(n){
            int dig = n%10;
            buff[i++] = (char)(zero+dig);
            n = n/10;
        }

        if(buff[0] == '-') j = 1;

        k = i - 1;

        // The loop reverses the string buff to get the correct order
        while(j < k){
            char temp = buff[j];
            buff[j++] = buff[k];
            buff[k--] = temp;
        }
    }

    buff[i] = '\n';

    bytes = i+1;

    // Inline assembly code to call with
    // %rdi = 1
    // %rsi = buff
    // %rdx = bytes
    // %eax = 1
    // prints "bytes" number of bytes starting from buff
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(bytes)
    );

    return bytes;
}

// Function to read float 
int readFlt(float *f){
    *f = 0;                 
    int i = 0;
    int j = 0;
    char buff[1], str[BUFF];
    int mult = 1;
    int count = 0;
    int start = 0;
    char read;
    int is_err = 0;
    int dot_occur = 0;

    while(1){

        // Inline assembly code to call with
        // %rdi = 0
        // %rsi = buff
        // %rdx = 1
        // %eax = 0
        // reads one character from stdin into buff
        __asm__ __volatile__ (
            "movl $0, %%eax \n\t"
            "movq $0, %%rdi \n\t"
            "syscall \n\t"
            :
            :"S"(buff), "d"(1)
        );

        read = buff[0];

        // if the read character is a whitespace character break the loop
        if(read == ' ' || read == '\n' || read == '\t') break;
        // if first character is '-', set sign multiplier to -1
        if(i == 0 && read == '-'){
            mult = -1;
            j = 1;
        }
        else{
            str[i] = read;
        }

        // Counting number of places after '.'
        if(start){
            count++;
        }

        if(read == '.'){
            dot_occur++;
            start = 1;
        }

        i++;

        // if read is not any of the accepted chars or the dot occurs more than once, set is_err to 1
        if(read != '.' && (read < '0' || read > '9') && read != '-' && read != ' ' && read != '\n' && read != '\t'){
            *f = 0;
            is_err = 1;
        }
        if(dot_occur == 2 && read == '.'){
            *f = 0;
            is_err = 1;
        }

    }

    // if there are digits after '.' or '.' is the last read character
    if(count != 0 || read == '.'){
        // Integer part loop
        while(j < i-count-1){
            *f = *f * 10 + (str[j]-'0');
            j++;
        }

        j++;

        // float part loop, add str[j]/10^(j-c)
        float mul = 0.1;

        while(j < i){
            *f += mul * (str[j]-'0');
            mul = mul/10;
            j++;
        }
    }
    // if the given input doesn't have a '.'
    else{
        // We write only the integer part loop
        while(j < i){
            *f = *f * 10 + (str[j]-'0');
            j++;
        }
    }

    // if there is an error, set f to 0 and return ERR
    if(is_err == 1){
        *f = 0;
        return ERR;
    }

    *f = *f * mult;

    return OK;
}

// Function to print a float f
int printFlt(float f){
    char buff[BUFF], zero = '0';
    int i = 0, j = 0, k, bytes;
    int num_decs = 0;

    // if f is zero, set buff to "0.0"
    if(f == 0){
        buff[i++] = zero;
        buff[i++] = '.';
        buff[i++] = zero;
    }
    else{
        // if f < 0, set first char in buff to '-' and f to -f
        if(f < 0){
            buff[i++] = '-';
            f = -f;
        }

        // while f != (int)f, multiply x by 10 
        while(f-(int)f != 0){
            num_decs++;
            f = f*10;
        }

        // set n as the integer part of f
        int n = (int)f;

        // while n is positive, add the one's digit of n to buff
        // if j == num_decs, add a '.' character
        while(n){
            if(num_decs == i-1 && buff[0] == '-'){
                buff[i++] = '.';
            }
            if(num_decs == i && buff[0] != '-'){
                buff[i++] = '.';
            }
            int dig = n%10;
            buff[i++] = (char)(zero+dig);
            n = n/10;
        }

        if(buff[0] == '-') j = 1;

        k = i - 1;

        // Loop to reverse the buff string
        while(j < k){
            char temp = buff[j];
            buff[j++] = buff[k];
            buff[k--] = temp;
        }

        // if there is no decimal part, add zero 
        if(num_decs == 0){
            buff[i++] = zero;
        }
    }

    buff[i] = '\n';

    bytes = i+1;

    // Inline assembly code to call with
    // %rdi = 1
    // %rsi = buff
    // %rdx = bytes
    // %eax = 1
    // prints "bytes" number of bytes starting from buff
    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(bytes)
    );

    return bytes;
}