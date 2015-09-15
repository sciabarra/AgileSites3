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
    public String value() default "";

    public String select() default "";

    public String description() default "";

    public boolean layout() default false;

    public String type() default "";

    public String subtype() default "false";

    public String ssCache() default "false";

    public String csCache() default "";

    public String extraCriteria() default "";

    public String criteria() default "";
}
