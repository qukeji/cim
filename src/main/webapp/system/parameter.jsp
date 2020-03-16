<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.util.Util"%>
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
String querystring="";

String Action = getParameter(request,"Action");
if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");

	Parameter p = new Parameter();
	p.Delete(id);

	response.sendRedirect("parameter.jsp?currPage="+currPage+"&rowsPerPage="+rowsPerPage);return;
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script language="javascript">

function ClearItems()
{
	if(confirm("确实要清空错误日志吗？")) 
	{
		this.location = "error_log.jsp?Action=Clear";
	}
}


function Details(id)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(520);
	dialog.setHeight(420);
	dialog.setUrl("system/parameter_edit.jsp?id=" + id);
	dialog.setTitle("修改参数");
	dialog.show();
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

function addParameter()
{
	var url='system/parameter_add.jsp';
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(420);
		dialog.setUrl(url);
		dialog.setTitle("添加参数");
		dialog.show();
}
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav"> 系统参数：</div>
    <div class="content_new_post">
		<div class="tidecms_btn" onClick="addParameter();">
			<div class="t_btn_pic"><img src="../images/icon/add.png" /></div>
			<div class="t_btn_txt">新建</div>
		</div>
    </div>
</div>
<div class="viewpane_c1" id="SearchArea"  style="display:none;">
	<div class="top">
        <div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="center">
    <table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>
    <td width="20">&nbsp;</td>
    <td><form name="search_form" action="">
	
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
		<tr align="center">
    				<th class="v1" width="25">编号</th>
    				<th class="v3">代码</th>
    				<th class="v1">标题</th>
					<th class="v1">日期</th>
    				<th class="v9" width="55">>></th>
  				</tr>
</thead>
 <tbody> 
<%
TableUtil tu = new TableUtil();
String ListSql = "select * from parameter order by id desc";
String CountSql = "select count(*) from parameter";

ResultSet Rs = tu.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
if(tu.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				String Name			= convertNull(Rs.getString("Name"));
				String Code			= convertNull(Rs.getString("Code"));
				String CreateDate	= convertNull(Rs.getString("CreateDate"));
				int id				= Rs.getInt("id");

				j++;
%>
	<tr>
    <td class="v1" width="25"><%=j%></td>
    <td class="v3" style="font-weight:700;"><a href="javascript:Details(<%=id%>);"><%=Code%></a></td>
	<td class="v1"><%=Name%></td>
    <td class="v4"  style="color:#666666;"><%=CreateDate%></td>
	<td class="v4"  style="color:#666666;"><a href="parameter.jsp?Action=Del&id=<%=id%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></td>
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
        	<div class="select"></div>
        	<div class="left">共<%=TotalNumber%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="parameter.jsp?currPage=1&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="parameter.jsp?currPage=<%=currPage-1%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="parameter.jsp?currPage=<%=currPage+1%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="parameter.jsp?currPage=<%=TotalPageNumber%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
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
		if(obj!=null)		this.location="parameter.jsp?rowsPerPage="+obj.value+"<%=querystring%>";
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
		var href="parameter.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
		document.location.href=href;
	});

});
</script>
</body></html>