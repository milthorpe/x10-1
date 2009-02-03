#ifndef X10AUX_THROW_H
#define X10AUX_THROW_H

#include <cstdlib>
#include <x10aux/config.h>
#include <x10aux/ref.h>

#include <x10/lang/Throwable.h>

#if defined __GNUC__ && !defined X10_CUDA
// stops the compiler warning about functions that don't return but do throw
#define NORETURN __attribute__ ((noreturn))
#else
#define NORETURN
#endif


namespace x10aux {

    template<class T> void throwException() NORETURN;

    void throwException(x10aux::ref<x10::lang::Throwable> e) NORETURN;

    inline void throwException(x10aux::ref<x10::lang::Throwable> e) {
        throw e->fillInStackTrace();
    }

    template<class T> void throwException() {
        throwException(T::_make());
    }

}

#undef NORETURN

#endif
// vim:tabstop=4:shiftwidth=4:expandtab
