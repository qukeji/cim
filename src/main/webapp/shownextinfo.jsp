<%@ page
import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.user.*,java.util.*,java.sql.*"
%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
	public boolean hasChild(String table ,int cid) throws Exception{
		TableUtil tu = new TableUtil();
		String sql = "select * from "+table+"  where Status=1 and Parent="+cid;
		ResultSet rs = tu.executeQuery(sql);
		boolean result = false;
		if(rs.next())
			result = true;
		tu.closeRs(rs);
		System.out.println(result+"=result");
		return result;
	}
%>
<%
if(! userinfo_session.isAdministrator())
{response.sendRedirect("../noperm.jsp");return;}
int cid_ = getIntParameter(request,"cid");
int itemid_  = getIntParameter(request,"itemid");
int channelid = getIntParameter(request,"channelid");
int level_ = getIntParameter(request,"level");
int haschild = getIntParameter(request,"haschild");
 
//if(haschild!=0 || level_==0){
	Channel channel = CmsCache.getChannel(channelid);
	String table = channel.getTableName();
	TableUtil tu = new TableUtil();
	String sql = "select * from "+table+"  where Status=1 and Parent="+cid_;
	//System.out.println("sql###="+sql);
	ResultSet rs = tu.executeQuery(sql);
	String str ="";
	 if(haschild==1){
		if(level_==0){
			str += "<div id=\"level"+(level_+1)+"\" class=\"c_m_box first\" style=\"\"><ul >";
		}else{
			str += "<div id=\"level"+(level_+1)+"\" class=\"c_m_box\" style=\"\"><ul >";
		}
	
		while(rs.next()){
			int itemid = rs.getInt("id");
			String Title = rs.getString("Title");
			int cid = rs.getInt("cid");
			int Level = rs.getInt("Level");
			int Parent = rs.getInt("Parent");
			int hasN = rs.getInt("haschild");
			int gid = rs.getInt("GlobalID");
			// System.out.println("gid="+gid+"=="+Parent);		 
			if(hasChild(table,cid))//有子节点
				str +="<li class=\"\" hasNext=\"1\" itemid=\""+itemid+"\" cid=\""+cid+"\" level=\""+Level+"\" globalid=\""+gid+"\">"+Title+"</li>";
			else
				str +="<li class=\"no_arrow\" hasNext=\"0\" itemid=\""+itemid+"\" cid=\""+cid+"\"  level=\""+Level+"\" globalid=\""+gid+"\">"+Title+"</li>";
			 
		}
		str += "</ul></div>";
		out.println(str);
	//}
	tu.closeRs(rs);
 }
%>
