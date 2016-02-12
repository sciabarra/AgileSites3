package boot.controller.content;

import agilesites.annotations.Controller;
import agilesites.annotations.Groovy;
import agilesites.annotations.Template;
import agilesites.api.Picker;
import agilesitesng.api.ASContentController;
import boot.model.block.Project;
import boot.model.block.ProjectHelper;
import com.fatwire.assetapi.fragment.EditableTemplateFragment;

import java.util.Map;

/**
 * Created by jelerak on 02/02/2016.
 */
@Controller
public class ProjectDetail extends ASContentController<Project> {

    @Template(from = "boot/portfolio-item.html", layout = true, forType = "BootContent", forSubtype = "Project")
    public String projectDetail(Picker p, ProjectHelper helper) {
        p.single(".img-portfolio").replaceWith(".img-portfolio", helper.editFragment("imageDetailFragment"));
        return p.outerHtml();
    }

    public void doWork(Map models) {
        super.doWork(models);
        @Groovy("def project = this.load()")
        Project project = this.load();
        EditableTemplateFragment<?> imageDetailFragment = newEditableTemplateFragment()
                .useTemplate("imageDetail")
                .setEmptyText("[ Drop Image ]")
                .forAsset(project.smallProjectImage.getAssetId())
                .editField(project.smallProjectImage.getName());


        models.put("imageDetailFragment", imageDetailFragment);

    }

}
