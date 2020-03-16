<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,tidemedia.cms.publish.*,java.util.concurrent.*"%>
<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.text.*,
				java.util.*"%>
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

java.util.Calendar nowdate = new java.util.GregorianCalendar();
java.util.Calendar nowdate2 = new java.util.GregorianCalendar();
//nowdate.add(Calendar.DATE,-5);
DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
DateFormat df2 = new SimpleDateFormat("yyyy-MM-dd");
//df.setTimeZone(java.util.TimeZone.getTimeZone("GMT"));
//out.print(df.format(nowdate.getTime()));

TableUtil tu = new TableUtil();
int m = 100;
nowdate.add(Calendar.DATE,-m);
nowdate.set(Calendar.HOUR_OF_DAY,0);
nowdate.set(Calendar.MINUTE,0);
nowdate.set(Calendar.SECOND,0);
nowdate.set(Calendar.MILLISECOND,0);
for(int i = m;i>0;i--)
{
	nowdate2.setTimeInMillis(nowdate.getTimeInMillis());
	nowdate2.add(Calendar.DATE,+1);

	String sql = "select count(*) from tidecms_log where LogType='添加文档' and CreateDate>='" + df.format(nowdate.getTime()) + "' and CreateDate<'" + df.format(nowdate2.getTime()) + "'";

	//out.println(sql+"<br>");
	int num = 0;
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next())
	{
		num = rs.getInt(1);
	}
	tu.closeRs(rs);

	out.println(df2.format(nowdate.getTime()) + ":" + num);

	out.println("<br>");
	nowdate.add(Calendar.DATE,+1);
}
%>