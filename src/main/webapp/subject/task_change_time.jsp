<%@ page import="tidemedia.cms.user.UserInfo,tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				java.util.*,
				java.text.ParseException,
				java.text.SimpleDateFormat"%>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
public static int dateToStamp(String s){
    int data=0;
    String res = "";
    try {
    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Date date = simpleDateFormat.parse(s);
    long ts = date.getTime();
    res = String.valueOf(ts);
    data = Integer.valueOf(res.substring(0,res.length()-3));
    } catch (ParseException e) {
        e.printStackTrace();
    }
return data;
}
    
%>

<%
System.out.println("======================hahahahahahahahh ");
int		GlobalID			= getIntParameter(request,"GlobalID");
Document doc = CmsCache.getDocument(GlobalID);
if(doc!=null){
    int ItemID = doc.getId();
    int ChannelID = doc.getChannel().getId();
    String start_time = doc.getValue("start_time");
    System.out.println("======================start_time;"+start_time);
    int start = dateToStamp(start_time);
    HashMap<String, String> map = new HashMap<String, String>();
    map.put("start",start+"");
    System.out.println("======================start;"+start);
    ItemUtil.updateItemById(ChannelID, map, ItemID, 1);
    if(doc.getStatus()==1){
        doc.setUser(userinfo_session.getId());
        doc.Approve(ItemID+"", ChannelID);//发布
        System.out.println("===============================发布了");
    }else{
        doc.setUser(userinfo_session.getId());
        doc.Delete2(ItemID+"",ChannelID);//撤稿
        System.out.println("======================撤稿了");
    }

}

%>
