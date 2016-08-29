package starter.element;

import wcs.java.util.TestRunnerElement;
import wcs.java.util.Util;
import agilesites.annotations.CSElement;
import agilesites.annotations.SiteEntry;

@SiteEntry
@CSElement
public class StTester extends TestRunnerElement {
	@Override
	public Class<?>[] tests() {
		return Util.classesFromResource(starter.Config.site.toLowerCase(), "tests.txt");
	}
}
