<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				java.util.*,
				tidemedia.cms.util.*,tidemedia.cms.publish.*,java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

	if(!userinfo_session.isAdministrator())
	{ response.sendRedirect("../noperm.jsp");return;}

	TableUtil tu = new TableUtil();
	String sql = "SELECT * FROM channel where Type=2";
	ResultSet rs = tu.executeQuery(sql);
	while(rs.next()){
		int id = rs.getInt("id");
		//获取保留的数据的id字符串（id1,id2,id3）
		TableUtil tu3 = new TableUtil();
		String sql3 = "select * from page_content where Page="+id+" order by CreateDate desc limit 3";
		ResultSet rs3 = tu3.executeQuery(sql3);
		String ids = "(";
		int n = 0;
		while(rs3.next()){
			int id3 = rs3.getInt("id");
			if(n==0){
				ids += id3;
			}else{
				ids += ","+id3;				
			}
			n++;
		}
		ids += ")"; 
		tu3.closeRs(rs3);
		//删除数据
		TableUtil tu2 = new TableUtil();
		String deletesql = "delete from page_content where Page="+id+" and id not in "+ids;
		tu2.executeUpdate(deletesql);	
	}
	tu.closeRs(rs);
%>
