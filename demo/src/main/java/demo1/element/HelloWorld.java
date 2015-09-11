package demo.element;

import agilesites.annotations.Controller;

import java.util.Map;

/**
 * Created by msciab on 09/09/15.
 */
@Controller
public class HelloWorld {

    public void doWork(Map models) {
        models.put("hello", "world");
    }
}
