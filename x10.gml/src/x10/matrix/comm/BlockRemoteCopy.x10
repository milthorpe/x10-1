/*
 *  This file is part of the X10 project (http://x10-lang.org).
 *
 *  This file is licensed to You under the Eclipse Public License (EPL);
 *  You may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *      http://www.opensource.org/licenses/eclipse-1.0.php
 *
 *  (C) Copyright IBM Corporation 2006-2016.
 */
package x10.matrix.comm;

import x10.matrix.Matrix;
import x10.matrix.DenseMatrix;
import x10.matrix.ElemType;

import x10.matrix.sparse.SparseCSC;
import x10.matrix.distblock.BlockSet;

public type BlocksPLH = PlaceLocalHandle[BlockSet];

/**
 * Implementation of send-receive matrix block across places.
 */
public class BlockRemoteCopy {
	protected static val baseTagCopyTo:Int=100000n;
	protected static val baseTagCopyFrom:Int=200000n;
	protected static val baseTagCopyIdxTo:Int=300000n;
	protected static val baseTagCopyIdxFrom:Int=400000n;
	protected static val baseTagCopyValTo:Int=500000n;
	protected static val baseTagCopyValFrom:Int=600000n;

	/**
	 * Copy source block to target block in distributed block matrix structure.
	 */
	public static def copy(distBS:BlocksPLH, 
			srcbid:Long, srcColOff:Long, 
			dstbid:Long, dstColOff:Long, 
			colCnt:Long):Long {
		//Favor of current place is source place, and using copyto
		if (srcbid == dstbid) return 0;
		
		val srcpid = distBS().findPlace(srcbid);
		val dsz = at(Place(srcpid)) {
			val blk = distBS().find(srcbid);
			val srcmat = blk.getMatrix();
			val dstpid = distBS().findPlace(dstbid);
			copy(srcmat, srcColOff, distBS, dstpid, dstbid, dstColOff, colCnt)  
		};
		return dsz;
	}
	
	// Remote array copy matrix to/from 
	/**
	 * Copy matrix to block of specified block ID 
	 */
	public static def copy(src:Matrix, dstBS:BlocksPLH, dstbid:Long):Long =
		copy(src, 0, dstBS, dstBS().findPlace(dstbid), dstbid, 0, src.N);

	/**
	 * Copy matrix block of specified block ID to specified matrix.
	 */
	public static def copy(srcBS:BlocksPLH, srcbid:Long, dst:Matrix):Long =
		copy(srcBS, srcBS().findPlace(srcbid), srcbid, 0, dst, 0, dst.N);

	
	public static def copy(src:Matrix, dstBS:BlocksPLH, dstpid:Long, dstbid:Long):Long =
		copy(src, 0, dstBS, dstpid, dstbid, 0, src.N);

	public static def copy(srcBS:BlocksPLH, srcpid:Long, srcbid:Long, dst:Matrix):Long =
		copy(srcBS, srcpid, srcbid, 0, dst, 0, dst.N);
	


	public static def copy(src:Matrix, srcColOff:Long, 
			dstBS:BlocksPLH, dstpid:Long, dstbid:Long, dstColOff:Long, colCnt:Long):Long {
		if (src instanceof DenseMatrix)
			return copy(src as DenseMatrix, srcColOff, dstBS, dstpid, dstbid, dstColOff, colCnt);
		else if (src instanceof SparseCSC)
			return copy(src as SparseCSC, srcColOff, dstBS, dstpid, dstbid, dstColOff, colCnt);
		else
			throw new UnsupportedOperationException("Matrix type is not supported in remote block copy");
	}
	
	public static def copy(srcBS:BlocksPLH, srcpid:Long, srcbid:Long, srcColOff:Long, 
			dst:Matrix, dstColOff:Long, colCnt:Long):Long {
		if (dst instanceof DenseMatrix)
			return copy(srcBS, srcpid, srcbid, srcColOff, dst as DenseMatrix, dstColOff, colCnt);
		else if (dst instanceof SparseCSC)
			return copy(srcBS, srcpid, srcbid, srcColOff, dst as SparseCSC, dstColOff, colCnt);
		else
			throw new UnsupportedOperationException("Matrix type is not supported in remote block copy");
	}


	protected static def copy(src:DenseMatrix, srcColOff:Long, 
				dstBS:BlocksPLH, dstpid:Long, bid:Long, dstColOff:Long, colCnt:Long):Long {		
		val srcIdxOff:Long = src.M * srcColOff;
		val datCnt:Long    = src.M * colCnt;
		val dstIdxOff:Long = dstBS().getGrid().getRowSize(bid) * dstColOff;
		
		copyOffset(src, srcIdxOff, dstBS, dstpid, bid, dstIdxOff, datCnt);
		return datCnt;
	}


	protected static def copyOffset(src:DenseMatrix, srcIdxOff:Long, 
			dst:BlocksPLH, dstpid:Long, bid:Long, dstIdxOff:Long, datCnt:Long): void {
		
        assert (srcIdxOff+datCnt<=src.d.size) :
            "Source starting offset:"+srcIdxOff+" plus data count:"+datCnt+
            " is larger source matrix data buffer size:"+src.d.size;
		
		if (here.id() == dstpid) {
			val blk = dst().find(bid);
			val dstden = blk.getMatrix() as DenseMatrix;
			Rail.copy(src.d, srcIdxOff, dstden.d, dstIdxOff, datCnt);
		} else {
			x10CopyOffset(src, srcIdxOff, dst, dstpid, bid, dstIdxOff, datCnt);
		}		
	}

	protected static def x10CopyOffset(src:DenseMatrix, srcIdxOff:Long, 
			dstBS:BlocksPLH, dstpid:Long, bid:Long, dstIdxOff:Long, datCnt:Long): void {
		
		val buf = src.d as Rail[ElemType]{self!=null};
		val srcbuf = new GlobalRail[ElemType](buf);

		at(Place(dstpid)) {
			//Remote copy: dst, srcbuf, srcIdxOff, dstIdxOff, datCnt,
			val blk = dstBS().find(bid);
			val dstden = blk.getMatrix() as DenseMatrix;
            assert (dstIdxOff+datCnt <= dstden.d.size) :
                "Receive buffer offset:"+dstIdxOff+" plus data count:"+datCnt+
                " is larger than receive buffer size:"+dstden.d.size;
			finish Rail.asyncCopy[ElemType](srcbuf, srcIdxOff, dstden.d, dstIdxOff, datCnt);
		}
	}

	// Remote array copy From 
	protected static def copy(srcBS:BlocksPLH, srcpid:Long, srcbid:Long, srcColOff:Long, 
						   dst:DenseMatrix, dstColOff:Long, colCnt:Long):Long {

		val dstIdxOff:Long = dst.M * dstColOff;
		val srcM:Long      = srcBS().getGrid().getRowSize(srcbid);
		val datCnt:Long    = srcM * colCnt;
		val srcIdxOff:Long = srcM * dstColOff;
		
		copyOffset(srcBS, srcpid, srcbid, srcIdxOff, dst, dstIdxOff, datCnt);
		return datCnt;
	}

	protected static def copyOffset(srcBS:BlocksPLH, srcpid:Long, srcbid:Long, srcIdxOff:Long, 
			dst:DenseMatrix, dstIdxOff:Long, datCnt:Long): void {

        assert (dstIdxOff+datCnt <= dst.d.size) :
            "Receive buffer offset:"+dstIdxOff+" plus data count:"+datCnt+
            " is larger than receive buffer size:"+dst.d.size;
		
		if (here.id() == srcpid) {
			val blk = srcBS().find(srcbid);
			val srcden = blk.getMatrix() as DenseMatrix;
			Rail.copy(srcden.d, srcIdxOff, dst.d, dstIdxOff, datCnt);
		} else {
			x10CopyOffset(srcBS, srcpid, srcbid, srcIdxOff, dst, dstIdxOff, datCnt);
		}
	}

	/**
	 * Copy data from remote dense matrix to here in a vector
	 */
	protected static def x10CopyOffset(srcBS:BlocksPLH, srcpid:Long, bid:Long, srcIdxOff:Long,
			dst:DenseMatrix, dstIdxOff:Long, datCnt:Long): void {
		
		val rmt:DenseRemoteSourceInfo  = at(Place(srcpid)) { 
			//Need: src, bid, srcIdxOff, datCnt
			val blk = srcBS().find(bid);
			val srcden = blk.getMatrix() as DenseMatrix;
			
            assert (srcIdxOff + datCnt <= srcden.d.size) :
                "Sending offset:"+srcIdxOff+" plus data count:"+datCnt+
                " is larger than sending matrix size:"+srcden.d.size;
			new DenseRemoteSourceInfo(srcden.d, srcIdxOff, datCnt)

		};
		finish Rail.asyncCopy[ElemType](rmt.valbuf, rmt.offset, dst.d, dstIdxOff, rmt.length);
	}


	// Sparse matrix copyTo/From

	// Copy sparse from here to remote place
	protected static def copy(src:SparseCSC, srcColOff:Long, 
			dstBS:BlocksPLH, dstpid:Long, dstbid:Long, dstColOff:Long, colCnt:Long):Long {
		
        assert(srcColOff+colCnt <= src.N) :
            "Source column offset:"+srcColOff+" column colunt:"+colCnt+
            " larger than source column size:"+src.N;
		
		if (here.id() == dstpid) {
			val blk = dstBS().find(dstbid);
			val dstspa = blk.getMatrix() as SparseCSC;
			val dz = SparseCSC.copyCols(src, srcColOff, dstspa, dstColOff, colCnt);
			return dz;
		}
		
		return x10Copy(src, srcColOff, dstBS, dstpid, dstbid, dstColOff, colCnt);
	}
	
	//Sparse matrix remote copy To
    protected static def x10Copy(src:SparseCSC, srcColOff:Long,
            dstBS:BlocksPLH, dstpid:Long, bid:Long, dstColOff:Long, colCnt:Long):Long {

		val datcnt = src.initRemoteCopyAtSource(srcColOff, colCnt);
        if (datcnt == 0L) return 0L;
		
		val idxbuf = src.getIndex() as Rail[Long]{self!=null};
		val valbuf = src.getValue() as Rail[ElemType]{self!=null};
		val datoff = src.getNonZeroOffset(srcColOff);
		val rmtidx = new GlobalRail[Long](idxbuf);
		val rmtval = new GlobalRail[ElemType](valbuf);

		at(Place(dstpid)) {
			//Remote capture: datcnt, rmtidx, rmtval, datoff			
			val blk = dstBS().find(bid);
			val dstspa = blk.getMatrix() as SparseCSC;
			//++++++++++++++++++++++++++++++++++++++++++++
			//Do not call getIndex()/getValue() before init at destination place
			//+++++++++++++++++++++++++++++++++++++++++++++
			dstspa.initRemoteCopyAtDest(dstColOff, colCnt, datcnt);
			val dstoff = dstspa.getNonZeroOffset(dstColOff);
			finish Rail.asyncCopy[Long  ](rmtidx, datoff, dstspa.getIndex(), dstoff, datcnt);
			finish Rail.asyncCopy[ElemType](rmtval, datoff, dstspa.getValue(), dstoff, datcnt);
			dstspa.finalizeRemoteCopyAtDest();
		}

		src.finalizeRemoteCopyAtSource();
		return datcnt;
	}

	// Copy sparse from remote to here
	protected static def copy(srcBS:BlocksPLH, srcpid:Long, srcbid:Long, srcColOff:Long,
			dst:SparseCSC, dstColOff:Long, colCnt:Long):Long {

        assert (dstColOff+colCnt <= dst.N) :
            "Receive offset:"+dstColOff+" plus column count:"+colCnt+
            " larger than receive matrix column size:"+dst.N;
		
		if (here.id() == srcpid) {
			val blk = srcBS().find(srcbid);
			val srcspa = blk.getMatrix() as SparseCSC;
			
			return SparseCSC.copyCols(srcspa, srcColOff, dst, dstColOff, colCnt);
		}

		return x10Copy(srcBS, srcpid, srcbid, srcColOff, dst, dstColOff, colCnt);
	}

	/**
	 * Copy sparse matrix block to here via array remote copy.
	 * 
	 * @param src   		source sparseCSC matrix block in all places
	 * @param srcpid  		source matrix's place id.
	 * @param srcColOff  	column offset in source matrix
	 * @param dst   		destination sparse matrix at here
	 * @param dstColOff  	column offset in target matrix
	 * @param colCnt 		count of columns to be copied in source matrix
	 * @return 				number of elements copied
	 */
	protected static def x10Copy(src:BlocksPLH, srcpid:Long, bid:Long, srcColOff:Long,
			dst:SparseCSC, dstColOff:Long, colCnt:Long):Long {

		val rmt = at(Place(srcpid)) {
			val blk = src().find(bid);
			val srcspa = blk.getMatrix() as SparseCSC;
			val off = srcspa.getNonZeroOffset(srcColOff);;
			val cnt = srcspa.countNonZero(srcColOff, colCnt);
			
			srcspa.initRemoteCopyAtSource(srcColOff, colCnt);
			SparseRemoteSourceInfo(srcspa.getIndex(), srcspa.getValue(), off, cnt)
		};

        if (rmt.length == 0L) return 0L;

		val dstoff = dst.getNonZeroOffset(dstColOff);
		dst.initRemoteCopyAtDest(dstColOff, colCnt, rmt.length);
		finish Rail.asyncCopy[Long  ](rmt.idxbuf, rmt.offset, dst.getIndex(), dstoff, rmt.length);
		finish Rail.asyncCopy[ElemType](rmt.valbuf, rmt.offset, dst.getValue(), dstoff, rmt.length);

		finish {
			at(Place(srcpid)) async {
				val srcspa = src().find(bid).getMatrix() as SparseCSC;
				srcspa.finalizeRemoteCopyAtSource();
			}
			dst.finalizeRemoteCopyAtDest();
		}
		
		return rmt.length;
	}
	
	public static def compBlockDataSize(distBS:BlocksPLH, rootbid:Long, colOff:Long, colCnt:Long):Long {
		if (colCnt < 0) return 0;
		var dsz:Long = 0;
		val rootpid= distBS().findPlace(rootbid);

		if (here.id() == rootpid) {
			val blk = distBS().findBlock(rootbid);
			return blk.compColDataSize(colOff, colCnt);
			
		} else {
			dsz = at(Place(rootpid)) {
				val blk = distBS().findBlock(rootbid);
				blk.compColDataSize(colOff, colCnt)
			};
		}
		return dsz;
	}

	public static def compBlockDataSize(distBS:BlocksPLH, rootbid:Long):Long =
		compBlockDataSize(distBS, rootbid, 0, distBS().getGrid().getColSize(rootbid));

}
