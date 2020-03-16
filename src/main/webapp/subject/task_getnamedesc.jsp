 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
				tidemedia.cms.util.*,
				java.sql.SQLException,
				java.sql.Timestamp,
				java.text.ParseException,
				java.text.SimpleDateFormat,
				java.util.Date,
				java.util.regex.Pattern"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>

<%
//设备和车辆名称
    JSONObject oo = new JSONObject();

	try{
	int ChannelID = getIntParameter(request,"ChannelID");
    String  itemid = getParameter(request,"itemid");
    int ItemID = 0;
    String[] itemidArray = itemid.split(",");

    //String keywords = CmsCache.getParameterValue("keywords");
	//int videoroot = CmsCache.getParameter("wenzheng_operating_record").getIntValue();

	 if(ChannelID==0){
		    oo.put("code",500);
			oo.put("message","频道id有误");
	 }else if(itemid==null||itemid.equals("")){
			oo.put("code",500);
			oo.put("message","id为空");
	 }else{

        //JSONArray jsonArray = new JSONArray(); 
        String name = "";
        JSONObject o = new JSONObject();
        for (int i = 0; i < itemidArray.length; i++) {
            ItemID = Integer.parseInt(itemidArray[i]);
            System.out.println("=========================ItemID:"+itemidArray[i]);
            
            if(ItemID!=0){
                Document doc=CmsCache.getDocument(ItemID,ChannelID);
                name += ","+doc.getTitle();
                
                
                
                //JSONObject o = new JSONObject();
                //o.put("name",name+"");
                //jsonArray.put(o);
            }
            
            
        }
        //o.put("name",name+"");
        if(name!=""){
            name = name.substring(1);
        }
        oo.put("name",name);
        oo.put("message","获取成功！");
        oo.put("code",200);        
  }
	}catch(Exception e){
			oo.put("message","接口调用失败，请检查传值参数");
			oo.put("code",500);
	}
	 
	out.println(oo.toString());
%>



