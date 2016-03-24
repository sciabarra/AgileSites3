package boot.controller.container;

import agilesitesng.api.ASAsset;
import agilesitesng.api.ASContentController;
import agilesitesng.api.ContentFactory;
import boot.model.container.MarketingContainer;
import com.fatwire.assetapi.data.AssetId;
import com.fatwire.assetapi.data.BuildersFactory;
import com.fatwire.assetapi.fragment.EditableTemplateFragment;
import com.fatwire.assetapi.fragment.ElementFragment;
import com.fatwire.assetapi.fragment.Fragment;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.junit.Assert.*;

/**
 * Created by jelerak on 16/02/2016.
 */
@RunWith(PowerMockRunner.class)
public class ASControllerTest<T extends ASContentController> {

    T controller;

    @Mock
    public ContentFactory contentFactoryMock;

    @Mock
    public BuildersFactory buildersFactoryMock;

    public T setUp(Class<T> clazz) throws Exception {
        controller = PowerMockito.spy(clazz.newInstance());
        controller.setCf(contentFactoryMock);
        controller.setReaderFactory(buildersFactoryMock);
        PowerMockito.doReturn(new MockEditableTemplateFragment()).when(controller, "newEditableTemplateFragment");
        PowerMockito.doReturn(new MockEditableTemplateFragment()).when(controller, "newElementFragment");
        return controller;
    }

    public class MockEditableTemplateFragment implements EditableTemplateFragment {
        @Override
        public EditableTemplateFragment setEmptyText(String s) {
            return this;
        }

        @Override
        public EditableTemplateFragment setTitle(String s) {
            return this;
        }

        @Override
        public EditableTemplateFragment setStyles(String s) {
            return this;
        }

        @Override
        public EditableTemplateFragment addButtons(String s, String... strings) {
            return this;
        }

        @Override
        public EditableTemplateFragment addEditorRoles(String s, String... strings) {
            return this;
        }

        @Override
        public EditableTemplateFragment addLegalTypes(String s, String... strings) {
            return this;
        }

        @Override
        public EditableTemplateFragment editField(String s) {
            return this;
        }

        @Override
        public EditableTemplateFragment editField(String s, int i) {
            return this;
        }

        @Override
        public EditableTemplateFragment editAsset(String s, String s1, String s2) {
            return this;
        }

        @Override
        public EditableTemplateFragment editAsset(String s, Long aLong, String s1) {
            return this;
        }

        @Override
        public EditableTemplateFragment editAsset(AssetId assetId, String s) {
            return this;
        }

        @Override
        public EditableTemplateFragment editAsset(String s, String s1, String s2, int i) {
            return this;
        }

        @Override
        public EditableTemplateFragment editAsset(String s, Long aLong, String s1, int i) {
            return this;
        }

        @Override
        public EditableTemplateFragment editAsset(AssetId assetId, String s, int i) {
            return this;
        }

        @Override
        public EditableTemplateFragment setSlotname(String s) {
            return this;
        }

        @Override
        public EditableTemplateFragment setVariant(String s) {
            return this;
        }

        @Override
        public EditableTemplateFragment forContext(String s) {
            return this;
        }

        @Override
        public com.fatwire.assetapi.fragment.TemplateFragment forAsset(String s, String s1) {
            return this;
        }

        @Override
        public com.fatwire.assetapi.fragment.TemplateFragment forAsset(String s, Long aLong) {
            return this;
        }

        @Override
        public com.fatwire.assetapi.fragment.TemplateFragment forAsset(AssetId assetId) {
            return this;
        }

        @Override
        public com.fatwire.assetapi.fragment.TemplateFragment useTemplate(String s) {
            return this;
        }

        @Override
        public com.fatwire.assetapi.fragment.TemplateFragment useDevice(String s) {
            return this;
        }

        @Override
        public com.fatwire.assetapi.fragment.TemplateFragment resolveDevice(boolean b) {
            return this;
        }

        @Override
        public com.fatwire.assetapi.fragment.TemplateFragment useStyle(Style style) {
            return this;
        }

        @Override
        public com.fatwire.assetapi.fragment.TemplateFragment useArguments(String s, String... strings) {
            return this;
        }

        @Override
        public com.fatwire.assetapi.fragment.TemplateFragment setArguments(String s) {
            return this;
        }

        @Override
        public com.fatwire.assetapi.fragment.TemplateFragment inSite(String s) {
            return this;
        }

        @Override
        public com.fatwire.assetapi.fragment.TemplateFragment invokeFrom(String s) {
            return this;
        }

        @Override
        public com.fatwire.assetapi.fragment.TemplateFragment addArgument(String s, String s1) {
            return this;
        }
    }

    public class MockElementFragment implements ElementFragment {
        @Override
        public ElementFragment useElement(String s) {
            return null;
        }

        @Override
        public ElementFragment useArguments(String s, String... strings) {
            return null;
        }

        @Override
        public ElementFragment addArgument(String s, String s1) {
            return null;
        }

        @Override
        public ElementFragment scopeAs(Scope scope) {
            return null;
        }
    }
}