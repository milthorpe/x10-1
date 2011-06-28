#ifndef X10AUX_MATH_UTILS_H
#define X10AUX_MATH_UTILS_H

#include <x10aux/config.h>

#include <math.h>

namespace x10aux {
    class math_utils {
    public:
        static inline x10_double pow(x10_double x, x10_double y) { return ::pow(x,y); }
        static inline x10_double exp(x10_double x) { return ::exp(x); }
        static inline x10_double expm1(x10_double x) { return ::expm1(x); }
        static inline x10_double cos(x10_double x) { return ::cos(x); }
        static inline x10_double sin(x10_double x) { return ::sin(x); }
        static inline x10_double tan(x10_double x) { return ::tan(x); }
        static inline x10_double acos(x10_double x) { return ::acos(x); }
        static inline x10_double asin(x10_double x) { return ::asin(x); }
        static inline x10_double atan(x10_double x) { return ::atan(x); }
        static inline x10_double atan2(x10_double x, x10_double y) { return ::atan2(x, y); }
        static inline x10_double cosh(x10_double x) { return ::cosh(x); }
        static inline x10_double sinh(x10_double x) { return ::sinh(x); }
        static inline x10_double tanh(x10_double x) { return ::tanh(x); }
        static inline x10_double log(x10_double x) { return ::log(x); }
        static inline x10_double log10(x10_double x) { return ::log10(x); }
        static inline x10_double log1p(x10_double x) { return ::log1p(x); }
        static inline x10_double sqrt(x10_double x) { return ::sqrt(x); }
        static inline x10_double cbrt(x10_double x) { return ::cbrt(x); }
        static inline x10_double hypot(x10_double x, x10_double y) { return ::hypot(x, y); }
        static inline x10_double ceil(x10_double x) { return ::ceil(x); }
        static inline x10_double floor(x10_double x) { return ::floor(x); }
        static inline x10_double round(x10_double x) { return ::round(x); }
    };
}

#endif
// vim:tabstop=4:shiftwidth=4:expandtab