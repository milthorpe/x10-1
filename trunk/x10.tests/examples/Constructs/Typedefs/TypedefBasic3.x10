// (C) Copyright IBM Corporation 2006
// This file is part of X10 Test. *

import harness.x10Test;

/**
 * Basic typdefs and type equivalence.
 *
 * @author bdlucas 9/2008
 */

public class TypedefBasic1 extends TypedefTest {

    public def run(): boolean = {
        
        type T1 = ()=>String;
        type T2 = ()=>String;

        var t0:()=>String = ()=>"0";
        var t1:T1 = ()=>"1";
        var t2:T2 = ()=>"2";

        t0 = t1;
        t1 = t2;
        t2 = t0;

        check("t0()", t0(), "1");
        check("t1()", t1(), "2");
        check("t2()", t2(), "1");

        return result;
    }

    public static def main(var args: Rail[String]): void = {
        new TypedefBasic1().execute();
    }
}
