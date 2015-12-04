package agilesitesng.api;

import agilesites.annotations.Controller;

@Controller
public class BlobAttribute {

    public BlobAttribute(String url) {
        this.url = url;
    }

    public BlobAttribute(String url, String name) {
        this.url = url;
        this.name = name;
    }

    public String url;

    private String name;

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url=url;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}

