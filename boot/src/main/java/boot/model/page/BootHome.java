package boot.model.page;

import agilesites.annotations.Attribute;
import agilesites.annotations.ContentDefinition;
import agilesites.annotations.FindStartMenu;
import agilesites.annotations.NewStartMenu;
import boot.model.Page;

import java.util.Date;

/**
 * Created by msciab on 03/12/15.
 */
@FindStartMenu("Find Boot Page")
@NewStartMenu("New Boot Page")
@ContentDefinition(flexContent = "PageDefinition",
        flexAttribute = "PageAttribute")
public class BootHome extends Page {

        @Attribute
        String bootTitle;

        @Attribute
        Date bootDate;
}
