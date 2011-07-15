/*
 *  This file is part of the X10 project (http://x10-lang.org).
 *
 *  This file is licensed to You under the Eclipse Public License (EPL);
 *  You may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *      http://www.opensource.org/licenses/eclipse-1.0.php
 *
 *  (C) Copyright IBM Corporation 2006-2010.
 */

#ifndef X10_LANG_REFERENCE_H
#define X10_LANG_REFERENCE_H

#include <x10aux/config.h>
#include <x10aux/ref.h>
#include <x10aux/RTT.h>
#include <x10aux/itables.h>

#include <x10aux/serialization.h>
#include <x10aux/deserialization_dispatcher.h>

namespace x10 {

    namespace lang {

        class String;
        class Any;
        class Object;
        
        /**
         * This is a class that exists only at the C++ implementation level,
         * not at the X10 language level.  Therefore it does not have an
         * associated RTT.
         * 
         * The purpose of this class is to provide a common C++ level superclass
         * for Object (X10 local objects), Closure (function objects created from X10 closure literals),
         * and IBox<T> (X10 structs of type T that have been boxed because they were upcast to an interface type).
         * The single common superclass is needed because pointers to instances of any of its subclasses could
         * appear in variables of interface type and we need a common C++ level
         * ancestor class so that virtual dispatch will work.
         */
        class Reference {
        public:
            Reference(){ }
//            virtual ~Reference() { }
            
            /*********************************************************************************
             * Implementation-level object model functions assumed to be defined for all types
             *********************************************************************************/
            virtual x10aux::itable_entry* _getITables() = 0;

            virtual const x10aux::RuntimeType *_type() const = 0;


            /*********************************************************************************
             * X10-level functions assumed to be defined for all types
             *********************************************************************************/
            virtual x10_boolean equals(x10aux::ref<Any> other) {
                return this->_struct_equals(x10aux::ref<Reference>(other));
            }

            virtual x10_boolean _struct_equals(x10aux::ref<Reference> other) {
                return other == x10aux::ref<Reference>(this);
            }
            
            virtual x10_int hashCode() = 0;

            virtual x10aux::ref<String> toString() = 0;
            
            /*********************************************************************************
             * Serialization/Deserialization functions assumed to be defined for all types
             *********************************************************************************/
            virtual x10aux::serialization_id_t _get_serialization_id() = 0;
            virtual void _serialize_body(x10aux::serialization_buffer &) = 0;
        };

        /**
         * This is a class that exists only at the C++ implementation level,
         * not at the X10 language level.  It's only real purpose is to
         * provide a C++ level type for X10_NULL and therefore permit
         * a unique RTT object to be associated with the X10 value null.
         */
        class NullType : public Reference {
          public:
            RTT_H_DECLS_CLASS;
        };
    }
}

#endif
// vim:tabstop=4:shiftwidth=4:expandtab:textwidth=100