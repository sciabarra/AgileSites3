package generator;

import agilesites.api.Content;
import agilesites.api.Picker;
import agilesites.api.PickerInjector;

/**
 * Created by msciab on 17/10/15.
 */
public class BeanHelper {

    private Picker picker;

    public BeanHelper(Picker picker) {
        this.picker = picker;
    }

    public BeanHelper putTitle(PickerInjector injector) {
        injector.inject(picker, "${a.Title}");
        return this;
    }

    public String html(Content...args) {
        return picker.html(args);
    }
}
