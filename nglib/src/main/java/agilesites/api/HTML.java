package agilesites.api;

import jodd.jerry.Jerry;
import java.util.Scanner;

/**
 *
 */
public class HTML extends Jerry {

    public HTML(String html) {
        super(Jerry.jerry(html));
    }

    public static HTML load(String res) {
        return new HTML(new Scanner(HTML.class.getResourceAsStream(res), "UTF-8").useDelimiter("\\A").next());
    }
}
