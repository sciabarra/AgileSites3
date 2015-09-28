package demo.model;

import agilesites.annotations.Type;
import agilesites.api.AgileAsset;

/**
 * Declaring a parent type for flex families
 */
@Type
public class DmParent<S> extends AgileAsset {
    S definition;

    public DmParent() {
    }

    public DmParent(S definition) {
        this.definition = definition;
    }

    public S getDefinition() {
        return definition;
    }

    public S get() {
        return definition;
    }
}
