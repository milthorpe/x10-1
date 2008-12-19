// (C) Copyright IBM Corporation 2006
// This file is part of X10 Test.

/**
 * @author bdlucas
 */

public class SeqMatMultAdd1b extends Benchmark {

    val N = 55*5;
    def expected() = -6.78452e+06;
    def operations() = N*N*N to double;

    //
    //
    //

    val r = [0..N-1,0..N-1] to Region;
    val a = Array.make[double](r, (p:Point)=>p(0)*p(1)/(N to double));
    val b = Array.make[double](r, (p:Point)=>p(0)-p(1) to double);
    val c = Array.make[double](r, (p:Point)=>p(0)+p(1) to double);

    def once() {
        for ((i,j,k):Point in r*(0..N-1))
            a(i,j) += b(i,k)*c(k,j);
        return a(20,20);
    }


    //
    //
    //

    public static def main(Rail[String]) {
        new SeqMatMultAdd1b().execute();
    }
}
