package starter.element;

import agilesites.annotations.CSElement;
import agilesites.annotations.SiteEntry;
import wcs.api.*;
import wcs.java.Element;
import wcs.java.Picker;

import static wcs.Api.arg;
import static wcs.Api.model;

@CSElement
public class StError extends Element {

    @Override
    public String apply(Env e) {
        return Picker.load("/starter/simple.html", "#content")
                .html(model(arg("Title", "Error"),
                        arg("Text", e.getString("error"))));

    }

}
