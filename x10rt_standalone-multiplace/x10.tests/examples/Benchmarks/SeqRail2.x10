// (C) Copyright IBM Corporation 2006
// This file is part of X10 Test.

/**
 * Basic rail performance test. Allocate a rail, assign values to each
 * element, read it back.
 *
 * Test is written to simulate treating the rail as a 2-d array in
 * order to facilitate comparisons with array performance tests
 * SeqPseudoArray2*.* and SeqArray2*.*.
 *
 * The following tests all do essentially the same work and so ideally
 * should deliver the same performance: SeqRail2.*,
 * SeqPseudoArray2*.*, SeqArray2*.*.
 *
 * @author bdlucas
 */

public class SeqRail2 extends Benchmark {

    //
    // parameters
    //

    val N = 2000;
    def expected() = 1.0*N*N*(N-1);
    def operations() = 2.0*N*N;


    //
    // the benchmark
    //

    val a = Rail.make[double](N*N);

    def once() {
        for (var i:int=0; i<N; i++)
            for (var j:int=0; j<N; j++)
                a(i*N+j) = (i+j) as double;
        var sum:double = 0.0;
        for (var i:int=0; i<N; i++)
            for (var j:int=0; j<N; j++)
                sum += a(i*N+j);
        return sum;
    }

    //
    // boilerplate
    //

    public static def main(Rail[String]) {
        new SeqRail2().execute();
    }
}