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

import harness.x10Test;



/**
 * @author bdlucas 8/2008
 */

public class GenericCast09 extends GenericTest {

    interface I[T] {
        def m(T):int;
    }

    class A implements I[int] {
        public def m(int) = 0;
    }

    public def run() = {

        var a:Object = new A();

        try {
            var i:I[String] = a as I[String]; // ERR: Warning: This is an unsound cast because X10 currently does not perform constraint solving at runtime for generic parameters.
        } catch (ClassCastException) {
            return true;
        }

        return false;
    }

    public static def main(var args: Array[String](1)): void = {
        new GenericCast09().execute();
    }
}
