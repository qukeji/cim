<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Action = getParameter(request,"Action");
int Parent = getIntParameter(request,"Parent");

if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");
	SpiderField s = new SpiderField(id);

	s.Delete(id);

	response.sendRedirect("spider_field_list.jsp?Parent=" + Parent);return;
}
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
     function addField()
{
	var	dialog = new top.TideDialog();
	dialog.setSuffix('_2');
	dialog.setWidth(500);
	dialog.setHeight(460);
	dialog.setUrl("../spider/spider_field_add2018.jsp?Parent=<%=Parent%>");
	dialog.setTitle("新建字段配置");
	dialog.show();
}

function editField(id)
{
	var	dialog = new top.TideDialog();
	dialog.setSuffix('_2');
	dialog.setWidth(500);
	dialog.setHeight(460);
	dialog.setUrl("../spider/spider_field_edit2018.jsp?id=" + id);
	dialog.setTitle("编辑字段配置");
	dialog.show();
}
function del(id,Parent)
{
	
	var url="spider_field_list_del2018.jsp?id="+id+"&Parent="+Parent;
	var	dialog = new top.TideDialog();
		dialog.setWidth(320);		
		dialog.setHeight(260);
		dialog.setSuffix('_2');
		dialog.setUrl(url);
		dialog.setTitle("删除字段");
		dialog.show();	
	
}	
function setReturnValue(o){
	if(o.refresh){
		var s = "spider_field_list2018.jsp?Parent=<%=Parent%>";
		
		document.location.href=s;
	}
}
    </script>
</head>

<body class="collapsed-menu email">
    <div class="br-mainpanel br-mainpanel-file">       
		<!-- br-pageheader -->
		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
			<div class="btn-group mg-l-auto ">
				<a href="javascript:addField();" class="btn btn-outline-info list_draft" onClick="addSpider();">添加</a>
			</div><!-- btn-group -->			
		</div>
        <div class="br-pagebody pd-x-20 pd-sm-x-30">
            <div class="card bd-0 shadow-base">
<table class="table mg-b-0" id="oTable">
    <thead>
        <tr>
            <th class="tx-12-force tx-mont tx-medium wd-50">编号</th>
            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">名称</th>
            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">字段</th>
            <th class="tx-12-force tx-mont tx-medium hidden-xs-down">操作</th>
        </tr>
    </thead>
<tbody>
<%
UserInfo userinfo = new UserInfo();
String ListSql = "select * from spider_field";
String CountSql = "select count(*) from spider_field";

ListSql += " where Parent=" + Parent;
CountSql += " where Parent=" + Parent;

ResultSet Rs = userinfo.List(ListSql,CountSql,1,1000);
%><!--<%=(System.currentTimeMillis()-begin_time)%>ms--><%
if(userinfo.pagecontrol.getRowsCount()>0)
{
	int j=0;

			while(Rs.next())
			{
				String Name = convertNull(Rs.getString("Name"));
				String Field = convertNull(Rs.getString("Field"));
				int id = Rs.getInt("id");

				j++;
				%><!--<%=(System.currentTimeMillis()-begin_time)%>ms--><%
%>
<tr id="jTip<%=j%>_id">
    <td class="valign-middle">
        <label class="ckbox mg-b-0">
				<%=j%>
			  </label>
    </td>
    <td class="hidden-xs-down">
       <%=Name%>
    </td>
    <td class="hidden-xs-down">
       <%=Field%>
    </td>
    <td class="hidden-xs-down">
        <a href="javascript:editField(<%=id%>);" class="btn btn-info btn-sm mg-r-5 mg-b-5 tx-13">编辑</a>     
     
       <a href="javascript:del(<%=id%>,<%=Parent%>);" class="btn btn-info btn-sm mg-r-5 mg-b-5 tx-13" >删除</a>
	</td>
</tr>
<%
			}			
%>
<%
}
userinfo.closeRs(Rs);
%>
    </tbody>
</table>
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
</body>
</html>