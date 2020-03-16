<%@ page import="tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*,java.sql.*,tidemedia.cms.base.*,tidemedia.cms.scheduler.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
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
	int		ContinueNewDocument	= getIntParameter(request,"ContinueNewDocument");
	int		NoCloseWindow		= getIntParameter(request,"NoCloseWindow");//不关闭窗口
	//int	AutoSave			= getIntParameter(request,"AutoSave");//自动保存

	int		Approve				= getIntParameter(request,"Approve");
	int		ItemID				= getIntParameter(request,"ItemID");
	int     title_repeat_config	= CmsCache.getParameter("sys_checktitle").getIntValue();//重复标题监测
	
	if(title_repeat_config==1){
		
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
			values2 = WordUtil.processHotword(values2);
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
	tidemedia.cms.system.Document doc = new tidemedia.cms.system.Document(gid);
	int status = doc.getStatus();
	String title = doc.getValue("Title");

	if(Approve==1){//提交审核
		ApproveAction aa = new ApproveAction();
		aa.setTitle(title);
		aa.setParent(gid);
		aa.setUserid(doc.getUser());
		aa.setAction(0);
		aa.setApproveId(0);
		aa.setEndApprove(0);
		aa.Add();
	}

	if(close_window_type==0) close_window_type = 1;
	String message = document.getMessage();
	if(NoCloseWindow==1)
	{
		//自动保存 不关闭窗口
		out.println("{\"id\":\""+document.getId()+"\",\"channelid\":\""+ChannelID+"\"}");
	}
	else
	{
		if(message.length()>0)
		{
			out.println("{\"message\":\""+message+"\"}");
		}
		else
		{
			out.println("{\"message\":\"\"}");	
		}
	}
}
%>
