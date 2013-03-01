/* Current test harness gets confused by packages, but it would be in package Classes5q6q;
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
 *  (C) Copyright IBM Corporation 2006-2010.
 */

import harness.x10Test;



public class Classes5q6q extends x10Test {
   public def run() : boolean = (new Hook()).run();
   public static def main(var args: Rail[String]): void = {
        new Classes5q6q().execute();
    }


// file Classes line 1292
 static class Ctors {
  public val a : Int;
  def this(a:Int) { this.a = a; }
  def this()      { this(100);  }
}
 static class Hook{ def run() {
 val x = new Ctors(10); assert x.a == 10;
 val y = new Ctors(); assert y.a == 100;
 return true;}}

}
