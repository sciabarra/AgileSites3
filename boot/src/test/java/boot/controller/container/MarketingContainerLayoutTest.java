package boot.controller.container;

import agilesitesng.api.AssetAttribute;
import boot.model.container.MarketingContainer;
import com.fatwire.services.beans.AssetIdImpl;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.modules.junit4.PowerMockRunner;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.when;

/**
 * Created by jelerak on 15/02/2016.
 */
@RunWith(PowerMockRunner.class)
public class MarketingContainerLayoutTest extends ASControllerTest<MarketingContainerLayout> {


    MarketingContainerLayout layout;


    @Before
    public void setup() throws Exception {
        layout = super.setUp(MarketingContainerLayout.class);
        when(buildersFactoryMock.getAssetId()).thenReturn(new AssetIdImpl("BootContainer", 0L));
        MarketingContainer marketingContainer = new MarketingContainer();
        marketingContainer.marketingItems = new AssetAttribute[]{
                new AssetAttribute("MarketingBlock", 0L),
                new AssetAttribute("MarketingBlock", 1L)
        };
        when(contentFactoryMock.load(any())).thenReturn(marketingContainer);

    }

    @Test
    public void testDoWork() throws Exception {
        Map models = new HashMap<String, Object>();
        layout.doWork(models);
        assertNotNull(models.get("MarketingContainer"));
        MarketingContainer container = (MarketingContainer) models.get("MarketingContainer");
        assertEquals(container.marketingItems.length, 2);
        assertNotNull(models.get("marketingBlockFragments"));
        List list = (List) models.get("marketingBlockFragments");
        assertEquals(list.size(), 2);
    }

}