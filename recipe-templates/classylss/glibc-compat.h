#ifndef __GLIBC_COMPAT_SYMBOL_H__
#define __GLIBC_COMPAT_SYMBOL_H__ 1

/**
 * add other architecures below
 */
#define GLIBC_COMPAT_SYMBOL(FFF, GGG, VER) \
    __asm__(".symver " #FFF "," #GGG "@GLIBC_" # VER);

#include <math.h>

GLIBC_COMPAT_SYMBOL(memcpy, memcpy, 2.2.5)

#define CREATE_COMPAT_FUNC1(name, oldname, version) \
extern double oldname ## _compat (double); \
GLIBC_COMPAT_SYMBOL(oldname ## _compat, oldname, version) \
static inline double name(double a) { return oldname ## _compat (a); }

static int signgam_;
extern double lgamma_r_compat(double, int *);
GLIBC_COMPAT_SYMBOL(lgamma_r_compat, lgamma_r, 2.2.5)
static inline double lgamma_(double a) { return lgamma_r_compat(a, &signgam_); }
#define lgamma lgamma_
#define signgam signgam_

extern double pow_compat(double, double);
GLIBC_COMPAT_SYMBOL(pow_compat, pow, 2.2.5)
static inline double pow_(double a, double b) { return pow_compat(a, b); }
#define pow pow_

CREATE_COMPAT_FUNC1(acosh_, acosh, 2.2.5)
#define acosh acosh_

CREATE_COMPAT_FUNC1(asin_, asin, 2.2.5)
#define asin asin_

CREATE_COMPAT_FUNC1(sinh_, sinh, 2.2.5)
#define sinh sinh_

CREATE_COMPAT_FUNC1(log10_, log10, 2.2.5)
#define log10 log10_

CREATE_COMPAT_FUNC1(cosh_, cosh, 2.2.5)
#define cosh cosh_

CREATE_COMPAT_FUNC1(log_, log, 2.2.5)
#define log log_

CREATE_COMPAT_FUNC1(exp_, exp, 2.2.5)
#define exp exp_

CREATE_COMPAT_FUNC1(atanh_, atanh, 2.2.5)
#define atanh atanh_
#endif /*__GLIBC_COMPAT_SYMBOL_H__*/

