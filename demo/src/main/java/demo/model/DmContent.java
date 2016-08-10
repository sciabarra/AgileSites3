package demo.model;

import agilesites.annotations.Type;
import agilesitesng.api.ASAsset;

@Type
public class DmContent<S> extends ASAsset {

    S definition;

    public DmContent() {
    }

    public S getDefinition() {
        return definition;
    }

    public DmContent(S definition) {
        this.definition = definition;
    }

    public S get() {
        return definition;
    }

}
