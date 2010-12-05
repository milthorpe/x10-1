/* Current test harness gets confused by packages, but it would be in package Vars_Local_not_the_express_plz;
*/

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

// file Vars line 409
 class Tub(p:Int){
   def this(pp:Int):Tub{self.p==pp} {property(pp);}
   def example() {
     val t : Tub = new Tub(3);
   }
 }
 class TubBounded{
 def example() {
   val t <: Tub = new Tub(3);
}}

class Hook {
   def run():Boolean = true;
}


public class Vars_Var_Bounded extends x10Test {
   public def run() : boolean = (new Hook()).run();
   public static def main(var args: Array[String](1)): void = {
        new Vars_Var_Bounded().execute();
    }
}    
