#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct stringt {
    char* val;
    int size;
} stringt;

void strt_make(stringt* strt, char* str){
    /*
    Makes string given stringt pointer and string

    Given:
    - stringt* strt
    - char* str

    Sets strt to stringt(val=str, size=length of str)

    */
    strt->val = str;
    strt->size = strlen(str);
}

void strt_info(stringt strt){
    /*
    Prints contents of stringt

    Given:
    - stringt strt
    */
    printf("string(val=<%s>, size=%d)\n", strt.val, strt.size);
}

void strt_append(stringt* strtA, stringt* strtB){
    /*
    Appends the second stringt pointer to the first

    Given:
    - stringt* strtA, strtB

    Sets strtA to stringt(val=strtA.val+strtB.val, size=strtA.size+strtB.size)
    */


    //update size
    strtA->size = strtA->size+strtB->size;
    
    //malloc and make new string
    char* tmp_val = strtA->val;
    strtA->val = malloc(strtA->size);
    strcpy(strtA->val, tmp_val);
    strcat(strtA->val, strtB->val);
}

void strt_substr(stringt* strtA, stringt* strtB, int start, int end){
    /*
    Gets substring from start to end of the second stringt pointer 
    and sets it to first stringt pointer

    Given:
    - stringt* strtA, strtB
    = int start, end

    Sets strtA to stringt(val=strtB[start:end], size=end-start)

    Sets strtA to empty stringt if start/end is invalid
    */


    //if invalid substr set to empty str
    if(start > end || start < 0 || end < 0 || end > strtB->size){
        strtA->size = 0;
        strtA->val = malloc(0);
        strtA->val = "";
    }
    else{
        //get substr
        char* tmp = strtB->val;
        strtA->size = end-start;
        strtA->val = malloc(strtA->size);
        for(int i = 0; i < strtA->size; i++){
            strtA->val[i] = tmp[start+i];
        }
    }
}

int strt_occurances(stringt strtA, char* str){
    /*
    Finds total occurances of substring str in stringt strtA

    Given:
    - stringt strtA
    - char* str

    Returns # occurances of str in strtA
    */
    if(strlen(str) > strtA.size){
        return 0;
    }
    
    int occs = 0;
    stringt findstr;
    for(int i = 0; i < strtA.size-strlen(str)+1; i++){
        strt_substr(&findstr, &strtA, i, i+strlen(str));
        if(strcmp(findstr.val, str)==0){
            occs++;

        }
    }
    return occs;
}

int strt_indexOf(stringt strtA, char chr){
    /*
    Gets index of first occurance of char in stringt

    Given:
    - stringt strtA
    - char chr

    Returns index of first occ. of chr in strtA, if not found, returns -1
    */
    for(int i = 0; i < strtA.size; i++){
        if(strtA.val[i]==chr){
            return i;
        }
    }
    return -1;
}

int strt_split(stringt** strtlist, stringt strt, char split){
    /*
    Makes a list of stringts, split by char split of the stringt strt.

    Given:
    - stringt** strtlist
    - stringt strt
    - char split

    Ex:

    strt = "Hello world!", char = 'l'

    Sets strtlist to {"He", "o wor", "d!"} in stringt form

    Returns length of strtlist
    */

    //allocate maximum possible size (realloc to index later on)
    int strtlist_len = strt.size;
    int strtlist_index = 0;
    *strtlist = realloc(*strtlist, strtlist_len*sizeof(**strtlist));

    stringt* tmp = *strtlist;

    int split_index = strt_indexOf(strt, split);

    //loop until no more possible splits
    while(split_index!=-1){
        //gets substring from split start to end
        if(split_index!=0){
            strt_substr(&tmp[strtlist_index++], &strt, 0, split_index);
        }
        strt_substr(&strt, &strt, split_index+1, strt.size);
        split_index = strt_indexOf(strt, split);

    }

    //possible leftover
    if(strt.size!=0){
        strt_substr(&tmp[strtlist_index++], &strt, 0, strt.size);
    }

    //realloc to correct size
    *strtlist = realloc(*strtlist, strtlist_index*sizeof(**strtlist));

    return strtlist_index;


}

void strt_filter(stringt* strt, char filter){
    /*
    Removes occurances of char filter from strt

    Given:
    - stringt* strt
    - char filter

    Ex:
    "Test|123|ABC", '|' => "Test123ABC"
    */
    char* tmp = (char*)malloc(strt->size);
    int tmp_indx = 0;

    for(int i = 0; i < strt->size; i++){
        if(strt->val[i]!=filter){
            tmp[tmp_indx++] = strt->val[i];
        }
    }

    tmp = (char *)realloc(tmp, tmp_indx);

    strt_make(strt, tmp);
}

void strt_replace(stringt* strt, char find, char replace){
    /*
    Replaces occurances of char find with char replace in strt

    Given:
    - stringt* strt
    - char find, replace

    Ex:
    "Test|123|ABC", '|', '^' => "Test^123^ABC"
    */
    char tmp[strt->size];
    int tmp_indx = 0;

    for(int i = 0; i < strt->size; i++){
        tmp[tmp_indx++] = (strt->val[i]==find) ? replace : strt->val[i];
    }

    strt_make(strt, tmp);
}

char* strt_uniqueChars(stringt strt){
    char* charlist = (char*)malloc(strt.size);
    int charlist_index = 0;

    charlist[charlist_index++] = strt.val[0];

    while(strt.size>1){
        strt_filter(&strt, strt.val[0]);
        charlist[charlist_index++] = strt.val[0];
    }

    charlist = (char *)realloc(charlist, charlist_index);

    return charlist;
}

void caesar_cipher(stringt* strt, int n){
    /*
    Does caesar cipher on stringt given an n shift
    */
    char* tmp = strt->val;
    char* res = (char*)malloc(strt->size);
    for(int i = 0; i < strt->size; i++){
        res[i] = tmp[i]+n;
    }

    strt_make(strt, res);
}

int main(int argc, char argv[]){
    stringt strA;
    strt_make(&strA, "Hello");


    return 0;
}