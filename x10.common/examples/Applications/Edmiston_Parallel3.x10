/** 
 * Parallel version of Edmiston's algorithm for Sequence Alignment.
 * This code is an X10 port of the Edmiston_Sequential.c program written by 
 * Sirisha Muppavarapu (sirisham@cs.unm.edu), U. New Mexico.
 *
 * @author Vivek Sarkar   (vsarkar@us.ibm.com)
 * @author Kemal Ebcioglu (kemal@us.ibm.com)
 * 
 * This version has more OO organization. 
 */


import java.util.Random;

/**
 * Single assignment synchronization buffer,
 * like an i-structure in a data flow machine.
 * All readers will wait until write occurs.
 */
class istructInt {
    int val;
    boolean filled=false;
    int rd() {
	int t;
        when(filled) {t=val;}
	return t;
    }
    atomic void wr(int v) {
        if (filled) throw new Error();
        filled=true;
        val=v;
    }
}

public class Edmiston_Parallel3 {
    const int N = 10;
    const int M = 10;

    /**
     * main run method
     */
    public boolean run() {
	charStr c1= new charStr(N,0);
	charStr c2= new charStr(M,N);
	editDistMatrix m=new editDistMatrix(c1,c2);
	m.pr("Edit distance matrix:");
        m.verify();
	return true;
    }

   /**
    * main method
    */
    public static void main(String[] args) {
        final boxedBoolean b=new boxedBoolean();
        try {
                finish b.val=(new Edmiston_Parallel3()).run();
        } catch (Throwable e) {
                e.printStackTrace();
                b.val=false;
        }
        System.out.println("++++++ "+(b.val?"Test succeeded.":"Test failed."));
        x10.lang.Runtime.setExitCode(b.val?0:1);
    }
    static class boxedBoolean {
        boolean val=false;
    }
}

/**
 * Operations and distributed data structures related to
 * an edit distance matrix
 */
class editDistMatrix {
   const int gapPen = 2;
   const int match = 0;
   const int misMatch= -1;
   const int EXPECTED_RESULT= 549;

   final istructInt[.] e;
   final charStr c1;
   final charStr c2;
   final int N;
   final int M;
   /**
    * Create edit distance matrix with Edmiston's algorithm
    */
   public editDistMatrix(charStr cSeq1, charStr cSeq2) {
	c1=cSeq1;
	c2=cSeq2;
	N=c1.s.region.high();
	M=c2.s.region.high();
        final dist D=dist.factory.block([0:N,0:M]);
        final dist Dinner=D|[1:N,1:M];
        final dist Dboundary=D-Dinner;
        //  Boundary of e is initialized to:
        //  0     1*gapPen     2*gapPen     3*gapPen ...
        //  1*gapPen ...
        //  2*gapPen ...
        //  3*gapPen ...
        //  ...
        e=new istructInt[D] (point [i,j]) {
            final istructInt t=new istructInt();
            if(Dboundary.contains([i,j])) t.wr(gapPen*(i+j));
            return t;
        };
        finish ateach(point [i,j]:Dinner)
           e[i,j].wr(min(e[i-1,j]->rd()+gapPen,
                         e[i,j-1]->rd()+gapPen,
                         e[i-1,j-1]->rd()
                           +(c1.s[i]==c2.s[j]?match:misMatch)));
   }

    /**
     * Find the sum of the elements of the edit distance matrix
     */
    int checkSum() {
        int sum=0;
        for(point [i,j]:e) sum+=e[i,j]->rd();
        return sum;
    }
    /**
     * Verify that the edit distance matrix has the expected
     * checksum.
     */
    public void verify() {
	if(checkSum()!=EXPECTED_RESULT) throw new Error();
    }

    /* 
     * Print the Edit Distance Matrix 
     */
    public void pr(final String s)
    {
        final int K=4; // padding amount

        System.out.println(s);

        System.out.print(" "+pad(' ',K));
        for(point [j]:0:M) System.out.print(" "+pad(c2.s[j],K));
        System.out.println();

        for(point [i]:0:N){
            System.out.print(" "+pad(c1.s[i],K));
            for(point [j]:0:M) System.out.print(" "+pad(e[i,j]->rd(),K));
            System.out.println();
        }
    }

   /*
    * utility functions
    */
    /**
     * returns the minimum of x y and z.
     */
    static int min(int x, int y, int z) {
        int t=(x<y)?x:y;
        return (t<z)?t:z;
    }
    /**
     * right justify an integer in a field of n blanks
     */
    static String pad(int x, int n) {
        String s=""+x;
        while (s.length()<n) s=" "+s;
        return s;
    }
    /**
     * right justify a character in a field of n blanks
     */
    static String pad(char x, int n) {
        String s=""+x;
        while (s.length()<n) s=" "+s;
        return s;
    }

}

/**
 * A random character array consisting of the letters ACTG 
 * and beginning with -
 */
value class charStr { 
    final char value[.] s;
    const char[] aminoAcids={'A','C','G','T'};
    public charStr(final int siz, final int randomStart) {
	s= new char value[[0:siz]->here] 
         (point [i]) { return i==0?'-':randomChar(randomStart+i);};
    }
	  
    /** 
     * Function to generate the i'th random character
     */
   
    private static char randomChar(int i) {
        // Randomly select one of 'A', 'C', 'G', 'T' 
        int n=0;
        final Random  rand=new Random(1L);
        // find i'th random number.
        // TODO: need to pre-compute random numbers and re-use
        for(point [k]: 1:i) n = nextChoice(rand);
        return aminoAcids[n];
    }

    private static int nextChoice(Random rand) {
        int k1=rand.nextBoolean()?0:1;
        int k2=rand.nextBoolean()?0:1;
        return k1*2+k2;
    }
}
