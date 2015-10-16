package demo.model;

import agilesites.annotations.Type;
import agilesites.api.AgileAsset;

/**
 * Declaring a type for Pages
 */
@Type
public class Page<S> extends AgileAsset {

    S definition;

    public Page() {
    }

    public Page(S definition) {
        this.definition = definition;
    }

    public S getDefinition() {
        return definition;
    }

    public S get() {
        return definition;
    }

}
