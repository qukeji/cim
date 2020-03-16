<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.io.*,tidemedia.cms.util.*,tidemedia.cms.system.*,tidemedia.cms.base.*,java.sql.*"%>
<%@ include file="../config1.jsp"%><%
request.setCharacterEncoding("utf-8");
String		vid			= getParameter(request,"vid");
String		itemid		= getParameter(request,"itemid");
String		aid			= getParameter(request,"aid");
String		status		= getParameter(request,"status");
String		videotype	= getParameter(request,"videotype");
String		Title		= getParameter(request,"title");
String		Userid		= getParameter(request,"userid");
String		Username	= getParameter(request,"username");
String		clubcreatetime	= getParameter(request,"createtime");
String		filepath	= getParameter(request,"filepath");
String		Keyword			= getParameter(request,"tag");
String		flv			= getParameter(request,"flv");
String		piccount	=getParameter(request,"piccount");
String		action	=getParameter(request,"action");
String  result			= "false";

if(!vid.equals(""))
{
int id=5017;
Channel channel =CmsCache.getChannel(id);
		TableUtil tu = new TableUtil();
		String statusdesc = "";
		if(status.equals("1")) statusdesc = "处理失败";
		else if(status.equals("2")) statusdesc = "处理中";
		else if(status.equals("3")) statusdesc = "处理完成";
		
	if(action.equals("new")){
		String sql="insert into "+channel.getTableName();
		sql+="(Title,vid,itemid,aid,videostatus,videotype,userid,username,";
		sql+="clubcreatetime,filepath,flv,piccount,SubTitle,Keyword,Tag,CreateDate,ModifiedDate,PublishDate,Active,Status,Category)";
				sql+=" values(";
				sql+="'"+tu.SQLQuote(Title)+"'";
				sql+=",'"+tu.SQLQuote(vid)+"'";
				sql+=",'"+tu.SQLQuote(itemid)+"'";
				sql+=",'"+tu.SQLQuote(aid)+"'";
				sql+=",'"+tu.SQLQuote(statusdesc)+"'";
				sql+=",'"+tu.SQLQuote(videotype)+"'";
				sql+=",'"+tu.SQLQuote(Userid)+"'";
				sql+=",'"+tu.SQLQuote(Username)+"'";
				sql+=",'"+tu.SQLQuote(clubcreatetime)+"'";
				sql+=",'"+tu.SQLQuote(filepath)+"'";
				sql+=",'"+tu.SQLQuote(flv)+"'";
				sql+=",'"+tu.SQLQuote(piccount)+"'";
				sql+=",''";
				sql+=",'"+tu.SQLQuote(Keyword)+"'";
				sql+=",''";
				sql+=",UNIX_TIMESTAMP()";
				sql+=",UNIX_TIMESTAMP()";
				sql+=",UNIX_TIMESTAMP()";
				sql+=",1";
				sql+=",0";
				sql+=","+id;
				sql+=")";
		int insertid = tu.executeUpdate_InsertID(sql);
		
		//更新序数
		sql = "update " + channel.getTableName() + " set OrderNumber=" + insertid + " where id=" + insertid;
		tu.executeUpdate(sql);
		
		Document document = new Document(insertid,id);
		new ItemSnap().Update(document);//加入全局库
	}else if(action.equals("update")){
		String sql = "update " + channel.getTableName() + " set ";
		sql += "vid='" + tu.SQLQuote(vid)+ "'";
		if(!Title.equals(""))
			sql += ",Title='" + tu.SQLQuote(Title)+ "'";
		if(!itemid.equals(""))
			sql += ",itemid='" + tu.SQLQuote(itemid) + "'";
		if(!aid.equals(""))
		sql += ",aid='" + tu.SQLQuote(aid) + "'";
		if(!statusdesc.equals(""))
			sql += ",videostatus='" + tu.SQLQuote(statusdesc) + "'";
		if(!videotype.equals(""))
			sql += ",videotype='" + tu.SQLQuote(videotype) + "'";
		if(!Userid.equals(""))
			sql += ",userid='" + tu.SQLQuote(Userid) + "'";
		if(!Username.equals(""))
			sql += ",username='" + tu.SQLQuote(Username) + "'";
		if(!clubcreatetime.equals(""))
			sql += ",clubcreatetime='" + tu.SQLQuote(clubcreatetime) + "'";
		if(!filepath.equals(""))
			sql += ",filepath='" + tu.SQLQuote(filepath) + "'";
		if(!flv.equals(""))
			sql += ",flv='" + tu.SQLQuote(flv) + "'";
		if(!Keyword.equals(""))
			sql += ",Keyword='" + tu.SQLQuote(Keyword) + "'";
		if(!piccount.equals(""))
			sql += ",piccount='"+tu.SQLQuote(piccount)+"'";
		sql += " where vid='"+tu.SQLQuote(vid)+"'";
		tu.executeUpdate(sql);
	}
		result = "true";
}
out.println(result);
%>