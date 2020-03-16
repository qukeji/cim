<%@ page import="java.io.*,
				java.util.*,
				java.net.URL,
				tidemedia.cms.base.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

java.net.URL path = null;
path = getClass().getClassLoader().getResource("cms.config.xml");
InputStream in = new FileInputStream(path.getFile());
//InputStream in = getClass().getResourceAsStream("/cms.config.xml");
Properties Props = new Properties();
Props.load(in);
//Props.setProperty("server","www.tidemedia.com");
//FileOutputStream os = new FileOutputStream("cms.config.xml");
//Props.store(os,"");

String PublishModeDesc = "";
String Charset = "";
String IsProtect = "";

if(convertNull(Props.getProperty("PublishMode")).equals("1"))
	PublishModeDesc = "动态发布";
else if(convertNull(Props.getProperty("PublishMode")).equals("2"))
	PublishModeDesc = "静态发布";
if(convertNull(Props.getProperty("Charset")).equals("gb2312"))
	Charset = "简体中文(GB2312)";
else if(convertNull(Props.getProperty("Charset")).equals("utf-8"))
	Charset = "Unicode(UTF-8)";
IsProtect = convertNull(Props.getProperty("IsProtect"));
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<script language=javascript>
function edit()
{
	this.location='edit.jsp';
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top"><table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
        <tr> 
          <td align="right"> 
		 
		  </td>
          <td width="20" align="right"></td>
        </tr>
      </table>
      <table width="100%" border="0" cellspacing="8" cellpadding="0">
        <tr>
          <td>
            <table width="80%" border="0" align="center" cellpadding="5" cellspacing="0" id="oTable">
              <tr align="center"> 
                <td width="5" class="box-blue"><span class="font-white"></span></td>
                <td width="153" class="box-blue"><span class="font-white"></span></td>
                <td width="422" class="box-blue"><span class="font-white"></span></td>
              </tr>

              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">本地站点目录：</div></td>
                <td width="422"><%=convertNull(Props.getProperty("SiteFolder"))%></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">本地站点地址：</div></td>
                <td width="422"><%=convertNull(Props.getProperty("SiteAddress"))%></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">管理员Email：</div></td>
                <td width="422"><%=convertNull(Props.getProperty("Email"))%></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">图片上传目录：</div></td>
                <td width="422"><%=convertNull(Props.getProperty("connString"))%></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">模板文件目录：</div></td>
                <td width="422"><%=convertNull(Props.getProperty("TemplateFolder"))%></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">备份文件目录：</div></td>
                <td width="422"><%=convertNull(Props.getProperty("BackupFolder"))%></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">静态发布时页面扩展名：</div></td>
                <td width="422"><%=convertNull(Props.getProperty("FileExt"))%></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">后台发布周期：</div></td>
                <td width="422"><%=convertNull(Props.getProperty("SleepTime"))%>分钟</td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">文件默认编码：</div></td>
                <td width="422"><%=Charset%></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">发布方式：</div></td>
                <td width="422"><%=PublishModeDesc%></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" > 
                  <div align="right">其他模块链接地址：</div></td>
                <td width="422"><%=convertNull(Props.getProperty("OtherModuleAddress"))%></td>
              </tr>
              <tr class="rows1"> 
                <td width="5" ></td>
                <td width="153" ></td>
                <td width="422">
                  <%if(!userinfo_session.hasPermission("DisableChangeConfig")){%>
                  <input type="button" name="button1" class="tidecms_btn3" value="修改配置信息" onClick="edit();"><%}%></td>
              </tr>
            </table>

            <div align="center"></div>
          </table>
			</td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
