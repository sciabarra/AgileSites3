package agilesites.api;

/**
 * Helper class to execute an action with injected data
 */
public class PickerInjector {

    public static final int REPLACE = 1;
    public static final int AFTER = 2;
    public static final int BEFORE = 3;
    public static final int ATTR = 4;
    public static final int APPEND = 5;

    private int action = 0;
    private String where = null;
    private String arg = null;

    public PickerInjector(int action, String where, String arg) {
        this.action = action;
        this.where = where;
        this.arg = arg;
    }

    public PickerInjector(int action, String where) {
        this(action, where, null);
    }

    public PickerInjector(int action) {
        this(action, null, null);
    }

    public void inject(Picker picker, String what) {
        switch (action) {
            case REPLACE:
                picker.replace(where, what);
                break;
            case AFTER:
                picker.after(where, what);
                break;
            case BEFORE:
                picker.before(where, what);
                break;
            case ATTR:
                picker.attr(where, what, arg);
                break;
            case APPEND:
                picker.append(what);
                break;
            default:
                throw new RuntimeException("Initialized with an unknow action "+action);
        }
    }
}
