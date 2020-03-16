<%@ page import="tidemedia.cms.util.*,
				java.io.File,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
     /**
	  * 用途 ：删除模板备份或者数据库备份  
	  *	1. 丁文豪   20150402      增加操作记录日志
	  * 2. 丁文豪    20150416  将获取备份文件目录改为系统参数获取
	  * 3. 丁文豪    20150417      修改程序，如果没有配置备份路径，写入日志，程序返回 
	  */

	String filenames = getParameter(request,"files");
	TideJson tj = CmsCache.getParameter("sys_backup_cfg").getJson();
	String   backuppath  = tj.getString("db_path");
	String[] files = filenames.split(",");
	
    if(backuppath.equals(""))
    {
		 Log.SystemLog("备份中心", "操作失败，没有配置备份路径");
	     return;
		
    }
	
	for(int i=0;i<files.length;i++)
	{
		File file = new File(backuppath+"/"+files[i]);
		
		if(file.isFile())
		{
			file.delete();
		    //  增加删除日志
		    Log l = new Log();
            l.setTitle(file.getName());
			l.setFromType("backup");
	        l.setUser(userinfo_session.getId());
	        if(file.getName().contains("sql")) 
	        	l.setLogAction(724); 
	        else 
	        	l.setLogAction(405);
	        l.Add();
		}
		 
	 }

%>
	