package agilesites.api;

/**
 * Base inteface for typed elements
 *
 */
public interface TypedElement<A> {

    public String apply(A a, Env e);

}
