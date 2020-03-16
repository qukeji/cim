<%@ page import="java.sql.*,tidemedia.cms.base.TableUtil"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String WebSiteName = "";
String Url = "";

String Sql = "select * from counter_info_list";
TableUtil tu = new TableUtil();

ResultSet Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	WebSiteName = convertNull(Rs.getString("Name"));
	Url = convertNull(Rs.getString("Url"));
}
tu.closeRs(Rs);
%>
<script>
function delall()
{
if(confirm("是否将所有统计数据删除？")){
	document.frmmodi.action.value=2;
	document.frmmodi.submit();
}
else {return false}
}

function change()
{
	document.frmmodi.action.value = 1;
	document.frmmodi.submit();
}
</script>
<HTML>
<HEAD>
<TITLE>网站统计分析系统</TITLE>
<META content="text/html; charset=utf-8" http-equiv=Content-Type>
<link rel="stylesheet" href="Info/Style.css">
<style type="text/css">
<!--
.Button {  background-color: #000099; height: 22px; color: #FFFFFF; width: 70px}
-->
</style>
</HEAD>
<BODY bgColor=#FFFFFF>
<CENTER>
<%@ include file="header.jsp"%>

  <table width="640" border=1 bordercolor=#000099 cellpadding=0 cellspacing=0 >
    <tbody> 
    <tr> 
      <td height="162"> 
        <table border=0 cellpadding=3 cellspacing=0 width="100%" bgcolor="#FFFFFF">
          <tbody> 
          <tr> 
            <td colspan=4 align="center" bgcolor="#000099"> <font color="#FFFFFF">设 
              置 网 站 基 本 信 息</font> </td>
          </tr>
          <tr bgcolor="#CCCCCC"> 
            <td align=left colspan="4">网站信息： ( * 为必填内容 )</td>
          </tr>
          <tr bgcolor="#FFFFFF"> 
            <td align=left colspan="4" height="186"> 
              <form method="post" action="modify.jsp" name="frmmodi">
                <table width="65%" border="0" cellspacing="0" cellpadding="0" align="center">
                  <tr> 
                    <td width="18%" height="27">&nbsp;</td>
                    <td width="55%" height="27">&nbsp;</td>
                    <td width="27%" height="27">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="18%" height="27">网站名称：</td>
                    <td width="55%" height="27"> 
                      <input type="text" name="WebName" maxlength="50" size="30" value="<%=WebSiteName%>" >
                    </td>
                    <td width="27%" height="27">*&nbsp;统计网站的名称 </td>
                  </tr>
                  <tr> 
                    <td width="18%">网站网址：</td>
                    <td width="55%"> 
                      <input type="text" name="WebUrl" maxlength="30" size="30" value="<%=Url%>" >
                    </td>
                    <td width="27%">*&nbsp;统计网站的网址 </td>
                  </tr>
                  <tr> 
                    <td width="18%">系统密码：</td>
                    <td width="55%"> 
                      <input type="text" name="PassWord" maxlength="20" size="30">
                    </td>
                    <td width="27%">*&nbsp;修改信息的密码</td>
                  </tr>
                  <tr> 
                    <td width="18%">新的密码：</td>
                    <td width="55%"> 
                      <input type="text" name="NewPsw" size="30" maxlength="20">
                    </td>
                    <td width="27%">&nbsp;&nbsp;更新的密码</td>
                  </tr>
                  <tr> 
                    <td width="18%">验证密码：</td>
                    <td width="55%"> 
                      <input type="text" size="30" maxlength="20" name="Confirm">
                    </td>
                    <td width="27%">&nbsp;&nbsp;必须与新密码相同</td>
                  </tr>
                  <tr> 
                    <td width="18%">&nbsp;</td>
                    <td colspan="2">&nbsp;</td>
                  </tr>
                  <tr> 
                    <td width="18%">&nbsp;</td>
                    <td colspan="2">&nbsp;</td>
                  </tr>
                  <tr align="center"> 
                    <td colspan="3"> 
					<input type="hidden" name="action" value="0">
                      <input type="button" name="Rereg" value="更改信息" class="Button" onClick="change();">
                      <input type="reset" name="Clear" value="清除重写" class="Button">
                      <input type="button" name="Rereg" value="统计重置" class="Button" onclick="delall();")>
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
                  </tr>
                </table>
              </form>
            </td>
          </tr>
          <tr align="right"> 
            <td colspan=4 bgcolor="#000099" height="2"> 
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
