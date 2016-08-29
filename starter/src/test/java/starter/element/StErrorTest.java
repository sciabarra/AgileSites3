package starter.element;

import static org.mockito.Mockito.*;
import static wcs.Api.*;
import wcs.api.*;
import org.junit.Before;
import org.junit.Test;
import wcs.java.util.TestElement;

public class StErrorTest extends TestElement {

	Env env = mock(Env.class);
	StError it;

	@Before
	public void setUp() {
        when(env.getString("error")).thenReturn("Hello, world");
		it = new StError();
	}

	@Test
	public void test() {
		// parse element in a custom env
		parse(it.apply(env));
		// check the result
		assertText("#detail p", "Hello, world");
	}
}
