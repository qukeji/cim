<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*,java.util.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
public String getShowPath(Channel channel) throws Exception{//显示站点发布节点

    String path = "";
    ArrayList arraylist = channel.getParentTree();

    if ((arraylist != null) && (arraylist.size() > 0))
    {
      for (int i = 0; i < arraylist.size(); ++i)
      {
        Channel ch = (Channel)arraylist.get(i);

		if((i+1)==arraylist.size()){//当前频道名
			path = path  + ch.getName() ;// + ((i < arraylist.size() - 1) ? ">" : "");
		}else{
			path = path  + ch.getName() + " > ";// + ((i < arraylist.size() - 1) ? ">" : "");
		}        
      }
    }

    arraylist = null;

    return path;
}
%>
<%	
	int	 ChannelID	 =	getIntParameter(request,"ChannelID");//当前频道id
	int	 channeliD	 =	getIntParameter(request,"channeliD");//站点id
	int	 itemId		 =	getIntParameter(request,"ItemID");//文章id
	String	 type	 =	getParameter(request,"type");//类型
	String	 weixinId	 =	getParameter(request,"weixinId");//微信公众号id
	Channel channel  = CmsCache.getChannel(channeliD);
	String  sitepath = getShowPath(channel);
	String  title  = "";
	Document Doc=CmsCache.getDocument(itemId,ChannelID);
	if(itemId != 0){
		title = Doc.getTitle();
	}else{
		title = "未命名";
	}
	
	int m = 0;
	if(type.equals("网站")){
		 m = 0;
	}
	if(type.equals("APP")){
		 m = 1;
	}
	if(type.equals("两微")){
		 m = 2;
	}
	if(type.equals("三方媒体")){
		 m = 3;
	}
	if(type.equals("电视端")){
		 m = 4;
	}
	if(type.equals("其他")){
		 m = 5;
	}
	String showMessage="";
	if(m !=2 ){
		showMessage += "<tr id='"+channeliD+m+"'><td>"+type+"<td><a href='javascript:;' class='pd-l-5'>"+sitepath
				+"</span></td><td>"+title+"</td><td>草稿</td><td class='td-handle'>"
				+"<button class='btn btn-info btn-sm mg-r-5 tx-13' onclick='fedit()'>编辑</button>"
				+"<button class='btn btn-info btn-sm mg-r-5 tx-13' onclick='fcancel()'>撤稿</button>"
				+"<button class='btn btn-info btn-sm tx-13' onclick='fdel("+m+','+channeliD+")'>删除</button></td></tr>";
	}else{
		String weixinIds = "\""+weixinId+"\"";
		JSONArray array =  new ChannelRecommend().findWeiXinAccount(userinfo_session.getId());
		sitepath = array.getJSONObject(0).get("accountname").toString();
		showMessage += "<tr id='"+weixinId+m+"'><td>"+type+"<td><a href='javascript:;' class='pd-l-5'>"+sitepath
				+"</span></td><td>"+title+"</td><td>草稿</td><td class='td-handle'>"
				//+"<button class='btn btn-info btn-sm mg-r-5 tx-13' onclick='fedit()'>编辑</button>"
				//+"<button class='btn btn-info btn-sm mg-r-5 tx-13' onclick='fcancel()'>撤稿</button>"
				+"<button class='btn btn-info btn-sm tx-13' onclick='fdel("+m+','+weixinIds+")'>删除</button></td></tr>";
	}
	JSONObject json = new JSONObject();
	json.put("showMessage", showMessage);
	out.println(json);
%>