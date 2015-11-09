package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;
import COM.FutureTense.Interfaces.IList;
import agilesites.api.Api;
import agilesites.api.AssetTag;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by msciab on 23/08/15.
 */
public class SqlService implements Service {


    @Override
    public String exec(HttpServletRequest req, ICS ics, HttpServletResponse res) throws Exception {

        String tables = ics.GetVar("tables");
        String sql = ics.GetVar("sql");
        String out = Api.tmp();
        StringBuffer err = new StringBuffer();

        int limit = -1;
        try {
            limit = Integer.parseInt(ics.GetVar("limit"));
        } catch (Exception ex) {
        }
        ics.SQL(tables, sql, out, limit, false, err);

        StringBuffer result = new StringBuffer();
        IList list = ics.GetList(out);
        if (list == null)
            return "error=" + err.toString();

        for (int i = 1; i <= list.numRows(); i++) {
            result.append("[[").append(tables).append("#").append(i).append("]]\n");
            list.moveTo(i);
            for (int j = 0; j < list.numColumns(); j++) {
                String name = list.getColumnName(j);
                result.append(name).append("=").append(list.getValue(name)).append("\n");
            }
        }
        return result.toString();
    }
}
