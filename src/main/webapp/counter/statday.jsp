<%@ page import="java.sql.*,tidemedia.cms.base.TableUtil,java.util.*,java.text.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int MaxWidth = 200;
int Year = getIntParameter(request,"Year");
int Month = getIntParameter(request,"Month");
int Day = getIntParameter(request,"Day");

java.util.Calendar nowDate = new java.util.GregorianCalendar();

if(Month==0||Year==0)
{
	Year = nowDate.get(Calendar.YEAR);
	Month = (nowDate.get(Calendar.MONTH)+1);
	Day = nowDate.get(Calendar.DATE);
}

%>
<HTML>
<HEAD>
<TITLE>网站统计分析系统</TITLE>
<META content="text/html; charset=utf-8" http-equiv=Content-Type>
<link rel="stylesheet" href="Info/Style.css">
</HEAD>
<BODY bgColor=#FFFFFF>
<CENTER>
<%@ include file="header.jsp"%>
  <table width="640" border=1 bordercolor=#000099 cellpadding=0 cellspacing=0 >
    <tbody> 
    <tr> 
      <td> 
<%
boolean exist = false;
String Sql = "select * from counter_stat_day where Day='"+Year + "-" + Month + "-" + Day + "'";
TableUtil tu = new TableUtil();
ResultSet Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	exist = true;
}
	int TotalNumber = 0;
	for(int i = 1;i<25;i++)
	{
		if(exist)
			TotalNumber += Rs.getInt("Hour"+i);
	}
%>
        <table border=0 cellpadding=3 cellspacing=0 width="100%" bgcolor="#FFFFFF">
          <tbody> 
          <tr align="right"> 
            <td colspan=4 bgcolor="#000099"> <font color="#FFFFFF"><%=Year+"-"+Month+"-"+Day%> 日 
              访 问 统 计 分 析 （总量：<%=TotalNumber%>）</font> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="StatAllDay.asp"><font color="#FFFFFF">[全部日分析]</font></a></td>
          </tr>
          <tr bgcolor="#CCCCCC"> 
            <td align=left>小时</td>
            <td align=left>访问人数</td>
            <td align=left>百分比</td>
            <td align=left>图示</td>
          </tr>
<%
	DecimalFormat df = new DecimalFormat("##0.00");

	for(int i = 1;i<25;i++)
	{
		int number = 0;
		String Percent = "0.00";
		int Width = 0;
		if(exist)
		{
			number = Rs.getInt("Hour"+i);
			Percent = df.format((100*number)/TotalNumber);
			Width = (number*MaxWidth)/TotalNumber;

		}
%>
          <tr bgcolor="#FFFFFF"> 
            <td align=left width="25%">
			<%=(i-1)+":00-"+(i)+":00"%></td>
            <td align=left width="20%"><%=number%></td>
            <td align=left width="20%"><%=Percent%></td>
            <td align=left width="35%"><img src="image/bar.gif" width="<%=Width%> "height="12"></td>
          </tr>
<%
	}
%>
          <tr align="right"> 
            <td colspan=4 bgcolor="#000099"> 
              <p>&nbsp;</p>
            </td>
          </tr>
          </tbody> 
        </table>
      </td>
    </tr>
    </tbody> 
  </table>
<%@ include file="end.jsp"%>
</CENTER>
</BODY>
</HTML>
