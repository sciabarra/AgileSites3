package agilesites.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by msciab on 14/06/15.
 */
@Target({ElementType.METHOD,ElementType.TYPE})
@Retention(RetentionPolicy.CLASS)
public @interface SiteEntry {

    public String name () default "";

    public String description() default "";

    public String ssCache() default "false";

    public String csCache() default "false";

    public String criteria() default "";

    public String extraCriteria() default "";

    public boolean wrapper() default false;

    public String elementName() default "";

}
