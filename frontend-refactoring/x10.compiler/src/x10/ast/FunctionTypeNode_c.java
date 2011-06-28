/*
 *  This file is part of the X10 project (http://x10-lang.org).
 *
 *  This file is licensed to You under the Eclipse Public License (EPL);
 *  You may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *      http://www.opensource.org/licenses/eclipse-1.0.php
 *
 *  (C) Copyright IBM Corporation 2006-2010.
 */

package x10.ast;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import polyglot.frontend.SetResolverGoal;
import polyglot.util.CodeWriter;
import polyglot.util.Position;
import polyglot.util.TransformingList;
import polyglot.util.TypedList;
import polyglot.visit.ContextVisitor;
import polyglot.visit.NodeVisitor;
import polyglot.visit.PrettyPrinter;
import polyglot.visit.TypeCheckPreparer;
import polyglot.visit.TypeChecker;

import x10.types.ClassType;
import x10.types.ClosureDef;
import x10.types.CodeDef;
import x10.types.CodeInstance;
import x10.types.Context;
import x10.types.DerefTransform;
import x10.types.LazyRef;
import x10.types.LocalDef;
import x10.types.Ref;
import x10.types.SemanticException;
import x10.types.Type;
import x10.types.TypeSystem;
import x10.types.Types;
import x10.types.X10ClassType;
import x10.types.TypeSystem;
import x10.types.constraints.CConstraint;
import x10.types.constraints.CConstraint;
import x10.visit.X10TypeChecker;

public class FunctionTypeNode_c extends TypeNode_c implements FunctionTypeNode {

	List<TypeParamNode> typeParams;
	List<Formal> formals;
	DepParameterExpr guard;
	// List<TypeNode> throwTypes;
	TypeNode returnType;
	TypeNode offersType;

	public FunctionTypeNode_c(Position pos, List<TypeParamNode> typeParams, List<Formal> formals, TypeNode returnType, DepParameterExpr guard, 
			 TypeNode offersType) {
		super(pos);
		this.typeParams = TypedList.copyAndCheck(typeParams, TypeParamNode.class, true);
		this.formals = TypedList.copyAndCheck(formals, Formal.class, true);
		// this.throwTypes = TypedList.copyAndCheck(throwTypes, TypeNode.class, true);
		this.returnType = returnType;
		this.guard = guard;
		this.offersType = offersType;
	}

	@Override
	public Node disambiguate(ContextVisitor ar) throws SemanticException {
		NodeFactory nf = (NodeFactory) ar.nodeFactory();
		TypeSystem ts = (TypeSystem) ar.typeSystem();
		FunctionTypeNode_c n = this;
		List<Ref<? extends Type>> typeParams = new ArrayList<Ref<? extends Type>>(n.typeParameters().size());
		for (TypeParamNode tpn : n.typeParameters()) {
			typeParams.add(Types.ref(tpn.type()));
		}
		List<Ref<? extends Type>> formalTypes = new ArrayList<Ref<? extends Type>>(n.formals().size());
		for (Formal f : n.formals()) {
			formalTypes.add(f.type().typeRef());
		}
		List<LocalDef> formalNames = new ArrayList<LocalDef>(n.formals().size());
		for (Formal f : n.formals()) {
			formalNames.add(f.localDef());
		}
	
		//if (guard != null)
		//	throw new SemanticException("Function types with guards are currently unsupported.", position());
		if (typeParams.size() != 0)
			throw new SemanticException("Function types with type parameters are currently unsupported.", position());
		Type result = ts.closureType(position(), returnType.typeRef(),
				//   typeParams, 
				formalTypes, formalNames, 
				guard != null ? guard.valueConstraint() 
						: Types.<CConstraint>lazyRef(new CConstraint())
						// guard != null ? guard.typeConstraint() : null,
						);

		//	    Context c = ar.context();
		//	    ClassType ct = c.currentClass();
		//	    CodeDef code = c.currentCode();
		//	    ClosureDef cd = ts.closureDef(position(),
		//	                                  Types.ref(ct), 
		//	                                  code == null ? null : Types.ref(code.asInstance()),
		//	                                  returnType.typeRef(),
		//	                                  typeParams,
		//	                                  formalTypes, 
		//	                                  formalNames, 
		//	                                  guard != null ? guard.xconstraint() : null,
		//	                                  throwTypes);
		//	    
		//	    Type t = cd.asType();
		//	    Type result = t;

		((LazyRef<Type>) typeRef()).update(result);
		return nf.CanonicalTypeNode(position(), typeRef());
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see x10.ast.FunctionTypeNode#returnType()
	 */
	public TypeNode returnType() {
		return this.returnType;
	}
	
	public TypeNode offersType() {
		return this.offersType;
	}

	/** Set the return type of the method. */
	public FunctionTypeNode returnType(TypeNode returnType) {
		FunctionTypeNode_c n = (FunctionTypeNode_c) copy();
		n.returnType = returnType;
		return n;
	}

	@Override
	  public void setResolver(Node parent, final TypeCheckPreparer v) {
	    	if (typeRef() instanceof LazyRef<?>) {
	    		LazyRef<Type> r = (LazyRef<Type>) typeRef();
	    		TypeChecker tc = new X10TypeChecker(v.job(), v.typeSystem(), v.nodeFactory(), v.getMemo());
	    		tc = (TypeChecker) tc.context(v.context().freeze());
	    		r.setResolver(new X10TypeCheckTypeGoal(parent, this, tc, r));
	    	}
	    }
	/* (non-Javadoc)
	 * @see x10.ast.FunctionTypeNode#typeParameters()
	 */
	public List<TypeParamNode> typeParameters() {
		return Collections.<TypeParamNode> unmodifiableList(this.typeParams);
	}

	/** Set the formals of the method. */
	public FunctionTypeNode typeParameters(List<TypeParamNode> typeParams) {
		FunctionTypeNode_c n = (FunctionTypeNode_c) copy();
		n.typeParams = TypedList.copyAndCheck(typeParams, TypeParamNode.class, true);
		return n;
	}

	/* (non-Javadoc)
	 * @see x10.ast.FunctionTypeNode#formals()
	 */
	public List<Formal> formals() {
		return Collections.<Formal> unmodifiableList(this.formals);
	}

	/** Set the formals of the method. */
	public FunctionTypeNode formals(List<Formal> formals) {
		FunctionTypeNode_c n = (FunctionTypeNode_c) copy();
		n.formals = TypedList.copyAndCheck(formals, Formal.class, true);
		return n;
	}

	/* (non-Javadoc)
	 * @see x10.ast.FunctionTypeNode#guard()
	 */
	public DepParameterExpr guard() {
		return guard;
	}

	public FunctionTypeNode guard(DepParameterExpr guard) {
		FunctionTypeNode_c n = (FunctionTypeNode_c) copy();
		n.guard = guard;
		return n;
	}


	/** Visit the children of the method. */
	public Node visitChildren(NodeVisitor v) {
		List<TypeParamNode> typeParams = this.visitList(this.typeParams, v);
		List<Formal> formals = this.visitList(this.formals, v);
		DepParameterExpr guard = (DepParameterExpr) this.visitChild(this.guard, v);
		TypeNode returnType = (TypeNode) this.visitChild(this.returnType, v);
		return reconstruct(typeParams, formals, guard, returnType);
	}

	protected Node reconstruct(List<TypeParamNode> typeParams, List<Formal> formals, DepParameterExpr guard, TypeNode returnType) {

		FunctionTypeNode_c n = this;
		n = (FunctionTypeNode_c) n.typeParameters(typeParams);
		n = (FunctionTypeNode_c) n.formals(formals);
		n = (FunctionTypeNode_c) n.guard(guard);
		n = (FunctionTypeNode_c) n.returnType(returnType);
		return n;
	}

	public String toString() {
		StringBuilder sb = new StringBuilder();
		if (typeParams.size() > 0) {
			sb.append("[");
			String sep = "";
			for (TypeParamNode p : typeParams) {
				sb.append(sep);
				sb.append(p);
				sep = ", ";
			}
			sb.append("]");
		}
		sb.append("(");
		String sep = "";
		for (Formal p : formals) {
			sb.append(sep);
			sb.append(p);
			sep = ", ";
		}
		sb.append(")");
		if (guard != null)
			sb.append(guard);
		sb.append(" => ");
		sb.append(returnType);
		return sb.toString();
	}

	public void prettyPrint(CodeWriter w, PrettyPrinter tr) {
		w.begin(0);

		if (typeParams.size() > 0) {
			w.write("[");

			w.allowBreak(2, 2, "", 0);
			w.begin(0);

			for (Iterator<Formal> i = formals.iterator(); i.hasNext();) {
				Formal f = i.next();

				print(f, w, tr);

				if (i.hasNext()) {
					w.write(",");
					w.allowBreak(0, " ");
				}
			}

			w.end();
			w.write("]");
			w.allowBreak(2, 2, " ", 1);
		}

		w.write("(");

		w.allowBreak(2, 2, "", 0);
		w.begin(0);

		for (Iterator<Formal> i = formals.iterator(); i.hasNext();) {
			Formal f = i.next();

			print(f, w, tr);

			if (i.hasNext()) {
				w.write(",");
				w.allowBreak(0, " ");
			}
		}

		w.end();
		w.write(")");
		w.allowBreak(2, 2, " ", 1);

		if (guard != null)
			print(guard, w, tr);
/*
		if (!throwTypes().isEmpty()) {
			w.allowBreak(6);
			w.write("throws ");

			for (Iterator<TypeNode> i = throwTypes().iterator(); i.hasNext();) {
				TypeNode tn = i.next();
				print(tn, w, tr);

				if (i.hasNext()) {
					w.write(",");
					w.allowBreak(4, " ");
				}
			}
		}
*/
		w.write(" => ");
		print(returnType, w, tr);

		w.end();
	}

}