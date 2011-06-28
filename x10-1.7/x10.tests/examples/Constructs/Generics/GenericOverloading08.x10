// (C) Copyright IBM Corporation 2008
// This file is part of X10 Test. *

import harness.x10Test;

import x10.compiler.ArithmeticOps;

/**
 * Two or more methods of a class or interface may have the same name
 * if they have a different number of type parameters, or they have
 * value parameters of different types.
 *
 * @author bdlucas 8/2008
 */

public class GenericOverloading08 extends GenericTest {

    static def m[T]() = 0;
    static def m[T,U]() = 1;

    public def run(): boolean = {

        check("m[int]()", m[int](), 0);
        check("m[String]()", m[String](), 0);
        check("m[String,int]()", m[String,int](), 1);

        return result;
    }
    public static def main(var args: Rail[String]): void = {
        new GenericOverloading08().execute();
    }
}