<%@ page import="java.io.*,tidemedia.cms.util.*,tidemedia.cms.system.*,tidemedia.cms.base.*,java.sql.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
int		channelid				= getIntParameter(request,"ChannelID");
String  title					= getParameter(request,"Title");
int		gid						= 0;
int		itemid					= 0;
Channel channel = CmsCache.getChannel(channelid);

if(channel.getChannelCode().startsWith("3625_4024_4347"))
{
int categoryid = 0;
if(channel.getType()==Channel.Category_Type)
{//继承表单的频道
	categoryid = channelid;
}

if(title.length()==0) title = "title";
TableUtil tu = new TableUtil();

String sql = "insert into " + channel.getTableName() + " (Title,SubTitle,Keyword,Tag,Category,CreateDate,User,TotalPage,PublishDate,Status,Active,ModifiedDate) values(";
sql += "'" + tu.SQLQuote(title) + "','','','',"+categoryid+",UNIX_TIMESTAMP(),"+userinfo_session.getId()+",1,UNIX_TIMESTAMP(),0,1,UNIX_TIMESTAMP())";

int insertid = tu.executeUpdate_InsertID(sql);

sql = "update " + channel.getTableName() + " set OrderNumber=" + insertid + " where id=" + insertid;
tu.executeUpdate(sql);

Document document = new Document(insertid,channel.getId());
new ItemSnap().Add(document);//加入全局库
gid = document.getGlobalID();
itemid = document.getId();
}
%>[{GlobalID:'<%=gid%>',ItemId:'<%=itemid%>'}]