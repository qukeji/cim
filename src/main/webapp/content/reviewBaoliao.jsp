<%@ page import="tidemedia.cms.system.*,
                java.util.*,tidemedia.cms.util.*,
                java.sql.*,tidemedia.cms.base.*,
                tidemedia.cms.scheduler.*,
                tidemedia.cms.publish.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
    public String reviewBaoliao(int doc_id,int ChannelID,int type,int userId) throws Exception{
        String message = "";
        try{/* HashMap map_doc = new HashMap();
        tidemedia.cms.system.Document document = new tidemedia.cms.system.Document();
        document.setRelatedItemsList(RelatedItemsList);
        document.setChannelID(ChannelID);
        document.setUser(userinfo_session.getId());
        document.setModifiedUser(userinfo_session.getId());
        map_doc.put("baoliaostatus",type+"");//状态
        return document.UpdateDocument(map_doc);;*/
            //改变爆料状态
            HashMap map_doc = new HashMap();
            map_doc.put("baoliaostatus",type+"");//状态
            ItemUtil.updateItemById(ChannelID, map_doc, doc_id, userId);
            //频道发布
            int		IncludeSubChannel	= 0;
            int		PublishAllItems		= 0;
            PublishManager publishmanager = PublishManager.getInstance();
            publishmanager.ChannelPublish(ChannelID,IncludeSubChannel,userId,PublishAllItems);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "处理成功";
    }
%>
<%
    try{
        Integer ChannelID = getIntParameter(request,"ChannelID");
        Integer doc_id = getIntParameter(request,"doc_id");
        Integer userId = userinfo_session.getId();
        Integer type = getIntParameter(request,"type");
        out.println(reviewBaoliao(doc_id,ChannelID,type,userId));
    }catch(Exception e){
        System.out.println(e.getMessage());
        out.println("保存没有成功，请重新尝试。");
    }
%>
