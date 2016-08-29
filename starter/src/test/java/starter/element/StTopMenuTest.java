package starter.element;

import org.junit.Before;
import org.junit.Test;
import wcs.api.Asset;
import wcs.api.Env;
import wcs.api.Id;
import wcs.api.SitePlan;
import wcs.java.util.TestElement;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * Created by msciab on 29/08/16.
 */
public class StTopMenuTest extends TestElement {
    Id homeId = new Id("Page", 1l);
    Id aboutId = new Id("Page", 2l);
    Id[] ids = new Id[]{homeId, aboutId};
    Asset home = mock(Asset.class);
    Asset about = mock(Asset.class);
    Env env = mock(Env.class);
    SitePlan sp = mock(SitePlan.class);
    StTopMenu it = new StTopMenu();

    @Before
    public void setUp() {
        when(env.getSitePlan()).thenReturn(sp);
        when(sp.children()).thenReturn(ids);
        when(env.getAsset(homeId)).thenReturn(home);
        when(env.getUrl(homeId)).thenReturn("/");
        when(env.getAsset(aboutId)).thenReturn(about);
        when(env.getUrl(aboutId)).thenReturn("/about");
        when(home.getName()).thenReturn("Home");
        when(about.getName()).thenReturn("About");
    }

    @Test
    public void test() {
        // parse element in a custom env
        parse(it.apply(env));
        assertText("a:eq(0)", "Home");
        assertText("a:eq(1)", "About");
    }
}