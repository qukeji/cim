<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
	currPage = 1;
if(rowsPerPage<=0)
	rowsPerPage = 15;
String querystring="";

String Action = getParameter(request,"Action");
int GroupID = getIntParameter(request,"GroupID");

if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");
	Spider s = new Spider(id);

	s.Delete(id);

	response.sendRedirect("list.jsp");return;
}

if(Action.equals("Clear"))
{
	 int id = getIntParameter(request,"id");
	Spider s = new Spider(id);

	s.DeleteSpiderItem();

	response.sendRedirect("list.jsp");return;
}
querystring ="&GroupID="+GroupID ;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/main-content.css" type="text/css" rel="stylesheet" />
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script language=javascript>
var GroupID = <%=GroupID%>;

function addSpider()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(550);
	dialog.setHeight(460);
	dialog.setUrl("spider/spider_add.jsp?GroupID="+GroupID);
	dialog.setTitle("新建采集");
	dialog.show();
}

function editSpider(id)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(550);
	dialog.setHeight(460);
	dialog.setUrl("spider/spider_edit.jsp?id=" + id);
	dialog.setTitle("编辑采集信息");
	dialog.show();
}

function setField(id)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(650);
	dialog.setHeight(460);
	dialog.setUrl("spider/spider_field_list.jsp?Parent=" + id);
	dialog.setTitle("字段配置");
	dialog.show();
}

function configSpider()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(300);
	dialog.setHeight(200);
	dialog.setUrl("spider/spider_config.jsp");
	dialog.setTitle("采集配置");
	dialog.show();
}

function spider_enable(id,flag)
{
	var msg = "确实要";
	if(flag==1) msg += "允许";
	else if(flag==2) msg += "禁止";
	else return;
	msg += "吗?";

	if(confirm(msg))
	{
		var url="spider_enable.jsp?id="+id+"&flag="+flag;
		$.ajax({type: "GET",url: url,success: function(msg){document.location.href=document.location.href;}});
	}
}
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav"><a href="list.jsp">所有采集</a></div>
    <div class="content_new_post">
        <a href="javascript:addSpider();" class="second">新建</a>
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
    <td width="20"> </td>
    <td><form name="search_form" action="" method="post" onSubmit="document.search_form.OpenSearch.value='1';">检索：文件名
		  <input name="Title" type="text" id="Title" size="18" class="textfield" value=""> 
    <input type="hidden" name="OpenSearch" id="OpenSearch" value="0">
    <input type="submit" name="Submit" class="tidecms_btn3" value="查找">
	</form></td>
    <td width="20"> </td>
  </tr>
</table>
    
    </div>
    <div class="bot">
    	<div class="left"></div>
    	<div class="right"></div>
    </div>
</div>
<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content">
	
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
	<tr id="oTable_th">
    	<th class="v1" width="25" align="center" valign="middle"><img src="../images/viewpane1.png" /></th>
    	<th class="v3" width="140" style="padding-left:10px;text-align:left;">名称</th>
    	<!--<th class="v1" align="center" valign="middle">采集地址</th>-->
		<th class="v1" align="center" valign="middle">已采</th>
		<th class="v1" align="center" valign="middle">对应频道</th>
		<th class="v1" align="center" valign="middle">上次采集时间</th>
		<th class="v1" align="center" valign="middle">下次采集时间</th>
                <th class="v1" align="center" valign="middle">采集周期</th>
    	<th class="v9" width="200" align="center" valign="middle">>></th>
  	</tr>
</thead>
 <tbody> 
<%
TableUtil tu = new TableUtil();
String ListSql = "select id,Name,Url,Status,Period,Channel,NextRunTime,PrevRunTime,FROM_UNIXTIME(NextRunTime) as NextRunTime1,FROM_UNIXTIME(PrevRunTime) as PrevRunTime1 from spider";
String CountSql = "select count(*) from spider";

if(GroupID==0)
{
	ListSql += " order by id";
//	ListSql += " where GroupID=0 or GroupID is null order by id";
//	CountSql += " where GroupID=0 or GroupID is null";
}
else if(GroupID==-1)
{
	ListSql += " order by Role,id";
	CountSql += "";
}
else
{
	ListSql += " where GroupID=" + GroupID + " order by id";
	CountSql += " where GroupID=" + GroupID;
}

ResultSet Rs = tu.List(ListSql,CountSql,currPage,rowsPerPage);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();
if(tu.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				String Name = convertNull(Rs.getString("Name"));
				String Url = convertNull(Rs.getString("Url"));
				String NextRunTime = convertNull(Rs.getString("NextRunTime1"));
				String PrevRunTime = convertNull(Rs.getString("PrevRunTime1"));
				if(Rs.getInt("NextRunTime")==0) NextRunTime = "";
				if(Rs.getInt("PrevRunTime")==0) PrevRunTime = "";
                                int Period=Rs.getInt("Period");
				int Status = Rs.getInt("Status");
				int id = Rs.getInt("id");
				int channelid = Rs.getInt("Channel");
				String channelname = "";
				int n = 0;
				if(channelid>0)
				{
					Channel ch = CmsCache.getChannel(channelid);
					if(ch!=null)
					channelname = ch.getParentChannelPath();
					
					int Category=0;
					if(ch.getType()!=0){//说明是继承频道
						Category=channelid;
					}
					String tableName = ch.getTableName();
					String sql_ = "select count(id) as rowCount from "+tableName+" where Active=1 and Category="+Category;
					//System.out.println(sql_);
					TableUtil tu_ = new TableUtil();
					ResultSet rs_ = tu_.executeQuery(sql_);
					while(rs_.next()){
						n = rs_.getInt("rowCount");
					}
					tu_.closeRs(rs_);
				}

				j++;
				%><!--<%=(System.currentTimeMillis()-begin_time)%>ms--><%
%>

	<tr id="jTip<%=j%>_id">
    <td class="v1" width="30" align="center" valign="middle"><%=j%></td>
    <td class="v3" align="left" valign="left"><a href="<%=Url%>" target="_blank"><%=Name%></a></td>
	<!--<td class="v1" align="center" valign="middle"><a href="<%=Url%>" target="_blank"><%=Url%></a></td>-->
	<td class="v1" align="center" valign="center"><%=n%></td>
	<td class="v1" align="left" valign="left"><%=channelname%></td>
	<td class="v1" align="center" valign="middle"><%=PrevRunTime%></td>
	<td class="v1" align="center" valign="middle"><%=NextRunTime%></td>
        <td class="v1" align="center" valign="middle"><%=Period%>分钟</td>
	<td class="v9"><a href="javascript:editSpider(<%=id%>);" class="operate">编辑</a> <a href="javascript:setField(<%=id%>);" class="operate">配置</a> <a href="list.jsp?id=<%=id%>&Action=Clear" onclick=" if(confirm('你确认要清空采集历史记录吗?')) return true; else return false;">清空</a> <a href="list.jsp?Action=Del&id=<%=id%>" class="operate" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a> <a href="spider_test.jsp?id=<%=id%>" target="_blank" class="operate">测试</a>
	<%if(Status==1){%><a href="javascript:spider_enable(<%=id%>,2)"><img src="../images/icon/02.png"></a><%}else if(Status==0){%>
	<a href="javascript:spider_enable(<%=id%>,1)"><img src="../images/icon/01.png"></a>
	<%}%>
	</td>
  </tr>
<%
			}			
%>
<%
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
            <div class="center"><a href="list.jsp?currPage=1&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a><%if(currPage>1){%><a href="list.jsp?currPage=<%=currPage-1%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a><%}%><%if(currPage<TotalPageNumber){%><a href="list.jsp?currPage=<%=currPage+1%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a><%}%><a href="list.jsp?currPage=<%=TotalPageNumber%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a></div>
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
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>
<script type="text/javascript">

function change(obj)
{
		if(obj!=null)		this.location="list.jsp?rowsPerPage="+obj.value+"<%=querystring%>";
}


jQuery(document).ready(function(){

       jQuery("#oTable").tablesorter({headers: { 0: { sorter: false}}});
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
		var href="list.jsp?currPage="+num+"&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
		document.location.href=href;
	});

});
</script>
</body></html>
