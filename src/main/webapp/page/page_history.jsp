<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

int pageId = getIntParameter(request,"id");
String SerialNo = getParameter(request,"SerialNo");

int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
	currPage = 1;
if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));
if(rowsPerPage<=0)
	rowsPerPage = 30;

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

TableUtil tu = new TableUtil();

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script>
function restore(id,d)
{
		 if(confirm("确定要恢复到"+d+"的内容吗？")){
			 var url="../page/page_restore.jsp?id=" + id;
			  $.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){
					 msg = msg.replace(/[\r\n]/g, ""); 
					 if(msg=="true")
					 {
					 alert("恢复成功!");top.location.href=top.location.href;
					 }
					 else
					 {alert(msg);}
					 }   
			}); 
		}
}
</script>
<style>
body,html{height:100%;overflow:hidden;}
</style>
</head>
<body>
<div class="content_2012" style="overflow:hidden;">
	
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy" style="height:340px;overflow-y:auto;">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v1"	align="center" valign="middle">修改者</th>
    				<th class="v4"  align="left" valign="middle" style="padding-left:10px;">修改时间</th>
					<th class="v9" width="70" align="center" valign="middle">>></th>
  				</tr>
</thead>
 <tbody> 
<%
String ListSql = "select id,User,FROM_UNIXTIME(CreateDate) as CreateDate from page_content where Page=" + pageId;
String CountSql = "select count(*) from page_content where Page=" + pageId;


ListSql += " order by id desc";

ResultSet Rs = tu.List(ListSql,CountSql,1,rowsPerPage);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
if(tu.pagecontrol.getRowsCount()>0)
{
	int j = 0;
	FileUtil fileutil = new FileUtil();
	//TemplateFile tf = null;

	while(Rs.next())
	{
			j++;
			int userid = Rs.getInt("User");
			int id_ = Rs.getInt("id");
			String ModifiedDate	= convertNull(Rs.getString("CreateDate"));
			ModifiedDate=Util.FormatDate("MM-dd HH:mm",ModifiedDate);
	%>

	<tr id="jTip<%=j%>_id">
	<td class="v1" align="center" valign="middle"><%=CmsCache.getUser(userid).getName()%></td>
     <td class="v4"  style="color:#666666;"><%=ModifiedDate%></td>
	 	<td class="v9">
	<div class="v9_button"><img src="../images/v9_button_2.gif" title="查看源代码" /></div>
	<div class="v9_button" onClick="restore(<%=id_%>,'<%=ModifiedDate%>')"><img src="../images/restory.gif" title="恢复" /></div>
	</td>
  </tr>
<%
		}
}

tu.closeRs(Rs);
%>
  
 </tbody> 
</table> 
        </div>
        <div class="viewpane_pages">
        	<div class="select">选择：<span id="selectAll">全部</span><span id="selectNo">无</span>			</div>
        	<div class="left">共 条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="page_history.jsp?currPage=1&id=<%=pageId%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="page_history.jsp?currPage=<%=currPage-1%>&id=<%=pageId%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="page_history.jsp?currPage=<%=currPage+1%>&id=<%=pageId%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="page_history.jsp?currPage=<%=TotalPageNumber%>&id=<%=pageId%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
		 <%}%>
            <div class="right">
            	<div style="float:left;">每页显示</div>
            	<div class="right_s1">
                <div class="right_s2">
            	    <select name="rowsPerPage" onChange="change(this);" id="rowsPerPage">
                  <option value="10">10</option>
                    <option value="15">15</option>
                    <option value="20">20</option>
                    <option value="25">25</option>
                    <option value="30">30</option>
                    <option value="50">50</option>
                    <option value="80">80</option>
                    <option value="100">100</option>
                  </select>
                </div>
                </div>
            	<div style="float:left;">条</div>
            </div>
        </div>
  </div>
 
</div>
 <script type="text/javascript"> 	
	function change(obj)
	{
		if(obj!=null)		this.location="page_history.jsp?currPage=1&id=<%=pageId%>&rowsPerPage="+obj.value+"<%=querystring%>";
	}

	function sort_select(obj){	

	}
</script>
</body></html>