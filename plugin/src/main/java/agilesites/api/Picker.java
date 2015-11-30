package agilesites.api;

/**
 * Created by msciab on 29/11/15.
 */
public interface Picker {
    Picker select(String where);

    Picker up();

    Picker replace(String where, String what);

    Picker remove(String where);

    Picker single(String where);

    Picker empty(String where);

    Picker empty();

    String html(Content...content);

    Picker removeAttrs(String where, String... attrs);

    String innerHtml(Content...content);

    String outerHtml(Content...content);

    Picker before(String where, String what);

    Picker after(String where, String what);

    Picker append(String where, String what);

    Picker append(String where);

    Picker attr(String where, String attr, String what);

    Picker prefixAttrs(String where, String attr, String prefix);

    Picker addClass(String where, String what);

    Picker replaceWith(String where, String what);

    PickerInjector replace(String where);

    PickerInjector after(String where);

    PickerInjector before(String where);

    PickerInjector attr(String where, String attr);

    PickerInjector append();

    //String call(String what);

}
