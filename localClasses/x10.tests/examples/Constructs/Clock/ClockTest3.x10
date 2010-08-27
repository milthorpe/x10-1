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
 * Clock test for barrier functions.
 * @author kemal 3/2005
 */
public class ClockTest3 extends x10Test {

	var val: int = 0;
	const N: int = 32;

	public def run(): boolean = {
		val c: Clock = Clock.make();

		foreach (val (i): Point in 0..(N-1)) clocked(c) {
			async(here) clocked(c) 
			   finish async(here) { 
			       async(here) { 
			          atomic val++; 
			       } 
			   }
			next;
			var temp: int;
			atomic { temp = val; }
			if (temp != N) {
				throw new Error();
			}
			next;
			async(here) clocked(c) finish async(here) { async(here) { atomic val++; } }
			next;
		}
		next; next; next;
		var temp2: int;
		atomic { temp2 = val; }
		if (temp2 != 2*N) {
			throw new Error();
		}
		return true;
	}

	public static def main(var args: Rail[String]): void = {
		new ClockTest3().executeAsync();
	}
}
