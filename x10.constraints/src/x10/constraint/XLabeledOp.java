package x10.constraint;

import x10.constraint.smt.XPrinter;

/**
 * A representation of an XExpr operator parameterized by the label. It is used
 * to represent field/method projection (a.f, a.foo()) when applied to a receiver 
 * as part of an XExpr. The specific field/method information is stored in def. 
 *  
 * @author lshadare
 *
 * @param <D>
 */
public class XLabeledOp<T extends XType, D extends XDef<T>> extends XOp<T> {
	D def; 
	T resultType; 
	
	XLabeledOp(D def, T type) {
		super(XOp.Kind.APPLY_LABEL);
		this.def = def;
		this.resultType = type; 
	}
	
	public D getLabel() {
		return def; 
	}

	@Override
	public T type() {
		return resultType; 
	}


	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((def == null) ? 0 : def.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!super.equals(obj))
			return false;
		if (getClass() != obj.getClass())
			return false;
		XLabeledOp<?,?> other = (XLabeledOp<?,?>) obj;
		if (def == null) {
			if (other.def != null)
				return false;
		} else if (!def.equals(other.def))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return kind.name() + " (" + def.toString() + ")";
	}

	@Override
	public String prettyPrint() {
		return def.getName();
	}

	@Override
	public String print(XPrinter<T> p) {
		return p.mangle(def.getName());
	}
	
}