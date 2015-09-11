package demo.element;

import agilesites.annotations.CSElement;
import agilesites.api.*;
import static agilesites.api.Api.*;

@CSElement
public class DmError implements Element {

    final static Log log = Log.getLog(DmError.class);

    @Override
    public String apply(Env e) {
        if (log.debug())
            log.debug("Demo Error");

        return Picker.load("/demo/simple.html", "#content")
                .html(model(arg("Title", "Error"),
                        arg("Text", e.getString("error"))));
    }
}
