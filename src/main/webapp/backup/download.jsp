<%@ page import="java.io.*,
 				 tidemedia.cms.util.*,
    			 tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%  

     /**
	  * 用途 ：下载模板备份或者数据库备份
	  *	1. 丁文豪   20150402      增加操作记录日志
	  * 2. 丁文豪    20150416      将获取备份文件目录改为参数获取，同时删掉了很多代码，这些代码不合逻辑
	  * 3. 丁文豪    20150417      修改程序，如果没有配置备份路径，写入日志，程序返回 
	  */

	if(!userinfo_session.isAdministrator())
	{ 
		response.sendRedirect("../noperm.jsp");
	    return;
	}
	
	String	Type		= getParameter(request,"Type");
	String	FileName	= getParameter(request,"FileName");
	String	Charset		= getParameter(request,"Charset");	  
	TideJson tj=CmsCache.getParameter("sys_backup_cfg").getJson();
	String   backuppath  =tj.getString("db_path");
	
    if(backuppath.equals(""))
    {
       Log.SystemLog("备份中心", "下载失败，没有配置备份路径");
	   return;
    }
    
	FileUtil fileutil = new FileUtil(); 
	fileutil.setActionuser(userinfo_session.getId());

	if(!FileName.equals(""))
	{
		String[] files = Util.StringToArray(FileName,","); 
		if(files!=null && files.length>0)
		{
			out.clear();
			out=pageContext.pushBody();		
			fileutil.downloadBackupFile(request,response,Util.ClearPath(backuppath + "/" + files[0]),"csv/downloadable",files[0]);
		    // 增加至操作日志
			Log l = new Log();
            l.setTitle(files[0]);
			l.setFromType("backup");
	        l.setUser(userinfo_session.getId());
	        // 区分 下载模板还是下载数据库备份
	        if(FileName.contains("sql"))
	           l.setLogAction(722);
	        else
	           l.setLogAction(406);
	        l.Add();
		}
	}


%>
