<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
 
long begin_time = System.currentTimeMillis();
//if(!(new UserPerm().canManageUser(userinfo_session)))
//{response.sendRedirect("../noperm.jsp");return;}

int GroupID = getIntParameter(request,"GroupID");

String groupName = "";
if(GroupID!=-1){
	UserGroup group = new UserGroup(GroupID);
	groupName = group.getName();
}


%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/main-content.css" type="text/css" rel="stylesheet" />
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<style type="text/css">
	input[type="checkbox"] {
		margin-bottom: 1px !important;
	}
	.view_table td {
		border: 0px !important;
	}
	.view_table, .view_table td, .view_table th {
		border-collapse: inherit !important;
	}
</style>
 
<script language=javascript>
	var groupName = "<%=groupName%>";
	//全选
	function selectAll(){
		var ischecked = $("#selectAll").prop("checked");
		if(ischecked){
			$(":checkbox",$("#oTable")).attr("checked",true);
		}else{
			$(":checkbox",$("#oTable")).attr("checked",false);
		}
	}
	//获取选中用户
	function getUser(){
		var id = "";
		var name = "";
		jQuery("#oTable input:checked").each(function(i){
			if(id!=""){
				id += ",";
				name += ",";
			}
			id +=jQuery(this).val();
			name +=jQuery(this).attr("describe");
		});
		var obj='{"id":"'+id+'","name":"'+name+'","groupName":"'+groupName+'"}';
		return obj;
	}
</script>
</head>
<body>
<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content">
	<div class="txt">
		<span class="title">全选</span>
		<span class="check"><input name="selectAll" type="checkbox" id="selectAll" onclick="selectAll()";/></span>
	</div>
  	<div class="viewpane">
        <div class="viewpane_tbdoy">
			<table width="100%" border="0" id="oTable" class="view_table">
				<tbody> 
<%
		TableUtil tu_user = new TableUtil("user");
		String ListSql = "select id,Role,Status,LastLoginDate,Name,Email,Username,UNIX_TIMESTAMP(ExpireDate) as ExpireDate from userinfo";
		String CountSql = "select count(*) from userinfo";

		if(GroupID==0)
		{
			ListSql += " where GroupID=0 or GroupID is null order by Role,id";
			CountSql += " where GroupID=0 or GroupID is null";
		}
		else if(GroupID==-1)
		{
			ListSql += " order by Role,id";
			CountSql += "";
		}
		else
		{
			ListSql += " where GroupID=" + GroupID + " order by Role,id";
			CountSql += " where GroupID=" + GroupID;
		}

		long nowdate = System.currentTimeMillis()/1000;
	
		ResultSet Rs = tu_user.List(ListSql,CountSql,1,1000);

		if(tu_user.pagecontrol.getRowsCount()>0){

			int m=0;
			while(Rs.next())
			{
				String Name = convertNull(Rs.getString("Name"));
				int id = Rs.getInt("id");

				if(m==0) out.println("<tr>");
				m++;
%>
					<td id="item_<%=id%>" class="tide_item" valign="top" class="c">
						<div class="txt">
                    		<span class="check"><input name="id" value="<%=id%>" type="checkbox" describe="<%=Name%>"/></span>
							<span class="title"><%=Name%></span>
						</div>
					</td>
<%
				if(m==5){ out.println("</tr>");m=0;}
			}
			tu_user.closeRs(Rs);
		}
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

</body>
</html>