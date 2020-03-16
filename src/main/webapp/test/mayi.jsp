<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.*,
				java.util.ArrayList,
				java.io.*,java.net.*,java.text.*,java.util.*,
				org.apache.commons.io.*,
				java.sql.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config1.jsp"%>
<%!public int getNum(String content,String s1)
{
	int num = 0;
	int i = content.indexOf(s1);
	if(i!=-1)
	{
		String s = content.substring(0,i);

		int j = s.lastIndexOf("/\">");
		if(j!=-1)
		{
			num = Util.parseInt(s.substring(j+3));
		}
	}
	return num;
}%>
<%
int id = getIntParameter(request,"id");

if(id==0) id = 1;
String url = "";
String sql = "";
TableUtil tu = new TableUtil();
if(id>=800000){out.println("全部结束.");}
else
{
	for(int i = 0;i<500;i++)
	{
		String content = "";
		url = "http://www.mayi.com/people/"+id+"/";
		InputStream in = new URL(url).openStream();
		try {
			content = IOUtils.toString(in,"utf-8");
			if(content==null)content = "";
			//System.out.println(content);
			if(content.equals("没有这个会员!"))
			 {
			   sql= "insert into mayi(user,status) values("+id+",0)";
			 }
			 else
			{
				 int people = getNum(content,"个朋友");
				 int photo = getNum(content,"张照片");
				 int blog = getNum(content,"篇日记");

				 sql = "insert into mayi(user,status,people,photo,blog) values("+id+",1,"+people+","+photo+","+blog+")";
			 }
			 out.println(sql+"<br>");
			 out.flush();
			 response.flushBuffer();
			 tu.executeUpdate(sql);

		} 
		catch(Exception e)
		{
			System.out.println(e.getMessage()+","+id);
			sql= "insert into mayi(user,status) values("+id+",2)";
		   tu.executeUpdate(sql);
		}
		finally {
		   IOUtils.closeQuietly(in);		   
		 }

		id++;
	}%><meta http-equiv="refresh" content="1; url=mayi.jsp?id=<%=id%>" /><%
}
%>