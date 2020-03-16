<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
    //更新评价接口
%>
<%!
    public static HashMap<String ,Object> addPolitics( int gid, int evaluation){
        HashMap<String ,Object> map= new HashMap<String,Object>();
        try{
            if(gid==0){
                map.put("status",501);
                map.put("message","缺少参数");
            }else{
                TideJson politics = CmsCache.getParameter("politics").getJson();
                int channelid1 = politics.getInt("politicsid");
                HashMap politicsmap=new HashMap();
                politicsmap.put("evaluation",evaluation+"");
                ItemUtil.updateItemByGid( channelid1,politicsmap, gid,1);
                //获得itemid
                Document doc1=CmsCache.getDocument(gid);
                int itemId = doc1.getId();
                Document doc = new Document(itemId,channelid1);
                //调用接口配置接口
    	        doc.Approve(itemId+"",channelid1);//发布
                map.put("message","更新成功");
                map.put("status",200);
            }
        }catch (Exception e){
                map.put("status","500");
                map.put("message","更新失败");
                
                e.printStackTrace();
        }
        return map;
    }
%>
<%
	String callback=getParameter(request,"callback");
    JSONObject json = new JSONObject();
    int   id      =   getIntParameter(request,"id");
    int   evaluation     =   getIntParameter(request,"evaluation");
    evaluation=evaluation+1;
    HashMap<String, Object> map = addPolitics(id,evaluation);
    json = new JSONObject(map);
    out.println(callback+"("+json.toString()+")");
%>















