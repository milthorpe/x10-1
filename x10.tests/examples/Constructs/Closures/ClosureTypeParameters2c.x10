// (C) Copyright IBM Corporation 2006
// This file is part of X10 Test. *

import harness.x10Test;


/**
 * Type parameters may be constrained by a where clause on the
 * declaration (�4.3,�9.5,�9.7,�12.5).
 */

public class ClosureTypeParameters2c extends ClosureTest {

    class V           {const name = "V";};
    class W extends V {const name = "W";}
    class X extends V {const name = "X";};
    class Y extends X {const name = "Y";};
    class Z extends X {const name = "Z";};

    public def run(): boolean = {
        
        class C[T] {val f = (){T<:Y} => T.name;}
        check("new C[X]().f()", new C[X]().f(), "X");

        return result;
    }

    public static def main(var args: Rail[String]): void = {
        new ClosureTypeParameters2c().execute();
    }
}
