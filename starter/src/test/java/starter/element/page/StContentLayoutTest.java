package starter.element.page;

import org.junit.Before;
import org.junit.Test;
import wcs.api.Asset;
import wcs.api.Env;
import wcs.java.util.TestElement;
import static org.mockito.Mockito.*;

public class StContentLayoutTest extends TestElement {
	Env e = mock(Env.class);
	Asset a = mock(Asset.class);
	StContentLayout it;

	@Before
	public void setUp() {
		when(e.getAsset()).thenReturn(a);
		when(a.editString("stTitle")).thenReturn("Home");
		when(a.editString("stSubtitle")).thenReturn("Home Page");
		when(a.editString(eq("stTeaserTitle"), eq(1), anyString())).thenReturn("First Teaser");
		when(a.editString(eq("stTeaserTitle"), eq(2), anyString())).thenReturn("Second Teaser");
		when(a.editString(eq("stTeaserText"), eq(1), anyString())).thenReturn("First Teaser Text");
		when(a.editString(eq("stTeaserText"), eq(2), anyString())).thenReturn("Second Teaser Text");
		it = new StContentLayout();
	}

	@Test
	public void test() {
		parse(it.apply(e));
		assertText("#title", "Home");
		assertText("#subtitle", "Home Page");
		assertText("#teaser-title1", "First Teaser");
		assertText("#teaser-title2", "Second Teaser");
		assertText("#teaser-body1", "First Teaser Text");
		assertText("#teaser-body2", "Second Teaser Text");
	}
}
