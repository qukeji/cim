<%@ page import="java.sql.*,tidemedia.cms.base.TableUtil,java.util.*,java.text.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int MaxWidth = 200;
int Year = getIntParameter(request,"Year");
int Week = getIntParameter(request,"Week");

java.util.Calendar nowDate = new java.util.GregorianCalendar();

if(Week==0||Year==0)
{
	Year = nowDate.get(Calendar.YEAR);
	Week = nowDate.get(Calendar.WEEK_OF_YEAR);
}

String[] WeekDesc = {"星期一","星期二","星期三","星期四","星期五","星期六","星期日"};
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
String Sql = "select * from counter_stat_week where Week='Total'";
TableUtil tu = new TableUtil();
ResultSet Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	exist = true;
}
	int TotalNumber = 0;
	for(int i = 1;i<8;i++)
	{
		if(exist)
			TotalNumber += Rs.getInt("Week"+i);
	}
%>
        <table border=0 cellpadding=3 cellspacing=0 width="100%" bgcolor="#FFFFFF">
          <tbody> 
          <tr align="right"> 
            <td colspan=4 bgcolor="#000099"> <font color="#FFFFFF">全 部 周 访 问 统 
              计 分 析 （总量：<%=TotalNumber%>）&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="statweek.jsp"><font color="#FFFFFF">[本周分析]</font></a></font> 
            </td>
          </tr>
          <tr bgcolor="#CCCCCC"> 
            <td align=left>星期</td>
            <td align=left>访问人数</td>
            <td align=left>百分比</td>
            <td align=left>图示</td>
          </tr>
<%
	DecimalFormat df = new DecimalFormat("##0.00");

	for(int i = 1;i<8;i++)
	{
		int number = 0;
		String Percent = "0.00";
		int Width = 0;
		if(exist)
		{
			if(i<7)
				number = Rs.getInt("Week"+(i+1));
			else
				number = Rs.getInt("Week1");
			Percent = df.format((100*number)/TotalNumber);
			Width = (number*MaxWidth)/TotalNumber;
		}
%>
          <tr bgcolor="#FFFFFF"> 
            <td align=left width="25%"><%=WeekDesc[i-1]%></td>
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
