package agilesites.api;

/**
 * Base inteface for typed elements
 *
 */
public interface TypedElement<A extends Asset> {

    public String apply(A a, Env e);

}
