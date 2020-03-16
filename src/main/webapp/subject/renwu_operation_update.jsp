<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.util.Date" %>
<%@ page import="javax.rmi.CORBA.Util" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

    int id = getIntParameter(request,"id");
    int channelid =getIntParameter(request,"channelid");
    JSONObject jsonObject=new JSONObject();
    if (channelid==0&&id==0){
        jsonObject.put("msg","参数不能为空");
        jsonObject.put("status","500");
        out.print(jsonObject);
        return;
    }
    Date RealStartDate = null;
    Date RealFinishDate = null;
    Date RealEndDate = null;
    int UserID = getIntParameter(request,"UserID");
    //int ItemId = getIntParameter(request,"ItemId");
    String FinishDesc = getParameter(request,"FinishDesc");
    int TaskStatus = getIntParameter(request,"TaskStatus");
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    HashMap map=new HashMap();
    if (TaskStatus==1){
        RealStartDate=new Date();
        map.put("RealStartDate",formatter.format(RealStartDate));
    }
    if (TaskStatus==2){
        RealFinishDate=new Date();
        map.put("FinishDesc",FinishDesc+"");
        map.put("RealFinishDate", formatter.format(RealFinishDate));
    }
    if (TaskStatus==3){
        RealEndDate=new Date();
        map.put("RealEndDate",formatter.format(RealEndDate));
    }

    //map.put("UserID",UserID);
    map.put("TaskStatus",TaskStatus+"");

    ItemUtil.updateItemById(channelid,map,id,UserID);
    jsonObject.put("msg","更新成功");
    jsonObject.put("status","200");
      out.print(jsonObject);

%>
