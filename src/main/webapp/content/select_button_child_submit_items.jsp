<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.util.StringUtils,
				tidemedia.cms.user.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				java.util.ArrayList,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%!
public static void selectChildSubmitItems(int channelid,int globalid,String ids,int user) throws MessageException, SQLException
{
	int[] ids_ = Util.StringToIntArray(ids, ",");
	TableUtil tu = new TableUtil();
	String sql = "";
	String table = "relation_button" ;
	
	for(int i = ids_.length-1;i>=0;i--)
	{
		int ChildGlobalID = ids_[i];
		sql = "insert into " + table + "(GlobalID,ChildGlobalID) values(" + globalid + "," + ChildGlobalID + ")";
		int insertid = tu.executeUpdate_InsertID(sql);
		sql = "update " + table + " set OrderNumber=" + insertid + " where id=" + insertid;
		tu.executeUpdate(sql);
	}
	Document document = new Document(globalid);
	Log l = new Log();
	l.setTitle(document.getTitle());
	l.setUser(user);
	l.setItem(document.getId());

	l.setLogAction(LogAction.document_add_relation);//l.setLogAction(110);
	l.setFromType("channel");
	l.setFromKey(channelid+"");
	l.Add();
}
%>
<%
	/*
	  *王海龙 2016/8/19  同一个记录在一篇文章中只添加一次
	  *
	  */
	int		ChannelID				= getIntParameter(request,"ChannelID");
	int		GlobalID				= getIntParameter(request,"GlobalID");
	String	ChildGlobalID			= getParameter(request,"ChildGlobalID");
	int		fieldgroup				= getIntParameter(request,"fieldgroup");


	ChannelPrivilege cp = new ChannelPrivilege();
	if(!cp.hasRight(userinfo_session,ChannelID,2))
	{
		response.sendRedirect("../close_pop.jsp");return;
	}
	TableUtil tu = new TableUtil();
	ResultSet rs = tu.executeQuery("select * from relation_button"+" where  childglobalid in ("+ChildGlobalID+") and globalid="+GlobalID);
	System.out.println("select * from relation_button"+" where  childglobalid in ("+ChildGlobalID+") and globalid="+GlobalID);
	boolean exist = false;
	if(rs.next())
	{
			exist = true;
	%>
	<script>
		alert("请确认是否已添加过选择的记录！");
		history.back();
	</script>
	<%
	}
	else
	{
			selectChildSubmitItems(ChannelID,GlobalID,ChildGlobalID,userinfo_session.getId());
			
	%>
		<script>
		opener.top.showTab(<%=fieldgroup%>,true);
		self.close();
	 </script>
	<%}

%>
