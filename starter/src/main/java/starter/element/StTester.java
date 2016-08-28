package starter.element;


import agilesites.annotations.CSElement;
import agilesites.annotations.SiteEntry;
import starter.Config;
import wcs.java.util.TestRunnerElement;
import wcs.java.util.Util;

@SiteEntry
@CSElement
public class StTester extends TestRunnerElement {

	@Override
	public Class<?>[] tests() {
		// all the tests of the suite
		return Util.classesFromResource(Config.site.toLowerCase(), "tests.txt");
	}
}
