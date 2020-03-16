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
	 <table class="table mg-b-0" id="content-table">
            <thead>
              <tr>                
                <th class="tx-12-force tx-mont tx-medium">&nbsp;</th>                             
              </tr>
            </thead>
            <tbody>	   
              <tr>   
                <td> 
                	<span class="mg-r-10">待发布模板任务：<a class="mg-r-3" href="../publish/publish_task2018.jsp?Status=0"><%=num2%></a>(<a href="../publish/publish_task2018.jsp?Status=0"><%=num22%></a>)</span> 
                	<span class="mg-r-10">已发布模板任务：<a class="mg-r-3" href="../publish/publish_task2018.jsp?Status=1"><%=num1%></a></span> 
                	<span class="">正在发布模板任务：<a class="mg-r-3" href="../publish/publish_task2018.jsp?Status=2"><%=num222%></a></span> 
                </td>               
              </tr>
              <tr>   
                <td>               
                	<span class="mg-r-10">待分发文件：<a class="mg-r-3" href="../publish/publish_task_custom2018.jsp?Status=0"><%=num4_prepaer%></a></span> 
                	<span class="mg-r-10">已分发文件：<a class="mg-r-3" href="../publish/publish_task_custom2018.jsp?Status=1"><%=num4_approved%></a></span>
                	<span class="mg-r-10">正在分发：<a class="mg-r-3" href="../publish/publish_task_custom2018.jsp?Status=2"><%=num4_approving%></a></span>
                	<span class="mg-r-10">分发失败：<a class="mg-r-3" href="../publish/publish_task_custom2018.jsp?Status=3"><%=num4_approvefaild%></a></span>                	
                </td>               
              </tr>
              <tr>   
                <td> 
                	<span class="mg-r-10">模板发布线程总数量：<%=TemplatePublishAgent.getMax_thread_number()%> </span> 
                	<span class="mg-r-10">当前模板发布线程数量：<%=TemplatePublishAgent.getPublishing_thread_number()%></span>
                	<span class="mg-r-10">当前信息：<%=TemplatePublishAgent.getMessage()%></span>             	
                </td>               
              </tr>
              <tr>                	
                <td> 
                	<span class="mg-r-10">文件分发线程总数量：<%=FilePublishAgent.getMax_thread_number()%></span> 
                	<span class="mg-r-10">当前文件分发线程数量：<%=FilePublishAgent.getCopying_thread_number()%> </span>
                	<span class="mg-r-10">FTP连接池：<%=ftp_size%></span>
                 	<span class="mg-r-10">当前信息：<%=FilePublishAgent.getMessage()%></span>  
                 <!--	<span class="mg-r-10">本次0个分发，0个已经在发，最后一个：</span>       -->           	
                </td>               
              </tr>
              <tr>                	
                <td> 
                	<span class="mg-r-10">总内存：<%=Runtime.getRuntime().totalMemory()/mb%>M</span> 
                	<span class="mg-r-10">空闲内存：<%=Runtime.getRuntime().freeMemory()/mb%>M</span>
                	<span class="mg-r-10">缓存频道数量：<%=channel_num%></span>               	
                </td>               
              </tr>
              <tr>                	
                <td> 
                	<span class="mg-r-10">模板正在生成文件：<%=template_files%> </span>                 	          	
                </td>               
              </tr>
              <tr>                	
                <td> 
                	<span class="mg-r-10">正在分发文件1：<%=copy_files1%></span>                 	          	
                </td>               
              </tr>
              <tr>                	
                <td> 
                	<span class="mg-r-10">正在分发文件2：<%=copy_files2%></span>                 	          	
                </td>               
              </tr>
			  <tr>                	
                <td> 
                	<span class="mg-r-10">发布方案监控进程：<%=PublishSchemeAgent.getMessage()%> </span>                 	          	
                </td>               
              </tr>
             <tr>                	
                <td> 
                	<span class="mg-r-10">采集引擎：线程数量：<%=SpiderAgent.getMax_thread_number()%> </span>                 	          	                 
                  <span class="mg-r-10">正在运行：<%=SpiderAgent.getRunning_thread_number()%></span>
                  <span class="mg-r-10">信息：<%=SpiderAgent.getMessage()%></span>  
                </td>				  
              </tr>
            </tbody>
          </table>
          <div id="tide_content_tfoot" style="">
          	
          </div>
<%
	}%>