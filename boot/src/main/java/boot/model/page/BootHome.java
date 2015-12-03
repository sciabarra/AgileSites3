package boot.model.page;

import agilesites.annotations.Attribute;
import agilesites.annotations.ContentDefinition;
import boot.model.Page;

/**
 * Created by msciab on 03/12/15.
 */
@ContentDefinition(flexContent = "PageDefinition",
        flexAttribute = "PageAttribute")
public class BootHome extends Page<BootHome> {

        @Attribute
        String bootTitle;
}
