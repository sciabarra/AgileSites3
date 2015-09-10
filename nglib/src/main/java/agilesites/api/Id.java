package agilesites.api;

/**
 * Simple Unique id (c and cid) holder class
 *
 * @author msciab
 */
public class Id {

    public String c;
    public Long cid;

    public Id(String c, Long cid) {
        this.c = c;
        this.cid = cid;
    }

    /**
     * Check if 2 id refers to the same asset
     */
    public boolean equals(Object o) {
        if (o instanceof Id) {
            Id id = (Id) o;
            return id.c != null && id.cid != null && c != null && cid != null && id.c.equals(c) && id.cid.equals(cid);
        }
        return false;
    }


    public String toString() {
        return c + ":" + cid.toString();
    }

}
