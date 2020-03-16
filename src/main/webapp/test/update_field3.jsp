<%@ page import="java.sql.*,tidemedia.cms.system.*,java.util.*,tidemedia.cms.base.*,tidemedia.cms.util.*,java.util.ArrayList"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config1.jsp"%>
<%

	String oldsrc="http://115.29.150.217";
	String newsrc="http://101.200.83.135";
	TableUtil video_update=new TableUtil();
	int count=0;
	List<Map> list =new ArrayList<Map>();
	String Channel_="14175,14188,14193,14198,14199,14212,14213,14214";
	String[] Channel_group=Channel_.split(",");
	for(String id:Channel_group){
		TableUtil video=new TableUtil();
		String sql_video="select * from "+CmsCache.getChannel(Util.parseInt(id)).getTableName()+" where photo like '"+oldsrc+"%'";
		ResultSet rs=video.executeQuery(sql_video);
		while(rs.next()){
			HashMap<String, String> map = new HashMap<String, String>();
			int globalid=rs.getInt("GlobalID");
			String Photo=rs.getString("photo");
			if(Photo!=null){
				map.put("photo",Photo);
				map.put("globalid",globalid+"");
				list.add(map);
			}
		}
		video.closeRs(rs);
	}
	
	for(int i=0;i<list.size();i++){
		Map map1 = list.get(i);
		String Photo1 = map1.get("photo")+"";
		String Photo_new=Photo1.replace(oldsrc,newsrc);
		String globalid=map1.get("globalid")+"";
		
		Document document = new Document(Util.parseInt(globalid));
		Channel channel = CmsCache.getChannel(document.getChannelID());
		String sql_update="update "+channel.getTableName()+" set photo='"+Photo_new+"' where globalid="+globalid+" ";
		video_update.executeUpdate(sql_update);
		out.print(sql_update+"<br>");
		//System.out.print(sql_update+"<br>");
	}
	
%>
