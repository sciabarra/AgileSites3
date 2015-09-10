package agilesites.api;

//import COM.FutureTense.Interfaces.IList;

import java.io.CharArrayWriter;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

/**
 * Collections of utils supporting common idioms.
 * <p/>
 * You need to import static wcs.core.Common.* to use them.
 *
 * @author msciab
 */
public class Api {
    private static long tmpVarCounter = System.currentTimeMillis();

    /**
     * Generate an unique temporary var name.
     */
    public synchronized static String tmp() {
        ++tmpVarCounter;
        return "_" + Long.toHexString(tmpVarCounter);
    }

    /**
     * Create an arg holder
     *
     * @param name of the arg
     * @param value of the arg
     * @return the arg object
     */
    public static Arg arg(String name, String value) {
        return new Arg(name, value);
    }

    /**
     * Create list of args
     *
     * @param name of the arg
     * @param values of the arg
     * @return the multiple args object
     */
    public static Args args(String name, String... values) {
        return new Args(name, values);
    }


    /**
     * Create an array of Arg from a list of strings in the form key=value
     * Allows a simple call argv("a", "1", "b", "2") instead of (args(arg("a","1"),arg("b","2"))
     *
     * @param args alternate key / value string args
     * @return a list of args
     */
    public static Arg[] argv(String... args) {
        List<Arg> ls = new ArrayList<Arg>();
        for (String arg : args) {
            int pos = arg.indexOf("=");
            if (pos == -1)
                ls.add(new Arg(arg, ""));
            else
                ls.add(new Arg(arg.substring(0, pos), arg.substring(pos + 1)));
        }
        return ls.toArray(new Arg[0]);
    }

    /**
     * Create an id
     *
     * @param c the content type
     * @param cid the content id
     * @return the id object
     */
    public static Id id(String c, Long cid) {
        return new Id(c, cid);
    }

    /**
     * Create an encoded call
     */
    public static String call(String name, Arg... args) {
        return Call.encode(name, args);
    }

    /**
     * Create an encoded call from a list of args
     */
    public static String call(String name, List<Arg> args) {
        return Call.encode(name, args);
    }

    /**
     * Guarantee a string will never be null, if parameters is null then it will
     * be returned as the empty string.
     *
     * @param s
     * @return the string or an empty string if the parameter is null
     */
    public static String nn(String s) {
        return s == null ? "" : s;
    }

    /**
     * If null returns the alternative otherwise the object
     *
     * @param obj
     * @param alt
     * @return the alt if null otherwise the obj
     */
    public static Object ifn(Object obj, Object alt) {
        return obj == null ? alt : obj;
    }

    // formatter for fatwire format
    private static SimpleDateFormat fmt = new SimpleDateFormat(
            "yyyy-MM-dd HH:mm:ss");

    /**
     * Convert as a date, null if error
     */
    public static java.util.Date toDate(String s) {
        if (s != null) {
            try {
                return fmt.parse(s);
            } catch (Exception e) {
            }
        }
        return null;
    }

    /**
     * Convert to a long, null if errors
     */
    public static Long toLong(String l) {
        if (l == null)
            return null;
        try {
            long ll = Long.parseLong(l);
            return new Long(ll);
        } catch (NumberFormatException ex) {
            return null;
        } catch (Exception ex) {
            // log.warn(ex, "unexpected");
        }
        return null;
    }

    /**
     * Convert to a double, null if errors
     */
    public static Double toDouble(String l) {
        if (l == null)
            return null;
        try {
            double dd = Double.parseDouble(l);
            return new Double(dd);
        } catch (NumberFormatException ex) {
            return null;
        } catch (Exception ex) {
            // log.warn(ex, "unexpected");
        }
        return null;
    }


    /**
     * Convert to int, null if erros
     */
    public static Integer toInt(String l) {
        if (l == null)
            return null;
        try {
            int ll = Integer.parseInt(l);
            return new Integer(ll);
        } catch (NumberFormatException ex) {
        } catch (Exception ex) {
            // log.warn(ex, "unexpected");
        }
        return null;
    }



    /**
     * Stream an exceptions in a string
     */
    public static String ex2str(Throwable ex) {
        CharArrayWriter caw = new CharArrayWriter();
        ex.printStackTrace(new PrintWriter(caw));
        return caw.toString();
    }

    /**
     * Print on standard output
     */
    public static void out(String message, Object... args) {
        System.out.println(args.length > 0 ? String.format(message, args)
                : message);
    }

    /**
     * Get a logger by name
     *
     * @param className
     * @return
     */
    public static Log getLog(String className) {
        return Log.getLog(className);
    }

    /**
     * Get a logger by class
     *
     * @param clazz
     * @return
     */
    public static Log getLog(Class<?> clazz) {
        return Log.getLog(clazz);
    }


    /**
     * Create a Model with args
     */
    public static Model model(Arg... args) {
        return new Model(args);
    }

    /**
     * Create a Model extending an existing model
     */
    public static Model model(Model m, Arg... args) {
        return new Model(m, args);
    }


}
