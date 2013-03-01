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
 * An await statement cannot occur in an atomic.
 * @vj
 */
public class NoAtEachInAtomic extends x10Test {

	var b: boolean;
	
	public def run(): boolean = {
			try { 
		      atomic 
		        ateach (p in 1..10 -> here) 
		           Console.OUT.println("Cannot reach this point.");
			} catch (IllegalOperationException) {
				return true;
			}
		 
		  return false;
	}

	public static def main(Rail[String]) {
		new NoAtEachInAtomic().execute();
	}
}
