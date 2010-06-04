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

package x10.array;

/**
 * This class represents a memory layout for a local chunk of a
 * distributed array. Its purpose is to define the mapping from points
 * in the array over which the region is defined to the offset in raw
 * memory for the local chunk of the array.
 *
 * This class is decoupled from the Region class because we may wish
 * to support different memory layouts for the same Region. For
 * example, for non-rectangular regions the user may wish to select
 * between a rectangular layout (which has efficient access but wastes
 * storage) or a non-rectangular layout (which makes the opposite
 * tradeoff).
 *
 * @author bdlucas
 */

abstract class Layout {

    abstract global def size(): int;

    abstract global def offset(pt: Point): int;
    abstract global def offset(i0: int): int;
    abstract global def offset(i0: int, i1: int): int;
    abstract global def offset(i0: int, i1: int, i2: int): int;
    abstract global def offset(i0: int, i1: int, i2: int, i3: int): int;

    /*
      doesn't work (for now? for good?) - use constructor instead
    static def make(min: Rail[int], max: Rail[int]): Layout {
        return new RectLayout(min, max);
    }
    */
}

