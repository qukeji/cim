<%@ page import="tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*,java.sql.*,tidemedia.cms.base.*"%>
<%@ page contentType="text/html;charset=gb2312" %>
<%@ include file="../config.jsp"%>
<%
/**
* 用途：内容页提交程序
* 1,李永海 20140101 创建
* 2,此文件编码必须是ANSI
* 3,曲科籍  20160825 专门为敏感词热词准备
* 4,
* 5,
*/
String Action = getParameter(request,"Action");
//WordUtil.initSensitiveword();//设置初始化
WordUtil.initHotkeyword();//设置初始化
//System.out.println("----设置初始化"+WordUtil.sensitiveword_init+"============="+WordUtil.hotkeyword_init);
if(!Action.equals(""))
{
	int		ChannelID			= getIntParameter(request,"ChannelID");
	int		close_window_type	= getIntParameter(request,"Close_Window_Type");
	String	RelatedItemsList	= getParameter(request,"RelatedItemsList");
	int ContinueNewDocument	= getIntParameter(request,"ContinueNewDocument");
	int NoCloseWindow		= getIntParameter(request,"NoCloseWindow");//不关闭窗口
	//int	AutoSave			= getIntParameter(request,"AutoSave");//自动保存

	int		ItemID				= getIntParameter(request,"ItemID");
	boolean chongfu = false;
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
			values2 = values2;
		}

		map.put(name,values2);
	}
	tidemedia.cms.system.Document document = new tidemedia.cms.system.Document();
	document.setRelatedItemsList(RelatedItemsList);
	document.setChannelID(ChannelID);
	document.setUser(userinfo_session.getId());
	document.setModifiedUser(userinfo_session.getId());
	//gid = document.getGlobalID();	
	if(Action.equals("Add"))
	{//2013-07-15 15:41:34
		document.AddDocument(map);
	}
	if(Action.equals("Update"))
	{
		document.UpdateDocument(map);		
	}
	gid = document.getGlobalID();
	//SetPublishJobUtil job = new SetPublishJobUtil();
	//SetRemoveJobUtil job2 = new SetRemoveJobUtil();
	tidemedia.cms.system.Document doc = new tidemedia.cms.system.Document(gid);
	int status = doc.getStatus();
	String spd = Util.convertNull(doc.getValue("SetPublishDate"));
	String spd2 = Util.convertNull(doc.getValue("Revoketime"));
	String title = doc.getValue("Title");
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
	if(close_window_type==0) close_window_type = 1;
	String message = document.getMessage();

	if(NoCloseWindow==1) message = "no close window";
	//if(AutoSave==1) message = "auto save";
	if(message.length()>0){
		out.println("{\"message\":\""+message+"\"}");
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
