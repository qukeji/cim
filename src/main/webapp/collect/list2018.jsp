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

	response.sendRedirect("list2018.jsp");return;
}

if(Action.equals("Clear"))
{
	 int id = getIntParameter(request,"id");
	Spider s = new Spider(id);

	s.DeleteSpiderItem();

	response.sendRedirect("list2018.jsp");return;
}
querystring ="&GroupID="+GroupID ;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS 列表</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <style>
        .collapsed-menu .br-mainpanel-file {
            margin-left: 0;
            margin-top: 0;
        }
    </style>
    <script src="../lib/2018/jquery/jquery.js"></script>
    <script language=javascript>
        var GroupID = <%=GroupID%>;

        function addSpider() 
		{
            var dialog = new top.TideDialog();
            dialog.setWidth(550);
            dialog.setHeight(460);
            dialog.setUrl("../spider/spider_add2018.jsp?GroupID=" + GroupID);
            dialog.setTitle("新建采集");
            dialog.show();
        }

        function editSpider(id) 
		{
            var dialog = new top.TideDialog();
            dialog.setWidth(550);22
            dialog.setHeight(460);
            dialog.setUrl("../spider/spider_edit2018.jsp?id=" + id);
            dialog.setTitle("编辑采集信息");
            dialog.show();
        }
	
        function setField(id) 
		{
            var dialog = new top.TideDialog();
            dialog.setWidth(650);
            dialog.setHeight(460);
            dialog.setUrl("../spider/spider_field_list2018.jsp?Parent=" + id);
            dialog.setTitle("字段配置");
            dialog.show();
        }

        function configSpider()
		{
            var dialog = new top.TideDialog();
            dialog.setWidth(300);
            dialog.setHeight(200);
            dialog.setUrl("../spider/spider_config.jsp");
            dialog.setTitle("采集配置");
            dialog.show();
        }   
		  function clear(id)
		{
			var url="../spider/list_clear2018.jsp?id="+id;
            var dialog = new top.TideDialog();
            dialog.setWidth(320);
            dialog.setHeight(260);
            dialog.setUrl(url);
            dialog.setTitle("清空采集记录");
            dialog.show();
        }
		  function del(id)
		{
			var url="../spider/list_del2018.jsp?id="+id;
            var dialog = new top.TideDialog();
            dialog.setWidth(320);
            dialog.setHeight(260);
            dialog.setUrl(url);
            dialog.setTitle("删除采集地址");
            dialog.show();
        }
        function spider_enable(id, flag) 
		{
			var url="../spider/spider_enable2018.jsp?id="+id+"&flag="+flag;
            var dialog = new top.TideDialog();
            dialog.setWidth(320);
            dialog.setHeight(260);
            dialog.setUrl(url);
            dialog.setTitle("删除采集地址");
            dialog.show();
									
 /*           var msg = "确实要";
            if (flag == 1) msg += "启用";
            else if (flag == 2) msg += "禁止";
            else return;
            msg += "吗?";

            if (confirm(msg)) {
var url = "spider_enable.jsp?id=" + id + "&flag=" + flag;
$.ajax({
    type: "GET",
    url: url,
    success: function(msg) {
        document.location.href = document.location.href;
    }
});
            }   */
        }
    </script>
</head>

<body class="collapsed-menu email">
    <div class="br-mainpanel br-mainpanel-file" id="js-source">
        <div class="br-pageheader pd-y-15 pd-md-l-20">
            <nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active">系统管理 / 采集系统</span>
            </nav>
        </div>
		<!-- br-pageheader -->
		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
			<div class="btn-group mg-l-auto hidden-sm-down">
				<a href="#" class="btn btn-outline-info list_draft" onClick="addSpider();">新建</a>
			</div><!-- btn-group -->
			<div class="btn-group mg-l-10 hidden-sm-down">
				<a href="" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
				<a href="" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
			</div>
		</div>
        <div class="br-pagebody pd-x-20 pd-sm-x-30">
            <div class="card bd-0 shadow-base">
<table class="table mg-b-0" id="content-table">
    <thead>
        <tr>
            <th class="tx-12-force tx-mont tx-medium wd-50">编号</th>
            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">名称</th>
            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">已采</th>
            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">对应频道</th>
            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">上次采集时间</th>
            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">下次采集时间</th>
            <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-80">采集周期</th>
            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">操作</th>
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
				%>
            <!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
            <%
%>
<tr id="jTip<%=j%>_id">
    <td class="valign-middle">
        <label class="ckbox mg-b-0">
				<%=j%>
			  </label>
    </td>
    <td class="hidden-xs-down">
        <a href="<%=Url%>" target="_blank">
            <%=Name%>
        </a>
    </td>
    <td class="hidden-xs-down">
        <%=n%>
    </td>
    <td class="hidden-xs-down">
        <%=channelname%>
    </td>
    <td class="hidden-xs-down">
        <%=PrevRunTime%>
    </td>
    <td class="hidden-xs-down">
        <%=NextRunTime%>
    </td>
    <td class="hidden-xs-down">
        <%=Period%>分钟</td>
    <td class="hidden-xs-down">
        <a href="javascript:editSpider(<%=id%>);" class="btn btn-info btn-sm mg-r-5 mg-b-5 tx-13">编辑</a>
        <a href="javascript:setField(<%=id%>);" class="btn btn-info btn-sm mg-r-5 mg-b-5 tx-13">配置</a>     
		<a href="javascript:clear(<%=id%>);" class="btn btn-info btn-sm mg-r-5 mg-b-5 tx-13">清空</a>        
	    <a href="javascript:del(<%=id%>);" class="btn btn-info btn-sm mg-r-5 mg-b-5 tx-13" >删除</a>
        <a href="../spider/spider_test.jsp?id=<%=id%>" target="_blank" class="btn btn-info btn-sm mg-r-5 mg-b-5 tx-13">测试</a>
        <%if(Status==1){%><button class="btn btn-info btn-sm mg-r-5 mg-b-5 tx-13" onclick="spider_enable(<%=id%>,2)">禁止</button>
        <%}else if(Status==0){%>
		<button class="btn btn-info btn-sm mg-r-5 mg-b-5 tx-13" onclick="spider_enable(<%=id%>,1)">启用</button>
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
<!--分页-->
<div id="tide_content_tfoot">
    <span class="mg-r-20 ">共<%=TotalNumber%>条</span>
    <span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

    <%if(TotalPageNumber>1){%>
        <%}%>
            <div class="jump_page ">
<span class="">跳至:</span>
<label class="wd-60 mg-b-0">
						<input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
					</label>
<span class="">页</span>
<a id="goToId" href="javascript:;" class="tx-14">Go</a>
            </div>
            <div class="each-page-num mg-l-auto">
				<span class="">每页显示:</span>
				<label class="wd-80 mg-b-0">
          			<select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="状态" onChange="change(this);" id="rowsPerPage">
						<option value="10" <%=rowsPerPage==10?"selected":""%>>10</option>
						<option value="15" <%=rowsPerPage==15?"selected":""%>>15</option>
						<option value="20" <%=rowsPerPage==20?"selected":""%>>20</option>
						<option value="25" <%=rowsPerPage==25?"selected":""%>>25</option>
						<option value="30" <%=rowsPerPage==30?"selected":""%>>30</option>
						<option value="50" <%=rowsPerPage==50?"selected":""%>>50</option>
						<option value="80" <%=rowsPerPage==80?"selected":""%>>80</option>
						<option value="100" <%=rowsPerPage==100?"selected":""%>>100</option>
						<option value="500" <%=rowsPerPage==500?"selected":""%>>500</option>
						<option value="1000" <%=rowsPerPage==1000?"selected":""%>>1000</option>
						<option value="5000" <%=rowsPerPage==5000?"selected":""%>>5000</option>   
					</select>
    			</label> 条
            </div>
			</div>
			<!--分页-->
        </div>
    </div>
	<!--列表-->
	<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
		<div class="btn-group mg-l-auto hidden-sm-down">
			<a href="#" class="btn btn-outline-info list_draft" onClick="addSpider();">新建</a>
		</div><!-- btn-group -->
		<div class="btn-group mg-l-10 hidden-sm-down">
			<a href="" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
			<a href="" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
		</div>
	</div>
</div>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.min.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
<script type="text/javascript">
function numberNull() 
{
 var dialog = new top.TideDialog();
            dialog.setWidth(300);
            dialog.setHeight(200);
            dialog.setUrl("list_numberNull2018.jsp");
            dialog.setTitle("采集配置");
            dialog.show();
}
function change(obj) {
    if (obj != null) this.location = "list2018.jsp?rowsPerPage=" + obj.value + "<%=querystring%>";
}
jQuery(document).ready(function() {
    jQuery("#oTable").tablesorter({
		headers: {0: {sorter: false}}
    });
jQuery("#rowsPerPage").val('<%=rowsPerPage%>');
jQuery("#goToId").click(function() {
var num = jQuery("#jumpNum").val();
if (num == "") {
	alert("请输入数字!");
   // numberNull();	       
    jQuery("#jumpNum").focus();
    return;
}
var reg = /^[0-9]+$/;
if (!reg.test(num)) {
     numberNull();	 
    jQuery("#jumpNum").focus();
    return;
}

if (num < 1)
    num = 1;
	var href = "list2018.jsp?currPage=" + num + "&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
	document.location.href = href;
});
});
</script>
</body>
</html>
