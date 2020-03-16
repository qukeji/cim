<%@ page import="tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*,java.net.*,java.sql.*,tidemedia.cms.base.*,tidemedia.cms.scheduler.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%@ include file="../approve/approve_config.jsp"%>
<%
    /**
     * 用途：提交审核
     */
    int gid = getIntParameter(request,"globalid");
    if(gid==0){
        out.println("请先保存稿件");
        return ;
    }


    String title = getParameter(request,"title");
    title = URLDecoder.decode(title,"utf-8");
    int action = getIntParameter(request,"action");
    int approveId = getIntParameter(request,"approveId");
    int approveendid = getIntParameter(request,"approveendid");
    int endApprove = getIntParameter(request,"endApprove");
    String actionMessage = getParameter(request,"actionMessage");
    String user = getParameter(request,"user");//有审核权限的用户
    Document document=CmsCache.getDocument(gid);
    int channelid=document.getChannelID();//获取评到id
    Channel channel=document.getChannel();


    ApproveItems approve_item = new ApproveItems(approveId);


    

    String[] users = user.split(",");
    int userid = userinfo_session.getId();//当前用户
    String UserName	= CmsCache.getUser(userid).getName();


    String name = approve_item.getTitle();
    int type = approve_item.getType();
    int userid_approve=document.getUser();

    String Titlename=document.getTitle();

    if(!Arrays.asList(users).contains(userid+"")&&action!=2){
            out.println("当前用户无此环节的审核权限");
        return ;
    }
    System.out.println("userid_approve:发起人id"+userid_approve+"操作id："+action+"频道id:"+channelid);
    if(userid_approve!=userid&&action==2){
        out.println("只有发起人才能完成选题");

        return ;
    }
    if(userid_approve==userid&&action==2){
        out.println("选题已完成");
        HashMap map_doc = new HashMap();
        map_doc.put("task_status",3+"");//
        ItemUtil.updateItemByGid(channelid, map_doc, gid,1);
        Log.SystemLog("完选选题", "用户"+UserName+"完成了选题："+Titlename+"   ");
        return ;
    }
    ApproveAction aa = new ApproveAction();
    aa.setTitle(title);
    aa.setParent(gid);
    aa.setUserid(userid);
    aa.setAction(action);
    aa.setApproveId(approveId);
    aa.setApproveName(name);
    aa.setEndApprove(endApprove);
    aa.setActionMessage(actionMessage);
    aa.Add();

    if(endApprove==1&&action==0){

        document.Approve(document.getId()+"",document.getChannelID());
    }

    //稿件审核相关逻辑
    ApproveDocument.approveSubmit(action, userid, approveId, gid, actionMessage, endApprove, type, users, title);

%>
