package agilesites.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by msciab on 14/06/15.
 */
@Target({ElementType.METHOD,ElementType.TYPE})
public @interface CSElement {
    public String name() default "";

    public String description() default "";

    public String from() default "";

    public String pick() default "";
}
