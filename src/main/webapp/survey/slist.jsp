<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="tidemedia.cms.base.TableUtil,tidemedia.cms.util.*,java.sql.*"%>
<%@ include file="../config.jsp" %>
<%
String contextPath=request.getContextPath();
String uri=request.getRequestURI();
TableUtil tu = new TableUtil("survey");

int currPage = Util.getIntParameter(request,"currPage");
int rowsPerPage = Util.getIntParameter(request,"rowsPerPage");
int TotalPageNumber =0;
int TotalNumber = 0;
if(currPage<1)
	currPage = 1;

if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));

if(rowsPerPage<=0)
	rowsPerPage =20;

int S_OpenSearch		=	Util.getIntParameter(request,"OpenSearch");

String querystring = "&rowsPerPage="+rowsPerPage;
String preUrl="";
String nextUrl="";
String beginUrl="";
String endUrl="";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>问卷列表</title>
<link href="../style/9/tidecms7.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script>
function addDocument(){
	window.open("/survey/manage/sadd.jsp");
}

function logout()
{
	document.location.href = "logout.jsp";
}

function del(id){
	var message = "真的要删除吗？";
	
	if(!confirm(message)){
			return;
	}

	 var url=  "scommand.jsp?command=del&ID=" + id ;
		 $.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.href=document.location.href;}   
		}); 
}

function editDocument(itemid)
{
	var url=  "showsurvey.jsp?SurveyID=" + itemid ;
	$.ajax({
			type: "GET",
			url: url,
			success: function(msg)
			{
				//alert(msg);
				var html = msg;
  				parent.oEditor.FCKUndo.SaveUndoStep() ;
				parent.oEditor.FCK.InsertHtml(html) ;//alert(html);
				parent.Ok();
			}   
		}); 

}
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：调查系统</div>
    <div class="content_new_post">
		<div class="top_button button_inline_block" onClick="openSearch();">
			<div class="top_button_outer button_inline_block">
				<div class="top_button_inner button_inline_block">
					<span class="img"><img src="../img/icon/preview.png" /></span>
					<span class="txt">检索</span>
				</div>
			</div>	
		</div>
		<div class="top_button button_inline_block" onClick="addDocument();">
		  <div class="top_button_outer button_inline_block">
				<div class="top_button_inner button_inline_block">
					<span class="img"><img src="../img/icon/add.png" /></span>
					<span class="txt">新建</span>
				</div>
			</div>
		</div>
  </div>
</div>
<div class="viewpane_c1" id="SearchArea" style="display:<%=(S_OpenSearch==1?"":"none")%>">
	<div class="top"><div class="left"></div><div class="right"></div></div>
    <div class="center">
<table width="100%" height="38" border="0" cellpadding="0" cellspacing="0" class="box-tint">
  <tr>

    <td width="20">&nbsp;</td>
    <td><form name="search_form" action="/cms/content/content.jsp?id=4020&rowsPerPage=20" method="post" onSubmit="document.search_form.OpenSearch.value='1';">检索：标题
		  <input name="Title" type="text" size="18" class="textfield" value="">
		  创建日期
		  <select name="CreateDate1" >
		    <option value=">" selected>大于</option>
		    <option value="=" >等于</option>
		    <option value="<" >小于</option>
          </select>
		  <input name="CreateDate" type="text" size="10"  class="textfield" value=""><img align="absmiddle" src="../img/calendar.gif" onclick="selectdate('CreateDate');">
		  作者
		  <input name="User" type="text" size="10"  class="textfield" value="">
		  来源
		  <input name="DocFrom" type="text" size="10"  class="textfield" value="">
		  状态
		  <select name="Status" >
		    <option value="0" selected></option>
		    <option value="2" >已发</option>

		    <option value="1" >草稿</option>
          </select>
		 包含子频道
		  <input type="checkbox" name="IsIncludeSubChannel" value="1" > 
    	  <input type="submit" name="Submit" class="tidecms_btn3" value="查找"><input type="hidden" name="OpenSearch" id="OpenSearch" value="0"></form></td>
    <td width="20">&nbsp;</td>
  </tr>
</table>
    </div>
    <div class="bot"><div class="left"></div><div class="right"></div></div>
</div>
<div class="content_top"><div class="left"></div><div class="right"></div></div>
<div class="content">

  	<div class="viewpane">
        <div class="viewpane_tbdoy">
<table width="100%" border="0"class="view_table" id="oTable">
	<tr>
    	<th class="v3" align="center"><a href="<%=uri%>?order=Title">标题</a></th>
    	<th class="v1" align="center" valign="middle"> <a href="<%=uri%>?order=Author">作者</a></th>
    	<th class="v8" align="center" valign="middle"><a href="<%=uri%>?order=StartDate">开始日期</a></th>
    	<th class="v4" align="center" valign="middle"><a href="<%=uri%>?order=EndDate">截止日期</a></th>
    	<th class="v7" align="center" valign="middle"><a href="<%=uri%>?order=IsMultiPost">重复回答</a></th>
    	<th class="v6" align="center" valign="middle"><a href="<%=uri%>?order=IsEnabled">启用</a></th>
		<th class="v9" align="center" valign="middle"><a href="<%=uri%>?order=IsAnonymous">匿名</a></th>
	</tr>
<%
	String ListSql,CountSql,Order,strOrder,sBackColor;

	Order = request.getParameter("order");
	if(Order == null || Order.length() ==0) strOrder = " Order by ID Desc";
	else strOrder = " Order by " + Order.trim();

	ListSql ="SELECT * FROM surveylist " + strOrder;
	CountSql="SELECT count(*) FROM surveylist " + strOrder;;
	ResultSet rsSurvey = tu.List(ListSql,CountSql,currPage,rowsPerPage);
	TotalPageNumber = tu.pagecontrol.getMaxPages();
	TotalNumber = tu.pagecontrol.getRowsCount();

	preUrl=uri+"?currPage="+(currPage-1)+querystring;
	nextUrl=uri+"?currPage="+(currPage+1)+querystring;
	beginUrl=uri+"?currPage=1"+querystring;
	endUrl=uri+"?currPage="+TotalPageNumber+querystring;

	if(rsSurvey == null)
	{
		out.print("<p align='center'> 没有找到结果！ </p>");
		return;
	}

	String sID;
	while(rsSurvey.next()){
		sID = rsSurvey.getString("ID");
%>
  	<tr>
    	<td class="v3"><img src="../img/tree6.png"/><input name="id" value="<%=sID%>" type="checkbox" style="display: none"/><%= rsSurvey.getString("Title")%></td>
		<td class="v1" align="center" valign="middle"><%= rsSurvey.getString("Author") %></td>
    	<td class="v8" align="center"><%= rsSurvey.getString("StartDate") %></td>
    	<td class="v4" align="center"><%= rsSurvey.getString("EndDate") %></td>
		<td class="v7" align="center"><%= ((rsSurvey.getString("IsMultiPost").equals("0"))?"否":"是") %></td>
		<td class="v6" align="center"><%= ((rsSurvey.getString("IsEnabled").equals("0"))?"否":"是") %></td>
        <td class="v9" align="center"><%= ((rsSurvey.getString("IsAnonymous").equals("0"))?"否":"是") %></td>
		<td class="v10">
			<div class="v9_button"><a href="sdetails.jsp?ID=<%= sID%>" target="_blank"><img src="../img/infoicon.gif" title="详细" /></a></div>
            <div class="v9_button"><a href="sedit.jsp?ID=<%= sID%>" target="_blank"><img src="../img/pip.gif" title="更改" /></a></div>
            <div class="v9_button"><a href="javascript:del('<%=sID%>');"><img src="../img/x_icon.gif" title="删除" /></a></div>
            <div class="v9_button"><a href="qlist.jsp?SurveyID=<%= sID%>" target="_blank"><img src="../img/viewicon.gif" title="管理问题" /></a></div>
            <div class="v9_button"><a href="preview.jsp?SurveyID=<%= sID%>" target="_blank"><img src="../img/search.gif" title="预览" /></a></div>
		</td>
  	</tr>
<%
	}
	tu.closeRs(rsSurvey);
%>
</table>
        </div>
		<%if(TotalPageNumber>0){%> 
        <div class="viewpane_pages">
        	<div class="left">共<%=TotalNumber%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;" onclick="GoPage('jumpNum','<%=TotalPageNumber%>','currPage');">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="<%=beginUrl%>" title="首页"><img src="../img/viewpane_pages1.png" alt="首页" /></a>
			<%if(currPage>1){%><a href="<%=preUrl%>" title="上一页"><img src="../img/viewpane_pages2.png" alt="上一页" />上一页</a><%}%>
			<%if(currPage<TotalPageNumber){%><a href="<%=nextUrl%>" title="下一页">下一页<img src="../img/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="<%=endUrl%>" title="末页"><img src="../img/viewpane_pages4.png" alt="末页" /></a></div>
            <%}%>
			<div class="right">
            	<div style="float:left;">每页显示</div>
            	<div class="right_s1">
                <div class="right_s2">
            	  <select name="rowsPerPage" onChange="changeRowsPerPage('rowsPerPage');" id="rowsPerPage">
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
	<%}%>
  	</div>
</div>
<div class="content_bot"><div class="left"></div><div class="right"></div></div>
<script>
	$("#rowsPerPage").val("<%=rowsPerPage%>");
	jQuery("#oTable tr:gt(0)").dblclick(function(){
		var obj=jQuery(":checkbox",jQuery(this));
		editDocument(obj.val());
	});
</script>
</body>
</html>