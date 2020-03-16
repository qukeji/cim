<%@ page import="java.sql.*,tidemedia.cms.base.TableUtil"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String WebSiteName = "";
String Url = "";
String StartDate = "";
int TotalNumber = 0;
int StartDays = 0;
int AveDayNum = 0;
int DayNumber = 0;
int MonthMaxNumber = 0;
int DayMaxNumber = 0;
int HourMaxNumber = 0;
String MonthMaxDate = "";
String DayMaxDate = "";
String HourMaxTime = "";

String MaxBrw = "";
int MaxBrwNumber = 0;
String MaxSys = "";
int MaxSysNumber = 0;
String MaxScreen = "";
int MaxScreenNumber = 0;
String MaxWeb = "";
int MaxWebNumber = 0;

String Sql = "select Name,Url,TotalNumber,Date_Format(StartDate,'%Y-%m-%d') as StartDate1,DATEDIFF(now(),StartDate) as StartDays,DayNumber,MonthMaxNumber,DayMaxNumber,HourMaxNumber,MonthMaxDate,DayMaxDate,HourMaxTime from counter_info_list";
TableUtil tu = new TableUtil();

ResultSet Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	WebSiteName = convertNull(Rs.getString("Name"));
	Url = convertNull(Rs.getString("Url"));
	StartDate = convertNull(Rs.getString("StartDate1"));
	TotalNumber = Rs.getInt("TotalNumber");
	StartDays = Rs.getInt("StartDays")+1;
	DayNumber = Rs.getInt("DayNumber");
	MonthMaxNumber = Rs.getInt("MonthMaxNumber");
	DayMaxNumber = Rs.getInt("DayMaxNumber");
	HourMaxNumber = Rs.getInt("HourMaxNumber");
	MonthMaxDate = convertNull(Rs.getString("MonthMaxDate"));
	DayMaxDate = convertNull(Rs.getString("DayMaxDate"));
	HourMaxTime = convertNull(Rs.getString("HourMaxTime"));

	if(!Url.startsWith("http://"))
		Url = "http://"+Url;
}
tu.closeRs(Rs);

Sql = "select *  From counter_browser Order By BrowserNumber DESC";
Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	MaxBrw = convertNull(Rs.getString("Browser"));
	MaxBrwNumber = Rs.getInt("BrowserNumber");
}
tu.closeRs(Rs);

Sql = "select *  From counter_system Order By SystemNumber DESC";
Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	MaxSys = convertNull(Rs.getString("System"));
	MaxSysNumber = Rs.getInt("SystemNumber");
}
tu.closeRs(Rs);

Sql = "select *  From counter_screen Order By ScreenNumber DESC";
Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	MaxScreen = convertNull(Rs.getString("Screen"));
	MaxScreenNumber = Rs.getInt("ScreenNumber");
}
tu.closeRs(Rs);

Sql = "select *  From counter_web Order By WebNumber DESC";
Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	MaxWeb = convertNull(Rs.getString("Web"));
	MaxWebNumber = Rs.getInt("WebNumber");
}
tu.closeRs(Rs);

if(StartDays<1)
	AveDayNum = StartDays;
else
	AveDayNum = TotalNumber/StartDays;
%>
<HTML>
<HEAD>
<TITLE>网站统计分析系统</TITLE>
<META content="text/html; charset=utf-8" http-equiv=Content-Type>
<STYLE type=text/css></STYLE>
<link rel="stylesheet" href="Info/Style.css">
</HEAD>
<BODY bgColor=#FFFFFF>
<CENTER>
<%@ include file="header.jsp"%>
  <table width="640" border=1 bordercolor=#000099 cellpadding=0 cellspacing=0>
    <tbody> 
    <tr> 
      <td> 
        <table border=0 cellpadding=3 cellspacing=0 width="100%" bgcolor="#FFFFFF">
          <tbody> 
          <tr> 
            <td colspan=4 align="center" bgcolor="#000099">
			<font color=#ffffff>网 站 综 合 统 计 信 息</font>
			</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan=2>网站名称</td>
            <td align=right colspan=2><%=WebSiteName%></td>
          </tr>
          <tr bgcolor="#E4E4E4"> 
            <td align=left colspan=2>网站网址</td>
            <td align=right colspan=2><a href="<%=Url%>" target="_blank"><%=Url%></a></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan=2>总统计天数</td>
            <td align=right colspan=2><%=StartDays%></td>
          </tr>
          <tr bgcolor="#E4E4E4"> 
            <td align=left colspan=2>开始统计日期</td>
            <td align=right colspan=2><%=StartDate%></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan=2>总访问量</td>
            <td align=right colspan=2><%=TotalNumber%></td>
          </tr>
          <tr bgcolor="#E4E4E4"> 
            <td align=left colspan=2>平均日访量</td>
            <td align=right colspan=2><%=AveDayNum%></td>
          </tr>
          <tr bgcolor="#000099"> 
            <td align=left colspan=4 height="2"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan=2>今日访问量</td>
            <td align=right colspan=2><%=DayNumber%></td>
          </tr>
          <tr bgcolor="#E4E4E4"> 
            <td align=left colspan=2>最高月访量</td>
            <td align=right colspan=2><%=MonthMaxNumber%></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan=2>最高月访量月份</td>
            <td align=right colspan=2><%=MonthMaxDate%></td>
          </tr>
          <tr bgcolor="#E4E4E4"> 
            <td align=left colspan=2>最高日访量</td>
            <td align=right colspan=2><%=DayMaxNumber%></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan=2>最高日访量日期</td>
            <td align=right colspan=2><%=DayMaxDate%></td>
          </tr>
          <tr bgcolor="#E4E4E4"> 
            <td align=left colspan=2>最高时访量</td>
            <td align=right colspan=2><%=HourMaxNumber%></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan=2>最高时访量时间</td>
            <td align=right colspan=2><%=HourMaxTime%> 
          </tr>
          <tr> 
            <td align=left colspan=4 height="2" bgcolor="#000099"></td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan=2>常用浏览器</td>
            <td align=right colspan=2><%=MaxBrw%> (<%=MaxBrwNumber%>)</td>
          </tr>
          <tr bgcolor="#E4E4E4"> 
            <td align=left colspan=2>常用操作系统</td>
            <td align=right colspan=2><%=MaxSys%> (<%=MaxSysNumber%>)</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan=2>常用屏幕分辨率</td>
            <td align=right colspan=2><%=MaxScreen%> (<%=MaxScreenNumber%>)</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan=2>访问最多的网站</td>
            <td align=right colspan=2>
			
			      <a href="<%=MaxWeb%>"><%=MaxWeb%></a> (<%=MaxWebNumber%>)
			 </td>
          </tr>
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
  <br>
  <table width="640" border="0" cellspacing="0" cellpadding="0">
    
  <tr align="center"> 
    <td> 
      <p><br>
       计数器测试系统 
</p>
    </td>
    </tr>
  </table>

</CENTER>
</BODY>
</HTML>
