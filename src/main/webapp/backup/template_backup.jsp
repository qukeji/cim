<%@ page import="java.io.*,
				 tidemedia.cms.util.*,
				 tidemedia.cms.system.*,
				 tidemedia.cms.base.TableUtil,
				 java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

	     /**
		  * 用途 ：备份模板    
		  *	1，丁文豪   20150402      增加操作记录日志
		  * 2. 丁文豪   20150416      备份路径改为从参数获取
		  * 3. 丁文豪    20150417      修改程序，如果没有配置备份路径，写入日志，程序返回 
		  */

		if(!userinfo_session.isAdministrator())
		{
			response.sendRedirect("../noperm.jsp");
			return;
		}

	
		TideJson tj = CmsCache.getParameter("sys_backup_cfg").getJson();
		String   backuppath  = tj.getString("db_path");
		
	    if(backuppath.equals(""))
	    {
			Log.SystemLog("备份中心", "操作失败,没有配置备份路径");
			return;
	    }
		TableUtil tu = new TableUtil();	
		String Sql = "select * from template_files";
		ResultSet Rs = tu.executeQuery(Sql);
		StringBuilder buf=new StringBuilder();
		
		while(Rs.next())
		{
			int id = Rs.getInt("id");
			String FileName = convertNull(Rs.getString("FileName"));
			String Content = convertNull(Rs.getString("Content"));
			int GroupID = Rs.getInt("GroupID");
			buf.append("-----------------------------------------------------------\r\n");
			buf.append("id:"+ id+"\r\n");
			buf.append("FileName:"+ FileName+"\r\n");
			buf.append("Content:"+ Content+"\r\n");
			buf.append("-----------------------------------------------------------\r\n");
		}
		
		String RealPath=backuppath+"/template_"+Util.getCurrentDate("yyyyMMdd_HHmmss")+".txt";
		File file=new File(RealPath);
		file.createNewFile();
		BufferedWriter ot = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(RealPath,false),"utf-8"));	
		ot.write(buf.toString(),0,buf.toString().length());
		ot.close();
	    //增加操作记录
	    Log l = new Log();
		l.setFromType("backup");
        l.setTitle("template_"+Util.getCurrentDate("yyyyMMdd_HHmmss")+".txt");
	    l.setUser(userinfo_session.getId());
	    l.setLogAction(404);
	    l.Add();

%>
