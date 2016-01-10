package agilesites.annotations;

import java.lang.annotation.*;

/**
 * Created by msciab on 14/06/15.
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.CLASS)
//@Repeatable(NewStartMenus.class)
public @interface NewStartMenu {

    String value();

    String description() default "";

    String assetType() default "";

    String assetSubtype() default "";

    String defaultValues() default "";

    String[] args() default {};

    public int priority() default 110;
}

