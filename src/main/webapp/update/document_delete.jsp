<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				java.io.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	getIntParameter(request,"ChannelID");
String		ItemID	=	getParameter(request,"ItemID");

int		CategoryID	=	getIntParameter(request,"CategoryID");
int		currPage	=	getIntParameter(request,"currPage");
int		rowsPerPage =	getIntParameter(request,"rowsPerPage");
int id = getIntParameter(request,"fileitemid");
//out.println("id="+id);
Channel channel = CmsCache.getChannel(5048);
String sql="select * from "+channel.getTableName()+" where id="+id;
TableUtil tu = new TableUtil();
ResultSet rs = tu.executeQuery(sql);
String title="";
String filename="";
String folder="";
String parentid="";
String site ="d:/web/tidecms_update/";
if(rs.next()){
	title = rs.getString("Title");
	filename = rs.getString("file");
	folder = rs.getString("folder");
	parentid=rs.getString("Parent");
}
tu.closeRs(rs);
if(!folder.endsWith("/")){
	folder+="/";
}

Channel channel_ = CmsCache.getChannel(5047);
String sql_="select * from "+channel_.getTableName()+" where GlobalID="+parentid;
out.println("sql_"+sql);
TableUtil tu_ = new TableUtil();
ResultSet rs_ = tu_.executeQuery(sql_);
int folderid=0;
if(rs_.next()){
	folderid=rs_.getInt("id");
}else{
out.println("can not find rs");
}
tu_.closeRs(rs_);
out.println("folderid="+folderid);
out.println(title+filename+folder+parentid);
String path = site+folderid+"/"+folder+filename;
out.println("path="+path);
File file = new File(path);
if(file.exists()){
	out.println("存在");
	file.delete();
}else{
	out.println("不存在");
}
if(ChannelID!=0 && !ItemID.equals(""))
{
	ChannelPrivilege cp = new ChannelPrivilege();
	if(cp.hasRight(userinfo_session,CategoryID>0?CategoryID:ChannelID,4))
	{
		Document document = new Document();
		document.setUser(userinfo_session.getId());
		document.Delete(ItemID,ChannelID);
	}

	String url = "";
	if(CategoryID==0)
		url = "../content/content.jsp?id="+ChannelID;
	else
		url = "../countent/content.jsp?id="+CategoryID;
	
	url += "&currPage="+currPage+"&rowsPerPage="+rowsPerPage;

	//response.sendRedirect(url);
}
%>
