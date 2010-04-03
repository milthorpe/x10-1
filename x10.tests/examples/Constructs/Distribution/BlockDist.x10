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

import x10.array.Dist;
import x10.array.Region;

/**
 * Basic distributions
 *
 */
class BlockDist extends TestDist {

    public def run() {
	chk(Place.places.length == 4, "This test must be run with 4 places");

        val r = [1..4, 1..7] as Region;
        pr("r " + r);

        prDist("block 0", Dist.makeBlock(r, 0));
        prDist("block 1", Dist.makeBlock(r, 1));

        return status();
    }

    def expected() =
        "r [1..4,1..7]\n"+
        "--- block 0: Dist(0->[1..1,1..7],1->[2..2,1..7],2->[3..3,1..7],3->[4..4,1..7])\n"+
        "    1  . 0 0 0 0 0 0 0 . . \n"+
        "    2  . 1 1 1 1 1 1 1 . . \n"+
        "    3  . 2 2 2 2 2 2 2 . . \n"+
        "    4  . 3 3 3 3 3 3 3 . . \n"+
        "--- block 1: Dist(0->[1..4,1..2],1->[1..4,3..4],2->[1..4,5..6],3->[1..4,7..7])\n"+
        "    1  . 0 0 1 1 2 2 3 . . \n"+
        "    2  . 0 0 1 1 2 2 3 . . \n"+
        "    3  . 0 0 1 1 2 2 3 . . \n"+
        "    4  . 0 0 1 1 2 2 3 . . \n";
    
    public static def main(var args: Rail[String]) {
        new BlockDist().execute();
    }
}
