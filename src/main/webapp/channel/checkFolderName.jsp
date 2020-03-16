<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,java.sql.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%!
	//自动生成目录名
	public static String getAutoFolderName(int parent) throws MessageException, SQLException{
		
		String FolderName = "";
		String sql = "";
		
		TableUtil tu = new TableUtil();
		int begin = 97;
		int i = 0;
		while(begin<=122 && i<=10)
		{
			sql = "select * from channel where FolderName='" + tu.SQLQuote(FolderName + (char)begin)	+ "' and Parent="+parent;
			if (!tu.isExist(sql)) {
				return FolderName + (char)begin;
			}
			
			begin ++;
			
			if(begin>122)
			{
				begin = 97;
				FolderName = FolderName + (char)(97 + i);
				i++;
			}
		}
		
		return FolderName;
	}
%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");

String FolderName =	getParameter(request,"FolderName");//目录名
int parent =	getIntParameter(request,"parent");//父频道编号
int type = getIntParameter(request,"type") ; //type=0:新建  type==1:修改
int id = 0;
if(type==1){
	id = parent ;
	Channel channel = new Channel(parent);
	parent = channel.getParent();
}

int id_ = 0;
TableUtil tu = new TableUtil();
String sql = "select id from channel where FolderName='"+tu.SQLQuote(FolderName)+"' and Parent="+parent + " and id!="+id;
ResultSet rs = tu.executeQuery(sql);
while(rs.next())
{
	id_ = rs.getInt("id");
}
tu.closeRs(rs);

if(id_!=0&&type==0){//新建时目录名重复
	FolderName = getAutoFolderName(parent);
}


JSONObject json = new JSONObject();
json.put("id",id_);
json.put("FolderName",FolderName);

out.println(json);
%>
