<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				org.json.JSONObject,
				java.sql.*"%>
<%@ page import="tidemedia.app.system.appUserInfo" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%@ include file="common.jsp"%>
<%
    //APP 获取用户信息
%>
<%
    JSONObject json=new JSONObject();//json存储信息
    int flag_v2=1;//apiv2.0的开关（社区开关）
    //接受参数
    int site = getIntParameter(request,"site");//站点名称
    try {
        //判断传值的site和session所属的用户site是否一致
        String cms_register = (String) TIDE.get("cms_register"); //获取用户所数据库
        String sql_user = "select siteflag from " + cms_register + " where Active=1 and id=" + userid + "";
        TableUtil tu_user = new TableUtil();
        ResultSet rs_user = tu_user.executeQuery(sql_user);
        int siteflag = 0;
        while (rs_user.next()) {
            siteflag = rs_user.getInt("siteflag");
        }
        tu_user.closeRs(rs_user);
        if (siteflag != site) {//判断是否一致
            json.put("message", "请登陆后再操作。");
            out.println(json);
            return;
        }

        int watch=0;//我的关注数量
        int fans=0;//我的粉丝数量
        int extra_days = 0;//连续xx天登陆给予额外积分奖励
        int upcontrol = 0;//加分上限控制
        int hour = 0;//加分上限时间范围(天)
        int hassign = 0;//用户的签到积分记录
        int over = 0;//当前已连续签到的次数
        int is_baoliao = 0;//是否提交过爆料
        if (flag_v2 != 0) {
            //查询出我的关注数量
            String cms_community_userwatch = (String) TIDE.get("cms_community_userwatch"); //获取关注记录数据库
            String sql_watch = "select count(id) as count from " + cms_community_userwatch + " where Active=1 and Status=1 and siteflag=" + site + " and userid=" + userid + "";
            watch =getNum(sql_watch);

            //查询我的粉丝数量
            String sql_fans = "select count(id) as count from " + cms_community_userwatch + " where Active=1 and Status=1 and siteflag=" + site + " and bewatchuserid=" + userid + "";
            fans = getNum(sql_fans);

            //社区积分记录表
            String tbname_score = (String) TIDE.get("cms_community_s_score_start") + site + (String) TIDE.get("cms_community_s_score_end");
            //社区积分规则表
            String tbname_rule = (String) TIDE.get("cms_community_s_levelrule_start") + site + (String) TIDE.get("cms_community_s_levelrule_end");

            //查询出额外签到奖励天数
            String sql_rule = "select extra_days,upcontrol,hour from " + tbname_rule + " where Active=1 and Status=1 and ruletype=1";
            TableUtil tu_rule = new TableUtil();
            ResultSet rs_rule = tu_rule.executeQuery(sql_rule);

            while (rs_rule.next()) {
                extra_days = rs_rule.getInt("extra_days");
                upcontrol = rs_rule.getInt("upcontrol");
                hour = rs_rule.getInt("hour");
            }
            tu_rule.closeRs(rs_rule);
            //查询出当前连续登陆天数
            String sql_continuity = "select id ,count(*) as count from " + tbname_score + " where Active=1 and Status=1 and ruletype=1 and userid=" + userid + "";
            int num_continuity = getNum(sql_continuity);

            //获取到当前已连续签到的次数
            if (extra_days == 0) {
                over = 0;
            } else {
                over = num_continuity % extra_days;
            }
            if (over == 0) {
                over = extra_days;
            }

            //查询出当日是否签到(0:未签到 1:已签到)
            java.util.Date date = new java.util.Date();
            long now = date.getTime() / 1000;//获取当前时间戳
            long one = 60 * 60 * 24;
            long time = now - (hour - 1) * one;

            //查询出用户的签到积分记录
            String sql_sign = "select count(id) as count from " + tbname_score + " where Active=1 and Status=1 and ruletype=1 and userid=" + userid + " and PublishDate>=" + time + "";
            int count_sign = getNum(sql_sign);
            if (count_sign < upcontrol) {
                hassign = 0;
            } else {
                hassign = 1;
            }
        }

        //获取用户是否提交过爆料
        String tb_resource = (String) TIDE.get("cms_resource_start") + site + (String) TIDE.get("cms_resource_end");
        String sql_mybaoliao = "SELECT id FROM " + tb_resource + " where Active=1 and baoliao_userid=" + userid + " limit 1;";
        TableUtil tu_mybaoliao = new TableUtil();
        ResultSet rs_mybaoliao = tu_mybaoliao.executeQuery(sql_mybaoliao);
        if (rs_mybaoliao.next()) {
            is_baoliao = 1;
        }
        tu_mybaoliao.closeRs(rs_mybaoliao);

        String sql = "select Title,phone,avatar,Truename,sex,weibo,QQ,wechat,designation,score,level from " + cms_register + " where siteflag=" + site + " and id=" + userid + "";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if (rs.next()) {
            if (flag_v2 != 0) {
                int score1 = rs.getInt("score");
                int level = rs.getInt("level");
                String designation = convertNull(rs.getString("designation"));
                String score = score1 + "";
                if (score1 >= 1000) {
                     score = String.format("%.1f", (float)score1 / 10000) + "w";
                }

                //查询出用户当前所处的等级，以及下一等级的起始积分数
                //社区等级制度表
                String tbname_level = (String) TIDE.get("cms_community_s_level_start") + site + (String) TIDE.get("cms_community_s_level_end");

                String sql_level = "select scoretop from " + tbname_level + " where Active=1 and Status=1 and level=" + level + "";
                TableUtil tu_level = new TableUtil();
                ResultSet rs_level = tu_level.executeQuery(sql_level);
                int scoretop = 0;
                if (rs_level.next()) {
                    scoretop = rs_level.getInt("scoretop") + 1;
                    json.put("scoretop", scoretop);
                }

                String designation1 = designation.equals("") ? "V 1" : designation;
                json.put("level", designation1);
                json.put("levelnum", score + "./" + scoretop);
                json.put("score", score);
                json.put("watch", watch);//watch关注数量
                json.put("friends", fans);//fans粉丝数量
                json.put("extraday", extra_days);
                json.put("hassign", hassign);
                json.put("currentday", over);

            }
            String Title = convertNull(rs.getString("Title"));
            String Truename = convertNull(rs.getString("Truename"));
            String nick = Title.equals("") ? Truename : Title;
            String phone = convertNull(rs.getString("phone"));
            String avatar = convertNull(rs.getString("avatar"));
            int sex = rs.getInt("sex");
            String weibo = convertNull(rs.getString("weibo"));
            String QQ = convertNull(rs.getString("QQ"));
            String wechat = convertNull(rs.getString("wechat"));
            String weibosign = weibo.equals("") ? "" : weibo;
            String qqsign = weibo.equals("") ? "" : QQ;
            String weixinsign = weibo.equals("") ? "" : wechat;

            json.put("nick", nick);
            json.put("moblie", phone);
            json.put("avatar", avatar);
            json.put("sex", sex);
            json.put("weibo", weibo);
            json.put("QQ", QQ);
            json.put("weixin", wechat);
            json.put("weibosign", weibosign);
            json.put("qqsign", qqsign);
            json.put("weixinsign", weixinsign);
            json.put("is_baoliao", is_baoliao);
            json.put("message", "成功");
            
        } else {
            json.put("message", "失败");
        }
    }catch (Exception e){
        json.put("message", "失败"+e.toString());
    }
    out.println(json);
%>

<%!
    //获取资源数
    public int getNum(String sql){
        int num = 0 ;
        try{
            TableUtil tu = new TableUtil();
            ResultSet Rs = tu.executeQuery(sql);
            if(Rs.next()) {
                num = Rs.getInt("count");
            }
            tu.closeRs(Rs);
        }catch(Exception e) {
            e.printStackTrace();
        }
        return num ;

    }

%>
