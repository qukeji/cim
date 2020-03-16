<%@ page import="java.sql.*,
				tidemedia.cms.user.ShortCut,
				tidemedia.cms.base.TableUtil"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 20;

String Action = getParameter(request,"Action");
if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");

	String Sql = "delete from mytask where id=" + id;

	TableUtil tu = new TableUtil();
	
	tu.executeUpdate(Sql);

	response.sendRedirect("task.jsp");return;

}
else if(Action.equals("Add"))
{
	String	Description		= getParameter(request,"Description");
	String	Href			= getParameter(request,"Href");
	String	Target			= getParameter(request,"Target");

	ShortCut sc = new ShortCut();

	sc.setDescription(Description);
	sc.setHref(Href);
	sc.setTarget(Target);
	sc.setUser(userinfo_session.getId());

	sc.Add();

	response.sendRedirect("task.jsp");return;
}
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script language=javascript>
var currPage = <%=currPage%>;
var pageName = "";
if(pageName=="") pageName = "task.jsp";

function gopage(currpage)
{
	var url = pageName + "?currPage="+currpage+"&rowsPerPage=<%=rowsPerPage%>";
	this.location = url;
}

function list(str)
{
	var url = pageName + "?rowsPerPage=<%=rowsPerPage%>";
	if(typeof(str)!='undefined')
		url += "&" + str;
	this.location = url;
}

var myObject = new Object();
myObject.title = "";

function change(obj)
{
	if(obj!=null)
		this.location = "task.jsp?rowsPerPage="+obj.value;
}

function addTask()
{
	var url='person/task_add.jsp?type=right';
	tidecms.dialog(url,450,300,"新建任务");
}

function check()
{
	if(document.form.Description.value=="")
	{
		alert("请输入描述!");
		document.form.Description.focus();
		return false;
	}
	if(document.form.Href.value=="")
	{
		alert("请输入链接!");
		document.form.Href.focus();
		return false;
	}

	return true;
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div class="content_t1">
	<div class="content_t1_nav">当前位置：我的工作任务</div>
		<div class="content_new_post">
			<div class="tidecms_btn" onClick="addTask();">
				<div class="t_btn_pic"><img src="../images/icon/add.png" /></div>
				<div class="t_btn_txt">新建工作任务</div>
			</div>
		</div>
    </div>
</div>
 
<div class="content_2012">

<div class="viewpane">

        <div class="viewpane_tbdoy">
<table width="100%" border="0" class="view_table ui-sortable ui-sortable-disabled" id="oTable">

<thead>
		<tr id="oTable_th">
    				<th style="padding-left:10px;text-align:left;" class="v3 header">编号</th>					
    				<th valign="middle" align="center" class="v1 header">名称</th>
    				<th valign="middle" align="center" class="v8 header">状态</th>    				
    				<th width="75" valign="middle" align="center" class="v9 header">&gt;&gt;</th>
  				</tr>
</thead>

 <tbody> 
<%
ShortCut sc = new ShortCut();
String ListSql = "select * from mytask where User="+userinfo_session.getId()+" order by OrderNumber desc";
String CountSql = "select count(*) from mytask where User=" + userinfo_session.getId();

ResultSet Rs = sc.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = sc.pagecontrol.getMaxPages();
int TotalNumber = sc.pagecontrol.getRowsCount();
if(sc.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				String Name			= convertNull(Rs.getString("Name"));
				String Content		= convertNull(Rs.getString("Content"));

				int id				= Rs.getInt("id");
				int Status			= Rs.getInt("Status");

				String StatusDesc	= "";
				if(Status==0)
					StatusDesc = "未处理";
				else if(Status==1)
					StatusDesc = "处理中";
				else if(Status==2)
					StatusDesc = "处理完毕";

				j++;
%>
  <tr class="tide_item" id="item_4" globalid="12" status="0" ordernumber="3" itemid="4" no="1">
    <td style="font-weight:700;" class="v3"><%=j%></td>
	<td valign="middle" align="center" class="v1"><%=Name%></td>
    <td class="v8"><%=StatusDesc%></td>
	<td class="v9">
	<a href="task.jsp?Action=Del&id=<%=id%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a>	
	</td>
  </tr> 
 <%
			}		
}
sc.closeRs(Rs);
%>
  
 </tbody> 
</table>
</div>
<script>
var page={currPage:'<%=currPage%>',rowsPerPage:'<%=rowsPerPage%>',TotalPageNumber:<%=TotalPageNumber%>};
</script>       
 
        <div class="viewpane_pages">
        	<%if(TotalPageNumber>0){%> 
        <div class="viewpane_pages">
        	<div class="left">共<%=TotalNumber%>条 <%=currPage%>/<%=TotalPageNumber%>页 
			<%if(TotalPageNumber>1){%>跳至<input name="jumpNum" id="jumpNum" type="text" />页 <span id="goToId" style="cursor:pointer;">GO</span><%}%></div>
			<%if(TotalPageNumber>1){%> 	
            <div class="center"><a href="javascript:gopage(1);" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="javascript:gopage(<%=currPage-1%>);" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="javascript:gopage(<%=currPage+1%>);" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="javascript:gopage(<%=TotalPageNumber%>);" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
		 <%}%>
			 <%}%>
            <div class="right">

            	<div style="float:left;">每页显示</div>
            	<div class="right_s1">
                <div class="right_s2">
            	    <select id="rowsPerPage" onChange="change(this);" name="rowsPerPage">
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
<script language=javascript>
rowsPerPage.value = <%=rowsPerPage%>;
</script>	
 

</body>
</html>
