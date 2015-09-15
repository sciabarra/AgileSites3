package ngdemo.element;

import agilesites.api.HTML;
import ngdemo.element.page.NgPageHomeLayout;
import org.junit.Test;

import java.util.Scanner;

import static org.junit.Assert.*;

/**
 * Created by msciab on 14/09/15.
 */
public class NgPageHomeLayoutTest {
    @Test
    public void test1() {
        String s = new Scanner(NgPageHomeLayoutTest.class.getResourceAsStream("/demo/index.html"), "UTF-8").useDelimiter("\\A").next();
        //String s = NgPageHomeLayout.ngPageHomeLayout(HTML.load("/demo/index.html"));
        System.out.println(s);
    }

}
