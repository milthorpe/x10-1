/*
 *  This file is part of the X10 project (http://x10-lang.org).
 *
 *  This file is licensed to You under the Eclipse Public License (EPL);
 *  You may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *      http://www.opensource.org/licenses/eclipse-1.0.php
 *
 *  (C) Copyright IBM Corporation 2014.
 */
package x10.util.resilient.iterative;

import x10.util.ArrayList;

public interface LocalViewResilientIterativeApp {
    /** @return true if computation has finished. */
    public def isFinished_local():Boolean;
    
    /**
     * Perform a single step of the computation on a single place
     * and update the finished status as required.
     */
    public def step_local():void;
    

    /**
     * Checkpoint the application state at all places.
     * @param store a resilient store containing an application checkpoint
     */
    public def checkpoint(store:ApplicationSnapshotsStore):void;
    
    /**
     * Restore the application state to the new place group, using the last
     * consistent checkpoint from the resilient store.
     * @param newPlaces the set of places over which to restore
     * @param store a resilient store containing an application checkpoint
     * @param lastCheckpointIter the iteration number of the saved checkpoint
     * @param list of added spare places for restore
     */
    public def restore(newPlaces:PlaceGroup, store:ApplicationSnapshotsStore, lastCheckpointIter:Long, newAddedPlaces:ArrayList[Place]):void;
    
}
