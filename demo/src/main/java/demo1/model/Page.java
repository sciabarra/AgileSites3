package demo.model;

import agilesites.annotations.Type;
import agilesites.api.AgileAsset;
import agilesites.api.Asset;

/**
 * Declaring a type for Pages
 */
@Type(flexAttribute = "PageAttribute",
        flexContent = "PageDefinition")
public class Page
        extends AgileAsset {
}
