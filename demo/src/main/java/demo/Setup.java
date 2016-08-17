package demo;

import wcs.api.Log;
import wcs.java.model.ElementImporter;
import wcs.java.model.StaticImporter;
import wcs.java.util.Util;
import COM.FutureTense.Interfaces.ICS;
import COM.FutureTense.Interfaces.IList;

public class Setup extends wcs.java.Setup {

    private static Log log = Log.getLog(Setup.class);

    @Override
	public Class<?>[] getAssets() {
           return Util.classesFromResource(Config.site, "elements.txt");
	}
}
