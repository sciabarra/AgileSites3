package boot.model.block;

import agilesites.annotations.Attribute;
import agilesites.annotations.ContentDefinition;
import agilesites.annotations.FindStartMenu;
import agilesites.annotations.NewStartMenu;
import agilesitesng.api.BlobAttribute;
import boot.model.BootContent;

/**
 * Created by jelerak on 12/02/2016.
 */
@NewStartMenu("Block: Employee")
@FindStartMenu("Block: Employee")
@ContentDefinition(flexAttribute = "BootAttribute",
        flexContent = "BootContentDefinition",
        flexParent = "BootParentDefinition")
public class EmployeeBlock extends BootContent{

    @Attribute(value = "Employee name")
    public String employeeName;

    @Attribute(value = "Job Title")
    public String jobTitle;

    @Attribute(value = "Profile")
    public String employeeProfile;

    @Attribute(value = "Profile Image")
    public BlobAttribute profileImage;


}
