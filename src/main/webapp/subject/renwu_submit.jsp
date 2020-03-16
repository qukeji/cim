<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.base.*,
                tidemedia.cms.user.*,
                tidemedia.cms.util.*,
                java.sql.*,
                org.json.*,
                java.util.*"%>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
    //任务提交接口
    String Action = getParameter(request,"Action");
    String callback=getParameter(request,"callback");
    JSONObject object=new JSONObject();
    int channelid       = getIntParameter(request,"ChannelID");
    int	ItemID			= getIntParameter(request,"ItemID");
    if (channelid==0){
        object.put("message","频道id不能为空");
        out.println(object);
        return;
    }
    int userId = userinfo_session.getId();
    String  userName = userinfo_session.getName();
    String StartDate            = getParameter(request,"StartDate");
    String users        = getParameter(request,"users");
    String EndDate          = getParameter(request,"EndDate");
    String title        = getParameter(request,"Title");
    String summary      = getParameter(request,"Summary");
    String users_id     = getParameter(request,"users_id");
    int SubjectId       = getIntParameter(request,"SubjectId");
    int TaskType        = getIntParameter(request,"TaskType");
    int TaskStatus      = getIntParameter(request,"TaskStatus");

    String SubjectName      = getParameter(request,"SubjectName");
    String user[]=users.split(",");
    String userid[]=users_id.split(",");

    HashMap map=new HashMap();
   
    map.put("StartDate",String.valueOf(StartDate));
    map.put("EndDate",String.valueOf(EndDate));
    map.put("users",String.valueOf(users));
    map.put("Title",String.valueOf(title));
    map.put("Summary",summary);
    map.put("users",users);
    map.put("UserID",users_id);
    map.put("SubjectId",SubjectId+"");
    map.put("TaskType",TaskType+"");
    map.put("SubjectName",SubjectName);
    map.put("TaskStatus",TaskStatus+"");

    map.put("User",userId+"");

    int gid = 0;
    if(Action.equals("Add"))
    {//2013-07-15 15:41:34
        gid = ItemUtil.addItemGetGlobalID(channelid, map);//添加到任务库
    }
    if(Action.equals("Update"))
    {
        System.out.println("update....");
        gid = CmsCache.getDocument(ItemID, channelid).getGlobalID();
        System.out.println(gid);
        ItemUtil.updateItem(channelid,map,gid,userinfo_session.getId());
    }

    if(gid!=0){
        object.put("id",gid);
        object.put("message","任务插入成功");
        object.put("status",200);

    }else {
        object.put("id",0);
        object.put("status","500");
        object.put("message","程序异常");
    }
   
    /*
     * 执行插入到操作记录库
     * */
   
    
    out.println(object);
%>
