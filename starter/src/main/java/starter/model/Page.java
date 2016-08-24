package starter.model;

import agilesites.annotations.Type;
import agilesitesng.api.ASAsset;

/**
 * Declaring a type for Pages
 */
@Type
public class Page<S> extends ASAsset {

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
