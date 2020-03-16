<%@ page import="java.sql.*,tidemedia.cms.base.TableUtil"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<HTML>
<HEAD>
<TITLE>网站统计分析系统</TITLE>
<META content="text/html; charset=utf-8" http-equiv=Content-Type>
<link rel="stylesheet" href="Info/Style.css">
<script language=javascript>
function seek(ip)
{
	window.open("about:blank","ip");
	document.ipform.ip.value = ip;
	document.ipform.submit();
}
</script>
</HEAD>
<BODY bgColor=#FFFFFF>
<CENTER>
<%@ include file="header.jsp"%>
  <table width="760" border=1 bordercolor=#000099 cellpadding=0 cellspacing=0 >
    <tbody> 
    <tr> 
      <td height="33"> 
        <table border=0 cellpadding=3 cellspacing=0 width="756" bgcolor="#FFFFFF">
          <tbody> 
          <tr> 
            <td colspan=6 align="center" bgcolor="#000099"> <font color="#FFFFFF">最 
              近 30 位 访 问 者 信 息 分 析 </font></td>
          </tr>
          <tr bgcolor="#CCCCCC"> 
            <td width="77" align=left>日期</td>
            <td width="167" align=left>地址</td>
            <td width="138" align=left>页面名称</td>
            <td align=left colspan="3">链接页面</td>
          </tr>
<%
String Sql = "select * from counter_visit order by id desc limit 0,100";
TableUtil tu = new TableUtil();

ResultSet Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	String _Date = convertNull(Rs.getString("VisitDate"));
	String IP = convertNull(Rs.getString("IP"));
	String Referer = convertNull(Rs.getString("Referer"));
	String PageName = convertNull(Rs.getString("PageName"));
%>
          <tr bgcolor="#FFFFFF">
            <td align=left><%=_Date%></td>
            <td align=left><%=IP%> <a href="javascript:seek('<%=IP%>');">IP查询</a></td>
            <td align=left><%=PageName%></td>
            <td width="350" colspan="3" align=left autowrap>
			<%if(Referer.equals("")){%>直接输入或书签导入
			<%}else{%>
			<a href="<%=Referer%>"><%=Referer%></a><%}%>
			</td>
          </tr>
<%
}
tu.closeRs(Rs);
%>
          <tr align="right"> 
            <td colspan=6 bgcolor="#000099"> 
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
<div style="display:none">
	<form method=post action="http://www.ip138.com/ips.asp" name="ipform" target="ip">
<input type="text" name="ip" size="16"> <input type="submit" value="查询"><input type="hidden" name="action" value="2">
	</form>
</div>
</CENTER>
</BODY>
</HTML>
