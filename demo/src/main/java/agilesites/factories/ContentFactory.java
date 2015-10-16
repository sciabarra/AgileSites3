package agilesites.factories;

//FIXME temporary solution to deploy lib classes as controllers

import agilesites.annotations.Controller;

/**
 * Created by jelerak on 15/10/2015.
 */
@Controller
public class ContentFactory<T> {

    public T load(Class<T> clazz, long cid, String c) {
        T t = null;
        try {
            t = clazz.newInstance();

        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return t;
    }
}
