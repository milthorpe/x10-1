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

package x10.core;

import x10.rtt.NamedType;
import x10.rtt.RuntimeType;
import x10.rtt.Type;
import x10.rtt.Types;

// XTENLANG-2686: Now x10.core.Throwable is a superclass of x10.lang.Throwable (mapped to x10.core.X10Throwable),
//                and also a superclass of x10.runtime.impl.java.WrappedThrowable and UnknownJavaThrowable.
public class Throwable extends java.lang.RuntimeException {

	private static final long serialVersionUID = 1L;

	public Throwable(java.lang.System[] $dummy) {
	    super();
	}

	public Throwable $init() {return this;}
    
    public Throwable() {
        super();
    }

    // TODO
    // public Throwable $init(java.lang.String message) {return this;}
    
    public Throwable(java.lang.String message) {
        super(message);
    }

    // TODO
    // public Throwable $init(java.lang.Throwable cause) {return this;}
    
    public Throwable(java.lang.Throwable cause) {
        super(cause);
    }

    // TODO
    // public Throwable $init(java.lang.String message, java.lang.Throwable cause) {return this;}
    
    public Throwable(java.lang.String message, java.lang.Throwable cause) {
        super(message, cause);
    }

    /* TODO to be removed
    // XTENLANG-1858: every Java class that could be an (non-static) inner class must have constructors with the outer instance parameter
    public Throwable(Object out$) {
        super();
    }

    // TODO
    // public Throwable $init(Object out$, java.lang.String message) {return this;}

    public Throwable(Object out$, java.lang.String message) {
        super(message);
    }

    // TODO
    // public Throwable $init(Object out$, java.lang.Throwable cause) {return this;}

    public Throwable(Object out$, java.lang.Throwable cause) {
        super(cause);
    }

    // TODO
    // public Throwable $init(Object out$, java.lang.String message, java.lang.Throwable cause) {return this;}
    
    public Throwable(Object out$, java.lang.String message, java.lang.Throwable cause) {
        super(message, cause);
    }
    */

    // XTENLANG-2680
	public java.lang.String getMessage$O() {
		return super.getMessage();
	}

    // XTENLANG-2680
	public void printStackTrace(x10.io.Printer p) {
	    // See @Native annotation in Throwable.x10
		x10.core.ThrowableUtilities.printStackTrace(this, p);
	}

    /* XTENLANG-2686: RTT is not necessary any more since this class is not mapped to x10.lang.Throwable
    public static final RuntimeType<Throwable> $RTT = new NamedType<Throwable>(
        "x10.lang.Throwable",
        Throwable.class,
        new Type[] { x10.rtt.Types.OBJECT }
    );
    public RuntimeType<?> $getRTT() {
        return $RTT;
    }
    public Type<?> $getParam(int i) {
        return null;
    }
    */

    @Override
    public java.lang.String toString() {
        java.lang.String msg = this.getMessage();
        java.lang.String name = Types.typeName(this);
        if (msg == null) {
            return name;
        } else {
            int length = name.length() + 2 + msg.length();
            java.lang.StringBuilder buffer = new java.lang.StringBuilder(length);
            return buffer.append(name).append(": ").append(msg).toString();
        }
    }

}
