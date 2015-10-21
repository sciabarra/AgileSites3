package generator;

import agilesites.api.Picker;

/**
 * Created by msciab on 21/10/15.
 */
public class JspGeneratorTest {

    @org.junit.Test
    public void testName() throws Exception {
        Picker p = Picker.load("/generator/template.html");
        JspGeneratorTester t = new JspGeneratorTester();
        System.out.println(t.generateJsp(p));
    }
}
