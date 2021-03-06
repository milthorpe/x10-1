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

package x10.matrix.util;
import x10.matrix.ElemType;
/**
 * Provides some static math methods.
 */
public class MathTool {
    public static delta:ElemType = (()=>{val x= (ElemType == Double? 0.00000001 as ElemType: 0.001f as ElemType); x})();
    public static delta2:ElemType = (ElemType == Float? 0.00001f as ElemType: 0.00000001 as ElemType);
					 
	/**
	 * Return true if the difference between the two values in ElemType 
	 * is less than delta, otherwise false.
	 */
	public static  def equals(a:ElemType, b:ElemType) = (Math.abs(a-b) < delta);
	public static  def equal(a:ElemType, b:ElemType) = (Math.abs(a-b) < delta);
	
	/**
	 * Return true if the value in ElemType type is less than delta
	 */
	public static  def isZero(a:ElemType)        = (Math.abs(a) < delta);

	/**
	 * Return true if the difference beween 1.0 and the value in ElemType 
	 * type is less than delta.
	 */
	public static  def isOne(a:ElemType)         = (Math.abs(a-1.0) < delta);

	/**
	 * Return an integer value which is no bigger than the square root of the specified integer, and
	 * can is evenly divisble.
	 */
	public static def sqrt(n:Int):Int {
		var rt:Int = Math.sqrt(n) as Int;
		for (; rt > 1n && n%rt != 0n; rt--);
		return rt;
	}
	
	/**
	 * Return an long value which is no bigger than the square root of the specified long, and
	 * can is evenly divisble.
	 */
	public static def sqrt(n:Long):Long {
		var rt:Long = Math.sqrt(n) as Long;
		for (; rt > 1L && n%rt != 0L; rt--);
		return rt;
	}
}
