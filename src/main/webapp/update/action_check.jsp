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
    int itemid = getIntParameter(request, "itemid");
	int siteid = getIntParameter(request, "siteid");

    TideJson update_api = CmsCache.getParameter("update_api").getJson();
    String url = "";
    String token = "";
    if (update_api != null) {
        url = update_api.getString("url");
        token = update_api.getString("token");
    } else {
        url = "http://jushi.tidemedia.com/cms/update_api/";
        token = "tidemedia";
    }
    String result = "";
	result = Util.connectHttpUrl(url + "action_details.jsp?token=" + token + "&itemId=" + itemid,"UTF-8");
	//System.out.println(result);

	JSONObject jsonObject = new JSONObject(result);
    String checkSql = jsonObject.getString("checkSql");
    String db = jsonObject.getString("db");
	int selectSite = jsonObject.getInt("selectSite");

	if(selectSite==1)
	{
		if(siteid==0)
		{
			out.println("请先选择站点");
			return;
		}
	}
	
    if(checkSql.contains("-1")){
        out.println("不需要检测");
    }else if(checkSql.toLowerCase().startsWith("select")){
        TableUtil tu = null;
        if(db.equals("用户库")){
            tu = new TableUtil("user");
        }else{
            tu = new TableUtil();
        }
		checkSql = checkSql.replace("{$site}",siteid+"");
		System.out.println(checkSql);
        ResultSet rs = tu.executeQuery(checkSql);
        String res = "";
        while(rs.next()){
            res = rs.getString(1);
        }
        tu.closeRs(rs);
        out.println(res);
    }
	else
	{
		out.println("检测语句不符合要求");
	}
%>