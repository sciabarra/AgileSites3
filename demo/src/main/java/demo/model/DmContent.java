package demo.model;

import agilesites.annotations.Type;
import agilesites.api.AgileAsset;


@Type
public class DmContent<S> extends AgileAsset {

    S definition;

    public DmContent() {
    }

    public DmContent(S definition) {
        this.definition = definition;
    }

    public S getDefinition() {
        return definition;
    }

    public S get() {
        return definition;
    }

}
