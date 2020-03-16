<%@ page import="java.sql.*,tidemedia.cms.base.TableUtil,java.util.*,java.text.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int MaxWidth = 200;

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
int TotalNumber = 0;

String Sql = "select RefererNumber from counter_referer";
TableUtil tu = new TableUtil();
ResultSet Rs = tu.executeQuery(Sql);

while(Rs.next())
{
	exist = true;
	TotalNumber += Rs.getInt(1);
}

tu.closeRs(Rs);
%>
        <table border=0 cellpadding=3 cellspacing=0 width="100%" bgcolor="#FFFFFF">
          <tbody> 
          <tr> 
            <td colspan=4 align="center" bgcolor="#000099"> 
              <div align="center"><font color="#FFFFFF">访 问 者 链 接 页 面 分 析 （总量：<%=TotalNumber%>）</font> 
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                <!--<a href="FWeburl.asp"><font color="#FFFFFF">[来访网站分析]</font></a> -->
              </div>
            </td>
          </tr>
          <tr bgcolor="#CCCCCC"> 
            <td align=left>链接页面</td>
            <td align=left>访问人数</td>
            <td align=left>百分比</td>
            <td align=left>图示</td>
          </tr>
<%
	DecimalFormat df = new DecimalFormat("##0.00");

	Sql = "select * from counter_referer";
	Rs = tu.executeQuery(Sql);
	while(Rs.next())
	{
		String Referer = "";
		int number = 0;
		String Percent = "0.00";
		int Width = 0;
		Referer = convertNull(Rs.getString("Referer"));
		number = Rs.getInt("RefererNumber");
		Percent = df.format((100*number)/TotalNumber);
		Width = (number*MaxWidth)/TotalNumber;
//		if(Referer.equals(""))
//			Referer = "直接输入或书签导入";
%>
          <tr bgcolor="#FFFFFF"> 
            <td align=left width="25%">
			 <%if(Referer.equals("")){%>直接输入或书签导入<%}else{%><a href="<%=Referer%>"><%=Referer%></a><%}%>
            <td align=left width="20%">&nbsp;&nbsp;<%=number%></td>
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
