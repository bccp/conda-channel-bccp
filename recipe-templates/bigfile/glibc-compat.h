#ifndef __GLIBC_COMPAT_SYMBOL_H__
#define __GLIBC_COMPAT_SYMBOL_H__ 1

/**
 * add other architecures below
 */
#define GLIBC_COMPAT_SYMBOL(FFF, GGG, VER) \
    __asm__(".symver " #FFF "," #GGG "@GLIBC_" # VER);

#include <math.h>

GLIBC_COMPAT_SYMBOL(memcpy, memcpy, 2.2.5)

#endif /*__GLIBC_COMPAT_SYMBOL_H__*/

