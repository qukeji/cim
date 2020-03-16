<%@ page import="java.util.List,
				tidemedia.cms.util.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%> 
<%!
	 /**
	  * 用途 ：数据库备份
	  *	1、丁文豪   20150402      增加操作记录日志
	  * 2.丁文豪    20150416  将获取备份文件目录 由defaultSite.getBackupFolder()----->系统参数获取
	  * 3.丁文豪    20150416			修改程序，如果没有配置备份路径，写入日志，程序返回
	  * 
	  */

	public void cmd(String[] cmd)
	{
	    try
		{
			java.lang.Runtime.getRuntime().exec(cmd);		 
		}
		catch(Exception e)
		{
 			System.out.println(e.getMessage());
		}
	}
	
%>
<%
	String dbname[]=request.getParameterValues("dbname");
	TideJson tj=CmsCache.getParameter("sys_backup_cfg").getJson();
	String   backuppath  =tj.getString("db_path");
	
	if(backuppath.equals(""))
	{
		Log.SystemLog("备份中心", "操作失败，没有配置备份路径");
		return;
    }
	
	if(!userinfo_session.isAdministrator())
	{ 
		response.sendRedirect("../noperm.jsp");
		return;
	}
	
	if(!backuppath.equals(""))
	{  
		String dateFormat = Util.getCurrentDate("yyyyMMdd_HHmmss");	 
		
		for(int i=0;i<dbname.length;i++)
		{
			String[] s1 = {"sh","-c", "mysqldump "+dbname[i]+">"+backuppath+"/"+dbname[i].substring(dbname[i].lastIndexOf(" ")+1)+"_"+dateFormat+".sql"};//windows
			cmd(s1);
			// 增加日志
			String  sqlPath =dbname[i].substring(dbname[i].lastIndexOf(" ")+1)+"_"+dateFormat+".sql";
			Log l = new Log();
	        l.setTitle(sqlPath);
			l.setFromType("backup");
	        l.setUser(userinfo_session.getId());
	        l.setLogAction(711);
	        l.Add();
		}
		
	}
%>
<script>
	top.TideDialogClose({refresh:'right'});
</script>