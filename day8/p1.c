#include <stdlib.h>
#include <stdio.h>

#define N 10000

int main(void) {

    char buf[N];
    size_t size = fread(buf, 1, N, stdin);
    buf[size] = '\0';

    int j_len = 0;
    for (int i = 0;; i++) 
        if (buf[i] == '\n') {j_len = i; break;}
    int i_len = 0;
    for (int i = 0;; i++) 
        if (buf[i] == '\0') {i_len = (i+1)/(j_len+1); break;}
    printf("j_len: %d, i_len: %d\n", j_len, i_len);

    #define JPOS(a) ((a) % (j_len+1))
    #define IPOS(a) ((a) / (j_len+1))

    int total_antinodes = 0;
    // antinode position
    for (int i = 0; i < size; ++i){
        int is_antinode = 0;
        // iterate through all, to see if two nodes have antinode at i,j
        if (buf[i] != '\n')
        for (int w = 0; w < size; ++w) {
            char node = buf[w];
            if (node == '\n' || node == '.') continue;
            for (int ww = w+1; ww < size; ++ww) {
                char nodenode = buf[ww];
                if (node == nodenode) {
                    int idiff = IPOS(ww) - IPOS(w);
                    int jdiff = JPOS(ww) - JPOS(w);

                    int fi = IPOS(w) - idiff;
                    int fj = JPOS(w) - jdiff;
                    if (IPOS(i) == fi && JPOS(i) == fj) is_antinode = 1;

                    int si = IPOS(ww) + idiff;
                    int sj = JPOS(ww) + jdiff;
                    if (IPOS(i) == si && JPOS(i) == sj) is_antinode = 1;
                }
            }
        }
        if (is_antinode) ++total_antinodes, printf("#");
        else printf("%c", buf[i]);
       
    }
    printf("\ntotal p1: %d\n", total_antinodes);

    total_antinodes = 0;
    // antinode position
    for (int i = 0; i < size; ++i){
        int is_antinode = 0;
        // iterate through all, to see if two nodes have antinode at i,j
        if (buf[i] != '\n')
        for (int w = 0; w < size; ++w) {
            char node = buf[w];
            if (node == '\n' || node == '.') continue;
            for (int ww = w+1; ww < size; ++ww) {
                char nodenode = buf[ww];
                if (node == nodenode) {
                    int idiff = IPOS(ww) - IPOS(w);
                    int jdiff = JPOS(ww) - JPOS(w);

                    for (int rep = -100; rep <= 100; rep++) {
                        int fi = IPOS(w) + rep*idiff;
                        int fj = JPOS(w) + rep*jdiff;
                        if (IPOS(i) == fi && JPOS(i) == fj) is_antinode = 1;
                    }
                }
            }
        }
        if (is_antinode) ++total_antinodes, printf("#");
        else printf("%c", buf[i]);
       
    }
    printf("\ntotal p2: %d\n", total_antinodes);
}