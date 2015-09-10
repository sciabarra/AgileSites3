package agilesites.api;

import org.apache.log4j.Logger;

/**
 * Log class that logs to a socket if available. This class is a layer on top of
 * Log4J but it is used in order to change implementation if needed at some
 * point.
 *
 * @author msciab
 */
public class Log {

    private Logger logger = null;

    private Log(Logger logger) {
        this.logger = logger;
    }

    /**
     * Log a trace level message - Use message as a format string for the other
     * args.
     * @param message    to log
     * @param args to the message
     */
    public void trace(String message, Object... args) {
        trace(null, message, args);
    }

    /**
     * @return if trace level is enabled
     */
    public boolean trace() {
        return logger.isTraceEnabled();
    }

    /**
     * Log an exception then a trace level message - Use message as a format
     * string for the other args.
     * @param exception  the exception
     * @param message the message
     * @param args arguments to the message
     */
    public void trace(Throwable exception, String message, Object... args) {
        if (logger != null)
            logger.trace(args.length > 0 ? String.format(message, args)
                    : message, exception);
    }

    /**
     * @return if debug level is enabled
     */
    public boolean debug() {
        return logger.isDebugEnabled();
    }

    /**
     * Write a debug message - Use message as a format string for the other
     * args.
     * @param message the message
     * @param args arguments to the message
     */
    public void debug(String message, Object... args) {
        debug(null, message, args);
    }

    /**
     * Log an exception then a debug level message - Use message as a format
     * string for the other args.
     * @param ex  the exception
     * @param message the message
     * @param args arguments to the message
     */
    public void debug(Throwable ex, String message, Object... args) {
        // System.out.println("[DEBUG]" + className + message + e2s(ex));
        if (logger != null && logger.isDebugEnabled())
            logger.debug(args.length > 0 ? String.format(message, args)
                    : message, ex);
    }

    /**
     * Log an info level message - Use message as a format string for the other
     * args.
     * @param message the message
     * @param args arguments to the message
     */
    public void info(String message, Object... args) {
        info(null, message, args);
    }

    /**
     * Log an exception then an info level message - Use message as a format
     * string for the other args.
     * @param ex  the exception
     * @param message the message
     * @param args arguments to the message
     */
    public void info(Throwable ex, String message, Object... args) {
        // System.out.println("[ INFO]" + className + message + e2s(ex));
        if (logger != null)
            logger.info(args.length > 0 ? String.format(message, args)
                    : message, ex);
    }

    /**
     * @return if info level is enabled
     */
    public boolean info() {
        return logger.isInfoEnabled();
    }

    /**
     * Log a warn level message - Use message as a format string for the other
     * args.
     * @param message the message
     * @param args arguments to the message
     */
    public void warn(String message, Object... args) {
        warn(null, message, args);
    }

    /**
     * Log an exception then a warn level message - Use message as a format
     * string for the other args.
     * @param ex  the exception
     * @param message the message
     * @param args arguments to the message
     */
    public void warn(Throwable ex, String message, Object... args) {
        // System.out.println("[WARN ]" + className + String.format(message,
        // args) + e2s(ex));
        if (logger != null)
            logger.warn(args.length > 0 ? String.format(message, args)
                    : message, ex);
    }

    /**
     * Log an error level message - Use message as a format string for the other
     * args.
     * @param message the message
     * @param args arguments to the message
     */

    public void error(String message, Object... args) {
        error(null, message, args);
    }

    /**
     * Log an exception then a error level message - Use message as a format
     * string for the other args.
     * @param ex  the exception
     * @param message the message
     * @param args arguments to the message
     *
     */
    public void error(Throwable ex, String message, Object... args) {
        // System.out.print("[ERROR]" + className + String.format(message, args)
        // + e2s(ex));
        if (logger != null)
            logger.error(args.length > 0 ? String.format(message, args)
                    : message, ex);
    }

    /**
     * Get a logger by name
     *
     * @param className to get the logger for
     * @return the logger
     */
    public static Log getLog(String className) {
        Logger logger;
        if (className != null)
            logger = Logger.getLogger(className);
        else
            logger = Logger.getRootLogger();
        return new Log(logger);
    }

    /**
     * Get a logger by class
     *
     * @param clazz to get the logger for
     * @return the logger
     */
    public static Log getLog(Class<?> clazz) {
        return getLog(clazz == null ? null : clazz.getCanonicalName());
    }

}
