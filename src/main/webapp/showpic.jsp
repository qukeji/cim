<%@ page import="java.sql.*,java.io.*,tidemedia.cms.base.TableUtil"%><%@ page contentType="image/jpeg;charset=gb2312" %><%@ include file="config.jsp"%><%if(!userinfo_session.isAdministrator()){ response.sendRedirect("../noperm.jsp");return;}
String	Type		= getParameter(request,"Type");
int	id				= getIntParameter(request,"id");

String Sql = "";

if(Type.equals("TemplateFile"))
	Sql = "select * from template_files where id=" + id;

//System.out.print(Sql);

TableUtil tu = new TableUtil();

ResultSet Rs = tu.executeQuery(Sql);

if(Rs.next())
{
	Blob b = Rs.getBlob("Photo");
	if(b!=null)
	{
		long size = b.length();
		//System.out.print(size);
		byte[] bs = b.getBytes(1, (int)size);
		response.setContentType("image/jpeg"); 
		OutputStream outs = response.getOutputStream(); 
		outs.write(bs);
		outs.flush();
	}
}

tu.closeRs(Rs);%>
