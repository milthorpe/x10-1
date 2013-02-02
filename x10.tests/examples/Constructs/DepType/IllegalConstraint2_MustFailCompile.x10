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
* Checking that the type-checker can correctly handle boolean expressions as the values
* boolean properties.

 */

public class IllegalConstraint2_MustFailCompile  extends x10Test {
    class D(c:C){}
    static type D(c:C) = D{self.c.a==c.a};
	class C(a:boolean) {
		static type C(b:boolean) = C{self.a==b};
		def n(x:C, y:C) {
			val z1: D(new C(x.a&&y.a)) // ERR
			  = new D(new C(x.a&&y.a)); 
		}
	}
    public def run() = true;

    public static def main(Array[String](1))  {
        new IllegalConstraint2_MustFailCompile().execute();
    }
}
