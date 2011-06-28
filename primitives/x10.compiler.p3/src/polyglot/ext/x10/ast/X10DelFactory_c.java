/*
 *
 * (C) Copyright IBM Corporation 2006-2008
 *
 *  This file is part of X10 Language.
 *
 */
/*
 * Created on Oct 7, 2004
 */
package polyglot.ext.x10.ast;

import polyglot.ast.AbstractDelFactory_c;
import polyglot.ast.Conditional;
import polyglot.ast.JL;
import polyglot.ast.Node;
import polyglot.ext.x10.extension.X10Del_c;
import polyglot.ext.x10.extension.X10Ext;
import polyglot.ext.x10.types.X10NamedType;
import polyglot.ext.x10.types.X10TypeSystem;
import polyglot.ext.x10.visit.X10PrettyPrinterVisitor;
import polyglot.types.SemanticException;
import polyglot.types.Type;
import polyglot.types.Types;
import polyglot.util.CodeWriter;
import polyglot.visit.Translator;
import polyglot.visit.TypeChecker;

/**
 * @author Christian Grothoff
 */
public class X10DelFactory_c extends AbstractDelFactory_c {

	/**
	 * A delegate that redirects translate to the X10PrettyPrinterVisitor.
	 */
	public static class TD extends X10Del_c {
		public void translate(CodeWriter w, Translator tr) {
			if (jl() instanceof Node) {
				Node n = (Node) jl();
				X10Ext ext = (X10Ext) n.ext();
				if (ext != null && ext.comment() != null)
					w.write(ext.comment());
			}
			new X10PrettyPrinterVisitor(w,tr).visitAppropriate(jl());
		}
	};

	public JL delNodeImpl() {
		return new TD();
	}

	/**
	 * For each async, add the delegate that redirects translate
	 * to the X10PrettyPrinterVisitor.
	 */
	public JL delAsyncImpl() {
		return delNodeImpl();
	}

	/**
	 * For each ateach loop, add the delegate that redirects translate
	 * to the X10PrettyPrinterVisitor.
	 */
	public JL delAtEachImpl() {
		return delNodeImpl();
	}

	/**
	 * For each foreach loop, add the delegate that redirects translate
	 * to the X10PrettyPrinterVisitor.
	 */
	public JL delForEachImpl() {
		return delNodeImpl();
	}

	/**
	 * For each x10 for loop, add the delegate that redirects translate
	 * to the X10PrettyPrinterVisitor.
	 */
	public JL delForLoopImpl() {
		return delNodeImpl();
	}

	/**
	 * For each finish, add the delegate that redirects translate
	 * to the X10PrettyPrinterVisitor.
	 */
	public JL delFinishImpl() {
		return delNodeImpl();
	}

	/**
	 * For each closure, add the delegate that redirects translate
	 * to the X10PrettyPrinterVisitor.
	 */
	public JL delClosureImpl() {
		return delNodeImpl();
	}

    /**
     * For each future, add the delegate that redirects translate
     * to the X10PrettyPrinterVisitor.
     */
    public JL delFutureImpl() {
        return delNodeImpl();
    }
}
