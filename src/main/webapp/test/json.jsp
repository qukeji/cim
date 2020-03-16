<%@ page import="org.json.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*,tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String json = "";//"{\"setting\":{\"autoPlay\":true,\"loop0\":false,\"width\":700,\"interactionMode1\":1,\"speed1\":-1,\"allowZoom\":true,\"fileExtension\":\"png\",\"loop1\":true,\"height\":525,\"interactionMode0\":0,\"fileExtensionZoom\":\"png\",\"speed0\":1},\"hotSpots\":[{\"id\":0,\"action\":\"openDetail?clickwheel.XSS\",\"name\":\"click wheel\",\"position\":\"0,11,454,138\"},{\"id\":1,\"action\":\"openDetail?headphone.flv\",\"name\":\"headphone\",\"position\":\"0,11,418,153\"}],\"media\":{\"n0\":1,\"init1\":0,\"init0\":0,\"n1\":30,\"step1\":2},\"type\":\"XObjectVR\",\"ctrler\":{\"type\":\"float\",\"preset\":\"minimal\"},\"name\":\"man reading newspaper\"}";
//JSONArray jsonArray = new JSONArray(json);
json = getParameter(request,"json");
if(!json.equals(""))
{
JSONObject oo = new JSONObject(json);
String title = oo.getString("name");
//out.print(o.getString("hotSpots"));
JSONArray jsonArray = new JSONArray(oo.getString("hotSpots"));
TableUtil tu = new TableUtil();
ResultSet rs = null;
int itemid = 0;
String sql = "select id from channel_s21_a where Title='" + tu.SQLQuote(title) + "'";
rs = tu.executeQuery(sql);
if(rs.next())
{
	itemid = rs.getInt("id");
}
tu.closeRs(rs);

if(itemid>0)
	{
		for(int i = 0;i<jsonArray.length();i++)
		{
			JSONObject o = jsonArray.getJSONObject(i);
			int id = Util.parseInt(o.getString("id"))+1;
			String po = o.getString("position");

			sql = "update channel_s21_a set position"+id+"='" + po + "' where id=" + itemid;
			tu.executeUpdate(sql);

			out.println(title+" ok...");
		}

		Document document = new Document();
		document.setUser(userinfo_session.getId());
		document.Publish(itemid+"",4562);
	}
}
%>
<form action="json.jsp" method="post">
<textarea name="json" cols=86 rows=14></textarea><br>
<input type="submit"> &nbsp;&nbsp;<input type="button" value="ХіМы" onClick="">
</form>
