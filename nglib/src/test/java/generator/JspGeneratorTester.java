package generator;

import agilesites.api.Picker;
import agilesites.api.JspGenerator;

/**
 * Created by msciab on 17/10/15.
 */

public class JspGeneratorTester implements JspGenerator {

    @Override
    public String generateJsp(Picker p) {
        return new BeanHelper(p)
                .putTitle(p.replace("#string"))
                .html();
    }
}
