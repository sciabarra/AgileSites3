package starter.test;
import static wcs.Api.*;

import starter.element.StError;
import wcs.api.*;
import wcs.java.util.TestElement;
import org.junit.Before;
import org.junit.Test;

@Index("starter/tests.txt")
public class StErrorTest extends TestElement {

	StError it;

	@Before
	public void setUp() {
		it = new StError();
	}

	@Test
	public void test() {

		// parse element in a custom env
		parse(it.apply(env(arg("error", "Hello, world"))));

		// check the result
		assertText("#detail p", "Hello, world");
	}

}
