<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.TideJson,
				org.json.JSONObject,
				java.util.*"%>
<%@ page contentType="text/json;charset=utf-8" %>
<%@ include file="../../../config.jsp"%>
<%
	int id = getIntParameter(request,"id");
	TideJson tj = CmsCache.getParameter("sys_vote_channel").getJson();
	int option = tj.getInt("option_channelid");
	String formurl=tj.getString("submit_url");
	
	StringBuffer html = new StringBuffer();
	
	Document doc = new Document(id);
	String title = doc.getTitle();
	int gid = doc.getGlobalID();
	html.append("<form id='vote_"+gid+"' action='"+formurl+"' method='post' name='vote_"+gid+"'>");
	html.append("<input type='hidden' name='globalid' value='"+gid+"'>");
	html.append("<input type='hidden' name='channel' value='"+doc.getChannelID()+"'>");
	//<dl><dt>연변장백산팀 vs 북경리공 에서 골을 넣을것 같은 연변팀 선수는?</dt><dd><label><input type="radio" name="optionid" value="37">하태균</label></dd><dd><label><input type="radio" name="optionid" value="38">스티브</label></dd><dd><label><input type="radio" name="optionid" value="39">차얼둔</label></dd><dd><label><input type="radio" name="optionid" value="40">리훈</label></dd><dd><label><input type="radio" name="optionid" value="41">김파</label></dd><dd><label><input type="radio" name="optionid" value="42">손군</label></dd><dd><label><input type="radio" name="optionid" value="43">최민</label></dd></dl>
	html.append("<dl><dt>"+doc.getTitle()+"</dt>");
	
	List<Document> list = ItemUtil.listItems(option," where Parent ="+gid+" and Active=1");
	for(Document document : list)
	{
		String option_title = document.getTitle();	
		html.append("<dd><label><input type='radio' name='option' value='"+document.getGlobalID()+"'>"+document.getTitle()+"</label></dd>");
	}
	html.append("<dt><input type='submit' value='投票' id='submit'></dt>");
	html.append("</form>");
	System.out.println(html.toString());
	JSONObject obj = new JSONObject();
	obj.put("html",html.toString());
	out.println(obj.toString());
%>