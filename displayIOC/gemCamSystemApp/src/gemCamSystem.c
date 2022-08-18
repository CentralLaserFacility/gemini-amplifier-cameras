#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <registryFunction.h>
#include <aSubRecord.h>
#include <menuFtype.h>
#include <errlog.h>
#include <epicsExport.h>
#include <sys/types.h>


// getline() not defined for all compilers  
//typedef intptr_t ssize_t;
//ssize_t getline(char **lineptr, size_t *n, FILE *stream);

const int MAX_STRING_LENGTH = 40;

static long _readlist(char filename[], void *destination)
{
    FILE *fp;

    // open file and make sure it's opened properly
    fp = fopen(filename,"r");
    if(NULL == fp) 
    {
        fprintf(stderr,"cannot open file\n");
        return 1;
    }

    // max line size defined
    size_t buffer_size = 80;
    char *line = malloc(buffer_size * sizeof(char));

    // read each line
    int i=0;
    while(-1 != getline(&line, &buffer_size, fp))
    {

        // getting rid of the trailing '\n'
        if ( '\n' == line[strlen(line) - 1])      
            line[strlen(line) - 1] = 0;

        // copy string to destination record
        memcpy((char *)destination+MAX_STRING_LENGTH*i, line, MAX_STRING_LENGTH*sizeof(char));
        i++;
    }

    fclose(fp);
    free(line);

    return 0;
}

static long readlist(aSubRecord *prec)
{
    long e = 0;
    
    e &= _readlist("camera.list", prec->vala);

    return e;
}

epicsRegisterFunction(readlist);



/* getline() not defined for all compilers so here's a version taken from Stack Overflow: 
ssize_t getline(char **lineptr, size_t *n, FILE *stream) {
    size_t pos;
    int c;

    if (lineptr == NULL || stream == NULL || n == NULL) {
        errno = EINVAL;
        return -1;
    }

    c = fgetc(stream);
    if (c == EOF) {
        return -1;
    }

    if (*lineptr == NULL) {
        *lineptr = malloc(128);
        if (*lineptr == NULL) {
            return -1;
        }
        *n = 128;
    }

    pos = 0;
    while(c != EOF) {
        if (pos + 1 >= *n) {
            size_t new_size = *n + (*n >> 2);
            if (new_size < 128) {
                new_size = 128;
            }
            char *new_ptr = realloc(*lineptr, new_size);
            if (new_ptr == NULL) {
                return -1;
            }
            *n = new_size;
            *lineptr = new_ptr;
        }

        ((unsigned char *)(*lineptr))[pos ++] = c;
        if (c == '\n') {
            break;
        }
        c = fgetc(stream);
    }

    (*lineptr)[pos] = '\0';
    return pos;
}
*/
