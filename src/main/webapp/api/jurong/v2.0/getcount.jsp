<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%
    //线索汇聚接口
%>
<%!
    public ArrayList getUserChannel(int userId,int channelid_,int data_type_) throws SQLException, MessageException, JSONException
    {
        UserInfo info = new UserInfo(userId);

        ArrayList<Integer> channellist = new ArrayList<Integer>();

        ArrayList<ChannelPrivilegeItem> Privilegelist=info.getChannelPermArray();
        for(ChannelPrivilegeItem cl:Privilegelist){

            int channelId = cl.getChannel() ;
            Channel c = CmsCache.getChannel(channelId);
            int [] PerArray=cl.getPermArray();
            for(int P:PerArray){
                if(P==1){//有浏览频道权限

                    if(data_type_==1){//稿件,选题频道跳过
                        if(channelId==channelid_||isTopicChannel(channelId,channelid_)){
                            continue;
                        }
                    }else{
                        if(!isTopicChannel(channelId,channelid_)){//不是选题频道，跳过
                            continue;
                        }
                    }
                    channellist.add(channelId);
                }
            }

            if(cl.getIsInherit()==1){//包含子频道

                ArrayList<Integer> arraylist = c.listAllSubChannelIDs();
                if (arraylist == null || arraylist.size() == 0){
                    continue;
                }

                for (int i = 0; i < arraylist.size(); i++) {

                    int childChannel = (int) arraylist.get(i);

                    if(data_type_==1){//稿件,选题频道跳过
                        if(childChannel==channelid_||isTopicChannel(childChannel,channelid_)){
                            continue;
                        }
                    }else{
                        if(!isTopicChannel(childChannel,channelid_)){//不是选题频道，跳过
                            continue;
                        }
                    }
                    channellist.add(childChannel);
                }
            }
        }
        return channellist ;
    }

    public String getUserChannelString(int userId,int channelid_,int data_type_) throws SQLException,MessageException,JSONException {
        // 列出频道下所有子频道和子分类
        ArrayList<Integer> arraylist = getUserChannel(userId,channelid_,data_type_);

        if (arraylist == null || arraylist.size() == 0)
            return "";

        String ids = "";

        for (int i = 0; i < arraylist.size(); i++) {
            Integer integer = (Integer) arraylist.get(i);
            ids += (ids.equals("") ? "" : ",") + integer;
        }
        return ids;
    }

    //判断频道是否是选题的子频道
    public boolean isTopicChannel(int channelid,int channelid_) throws tidemedia.cms.base.MessageException, java.sql.SQLException,org.json.JSONException{
        boolean flag = false ;

        Channel channel = CmsCache.getChannel(channelid_);
        Channel channel1 = CmsCache.getChannel(channelid);

        String code = channel.getChannelCode();
        String code1 = channel1.getChannelCode();
        if(code1.contains(code)){
            flag = true ;
        }

// 	tidemedia.cms.base.TableUtil tu = new tidemedia.cms.base.TableUtil();
//	String sql = "select * from channel where parent="+channelid_+" and id="+channelid;
//	java.sql.ResultSet rs = tu.executeQuery(sql);
//	if(rs.next()){
//		flag = true ;
//	}
//	tu.closeRs(rs);
        return flag ;
    }

    public HashMap<String, Object> getItems(int userId){
        HashMap<String, Object> map = new HashMap<String, Object>() ;


        return map ;
    }
    public int getNumber(String sql) throws MessageException, SQLException
    {
        int num = 0;

        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if (rs.next())
            num = rs.getInt(1);
        tu.closeRs(rs);

        return num;
    }
%>
<%

    int userId = userinfo_session.getId();//当前登录用户id
    System.out.println("userId:"+userId);
    JSONObject json = new JSONObject();

    try{
        TideJson jurong = CmsCache.getParameter("jurong").getJson();//聚融接口信息
        int channel_xiansuo = jurong.getInt("collect");
        int channelId_hot = jurong.getInt("hotword");

        Channel channel_review = ChannelUtil.getApplicationChannel("task_doc");
        int channelid = channel_review.getId() ;//选题频道编号

        Channel channel = CmsCache.getChannel(channel_xiansuo);
        Channel channel_hot = CmsCache.getChannel(channelId_hot);

        TableUtil tu = new TableUtil();
        String countSql = "";

        //查询线索汇聚总数量
        countSql = "select count(*) from "+channel.getTableName()+" where Active=1";
        int count = getNumber(countSql);
        //System.out.println("线索："+countSql);

        //查询热点跟踪总数量
        countSql = "select count(*) from "+channel_hot.getTableName()+" where Active=1";
        int count_hot = getNumber(countSql);

        //查询审核数量
        //稿件待审核数量
        int count_review = 0 ;
        int ChannelIds_review = getChannel(userinfo_session);//用户频道权限
        if(ChannelIds_review!=0){//有权限
            countSql = "select count(*) from item_snap where Active=1 and ChannelID in("+ChannelIds_review+") and Status=0";
            count_review = getNumber(countSql);
        }
        //选题待审核数量
        String ChannelIds ="";
        ChannelIds = getUserChannelString(userId, channelid, 2);//用户频道权限
        if(!ChannelIds.equals("")){//有权限
            countSql = "select count(*) from "+channel_review.getTableName()+" where Active=1 and task_status=0 and Category in ("+ChannelIds+")";
            //count_review += getNumber(countSql);
        }

        //查询选题数量
        int count_topic = 0 ;
        ChannelIds = getUserChannelString(userId, channelid, 2);//用户频道权限
        if(!ChannelIds.equals("")){//有权限
            countSql = "select count(*) from "+channel_review.getTableName()+" where Active=1 and Category in ("+ChannelIds+")";
            //System.out.println("countSql:"+countSql);
            count_topic += getNumber(countSql);
        }

        json.put("count",count);
        json.put("hotcount",count_hot);
        json.put("reviewcount",count_review);
        json.put("topiccount",count_topic);
        json.put("status",200);
        json.put("message","成功");

    }catch(Exception e){
        json.put("status",500);
        json.put("message","程序异常");
        e.printStackTrace();
    }

    out.println(json);
%>
<%!
    //租户频道
    public int getChannel(UserInfo userinfo){
        int parent = 0 ;
        try{
            TableUtil tu = new TableUtil();
            String sql = "";

            int userid = userinfo.getId();//当前登录用户id
            int company = userinfo.getCompany();//关联的租户编号

            Channel channel = ChannelUtil.getApplicationChannel("shengao");
            int channelid = channel.getId() ;//频道编号
         
                sql = "select id from channel where parent="+channelid;
                if(company!=0){//用户关联了租户
                sql+=" and company="+company;
                }
                ResultSet rs = tu.executeQuery(sql);
                if(rs.next()){
                    parent = rs.getInt("id");
                }else{
                     parent = channelid ;
                } 
                tu.closeRs(rs);
           
               
            
        }catch(Exception e){
            e.printStackTrace();
        }
        return parent ;
    }
%>
