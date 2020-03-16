<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,tidemedia.cms.publish.*,java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!	public  String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("GBK");
			String temp = new String(temp_t, "iso-8859-1");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}
%>


<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int flag = getIntParameter(request,"flag");

int num1 = 0;
int num2 = 0;
int num3 = 0;
int num4 = 0;
int channel_num = 0;

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();

if(flag==1)
{
	Sql = "delete from publish_task where Status=1";
	tu.executeUpdate(Sql);
	//out.println("清空发布任务.");

	Sql = "delete from publish_item where Status=1";
	tu.executeUpdate(Sql);
	//out.println("清空发布过的文件.");

	response.sendRedirect("manager.jsp");return;
}
else if(flag==2)
{
	PublishManager.getInstance().setCopyfile(new CopyFile());
	response.sendRedirect("manager.jsp");return;
}
else if(flag==3)
{
	PublishManager.getInstance().setPublishagent(new PublishAgent());
	response.sendRedirect("manager.jsp");return;
}
else if(flag==4)
{
	ConcurrentHashMap channels = CmsCache.getChannels();
	channels.clear();
	response.sendRedirect("manager.jsp");return;
}
else if(flag==5)
{
	System.gc();
	response.sendRedirect("manager.jsp");return;
}
else if(flag==6)
{

Sql = "select count(*) from publish_task where Status=1";
Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	num1 = Rs.getInt(1);
}
tu.closeRs(Rs);

Sql = "select count(*) from publish_task where Status=0";
Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	num2 = Rs.getInt(1);
}
tu.closeRs(Rs);

Sql = "select count(*) from publish_item where Status=1";
Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	num3 = Rs.getInt(1);
}
tu.closeRs(Rs);

Sql = "select count(*) from publish_item where Status!=1";
Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	num4 = Rs.getInt(1);
}
tu.closeRs(Rs);

ConcurrentHashMap channels = CmsCache.getChannels();
channel_num = channels.size();

String desc1 = "没有运行";
CopyFile cf = PublishManager.getInstance().getCopyfile();
if(cf!=null && cf.getRunner()!=null)
	desc1 = "正在运行,运行时间："+(System.currentTimeMillis()-cf.getStart_time())/1000+",发布文件：" + PublishManager.getInstance().getCopyingFileName();

String desc2 = "没有运行";
CopyFile cf2 = PublishManager.getInstance().getCopyfile2();
if(cf2!=null && cf2.getRunner()!=null)
	desc2 = "正在运行,运行时间："+(System.currentTimeMillis()-cf2.getStart_time())/1000+",发布文件：" + PublishManager.getInstance().getCopyingFileName();

int mb = 1024*1024;
%>
完成的任务数量：<%=num1%><br>
未完成的任务数量：<%=num2%><br>
发布过的文件数量：<%=num3%><br>
未发布的文件数量：<%=num4%><br>
发布队列一：<%=desc1%><br>
发布队列二：<%=desc2%><br>
缓存频道数量：<%=channel_num%>
<br>

<br><br>总内存：<%=Runtime.getRuntime().totalMemory()/mb%>M&nbsp;&nbsp;空闲内存：<%=Runtime.getRuntime().freeMemory()/mb%>M <a href="manager.jsp?flag=5">强制GC</a>
<%}else{%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="../common/jquery.js"></script>
</head>
<body>
<div id="msg"></div>
<script>
function load()
	{
		$("#msg").load("manager.jsp?flag=6"); 
	}
setInterval(load, 2000);
</script>
<a href="manager.jsp?flag=1">清空</a> <a href="manager.jsp?flag=2">重置文件上传进程</a> <a href="manager.jsp?flag=3">重置模板发布进程</a> <a href="manager.jsp?flag=4">初始化缓存</a>
</body>
</html>
<%}%>