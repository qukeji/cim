<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int templateid = getIntParameter(request,"templateid");

int GroupID = getIntParameter(request,"GroupID");

int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
	currPage = 1;
if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));
if(rowsPerPage<=0)
	rowsPerPage = 20;

String S_Title			=	getParameter(request,"Title");
String S_CreateDate		=	getParameter(request,"CreateDate");
String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_User			=	getParameter(request,"User");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/main-content.css" type="text/css" rel="stylesheet" />
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script language="javascript">
var myObject = new Object();
myObject.title = "新建文件";
</script>
</head>
<body>
<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content">
	
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy" style="height: 360px; overflow: auto;">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v3" style="padding-left:10px;text-align:left;">名称</th>
  				</tr>
</thead>
 <tbody> 
<%
TableUtil tu = new TableUtil();
String ListSql = "select * from channel_template where TemplateID=" + templateid + " order by id asc";
//String CountSql = "select count(*) from template_files";


ResultSet Rs = tu.executeQuery(ListSql);

	int j = 0;

	//TemplateFile tf = null;

	while(Rs.next())
	{
			j++;
			int channelid = Rs.getInt("Channel");	
			Channel ch = CmsCache.getChannel(channelid);
	%>

	<tr id="jTip<%=j%>_id">
    <td class="v3" style="font-weight:700;"><%=ch.getParentChannelPath()%></td>
  </tr>
<%
		}

tu.closeRs(Rs);
%>
  
 </tbody> 
</table> 
        </div>

</div>
 
</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>

</body></html>