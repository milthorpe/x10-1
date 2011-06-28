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

package x10.visit;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import polyglot.frontend.Job;
import polyglot.util.Position;
import polyglot.visit.ContextVisitor;
import polyglot.visit.NodeVisitor;
import x10.ast.Atomic;
import x10.ast.Block;
import x10.ast.Expr;
import x10.ast.Node;
import x10.ast.NodeFactory;
import x10.ast.Stmt;
import x10.ast.X10MethodDecl;
import x10.ast.NodeFactory;
import x10.extension.X10ClassBodyExt_c;
import x10.types.SemanticException;
import x10.types.TypeSystem;
import x10.types.X10Flags;
import x10.types.TypeSystem;

public class RewriteAtomicMethodVisitor extends ContextVisitor {

	public RewriteAtomicMethodVisitor(Job job, TypeSystem ts, NodeFactory nf) {
		super(job, ts, nf);
	}

	<T extends Node> T check(T n) throws SemanticException {
		return (T) n.del().disambiguate(this).del().typeCheck(this).del().checkConstants(this);
	}

	@Override
	public Node leaveCall(Node old, Node n, NodeVisitor v) throws SemanticException {
		n = super.leaveCall(old, n, v);

		if (n instanceof X10MethodDecl) {
			X10MethodDecl md = (X10MethodDecl) n;
			X10Flags flags = X10Flags.toX10Flags(md.flags().flags());
			if (flags.isAtomic()) {
				Block b = md.body();
				NodeFactory nf = (NodeFactory) this.nf;
				Position pos = b.position();

				Expr here = nf.Here(pos);
				here = check(here);

				Stmt atomic = nf.Atomic(pos, here, b);
				atomic = check(atomic);

				b = nf.Block(pos, Collections.singletonList(atomic));
				b = check(b);
				
				return md.body(b);
			}
		}

		return n;
	}
}