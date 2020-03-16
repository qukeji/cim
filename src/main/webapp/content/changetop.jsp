<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
//获取数据库当前时间
	public static int getCurrentTimeSql() throws Exception{
		TableUtil tu=new TableUtil();
		int CurrentTimeL=0;
		String sql="select UNIX_TIMESTAMP() as now";
		ResultSet rs=tu.executeQuery(sql);
		while(rs.next()){
			CurrentTimeL=rs.getInt("now");
		}
		tu.closeRs(rs);
		return CurrentTimeL;
	}
%>
<%
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int way = getIntParameter(request,"way");
String items = getParameter(request,"ids");
if(way==2)
	way = 0;
else if(way==1) 
	way = 1;
Channel channel = CmsCache.getChannel(id);
if(channel==null || channel.getId()==0)
{
	response.sendRedirect("../content/content_nochannel.jsp");
	return;
}

String [] idsgroup=items.split(",");

	for(String itemid:idsgroup){


		int itemid_int=Util.parseInt(itemid);
		Document doc = new Document(itemid_int,id);
		int gid=doc.getGlobalID();
		int status = doc.getStatus();

		HashMap<String,String> map = new HashMap<String,String>();
		int CurrentTime=getCurrentTimeSql();
		if(way==0){
			CurrentTime=0;
		}

		map.put("DocTop",way+"");
		map.put("DocTopTime",CurrentTime+"");
		ItemUtil.updateItem(id,map,gid,userinfo_session.getId());
		//如果不是草稿，触发发布
		if(status!=0){
			doc.Approve(doc.getId()+"",doc.getChannelID());
			//System.out.println("发布耶也");
		}
        
		Log l = new Log();
	    l.setTitle(doc.getTitle());
	    l.setUser(userinfo_session.getId());
	    l.setItem(itemid_int);
	    if(way==1){
	        l.setLogAction(1700);
	    }else{
	        l.setLogAction(1701);
	    }
	    l.setFromType("channel");
	    l.setFromKey((new StringBuilder()).append(id).append("").toString());
	    l.Add();
        
	}
out.println("success");
%>
