package agilesites.annotations;
//NOTE if you change this class copy it also in the plugin!

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by msciab on 14/06/15.
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.SOURCE)
public @interface AttributeEditor {
    String value() default "";
    String description() default "";
    int priority() default 95;
}
