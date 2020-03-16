<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.base.*,
                tidemedia.cms.util.*,
                tidemedia.cms.user.*,
                java.util.*,
                org.json.*,
                java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
        int channelId       = getIntParameter(request,"channelid");
        HashMap map_doc=new HashMap();
        map_doc.put("Title","分割线");
        map_doc.put("code","cutoffrule");
		map_doc.put("tidecms_addGlobal", "1");
        ItemUtil.addItem(channelId, map_doc);
 
%>
