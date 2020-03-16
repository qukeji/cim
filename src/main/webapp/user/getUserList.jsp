<%@ page import="java.sql.*,
				org.json.*,
				java.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
int company = getIntParameter(request,"company");
String users = getParameter(request,"users");
String[] userIds = users.split(",");

JSONObject o = new JSONObject();

long begin_time = System.currentTimeMillis();

int GroupID = getIntParameter(request,"GroupID");

String groupName = "";
if(GroupID!=-1){
	UserGroup group = new UserGroup(GroupID);
	groupName = group.getName();
}

TableUtil tu_user = new TableUtil("user");
String ListSql = "select id,Role,Status,LastLoginDate,Name,Email,Username,UNIX_TIMESTAMP(ExpireDate) as ExpireDate from userinfo where Role=1 and (company=0 or company="+company+")";
String CountSql = "select count(*) from userinfo where Role=1 and (company=0 or company="+company+")";

if(GroupID==0)
{
	ListSql += " and GroupID=0 or GroupID is null order by Role,id";
	CountSql += " and GroupID=0 or GroupID is null";
}
else if(GroupID==-1)
{
	ListSql += " order by Role,id";
	CountSql += "";
}
else
{
	ListSql += " and GroupID=" + GroupID + " order by Role,id";
	CountSql += " and GroupID=" + GroupID;
}

long nowdate = System.currentTimeMillis()/1000;

ResultSet Rs = tu_user.List(ListSql,CountSql,1,1000);
String html = "";
if(tu_user.pagecontrol.getRowsCount()>0){

	int m=0;
	while(Rs.next())
	{
		String Name = convertNull(Rs.getString("Name"));
		int id = Rs.getInt("id");

		String checkbox =  "";
		if(Arrays.asList(userIds).contains(id+"")){
			checkbox = "checked";
		}

		if(m==0){
			html += "<div class=\"row ckbox-row\">";
		}
		m++;

		html += "<label class=\"ckbox mg-r-20\">";
		html += "<input name=\"id\" type=\"checkbox\" value=\""+id+"\" describe=\""+Name+"\" "+checkbox+"><span>"+Name+"</span>";
		html += "</label>";

		if(m==3){ 
			html += "</div>";
			m=0;
		}
	}
	tu_user.closeRs(Rs);
}

o.put("html", html);
o.put("groupName", groupName);

out.println(o);
%>