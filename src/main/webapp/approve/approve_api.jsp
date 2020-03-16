<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
    int id = getIntParameter(request,"insertId");
    ApproveAction approveAction = new ApproveAction(id);
    System.out.println("approveActionid="+id);
    int parent = approveAction.getParent();
    int userId = approveAction.getUserid();
    int action = approveAction.getAction();
    int endApprove = getIntParameter(request,"endApprove");
    Document doc=CmsCache.getDocument(parent);
    int channelid=doc.getChannelID();
    if (action==1){
        HashMap map_doc = new HashMap();
        map_doc.put("task_status",2+"");//
        ItemUtil.updateItemByGid(channelid, map_doc, parent,1);
    }
    if(endApprove==1&&action==0){
        HashMap map_doc = new HashMap();
        map_doc.put("task_status",1+"");//
        ItemUtil.updateItemByGid(channelid, map_doc, parent,1);
    }
    if(endApprove==1&&action==2){
        HashMap map_doc = new HashMap();
        map_doc.put("task_status",3+"");//
        ItemUtil.updateItemByGid(channelid, map_doc, parent,1);
    }
   


%>
