 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>

<%
//获取帖子转发继续阅读列表接口
String callback=getParameter(request,"callback");
JSONObject oo = new JSONObject();

try{
	int SiteId		= getIntParameter(request,"site");//站点id
	int num			= getIntParameter(request,"num");//查询数量
	int globalid	= getIntParameter(request,"globalid");//帖子id
	if(num==0){
        num=3;
    }

	if(SiteId==0||globalid==0){
		oo.put("status",500);
		oo.put("message","请确认参数是否正确");
	}else{

		JSONArray list = new JSONArray();
		
		Document doc = CmsCache.getDocument(globalid);
		String table = doc.getChannel().getTableName();
		String sql = "select * from " + table + " where Active=1 and GlobalID!="+globalid+" order by id desc limit "+num;
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
        while(rs.next()) {			
			String Title=convertNull(rs.getString("Title"));
			int GlobalID = rs.getInt("GlobalID");
			String PublishDate	= convertNull(rs.getString("PublishDate"));
			PublishDate=Util.FormatDate("MM-dd HH:mm",PublishDate);
			String Photo = convertNull(rs.getString("Photo"));
			Document document = CmsCache.getDocument(GlobalID);
            String shareurl = document.getHttpHref();
			
			JSONObject o = new JSONObject();
			o.put("title",Title);
			o.put("globalid",GlobalID);
			o.put("date",PublishDate);
			o.put("photo",Photo);
			o.put("shareurl",shareurl);

			list.put(o);
        } 
        tu.closeRs(rs);
		
		oo.put("list",list);
		oo.put("message","获取成功！");
        oo.put("status",200);
	}
}catch(Exception e){
		oo.put("message","接口调用失败，请检查传值参数");
		oo.put("status",500);
}
if(callback!=null&&callback!=""){
	out.println(callback+"("+oo.toString()+")");
}else{
	out.println(oo.toString());
}
    	 
%>