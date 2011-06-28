/**
 * X10 port of sor benchmark from Section 2 of Java Grande Forum Benchmark Suite
 *
 *  PARALLEL VERSION
 *
 * @author Vivek Sarkar (vsarkar@us.ibm.com)
 *
 * Porting issues identified:
 * 1) Replace Java multidimensional arrays by X10 multidimensional arrays, since Java multidimensional arrays
 *    do not currently work in X10.  See following sample output when trying to compile a code w/ a multi-dim array:
 *       sor\JGFSORBench.x10:79: The type of the variable initializer "double[]" does
 *       not match that of the declaration "double[][]".
 *              double [][] A = new double[M][N];
 *                              ^-------------^
 * 2) Add suffix D for all double constants
 * 3) Increased error threshold from 1e-12 to 1e-3
 *    TODO: check the source of error --- is it due to the red-black loop parallelization?
 *    
 * @authro xinb
 * 	o	use the X10 idiom to initialize array.
 */


package sor;
import jgfutil.*; 
import java.util.Random;

public class JGFSORBench extends SOR implements JGFSection2{ 
	
	private int size; 
	private int datasizes[]={1000,1500,2000, 10}; //append reduced size
	//private int datasizes[]={10,1500,2000};
	private static final int JACOBI_NUM_ITER = 100;
	private static final long RANDOM_SEED = 10101010;
	
	Random R = new Random(RANDOM_SEED);
	
	public void JGFsetsize(int size){
		this.size = size;
	}
	
	public void JGFinitialise(){
		
	}
	
	public void JGFkernel(){
		double [.] G =RandomMatrix(datasizes[size], datasizes[size],R);
		
		SORrun(1.25, G, JACOBI_NUM_ITER);
		
	}
	
	public void JGFvalidate(){
		double refval[] = {0.498574406322512D,1.123010681492097D,1.9967774998523777D, 4.5185971433257635E-5D};//append reduced size
		//double refval[] = {4.5185971433257635E-5D,1.123010681492097D,1.9967774998523777D};
		double dev = Math.abs(gtotal.val - refval[size]);
		if (dev > 1.0e-12 ){ 
			System.out.println("Validation failed");
			System.out.println("gtotal = " + gtotal.val + "  " + dev + "  " + size);
			throw new Error("Validation failed");
		}
	}
	
	public void JGFtidyup(){
		System.gc();
	}  
	
	
	
	public void JGFrun(int size){
		
		
		JGFInstrumentor.addTimer("Section2:SOR:Kernel", "Iterations",size);
		
		JGFsetsize(size); 
		JGFinitialise(); 
		JGFkernel(); 
		JGFvalidate(); 
		JGFtidyup(); 
		
		
		JGFInstrumentor.addOpsToTimer("Section2:SOR:Kernel", (double) (JACOBI_NUM_ITER));
		
		JGFInstrumentor.printTimer("Section2:SOR:Kernel"); 
	}
	
	private static double[.] RandomMatrix(final int M, final int N, final java.util.Random R)
	{
		final double[.] t= new double[blockStar([0:M-1],[0:N-1])];
		//XXX cx10: better to aggregate initializtion at each place into one async, except
		//if Random use some machine-specific state, this might not be right.
		for(point [i,j]:t)  
			write(t, i, j, R.nextDouble() * 1e-6);
		return t;
	}
	private static void write(final double[.] t, final int i, final int j, final double v) {
		finish async(t.distribution[i,j]) t[i,j]=v;
	}

	private static dist blockStar(final region r1, final region r2) {
	 	final dist d1=dist.factory.block(r1);	
		return distTimesRegion(d1,r2);
	}

        /**
	 * Takes the cartesian product of a 1D distribution d and
         * 1D region r, retuning a new 2D distribution d*r
         *
	 * Region of (d*r) = [d.region,r] 
         *
         * Point to place mapping of (d*r):
         *
         * For all i, For all j, (d*r)[i,j] = d[i]
         */
	private static dist distTimesRegion(dist d,region r) {
		dist d0=[1:0,1:0]->here;
		for(place p: d.places()) d0=d0 || ([(d|p).region,r]->p);
		return d0;
	}
		
	
	
}