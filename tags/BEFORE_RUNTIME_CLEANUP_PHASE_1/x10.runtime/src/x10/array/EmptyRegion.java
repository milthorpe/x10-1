/*
 * Created by vj on Jan 4, 2005
 */
package x10.array;

import java.util.Iterator;
import java.util.NoSuchElementException;

import x10.lang.point;
import x10.lang.region;
import x10.lang.RankMismatchException;

/**
 * The empty region of rank k. There is only one unique object in each such type.
 * @author vj Jan 4, 2005
 */
public class EmptyRegion extends region {

	/**
	 * @param rank
	 */
	public EmptyRegion(/*long*/ int rank) {
		super(rank);
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#size()
	 */
	public int size() {
		return 0;
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#rank(long)
	 */
	public region rank(int index) {
		assert index < rank;
		return new EmptyRegion(1);
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#isConvex()
	 */
	public boolean isConvex() {
		return true;
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#low()
	 */
	public int low() {
		throw new UnsupportedOperationException();
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#high()
	 */
	public int high() {
		throw new UnsupportedOperationException();
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#union(x10.lang.region)
	 */
	public region union(region r) {
		assert r != null;
		if (r.rank != rank)
			throw new RankMismatchException(r, rank);
		return r;
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#intersection(x10.lang.region)
	 */
	public region intersection(region r) {
		assert r != null;
		if (r.rank != rank)
			throw new RankMismatchException(r, rank);
		return this;
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#difference(x10.lang.region)
	 */
	public region difference(region r) {
		assert r != null;
		if (r.rank != rank)
			throw new RankMismatchException(r, rank);
		return this;
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#convexHull()
	 */
	public region convexHull() {
		return this;
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#contains(x10.lang.region)
	 */
	public boolean contains(region r) {
		if (r.rank != rank)
			throw new RankMismatchException(r, rank);
		return r.size() == 0;
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#contains(x10.lang.point)
	 */
	public boolean contains(point p) {
		if (p.rank != rank)
			throw new RankMismatchException(p, rank);
		return false;
	}

	// [IP] FIXME: should we be asserting this here?
	public boolean contains(int[] p) {
		assert this.rank == p.length;
		return false;
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#disjoint(x10.lang.region)
	 */
	public boolean disjoint(region r) {
		if (r.rank != rank)
			throw new RankMismatchException(r, rank);
		return true;
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#ordinal(x10.lang.point)
	 */
	public int ordinal(point p) throws ArrayIndexOutOfBoundsException {
		throw new ArrayIndexOutOfBoundsException();
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#coord(int)
	 */
	public point coord(int ord) throws ArrayIndexOutOfBoundsException {
		throw new ArrayIndexOutOfBoundsException();
	}

	/* (non-Javadoc)
	 * @see x10.lang.region#iterator()
	 */
	public Iterator iterator() {

		class RegionIterator implements Iterator {

			public boolean hasNext() {
				return false;
			}

			public void remove() {
				throw new Error("not implemented");
			}

			public java.lang.Object next() {
				throw new Error("No such element.");
			}
		}

		return new Iterator() {
			public boolean hasNext() {
				return false;
			}
			public void remove() throws UnsupportedOperationException {
				throw new UnsupportedOperationException();
			}
			public java.lang.Object next() throws NoSuchElementException {
				throw new NoSuchElementException();
			}
		};
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		return "EmptyRegion("+rank+")";
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	public boolean equals(java.lang.Object o) {
		boolean ret;
		if (o == null || !(o instanceof region))
			ret = false;
		else {
			region oe = (region) o;
			ret = (oe.rank == this.rank) && oe.size() == 0;
		}
		return ret;
	}

	
}

