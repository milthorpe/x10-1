#ifndef X10_LANG_REF_H
#define X10_LANG_REF_H

#include <x10aux/config.h>
#include <x10aux/ref.h>
#include <x10aux/RTT.h>

#include <x10/lang/Object.h>

namespace x10 {
    namespace runtime {
        class Lock;
    }
    
    namespace lang {

        class String;

        class Ref : public virtual Object {
        public:
            class RTT : public x10aux::RuntimeType { 
                public:
                static RTT* const it; 
            
                virtual void init() {
                    initParents(1,x10aux::getRTT<Object>());
                }
                
                virtual std::string name() const {
                    return "x10.lang.Ref";
                }

            };
#ifdef X10_USE_BDWGC
            /* References that have been shipped to remote Places,
             * and therefore must be treated as roots for local GCs
             */
            class ReferenceLogger {
                Ref*** escapedReferences;
                int nextSlot;
            public:
                ReferenceLogger();
                void log(x10aux::ref<Ref> x);
                x10aux::ref<x10::runtime::Lock> lock;
            };

            static ReferenceLogger* refLogger;
#endif
            
            virtual const x10aux::RuntimeType *_type() const {
                return x10aux::getRTT<Ref>();
            }

            static x10aux::ref<Ref> _make() {
                return (new (x10aux::alloc<Ref>()) Ref())->_constructor();
            }

            x10aux::ref<Ref> _constructor() { return this; }

            static const x10aux::serialization_id_t serialization_id;

            static void _serialize(x10aux::ref<Ref> this_,
                                   x10aux::serialization_buffer &buf,
                                   x10aux::addr_map &m)
            {

#ifdef X10_USE_BDWGC
                refLogger->log(this_);
#endif                
                // don't send an id, just serialise the ref (null/local/remote -- we don't care)
                buf.write(x10_ref_serialize(reinterpret_cast<x10_addr_t>(this_.get())),m);
            }

            virtual void _serialize_id(x10aux::serialization_buffer &buf, x10aux::addr_map &m) {
                buf.write(serialization_id,m);
            };

            virtual void _serialize_body(x10aux::serialization_buffer &buf, x10aux::addr_map &m) {
                _S_("Serialising a local Ref object of type "<<_type()->name());
                buf.write(x10_ref_serialize((x10_addr_t)this),m);
            };

            template<class T> static x10aux::ref<T> _deserialize(x10aux::serialization_buffer &buf){
                x10_addr_t flagged = x10_ref_deserialize(buf.read<x10_remote_ref_t>());
                if (x10_ref_get_addr(flagged) == NULL) return x10aux::null;
                return (T*)flagged;
            }

            template<class T> friend class x10aux::ref;

            virtual x10_int hashCode();

            virtual x10aux::ref<String> toString();

            virtual bool equals(x10aux::ref<Object> other) {
                if (other==x10aux::ref<Ref>(this)) return true;
                return false;
            }

        };

    }
}


#endif
// vim:tabstop=4:shiftwidth=4:expandtab
