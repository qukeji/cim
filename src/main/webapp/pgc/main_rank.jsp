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
<%@ page import="static tidemedia.cms.util.Util2.convertNull" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
    //概览页面数据统计
%>

<%
    String whereSql = " where Active=1 ";
    JSONArray array = new JSONArray();

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
    int User=0;
    JSONArray Json=new JSONArray();
    while(rs2.next()){
        JSONObject json = new JSONObject();
        int photocount=rs2.getInt("num");
        User=rs2.getInt("User");
        String juxian_phone	= convertNull(rs2.getString("juxian_phone"));
        String juxian_username	= convertNull(rs2.getString("juxian_username"));
        if(!juxian_phone.equals("")) {
            //用户信息
            String sql1 = "select LastLoginDate,Name from userinfo where tel=" + juxian_phone;
            TableUtil tu2 = new TableUtil("user");
            ResultSet rs3 = tu2.executeQuery(sql1);
            String loginDate = "";
            String Name = "";
            if (rs3.next()) {
                loginDate = convertNull(rs3.getString("LastLoginDate")).replace(".0", "");
                Name = convertNull(rs3.getString("Name"));
            }
            tu2.closeRs(rs3);
            json.put("photocount", photocount);
            json.put("juxian_username", juxian_username);
            json.put("loginDate", loginDate);
            json.put("Name", Name);
            json.put("juxian_phone", juxian_phone);
            Json.put(json);
        }
    }
    tu1.closeRs(rs2);
    for(int i = 0; i < Json.length(); i++) {
        JSONObject jsonObject = Json.getJSONObject(i);
        JSONObject jsonResult = new JSONObject();
        //获取手机号
        String juxian_phone = jsonObject.getString("juxian_phone");
        //视频统计
        Channel video_channel = ChannelUtil.getApplicationChannel("pgc_video");
        int childChannel = video_channel.getId() ;
        int  videocount=0;
        Channel channel2 = CmsCache.getChannel(childChannel);
        String sql2 = "select *,count(1) as num from " + channel2.getTableName() + whereSql+" and juxian_phone="+juxian_phone+" group by juxian_phone order by num desc limit 10";

        TableUtil tu4 = new TableUtil();
        ResultSet rs4 = tu4.executeQuery(sql2);
        while(rs4.next()){
            videocount=rs4.getInt("num");

        }
        tu4.closeRs(rs4);
        //获取pgc_直播编号
        Channel live_channel = ChannelUtil.getApplicationChannel("pgc_live");
        int channelid = live_channel.getId() ;
        Channel channel3 = CmsCache.getChannel(channelid);
        //直播内容
        String sql3 = "select *,count(1) as num from " + channel3.getTableName() + whereSql+" group by juxian_phone order by num desc limit 10";
        TableUtil tu5 = new TableUtil();
        ResultSet rs5 = tu5.executeQuery(sql3);
        int zhibocount=0;
        while(rs5.next()){
            zhibocount=rs5.getInt("num");
        }
        tu5.closeRs(rs5);
        jsonResult.put("childChannel",childChannel);
        jsonResult.put("photocount",jsonObject.getString("photocount"));
        jsonResult.put("videocount",videocount);
        jsonResult.put("Name",jsonObject.getString("Name"));
        jsonResult.put("loginDate",jsonObject.getString("loginDate"));
        jsonResult.put("juxian_phone",juxian_phone);
        jsonResult.put("juxian_username",jsonObject.getString("juxian_username"));
        jsonResult.put("zhibocount",zhibocount);
        array.put(jsonResult);
    }
    out.println(array);

%>
