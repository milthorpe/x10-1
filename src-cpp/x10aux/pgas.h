#ifndef X10AUX_PGAS_H
#define X10AUX_PGAS_H

#include <x10aux/config.h>

#include <x10/x10.h> //pgas

// Has to be first (aside from config.h which is inert and pgas itself)

namespace x10aux {

    class PGASInitializer {
        static int count;
    public:
        PGASInitializer() {
            if (count++ == 0) {
                x10_init();
                _X_("PGAS initialization complete");
            }
        }

        ~PGASInitializer() {
            if (--count == 0) {
                x10_finalize();
                _X_("PGAS shutdown complete");
            }
        }

    };
}



#include <x10aux/ref.h>

namespace x10 { namespace lang { class VoidFun_0_0; } }


namespace x10aux {

    //inline x10_int here() { return (x10_int) x10_here(); }

    template<class T> inline x10_int location(T* p) {
        return (x10_int) x10_ref_get_loc((x10_addr_t)p);
    }

    template<class T> inline x10_int location(ref<T> r) {
        return (x10_int) x10_ref_get_loc((x10_addr_t)r.get());
    }

    void run_at(x10_int place, ref<x10::lang::VoidFun_0_0> body);
}

namespace {
    static x10aux::PGASInitializer pgas_initializer;
}


#endif
// vim:tabstop=4:shiftwidth=4:expandtab
