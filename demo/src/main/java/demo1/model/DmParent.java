package demo.model;

import agilesites.annotations.Type;
import agilesites.api.AgileAsset;

/**
 * Declaring a parent type for flex families
 */
@Type(flexAttribute = "DemoAttribute",
        flexContent = "DemoContentDefinition",
        flexParent = "DemoParentDefinition")
public class DmParent
        extends AgileAsset {
}
