import harness.x10Test;


/**
 * Java and X10 permit a call to a method which returns a value to occur as a statement.
 * The returned value is discarded. However, Java does not permit a variable standing alone
 * as a statement. Thus the x10 compiler must check that as a result of flattening it does
 * not produce a variable standing alone. 
 * In an earlier implementation this would give a t0 not reachable error.
 */
public class FlattenAsyncExpr extends x10Test {
    int[.] a;
    public FlattenAsyncExpr() {
      a = new int[[1:10]] (point [j]) { return j;};
    }
    int m(int x) {
      
      return x;
    }
    
	public boolean run() {
		async(a.distribution[1]) {
					m(50000);
					//atomic { a[1] = a[1]^2;
          
				}
	 return true;
	}

	public static void main(String[] args) {
		new FlattenAsyncExpr().execute();
	}
	
}

