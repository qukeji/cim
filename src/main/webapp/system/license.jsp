<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.util.Util"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div class="content_t1">
	<div class="content_t1_nav"> 许可证</div>
    <div class="content_new_post">
		<div class="tidecms_btn" onClick="location='license_edit.jsp';">
			<div class="t_btn_pic"><img src="../images/icon/del.png"/></div>
			<div class="t_btn_txt">更新许可证</div>
		</div>
    </div>
</div>

 
<div class="content_2012">
  	<div class="viewpane">
        <div class="viewpane_tbdoy">
            <table width="100%" border="0" id="oTable" class="view_table">
			<thead>
				<tr>
    				<th class="v1" width="25" align="center" valign="middle">&nbsp;</th>
    				<th class="v3" style="padding-left:10px;text-align:left;">&nbsp;</th>
  				</tr>
			</thead>
			<tbody>
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">公司：</div></td>
                <td width="422"><%=CmsCache.getCompany()%></td>
              </tr>
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">许可类型：</div></td>
                <td width="422"><%=CmsCache.getLicenseType()%></td>
              </tr>
<%if(CmsCache.getLicenseType().equals("Evaluation")){%>
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">有效期至：</div></td>
                <td width="422"><%=CmsCache.getExpiresDateStr()%></td>
              </tr>
<%}%>
			  </tbody>
            </table>
</div>
</div>
</div>

 
</body>
</html>