/* Current test harness gets confused by packages, but it would be in package ReTypes7j6c;
*/
// Warning: This file is auto-generated from the TeX source of the language spec.
// If you need it changed, work with the specification writers.


/*
 *  This file is part of the X10 project (http://x10-lang.org).
 *
 *  This file is licensed to You under the Eclipse Public License (EPL);
 *  You may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *      http://www.opensource.org/licenses/eclipse-1.0.php
 *
 *  (C) Copyright IBM Corporation 2006-2016.
 */

import harness.x10Test;



public class ReTypes7j6c extends x10Test {
   public def run() : boolean = (new Hook()).run();
   public static def main(args:Rail[String]):void {
        new ReTypes7j6c().execute();
    }


// file Types line 284
 static  class Example {
 static public def example() {
var gotNPE: Boolean = false;
val p : Point = null;
try {
  val q = p * 2; // method invocation, NPE
}
catch(NullPointerException) {
  gotNPE = true;
}
assert gotNPE;
 } }
 static  class Hook{ def run() {Example.example(); return true;}}

}
