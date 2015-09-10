package agilesites.annotations;

import java.lang.annotation.*;

/**
 * Created by msciab on 14/06/15.
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.CLASS)
//@Repeatable(FindStartMenus.class)
public @interface FindStartMenu {

    String value();

    String description() default "";

    String assetType() default "";

    String assetSubtype() default "";

    String defaultValues() default "";

}

