<%@ page import="java.sql.*,tidemedia.cms.base.TableUtil"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String WebSiteName = "";
String Url = "";
String Password = "";
String StartDate = "";
String NewPsw = "";
String Confirm = "";
String Sql = "";
ResultSet Rs;
int Action = 0;
int Flag = 0;
int PswMod = 0;
int Restart = 0;

WebSiteName = getParameter(request,"WebName");
Url = getParameter(request,"WebUrl");
Password = getParameter(request,"PassWord");
Action = getIntParameter(request,"action");
TableUtil tu = new TableUtil();

if(Action==1)
{
	NewPsw = getParameter(request,"NewPsw");
	Confirm = getParameter(request,"Confirm");

	Sql = "select * from counter_info_list";
	Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		StartDate = convertNull(Rs.getString("StartDate"));
		if(!Password.equals(convertNull(Rs.getString("Password"))))
			Flag = 2;

		if(!WebSiteName.equals("") && !Url.equals(""))
		{
			Sql = "update counter_info_list set Name='" + tu.SQLQuote(WebSiteName)+"',Url='"+tu.SQLQuote(Url)+"',Password='"+tu.SQLQuote(Password)+"'";
			tu.executeUpdate(Sql);
			//System.out.println(WebSiteName+":"+Sql);
			Flag = 1;
		}
	}
	tu.closeRs(Rs);
}
else if(Action==2)
{
}
%>
<HTML>
<HEAD>
<TITLE>网站统计分析系统</TITLE>
<META content="text/html; charset=utf-8" http-equiv=Content-Type>
<link rel="stylesheet" href="Info/Style.css">
<style type="text/css">
<!--
.Button {  background-color: #000099; height: 22px; color: #FFFFFF}
-->
</style>
</HEAD>
<BODY bgColor=#FFFFFF>
<CENTER>
<%@ include file="header.jsp"%>
  <table width="640" border=1 bordercolor=#000099 cellpadding=0 cellspacing=0 >
    <tbody> 
    <tr> 
      <td> 
        <table border=0 cellpadding=3 cellspacing=0 width="100%" bgcolor="#FFFFFF">
          <tbody> 
          <tr> 
            <td colspan=4 align="center" bgcolor="#000099"> <font color="#FFFFFF"> 
             修 改 网 站 信 息</font></td>
          </tr>
          <tr bgcolor="#CCCCCC"> 
            <td align=left colspan="4">操作结果：</td>
          </tr>
		  <%if(Action==1){%>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan="4"> 
              <table width="40%" border="0" cellspacing="0" cellpadding="0" align="center">
                <tr valign="middle" align="center"> 
                  <td colspan="3"> <%
					if(Flag==1)
					{
                       out.println("<br><br> <img src='Image/Success.gif'>&nbsp;&nbsp;&nbsp;修改成功！！！<br><br><br>");
					   out.println("<div align='left'>网站名称："+(WebSiteName)+"</div><br><br>");
					   out.println("<div align='left'>网站网址："+Url+"</div><br><br>");
				       out.println("<div align='left'>开始日期："+StartDate+"</div><br><br>");
                       if(PswMod==1)  out.println("<div align='left'>新的密码："+NewPsw+"</div><br><br>");
                    }else{
					  out.println("<br><br><img src='Image/Failure.gif'>&nbsp;&nbsp;&nbsp;修改失败！！！<br><br>");
					  if(WebSiteName.equals("")) out.println("请输入网站名称.<br><br>");
                      if(Url.equals("")) out.println("请输入网站网址.<br><br>");
					  if(Flag==2) out.println("请重新输入系统密码。<br><br>");
					     out.println(" <a href='javascript:history.back();'>返回上页</a><br><br><br>");
					}
					%> </td>
                </tr>
              </table>
            </td>
          </tr>
		  <%}else if(Action==2){ %>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan="4"> 
              <table width="40%" border="0" cellspacing="0" cellpadding="0" align="center">
                <tr valign="middle" align="center"> 
                  <td colspan="3"> 
				  <% if(Restart==1){
				       out.println("<br><br> <img src='Image/Success.gif'>&nbsp;&nbsp;&nbsp;统计重置成功！！！<br><br><br>");
				  	   out.println("<div align='left'>网站名称："+convertNull(WebSiteName)+"</div><br><br>");
					   out.println("<div align='left'>网站网址："+Url+"</div><br><br>");
				       out.println("<div align='left'>开始日期："+StartDate+"</div><br><br>");
					}else{
					   out.println("<br><br><img src='Image/Failure.gif'>&nbsp;&nbsp;&nbsp;重置失败！！！<br><br>");
					   out.println("请重新输入密码。<br><br>");
					   out.println(" <a href='javascript:history.back();'>返回上页</a><br><br><br>");
					   }
                 %> 
                  </td>
                </tr>
              </table>
            </td>
          </tr>

		  <%}%>
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
