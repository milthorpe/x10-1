package x10.array.sharedmemory;
import java.util.Iterator;

import junit.framework.TestCase;
import x10.array.ContiguousRange;
import x10.array.Range;
import x10.array.Region_c;
import x10.array.sharedmemory.Distribution_c;
import x10.lang.Activity;
import x10.lang.Runtime;
import x10.lang.point;
import x10.lang.distribution;
import x10.lang.region;
import x10.runtime.DefaultRuntime_c;
import x10.runtime.Place;
import x10.runtime.ThreadRegistry;

/**
 * @author Christian Grothoff, Christoph von Praun
 * @author vj
 */
public class TestDistribution_c extends TestCase {
    
    private final Activity a
    = new Activity() { public void run() {} }; // dummy
    
    /**
     * Junit may use additional threads to run the testcases
     * (other than the main one used to initialize the
     * Runtime class).  Hence we need a litte hack to register
     * the thread used to run the testcase as a 'local' thread
     * with the Runtime.
     */
    public void setUp() {
        DefaultRuntime_c r = (DefaultRuntime_c) Runtime.runtime;
        Place[] pls = Place.places();
        if (r instanceof ThreadRegistry) {
            Thread t = Thread.currentThread();
            ThreadRegistry tr = (ThreadRegistry) r;
            tr.registerThread(t, pls[0]);
            tr.registerActivityStart(t, a, null);
        }
    }
    
    /**
     * Clean-up effects from setUp().
     */
    public void tearDown() {
        DefaultRuntime_c r = (DefaultRuntime_c) Runtime.runtime;
        if (r instanceof ThreadRegistry) {
            Thread t = Thread.currentThread();
            ThreadRegistry tr = (ThreadRegistry) r;
            tr.registerActivityStop(t, a);
        }
    }
    

    
    public void testDistribution_difference() {
        // must be a number that can be blocked on the 
        // given number of processors.
        
        int N = 12;
        boolean assert1, assert2, assert3, assert4, assert5, assert6;
        
        region R1 = region.factory.region(0, N + 1);
        assert1 = R1.size() == N+2;
        System.out.println("assert1 = " + assert1);
        
        region R2 = region.factory.region(1, N);
        assert2 = R2.size() == N;
        System.out.println("assert2 = " + assert2);
        
        region R = region.factory.region(R1, R1);
        assert3 = R.size() == (N+2) * (N+2);
        System.out.println("assert3 = " + assert3);
        
        region R_inner = region.factory.region(R2, R2);
        assert4 = R_inner.size() == N * N;
        System.out.println("assert4 = " + assert4);
        
        // test might fail for incorrect N.
        distribution D = distribution.factory.block(R);        
        distribution D_inner = D.restriction(R_inner);
        assert5 = D_inner.region.size() == N * N;
        System.out.println("assert5 = " + assert5);
        
        distribution D_Boundary = D.difference(D_inner.region);
        assert6 = D_Boundary.region.size() == ((N+2) * (N+2)) - (N*N);
        System.out.println("assert6 = " + assert6);
        
        assertTrue(assert1 && assert2 && assert3 && assert4 && assert5 && assert6);
    }
}