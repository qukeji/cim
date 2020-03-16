<%@ page import="tidemedia.cms.system.*,java.util.*,org.json.JSONArray,org.json.JSONObject,tidemedia.cms.util.*,java.net.*,java.sql.*,tidemedia.cms.base.*,tidemedia.cms.scheduler.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>

<%
    /**
     * 用途：提交审核
     */
    int gid = getIntParameter(request,"globalid");
    String score = getParameter(request,"score").trim();
    int action = getIntParameter(request,"action");
    int approveId = getIntParameter(request,"approveId");
    int endApprove = getIntParameter(request,"endApprove");
    String actionMessage = getParameter(request,"actionMessage");
    String user = getParameter(request,"user");//有审核权限的用户
    String[] users = user.split(",");


    Document document = new Document(gid);
    document.Approve(document.getId()+"",document.getChannelID());
    String userid2=document.getValue("users_id");
    String username2= document.getValue("users");
    String[] usernames=username2.split(",");
    String[] userids=userid2.split(",");
    String title=document.getTitle();
    int itemid=document.getId();
    int channelid=document.getChannelID();
    int channelid_insert=14353;
    channelid_insert+=(channelid-14325);
    System.out.println("选题channelid："+channelid);
    System.out.println("评分对应评到："+channelid_insert);
    System.out.println("参与人用户id："+userid2);
    int num=usernames.length;
    int own_score=Integer.parseInt(score)/num;
    for(int i=0;i<usernames.length;i++){
        System.out.println("执行到这里");
        HashMap<String,String> map = new HashMap<String,String>();
        map.put("Title",title);//标题
        map.put("username",usernames[i]);//参与人姓名
        map.put("uid",userids[i]);//参与人ID
        map.put("scope",own_score+"");//个人得分数
        map.put("topic_id",itemid+"");//选题编号
        map.put("Status",1+"");
        ItemUtil.addItem(channelid_insert,map);
    }
    //Channel channel_review = ChannelUtil.getApplicationChannel("task_doc");
    if(action==3){
            TableUtil tu = new TableUtil();
            String sql = "UPDATE "+document.getChannel().getTableName()+" SET score = "+score+" WHERE id = "+document.getId();
            System.out.println("pingfen:"+sql);
            tu.executeUpdate(sql);
             //小米推送
            TideJson jurong = CmsCache.getParameter("jurong").getJson();//聚融接口信息
            String push_url = jurong.getString("push_url");
            if(!push_url.equals("")){
                push_url = push_url+"?type=4&id="+gid;
                push_url = Util.ClearPath(push_url);
                Util.connectHttpUrl(push_url);
            }
    }
out.print(document.getTitle());
%>
