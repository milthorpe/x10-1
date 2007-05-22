/*
 *
 * (C) Copyright IBM Corporation 2006
 *
 *  This file is part of X10 Language.
 *
 */
package polyglot.ext.x10.extension;

import java.util.List;

import polyglot.ast.Ext;
import polyglot.ast.Node;
import polyglot.ast.NodeFactory;
import polyglot.frontend.ExtensionInfo;
import polyglot.types.ClassType;
import polyglot.ext.x10.ast.AnnotationNode;
import polyglot.ext.x10.types.X10ClassType;
import polyglot.ext.x10.types.X10TypeSystem;

public interface X10Ext extends Ext {
    /**
      * Comment adjacent to the node in the source code.
      * @return the comment
      */
    public String comment();
    
    /**
      * Clone the extension object and set its comment.
      * @param comment
      * @return a new extension object
      */
    public X10Ext comment(String comment);
    
    /**
      * Clone the extension object and the node and set its comment.
      * @param comment
      * @return a new Node
      */
    public Node setComment(String comment);
    
    public Node rewrite(X10TypeSystem ts, NodeFactory nf, ExtensionInfo info);
    
    /**
     * Annotation on the node.
     * @return
     */
    public List<AnnotationNode> annotations();
    public List<X10ClassType> annotationTypes();
    public X10ClassType annotationNamed(String name);
    
    /**
     * Set the annotations.
     * @param annotations
     * @return
     */
    public Node annotations(List<AnnotationNode> annotations);
}
