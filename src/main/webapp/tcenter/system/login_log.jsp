<%@ page import="java.sql.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.user.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 20;

int  Log_Action           =   getIntParameter(request,"Log_Action");
String S_CreateDate		=	getParameter(request,"CreateDate");
String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_User			=	getParameter(request,"User");
int S_Status			=	getIntParameter(request,"Status");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
String Log_Action_name="";
if((!S_User.equals(""))||(!S_CreateDate.equals(""))){
    S_OpenSearch=1;
}

String querystring = "";
querystring = "&User="+S_User+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1;

String Action = getParameter(request,"Action");
if(Action.equals("Del"))
{
/*	int id = getIntParameter(request,"id");

	String Sql = "delete from login_log where id=" + id;

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("login_log.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage);
*/
}
else if(Action.equals("Clear"))
{
	String Sql = "TRUNCATE login_log";

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("login_log.jsp");return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<link href="../style/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript"
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/content.js"></script>
<script language="javascript">
var listType=1;
function ClearItems()
{
	if(confirm("确实要清空登录日志吗？")) 
	{
		this.location = "login_log.jsp?Action=Clear";
	}
}

function openSearch()
{ 
	var SearchArea=document.getElementById("SearchArea");
	if(SearchArea.style.display == "none")
	{
		//document.search_form.OpenSearch.value="1";
		SearchArea.style.display = "";
	}
	else
	{
		//document.search_form.OpenSearch.value="0";
		SearchArea.style.display = "none";
	}
}

function check(){
	//var CreateDate=document.getElementById("CreateDate").value;
  return true;
}

</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">登录日志：</div>
    <div class="content_new_post">
    	<a href="javascript:openSearch();" class="first">检索</a>
    </div>
</div>
<div class="viewpane_c1" id="SearchArea"  style="display:<%=(S_OpenSearch==1?"":"none")%>">
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
    <table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>
    <td width="20">&nbsp;</td>
    <td><form name="search_form" action="login_log.jsp?rowsPerPage=<%=rowsPerPage%>" method="post">检索：
	     用户<input name="User" type="text" size="15" class="textfield" value="<%=S_User%>">&nbsp;
		  创建日期
		  <select name="CreateDate1">
		    <option value=">" <%=(S_CreateDate1.equals(">")||S_CreateDate1.equals("")?"selected":"")%>>大于</option>
		  <!--  <option value="=" <%=(S_CreateDate1.equals("=")?"selected":"")%>>等于</option>-->
		    <option value="<" <%=(S_CreateDate1.equals("<")?"selected":"")%>>小于</option>
      </select>
		  <input name="CreateDate" id="CreateDate" type="text" size="10"  class="textfield" value="<%=S_CreateDate%>"> 
		 <input name="Submit" type="submit" class="tidecms_btn2" value="查找" />
		 <input type="hidden" name="OpenSearch" value="0">
	</form>
  </tr>
</table>
    
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>
 
<div class="content_2012">
	
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v1" width="25" align="center" valign="middle">编号</th>
    				<th class="v3" style="padding-left:10px;text-align:left;">用户</th>
    				<th class="v1"	align="center" valign="middle">登录日期</th>
					<th class="v1"	align="center" valign="middle">是否成功</th>
					<th class="v1"	align="center" valign="middle">IP地址</th>
  				</tr>
</thead>
 <tbody> 
<%
TableUtil pt = new TableUtil("user");
String ListSql = "select * from login_log where 1=1";
String CountSql = "select count(*) from login_log where 1=1";

if(!S_User.equals("")){
    ListSql+=" and UserName like '%"+pt.SQLQuote(S_User)+"%'";
    CountSql+=" and UserName like '%"+pt.SQLQuote(S_User)+"%'";
}
if(!S_CreateDate.equals("")){
	 ListSql+=" and  Date "+S_CreateDate1+" '"+pt.SQLQuote(S_CreateDate)+"'";
     CountSql+=" and  Date "+S_CreateDate1+" '"+pt.SQLQuote(S_CreateDate)+"'";
}
ListSql+=" order by id desc";
ResultSet Rs = pt.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = pt.pagecontrol.getMaxPages();
int TotalNumber = pt.pagecontrol.getRowsCount();
if(pt.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				int UserID = Rs.getInt("User");
				UserInfo user = null;
				
				if(UserID>0) user = (UserInfo)CmsCache.getUser(UserID);
				String UserName = convertNull(Rs.getString("UserName"));
				String LoginDate = convertNull(Rs.getString("Date"));
				String Success = "";
				String cookieDesc = "";
				if(Rs.getInt("IsCookie")==1)
					cookieDesc = "(cookie)";

				if(Rs.getInt("IsSuccess")==1)
				{
					Success = "成功" + cookieDesc;
				}
				else
					Success = "<font color=red>失败"+cookieDesc+"</font>";
				String IP = convertNull(Rs.getString("IP"));
				int id = Rs.getInt("id");

				j++;

				String UserNameDesc = UserName;
				if(user!=null) UserNameDesc = UserName + "(" + user.getName() + ")";
%>

	<tr>
    <td class="v1" width="25" align="center" valign="middle"><%=j%></td>
    <td class="v3" style="font-weight:700;"><a href="login_log.jsp?User=<%=UserName%>"><%=UserNameDesc%></a></td>
	<td class="v1" align="center" valign="middle"><%=LoginDate%></td>
    <td class="v4" align="center" style="color:#666666;"><%=Success%></td>
	<td class="v4"  style="color:#666666;"><%=IP%></td>
  </tr>
<%
			}		
}
pt.closeRs(Rs);
%>
  
 </tbody> 
</table> 
        </div>
        <div class="viewpane_pages">
        	<div class="select"></div>
        	<div class="left">共<%=TotalNumber%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="login_log.jsp?currPage=1&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="login_log.jsp?currPage=<%=currPage-1%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="login_log.jsp?currPage=<%=currPage+1%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="login_log.jsp?currPage=<%=TotalPageNumber%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
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
		if(obj!=null)		this.location="login_log.jsp?rowsPerPage="+obj.value+"<%=querystring%>";
	}

jQuery(document).ready(function(){
	jQuery("#rowsPerPage").val('<%=rowsPerPage%>');

	jQuery("#goToId").click(function(){
		var num=jQuery("#jumpNum").val();
		if(num==""){
			alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;}
		 var reg=/^[0-9]+$/;
		 if(!reg.test(num)){
			alert("请输入数字!");
			jQuery("#jumpNum").focus();
			return;
		 }

		if(num<1)
			num=1;
		var href="login_log.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
		document.location.href=href;
	});

});
</script>
</body></html>