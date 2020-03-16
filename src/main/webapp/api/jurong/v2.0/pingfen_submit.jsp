<%@ page import="tidemedia.cms.system.*,java.util.*,org.json.JSONArray,org.json.JSONObject,tidemedia.cms.util.*,java.net.*,java.sql.*,tidemedia.cms.base.*,tidemedia.cms.scheduler.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%!
    //判断频道是否是选题的子频道（选题父频道，当前频道）
    public boolean isTopicChannel(int channelid,int channelid_) throws tidemedia.cms.base.MessageException, java.sql.SQLException,org.json.JSONException{
        boolean flag = false ;

        Channel channel = CmsCache.getChannel(channelid_);
        Channel channel1 = CmsCache.getChannel(channelid);

        String code = channel.getChannelCode();
        String code1 = channel1.getChannelCode();
        if(code.contains(code1)){
            flag = true ;
        }
        return flag ;
    }
%>
<%
    /**
     * 用途：提交审核
     */
    int gid = getIntParameter(request,"globalid");
    String score = getParameter(request,"score").trim();
    score = URLDecoder.decode(score,"utf-8");
    int action = getIntParameter(request,"action");
    int approveId = getIntParameter(request,"approveId");
    int endApprove = getIntParameter(request,"endApprove");
    String actionMessage = getParameter(request,"actionMessage");
    String user = getParameter(request,"user");//有审核权限的用户
    String[] users = user.split(",");

    /*
    ApproveItems approve_item = new ApproveItems(approveId);
    String name = approve_item.getTitle();

    ApproveAction aa = new ApproveAction();
    aa.setTitle(title);
    aa.setParent(gid);
    aa.setUserid(userid);
    aa.setAction(action);
    aa.setApproveId(approveId);
    aa.setApproveName(name);
    aa.setEndApprove(endApprove);
    aa.setActionMessage(actionMessage);
    aa.Add();//如操作表
*/
    Document document = new Document(gid);
    document.Approve(document.getId()+"",document.getChannelID());
    Channel channel_review = ChannelUtil.getApplicationChannel("task_doc");
    int channelid = channel_review.getId() ;//选题频道编号

    if(action==3){
        //改变选题评分
        //if(isTopicChannel(channelid,document.getChannelID())){
            TableUtil tu = new TableUtil();
            String sql = "UPDATE "+document.getChannel().getTableName()+" SET score = "+score+" WHERE id = "+document.getId();
            int rs = tu.executeUpdate(sql);
       // }
        /*
        * 插入到评分选题频道
        * */
        //1.查询选题信息
         /*
        String title2=document.getTitle();
        String userids=document.getValue("users_id");
        String usernames=document.getValue("users");
        String userarry[]=userids.split(",");
        String unamearry[]=usernames.split(",");*/
    }
    out.println(userid);
%>
