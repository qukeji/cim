<%@page import="java.util.Date"%>
<%@ page import="tidemedia.cms.system.*,
				java.util.*,
				java.text.*,
				tidemedia.cms.util.*,
				java.net.*,
				java.sql.*,
				org.json.*,
				tidemedia.cms.base.*,
				tidemedia.cms.scheduler.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
    /**
     * 用途：提交审核
     */
    int gid = getIntParameter(request,"globalid");
    int ItemID = getIntParameter(request,"ItemID");
    int ChannelID = getIntParameter(request,"ChannelID");
    if(gid==0){
        out.println("请先保存稿件");
        return ;
    }
    String title = CmsCache.getDocument(gid).getTitle();
//String title = getParameter(request,"title");
//title = URLDecoder.decode(title,"utf-8");
    int action = getIntParameter(request,"action");
    int approveId = getIntParameter(request,"approveId");
    int endApprove = getIntParameter(request,"endApprove");
    String actionMessage = getParameter(request,"actionMessage");
    String user = getParameter(request,"user");//有审核权限的用户
    String[] users = user.split(",");
    int userid = userinfo_session.getId();//当前用户
    int isEndRe = 0;

    ApproveItems approve_item = new ApproveItems(approveId);
    String url =approve_item.getUrl();
    System.out.println("执行的url"+url);
    String name = approve_item.getTitle();
    int type = approve_item.getType();
    if(!Arrays.asList(users).contains(userid+"")){
        out.println("当前用户无此环节的审核权限");
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

    if(endApprove==1&&action==0){//终审通过触发发布
        Document document = new Document(gid);
        document.setUser(userinfo_session.getId());
    }

    if(endApprove==1&&action==1){//终审驳回触发撤稿并修改最后一次审核的状态
        Document document = new Document(gid);
        document.setUser(userinfo_session.getId());
        document.Delete2(document.getId()+"",document.getChannelID());
        isEndRe = 1;
        int ApproveActionId = getIntParameter(request,"ApproveActionId");
        String Sql = "update approve_actions set endApprove=0 where id=" + ApproveActionId;
        TableUtil tu = new TableUtil();
        tu.executeUpdate(Sql);
    }
//稿件审核相关逻辑
    ApproveDocument.approveSubmit(action, userid, approveId, gid, actionMessage, endApprove, type, users, title);
%>
