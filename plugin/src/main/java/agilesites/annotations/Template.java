package agilesites.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by msciab on 14/06/15.
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.CLASS)
public @interface Template {
    public String name () default "";

    public String description() default "";

    public String from() default "";

    public String pick() default "";

    public String forType() default "";

    public String forSubtype() default "";

    public String controller() default "";

    public boolean layout() default false;

    public boolean external() default false;

    public String ssCache() default "false";

    public String csCache() default "false";

    public String criteria() default "";

    public String extraCriteria() default "";

    public int priority() default 60;
}
