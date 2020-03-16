<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%						
		TableUtil u=new TableUtil();
		TableUtil u1=new TableUtil();
		TableUtil tu3=new TableUtil();
		String sql="select ChannelID,ItemID,Title from item_snap";// limit 0,800";
		ResultSet rs = u.executeQuery(sql);
		ResultSet rs1 = null;
		while(rs.next()){
			int cid=rs.getInt(1);
			int iid=rs.getInt(2);
			//String title=convertNull(rs.getString("Title"));
			if(cid==0){
				out.println("[channelid is 0！]");
			}else{
				/*
				Document c=new Document(iid,cid);
				if(c==null){
					out.println("[object null！]");
				}else{
					out.println("[title:"+c.getTitle()+"]");
				}*/
				boolean exist = false;
				try{
				Channel channel = CmsCache.getChannel(cid);//new Channel(cid);
				String sql1="select id from "+channel.getTableName()+" where id="+iid;
				rs1 = u1.executeQuery(sql1);				
				if(rs1.next()){
					exist = true;
				}
				u1.closeRs(rs1);
				}catch(SQLException e){}

				if(!exist)
				{
					out.println("[不存在]"+iid);
					tu3.executeUpdate("delete from item_snap where ChannelID="+cid+" and ItemID="+iid);
				}
			}
		}
		u.closeRs(rs);
%>