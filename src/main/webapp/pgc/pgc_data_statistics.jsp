<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.Date,
				java.text.DecimalFormat,
				java.text.SimpleDateFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
    //概览页面数据统计
%>
<%
    String whereSql = " where Active=1 ";
    //1、获取当前登录用户的companyid
    int companyid = userinfo_session.getCompany();
    //获取图文
    Channel doc_channel = ChannelUtil.getApplicationChannel("pgc_doc");
    int channelid1 = doc_channel.getId() ;
    TableUtil tu1 = new TableUtil();

    String sql_channel1="";
    String sql_channel2="";

    Channel channel1 = CmsCache.getChannel(channelid1);
    sql_channel2 = "select *,count(1) as num from "+channel1.getTableName();

    String whereSql2=" group by juxian_phone order by num desc limit 10";

    if(companyid!=0){
        //2、获取图片频道下的对应租户子频道
        sql_channel1 = "select * from channel where parent ="+channelid1+" and company="+companyid;
        ResultSet rs1 = tu1.executeQuery(sql_channel1);
        int  id=0;
        if(rs1.next()){
            id=rs1.getInt("id");
        }
        tu1.closeRs(rs1);
        sql_channel2+=whereSql+" and Category="+id+whereSql2;
    }else{
        //3、获取图文频道下的租户频道id
        sql_channel2+=whereSql+whereSql2;
    }
    //查询图文下对应租户信息
    ResultSet rs2 = tu1.executeQuery(sql_channel2);
    JSONArray Json=new JSONArray();
    while(rs2.next()){
        JSONObject json = new JSONObject();
        int photocount=rs2.getInt("num");
        String juxian_phone	= convertNull(rs2.getString("juxian_phone"));
        if(!juxian_phone.equals("")) {
            String sql1 = "select LastLoginDate,Name from userinfo where tel=" + juxian_phone;
            TableUtil tu2 = new TableUtil("user");
            ResultSet rs3 = tu2.executeQuery(sql1);
            tu2.closeRs(rs3);
            json.put("juxian_phone", juxian_phone);
            json.put("photocount", photocount);
            Json.put(json);
        }
    }
    tu1.closeRs(rs2);
    JSONObject jsonResult = new JSONObject();
    int  videocount=0;
    int  zhibocount=0;
    int  photocount=0;
    for(int i = 0; i < Json.length(); i++) {
        JSONObject jsonObject = Json.getJSONObject(i);
        int photocount1=0;
        //获取手机号
        String juxian_phone = jsonObject.getString("juxian_phone");
        photocount1 = Integer.parseInt(jsonObject.getString("photocount"));
        photocount+=photocount1;
        //视频统计
        Channel video_channel = ChannelUtil.getApplicationChannel("pgc_video");
        int childChannel = video_channel.getId() ;
        int  videocount1=0;
        Channel channel2 = CmsCache.getChannel(childChannel);
        String sql2 = "select *,count(1) as num from " + channel2.getTableName() + whereSql+" and juxian_phone="+juxian_phone+" group by juxian_phone order by num desc limit 10";
        TableUtil tu4 = new TableUtil();
        ResultSet rs4 = tu4.executeQuery(sql2);
        while(rs4.next()){
            videocount1=rs4.getInt("num");
        }
        videocount+=videocount1;
        tu4.closeRs(rs4);

        //获取pgc_直播编号
        Channel live_channel = ChannelUtil.getApplicationChannel("pgc_live");
        int channelid = live_channel.getId() ;
        Channel channel3 = CmsCache.getChannel(channelid);
        //直播内容
        String sql3 = "select *,count(1) as num from " + channel3.getTableName() + whereSql+" group by juxian_phone order by num desc limit 10";
        TableUtil tu5 = new TableUtil();
        ResultSet rs5 = tu5.executeQuery(sql3);
        int zhibocount1=0;
        while(rs5.next()){
            zhibocount1=rs5.getInt("num");
        }
        tu5.closeRs(rs5);
        zhibocount+=zhibocount1;
    }
    //PGC资源总数
    int count4= videocount+zhibocount+photocount;
    jsonResult.put("tupian",photocount);
    jsonResult.put("shiping",videocount);
    jsonResult.put("zhibo",zhibocount);
    jsonResult.put("count4",count4);
    out.println(jsonResult.toString());
%>

