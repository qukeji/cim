<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				java.util.*,
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
int num22 = 0;
int num222 = 0;//正在发布模板任务
int num3 = 0;
int num4 = 0;
int num4_prepaer=0;
int num4_approved=0;
int num4_approving=0;
int num4_approvefaild=0;
int channel_num = 0;

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();
%>

<%
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

	Sql = "select count(*) from publish_task where Status=0 and CanPublishTime<=UNIX_TIMESTAMP()";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num2 = Rs.getInt(1);
	}
	tu.closeRs(Rs);

	num22 = tu.getNumber("select count(*) from publish_task where Status=0 and CanPublishTime>UNIX_TIMESTAMP()");
	num222 = tu.getNumber("select count(*) from publish_task where Status=2");

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
	//待发布
	Sql="select count(*) from publish_item where Status=0 or Status=2 ";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num4_prepaer = Rs.getInt(1);
	}
	tu.closeRs(Rs);
	//发布完成
	Sql="select count(*) from publish_item where Status=1 ";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num4_approved = Rs.getInt(1);
	}
	tu.closeRs(Rs);
	//正在发布
	Sql="select count(*) from publish_item where Status=3 ";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num4_approving = Rs.getInt(1);
	}
	tu.closeRs(Rs);
	//发布失败
	Sql="select count(*) from publish_item where Status=4 ";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		num4_approvefaild = Rs.getInt(1);
	}
	tu.closeRs(Rs);
	
	ConcurrentHashMap channels = CmsCache.getChannels();
	channel_num = channels.size();

	int mb = 1024*1024;

	String file = "";
	HashMap h = PublishManager.getInstance().publishingFiles;
	file = (String)h.get("1");

	ArrayList ftps = FtpManager.getFtps();//数据库连接池
    int ftp_size=ftps.size();//数据库连接池数量

	String template_files = "";
	String copy_files1 = "";
	String copy_files2 = "";

	ConcurrentHashMap publishing_files_2016 = PublishManager.getInstance().getPublishing_files_2016();
	Iterator entrys = publishing_files_2016.entrySet().iterator();  
	int j = 1;
	while (entrys.hasNext()) {                
            Map.Entry entry = (Map.Entry) entrys.next();                
            String key = (String)entry.getKey();  
			template_files = template_files + "<br>" + (j++) + " " + (String)key; 
    }   

	
	ConcurrentHashMap copying_files_2016 = PublishManager.getInstance().getCopying_files_2016();
	entrys = copying_files_2016.entrySet().iterator();  
	while (entrys.hasNext()) {                
            Map.Entry entry = (Map.Entry) entrys.next();                
            String key = (String)entry.getKey();  
			copy_files1 = copy_files1 + "," + (String)key; 
    } 

	j = 1;
	ConcurrentHashMap copying_files2_2016 = FilePublishAgent.getCopying_files2_2016();
	entrys = copying_files2_2016.entrySet().iterator();  
	while (entrys.hasNext()) {                
            Map.Entry entry = (Map.Entry) entrys.next();                
            String key = (String)entry.getKey();  
			//copy_files2 = copy_files2 + "," + (String)key; 
			copy_files2 = copy_files2 + "<br>" + (j++) + " " + key; 
    } 

	%>
	<table width="100%" border="0" class="view_table">
	  <tr>
		<th scope="col"> </th>
	  </tr>

	<!--  <tr>
		<td>发布过的文件数量：</td>
	  </tr>-->
	  <tr>
		<td>   待发布模板任务：<a href="../publish/publish_task.jsp?Status=0"><%=num2%>(<%=num22%>)</a>      已发布模板任务：<a href="../publish/publish_task.jsp?Status=1"><%=num1%></a>      正在发布模板任务：<a href="../publish/publish_task.jsp?Status=2"><%=num222%>
		</td> 
	  </tr>
	  <tr>
		<td>   待分发文件：<a href="../publish/publish_task_custom.jsp?Status=0"><%=num4_prepaer%></a>      已分发文件：<a href="../publish/publish_task_custom.jsp?Status=1"><%=num4_approved%></a>      正在分发：<a href="../publish/publish_task_custom.jsp?Status=2"><%=num4_approving%></a>      分发失败：<a href="../publish/publish_task_custom.jsp?Status=3"><%=num4_approvefaild%></a></td> 
	  </tr>
	  <tr>
	  <td>模板发布引擎 线程总数量：<%=TemplatePublishAgent.getMax_thread_number()%>           当前线程数量：<%=TemplatePublishAgent.getPublishing_thread_number()%> 当前信息：<%=TemplatePublishAgent.getMessage()%></td>
	  </tr>
	  <tr>
	  <td>文件分发引擎 线程总数量：<%=FilePublishAgent.getMax_thread_number()%>           当前线程数量：<%=FilePublishAgent.getCopying_thread_number()%>     FTP连接池： <%=ftp_size%> 当前信息：<%=FilePublishAgent.getMessage()%></td>
	  </tr> 

	  <tr>
		<td>模板正在生成文件：<%=template_files%></td>
	  </tr>
	  <tr>
		<td>正在分发文件1：<%=copy_files1%></td>
	  </tr>
	  <tr>
		<td>正在分发文件2：<%=copy_files2%></td>
	  </tr>
	  <tr>
		<td>发布方案监控进程：<%=PublishSchemeAgent.getMessage()%></td>
	  </tr>
	  <tr>
		<td>采集引擎：线程数量：<%=SpiderAgent.getMax_thread_number()%> 正在运行：<%=SpiderAgent.getRunning_thread_number()%> 信息：<%=SpiderAgent.getMessage()%></td>
	  </tr>
	  <tr>
		<td>总内存：<%=Runtime.getRuntime().totalMemory()/mb%>M 空闲内存：<%=Runtime.getRuntime().freeMemory()/mb%>M 缓存频道数量：<%=channel_num%></td>
	  </tr>
	</table>
<%
	}%>