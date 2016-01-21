package agilesites.annotations;

import java.lang.annotation.*;

/**
 * Created by msciab on 11/08/15.
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.CLASS)
public @interface FlexType {

    String name();

    String parentType();

}
