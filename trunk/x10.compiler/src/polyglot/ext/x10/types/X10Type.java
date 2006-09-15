/*
 * Created on Nov 30, 2004
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package polyglot.ext.x10.types;

import java.util.List;

import polyglot.ext.x10.types.constr.C_Term;
import polyglot.ext.x10.types.constr.Constraint;
import polyglot.types.Type;


/**
 * @author vj
 *
 */
public interface X10Type extends Type {

    
    /** Return a subtype of the basetype with the given
     * depclause and type parameters.
     * 
     * @param d
     * @param g
     * @return
     */
    X10Type makeVariant(Constraint d, List g);
    X10Type  baseType();
    List typeParameters();
    boolean isParametric();
    NullableType toNullable();
    FutureType toFuture();
    Constraint depClause();
    /**
     * Is this is a constrained type?
     * @return true iff depClause()==null or depClause().valid();
     */
    boolean isConstrained();
    
    /**
     * If the type constrains the given property to
     * a particular value, then return that value, otherwise 
     * return null
     * @param name -- the name of the property.
     * @return null if there is no value associated with the property in the type.
     */
    C_Term propVal(String name);
    /** The list of properties of the class.
     
     * @return
     */
    List/*<PropertyInstance>*/ properties();

}
