#ifndef X10AUX_STRING_UTILS_H
#define X10AUX_STRING_UTILS_H

#include <x10aux/config.h>
#include <x10aux/ref.h>

namespace x10 {
    namespace lang {
        template<class T> class Rail;
        template<class T> class ValRail;
        class String;
    }
}

namespace x10aux {

    extern ref<x10::lang::String> nullString;

    x10::lang::Rail<ref<x10::lang::String> > *convert_args(int ac, char **av);

    void free_args(ref<x10::lang::Rail<ref<x10::lang::String> > > arr);

    template<class T> bool is_null(ref<T> v) { return v.isNull(); }
    template<class T> bool is_null(T v) { return false; }

    template<class T> ref<x10::lang::String> safe_to_string(T v) {
        if (is_null(v)) return nullString;
        return to_string(v);
    }

    // Used by x10/util/StringBuilder.x10
    ref<x10::lang::String> vrc_to_string(x10aux::ref<x10::lang::ValRail<x10_char> > v);
}

    

#endif
// vim:tabstop=4:shiftwidth=4:expandtab