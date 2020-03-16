<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*,
				java.net.URLDecoder,
 java.io.File,
 java.io.IOException,
 java.nio.charset.Charset,
java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>

<%
    /*
        接收热点数据
     */
    TideJson hot_channel= CmsCache.getParameter("spider_hot_parentid").getJson();
    Integer parent_channelid = hot_channel.getInt("channelid");
    String channelName = getParameter(request,"channelName");
    Integer channelid= 0;
    String sql="select id from channel where Name ='"+channelName+"' and parent="+parent_channelid;

    TableUtil tu = new TableUtil();

    ResultSet rs = tu.executeQuery(sql);
    if(rs.next()){
        channelid = rs.getInt("id");
    }
    tu.executeUpdate("delete from "+CmsCache.getChannel(parent_channelid).getTableName()+" where category="+channelid +" and date_format(FROM_UNIXTIME(createdate),'%Y-%m-%d') <= date_format(DATE_SUB(curdate(), INTERVAL 1 MONTH),'%Y-%m-%d')");
    tu.closeRs(rs);
    if(channelid==0){
        return;
    }
    String DocFrom = URLDecoder.decode(getParameter(request,"DocFrom"),"utf-8");
    String hot = URLDecoder.decode(getParameter(request,"hot"),"utf-8");
    String SpiderUrl = URLDecoder.decode(getParameter(request,"SpiderUrl"),"utf-8");
    String picurl = URLDecoder.decode(getParameter(request,"picurl"),"utf-8");
    String videourl = URLDecoder.decode(getParameter(request,"videourl"),"utf-8");
    String newurl = URLDecoder.decode(getParameter(request,"newurl"),"utf-8");
    String Title = URLDecoder.decode(getParameter(request,"Title"),"utf-8");
    SpiderUrl = SpiderUrl.replace("^","&");
    picurl=picurl.replace("^","&");
    videourl=videourl.replace("^","&");
    newurl =newurl.replace("^","&");
    HashMap<String,String> mapParam = new HashMap<String, String>();
    mapParam.put("DocFrom",DocFrom);
    mapParam.put("hot",hot);
    mapParam.put("SpiderUrl",SpiderUrl);
    mapParam.put("picurl",picurl);
    mapParam.put("videourl",videourl);
    mapParam.put("newurl",newurl);
    mapParam.put("channelName",channelName);
    mapParam.put("Title",Title);
    mapParam.put("Status",1+"");

    ItemUtil its = new ItemUtil();
    its.addItemGetID(channelid, mapParam);//根据频道id入库微博数据

%>
