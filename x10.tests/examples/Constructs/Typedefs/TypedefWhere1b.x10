// (C) Copyright IBM Corporation 2006
// This file is part of X10 Test. *

import harness.x10Test;

/**
 * @author bdlucas 9/2008
 */

public class TypedefWhere1b extends TypedefTest {

    class X           {def name() = "X";}
    class Y extends X {def name() = "Y";}
    class Z extends Y {def name() = "Z";}

    public def run(): boolean = {
        
        type B[T]{T<:Y} = T;
        b:B[Y] = new Y();
        check("b.name()", b.name(), "Y");

        return result;
    }

    public static def main(var args: Rail[String]): void = {
        new TypedefWhere1b().execute();
    }
}
