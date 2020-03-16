<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
                tidemedia.cms.system.Document,
                tidemedia.cms.system.ItemUtil,
				java.util.*,
				java.io.*,
				java.text.SimpleDateFormat,
				java.util.Date,
                java.text.*,
				java.util.HashMap,
				org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="../config1.jsp"%>
<%!
	public int  channelid=16740;
	public  boolean unBind(int parentid,int globalid)throws MessageException, SQLException{	
		String Table =CmsCache.getChannel(channelid).getTableName();
		String sql ="update "+Table+" set isBind=0 where GlobalID="+globalid;
		TableUtil tu = new TableUtil();
		int i =tu.executeUpdate(sql);
		if(i>0){
			return true;
		}else{
			return false;
		} 		
	}
%>
<%
	int id = getIntParameter(request,"id");
	int docid = getIntParameter(request,"docid");
        //或者是先查询是否绑定 未绑定的返回已绑定
	JSONObject json =new JSONObject();
	boolean b =unBind(id,docid);
	if(b){
		json.put("status",1);
		json.put("message","成功");
	}else{
		json.put("status",0);
		json.put("message","失败");
	}
	out.print(json);
%>
