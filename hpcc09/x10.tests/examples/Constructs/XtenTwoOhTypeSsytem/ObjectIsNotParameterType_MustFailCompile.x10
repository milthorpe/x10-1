/*
 *
 * (C) Copyright IBM Corporation 2006
 *
 *  This file is part of X10 Test.
 *
 */
import harness.x10Test;

/**
 * A value of an unconstrained type parameter T cannot be assigned to a variable of type Object.
 *
 * @author vj 
 */
public class ObjectIsNotParameterType_MustFailCompile extends x10Test {
	class GenericWrapper[T] {
		  public def testAssign(x:T) {
		    var dummy:Object = null;
		  // bad!!
		    x=dummy;
		  }
		}
	
	public def run()=true;

	public static def main(Rail[String]) {
		new ObjectIsNotParameterType_MustFailCompile().execute();
	}

  
}
