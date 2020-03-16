 <%@ page import="tidemedia.cms.system.*,
                  java.util.*,
				  tidemedia.cms.util.*,
				  java.sql.*,
				  tidemedia.cms.base.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@page import="org.json.JSONObject"%>
<%@ include file="../config.jsp"%>
<%
/**
* 用途：内容页提交程序
* 1,李永海 20140101 创建
* 2,此文件编码必须是ANSI
* 3,
* 4,
* 5,
*/
String Action = getParameter(request,"Action");
if(!Action.equals(""))
{
	int		ChannelID			= getIntParameter(request,"ChannelID");
	int		close_window_type	= getIntParameter(request,"Close_Window_Type");
	String	RelatedItemsList	= getParameter(request,"RelatedItemsList");

	int		ItemID				= getIntParameter(request,"ItemID");
	/*boolean chongfu = false;
	String Title = getParameter(request,"Title");
	TableUtil tu = new TableUtil();
	Channel channel = CmsCache.getChannel(ChannelID);
	String sql = "select id from " + channel.getTableName() + " where Title='" + tu.SQLQuote(Title) + "' and Active=1 and id!="+ItemID;
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next())
	{
		chongfu = true;
	}
	tu.closeRs(rs);
	if(chongfu)
	{
		out.println("{\"message\":\"标题已经存在\"}");
		return;
	}
*/
	int gid=0;

	HashMap map = new HashMap();
	Enumeration enumeration = request.getParameterNames();
	while(enumeration.hasMoreElements()){
		String name=(String)enumeration.nextElement();
		String values[] = request.getParameterValues(name);
		String values2 = "";
		if(values!=null)
		{
			if(values.length==1)
				values2 = values[0];
			else
				values2 = Util.ArrayToString(values,",");
		}

		if(name.equals("Content"))
		{
			//处理热词
			values2 = WordUtil.processHotword(values2);
		}

		map.put(name,values2);
	}
	tidemedia.cms.system.Document document = new tidemedia.cms.system.Document();
	document.setRelatedItemsList(RelatedItemsList);
	document.setChannelID(ChannelID);
	document.setUser(userinfo_session.getId());
	gid = document.getGlobalID();	
	int resultflag = 0;
	if(Action.equals("Update"))
	{
		resultflag = document.UpdateDocument(map);		
	}
	System.out.println("穿过document.UpdateDocument"+map);
	System.out.println("穿过document"+document);
	if(Action.equals("Add"))
	{//2013-07-15 15:41:34
		resultflag = document.AddDocument(map);
	}
	//判断操作是否成功
		if(resultflag==0){
			out.println("{\"message\":\"无权限进行此操作\"}");
			return;
		}else if(resultflag==2){
			out.println("{\"message\":\"保存没有成功，请重新尝试。\"}");
			return;
		}else if(resultflag==3){
			out.println("{\"message\":\"内容存在敏感词。\"}");
			return;
		}
	gid = document.getGlobalID();
	//SetPublishJobUtil job = new SetPublishJobUtil();
	//SetRemoveJobUtil job2 = new SetRemoveJobUtil();
	document = new tidemedia.cms.system.Document(gid);
    int status = document.getStatus();
	if(status==1)
	{
			StringBuffer xml = new StringBuffer("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>");
			//HashMap<String,String> map_push = new HashMap<String,String>();
			String content = "",audience_type_ = "all",audience = "all";
			int type = document.getIntValue("type");
			int audience_type = document.getIntValue("audience_type");

			//获取第三方平台密钥	
			Channel channel = CmsCache.getChannel(ChannelID);
			int SiteID = channel.getSiteID();
			String sql = "select packagename,bundleid,android_secrect_key,ios_secrect_key from channel_threadmanager where Active=1 and siteflag="+SiteID;
			TableUtil tu = new TableUtil();
			ResultSet rs = tu.executeQuery(sql);
			String package_name = "";
			String bundleid = "";
			String android_secret_key = "";
			String ios_secret_key = "";
			if(rs.next()){
				package_name = convertNull(rs.getString("packagename"));
				bundleid = convertNull(rs.getString("bundleid"));
				android_secret_key = convertNull(rs.getString("android_secrect_key"));
				ios_secret_key = convertNull(rs.getString("ios_secrect_key"));
			}
			tu.closeRs(rs);

			//获取是否允许评论
			String sql1 = "select allowcomment from channel_docshowconfig where Active=1 and siteflag="+SiteID;
			TableUtil tu1 = new TableUtil();
			ResultSet rs1 = tu1.executeQuery(sql1);
			int allowcomment = 0;
			if(rs1.next()){
				allowcomment = rs1.getInt("allowcomment");
			}
			tu1.closeRs(rs1);

//			TideJson json = CmsCache.getParameter("sys_push").getJson();
		 
//			String appkey = json.getString("appkey");
//			String masterkey = json.getString("masterkey");
					
			//if(type==1)
			//{//通知
			
			//}
			if(type==2)
			{
				//消息
				content = document.getContent();
				//map_push.put("content",document.getContent());//消息内容
			}

			if(audience_type==0)
			{
				audience = document.getValue("device_tag");
				audience_type_ = "tag";
			}
			else if(audience_type==1)
			{
				audience = document.getValue("device_alias");
				audience_type_ = "alias";
			}
			else if(audience_type==2)
			{
				audience = document.getValue("device_tag");
				audience_type_ = "registration";
			}
/*			
			if(audience_type==2)
			{
				audience = document.getValue("device_tag");
				audience_type_ = "tag";
			}
			else if(audience_type==3)
			{
				audience = document.getValue("device_alias");
				audience_type_ = "alias";
			}
			else if(audience_type==4)
			{
				audience = document.getValue("registration");
				audience_type_ = "registration";
			}
*/
			String Summary=Util.XMLQuote(document.getValue("Summary"));
			boolean Summary_bl = Summary.equals("");

//			System.out.println(document.getValue("device_tag").equals(""));
			
			xml.append("<push>");

			xml.append("<platform>"+document.getValue("platform")+"</platform>");
			xml.append("<object>"+document.getIntValue("audience_type")+"</object>");//0所有人,1别名,2序列号
			xml.append("<value>"+(document.getValue("device_tag").equals("")?"":document.getValue("device_tag"))+"</value>");
			xml.append("<title>"+document.getTitle()+"</title>");
			xml.append("<summary>"+Util.XMLQuote(document.getValue("Summary"))+"</summary>");
			xml.append("<desc>"+(Summary_bl?document.getTitle():Summary)+"</desc>");
			xml.append("<extra>"+"{\"globalid\":\""+document.getIntValue("source_gid")+"\",\"title\":\""+document.getTitle()+"\",\"url\":\""+document.getValue("source_url")+"\",\"Photo\":\""+document.getValue("Photo")+"\",\"frame\":\""+document.getValue("frame")+"\",\"jumptype\":\""+document.getValue("jumptype")+"\",\"secondcategory\":\""+document.getValue("secondcategory")+"\",\"doc_type\":\""+document.getValue("doc_type")+"\",\"sharepicurl\":\""+document.getValue("sharepicurl")+"\",\"audio\":\""+document.getValue("audio")+"\",\"allowcomment\":\""+allowcomment+"\"}"+"</extra>");
			xml.append("<time>0</time>");
			xml.append("<badge>0</badge>");
			xml.append("<beat>"+document.getValue("develop")+"</beat>");//0是正式环境，1是测试环境
			xml.append("<package_name>"+package_name+"</package_name>");// android是包名
			xml.append("<bundleid>"+bundleid+"</bundleid>");// ios为bundelid
			xml.append("<android_secret_key>"+android_secret_key+"</android_secret_key>");
			xml.append("<ios_secret_key>"+ios_secret_key+"</ios_secret_key>");
			xml.append("<project>"+CmsCache.getCompany()+"</project>");

/*			xml.append("<type>"+type+"</type>");
			xml.append("<id>"+document.getIntValue("source_gid")+"</id>");
			xml.append("<url>"+document.getValue("source_url")+"</url>");
			xml.append("<alert>"+document.getTitle()+"</alert>");
			xml.append("<audience>"+audience+"</audience>");
			xml.append("<develop>"+document.getIntValue("develop")+"</develop>");
			xml.append("<id>"+document.getIntValue("source_gid")+"</id>");
*/			
			xml.append("</push>");

			String result = Util.postHttpUrl("http://cloud.tidedemo.com:888/cms_cloud/push/mi_push_log.jsp",xml.toString());
//			System.out.println("推送结果："+result);
			JSONObject obj = new JSONObject(result);
			map.put("state",obj.get("state"));
			map.put("xiaoxiID",obj.getString("Summary"));
	        ItemUtil. updateItem(ChannelID,  map, gid,userinfo_session.getId());
			//document.UpdateDocument(map);
			//boolean result = Push.send(map_push,type,gid);
	}
	String spd = Util.convertNull(document.getValue("SetPublishDate"));
	String spd2 = Util.convertNull(document.getValue("Revoketime"));
	//String title = doc.getValue("Title");
	spd=spd.replace(".0","");
	spd2=spd2.replace(".0","");
	/*
	if(status==0&&spd!=null&&spd.length()>0&&Util.getCalendar(spd,"yyyy-MM-dd HH:mm").getTimeInMillis()>System.currentTimeMillis()){
		//必须是草稿状态 一次判断 不为null，length，时间
		job.setPublishJob(gid);
	}
	if(spd2!=null&&spd2.length()>0&&Util.getCalendar(spd2,"yyyy-MM-dd HH:mm").getTimeInMillis()>System.currentTimeMillis()){
		//必须是已发状态 一次判断 不为null，length，时间
		job2.setPublishJob2(gid);
	}*/
	int ContinueNewDocument	= getIntParameter(request,"ContinueNewDocument");
	int NoCloseWindow		= getIntParameter(request,"NoCloseWindow");
	if(close_window_type==0) close_window_type = 1;
	String message = document.getMessage();
	if(message.length()>0){
		out.println("{\"message\":\"\"}");	
		//out.println("{\"message\":\""+message+"\"}");
	}else {
		out.println("{\"message\":\"\"}");	
	}
	/*
	if(ContinueNewDocument==1)
		response.sendRedirect("document.jsp?ContinueNewDocument=1&ItemID=0&ChannelID="+ChannelID);
		
	else if(NoCloseWindow==1)
		response.sendRedirect("document.jsp?NoCloseWindow=1&ItemID=" + document.getId() + "&ChannelID="+ChannelID);
	else
		response.sendRedirect("../close_pop.jsp?Type="+close_window_type);
		*/
}
%>
