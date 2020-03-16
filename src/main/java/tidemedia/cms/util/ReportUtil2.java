package tidemedia.cms.util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelUtil;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Site;
import tidemedia.cms.user.UserInfo;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import static tidemedia.cms.util.Util2.convertNull;

/*首页统计查询*/
public class ReportUtil2<main> {

    public static List<Integer> pvs = new ArrayList<Integer>();//纵坐标
    public static List<String> xaxis= new ArrayList<String>();//横坐标
    public static String siteids = "";
    public static boolean isES = true ;//是否查询ES

    //初始化参数
    public static void init() throws MessageException, SQLException {
        TideJson ES_json = CmsCache.getParameter("ES_Config").getJson();
        int status = 0;
        if(ES_json.getInt("status")==1) status = 1;
        String HOST = ES_json.getString("host");

        if(status==0 || HOST.equals("")) {//host为空，es连接关闭
            isES = false ;
        }else{
            isES = true ;
        }
        xaxis = new ArrayList<String>();
        pvs = new ArrayList<Integer>();
        siteids = "";
    }

    public static JSONObject mainData(int userid) throws MessageException, SQLException, JSONException, ParseException {

        init();//初始化参数

        JSONObject json = new JSONObject();

        long current = System.currentTimeMillis();
        String begintime = getZeroDate(6,"yyyy-MM-dd HH:mm:ss");//开始时间
        String endtime = Util.getCurrentDate("yyyy-MM-dd HH:mm:ss");//结束时间
        xaxis = getDate(begintime,endtime) ;//横坐标

        //获取租户id
        UserInfo user = CmsCache.getUser(userid);
        int companyid = user.getCompany();

        //查询站点数及频道树
        getSite(companyid,json);

        //查询资源数
        getDocNum(userid,json);

        //查询pv数
        int pv1 = 0;
        int pv2 = 0;
        JSONArray arr = ChannelUtil.getApplicationChannel("app",companyid,1,user);
        for(int i=0;i<arr.length();i++){
            JSONObject job = arr.getJSONObject(i);
            int siteid = job.getInt("siteid");
            final String code = "s"+siteid+"_a_a";//栏目管理频道标识
            Channel channel = CmsCache.getChannel(code);
            int id = channel.getId();//栏目管理频道编号

            if(isES){//ES查询
                pv1 += getEsPvNum(id,"","");
                pv2 += getEsPvNum(id,begintime,endtime);
            }else{
                pv1 += getPV(id,"","");
                pv2 += getPV(id,begintime,endtime);
            }
        }
        json.put("pv",pvs);
        json.put("xaxis",xaxis);
        json.put("pv1", pv1);
        json.put("pv2", pv2);

        return json ;
    }

    //查询资源数
    public static void getDocNum(int userid, JSONObject json) throws MessageException, SQLException, JSONException {

        int count = 0 ;//资源总数
        int PublishCount = 0 ;//已发
        int UnPublishCount = 0 ;//草稿
        int TodayCount;//今日新增
        int DaysCount;//7天数据量
        int UserCount;//用户发稿量
        int UserCount1;//用户24小时发稿量

        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        String nowDate = sdf.format(calendar.getTime());//当天0点时间
        long nowTime= calendar.getTimeInMillis()/1000;//当天0点时间戳

        calendar.add(Calendar.DATE, +1);
        String  date1 = sdf.format(calendar.getTime());//后一天0点时间

        calendar.add(Calendar.DATE, -7);
        String  begintime = sdf.format(calendar.getTime());//7天前的时间
        long time2 = calendar.getTimeInMillis()/1000;//7天前的时间戳

        int time3 = (int)(System.currentTimeMillis()/1000);//当前时间戳
        String date3 = Util.FormatTimeStamp("",time3);//当前时间

        int time4 = time3-86400 ;//前一天同时间的时间戳
        String date4 = Util.FormatTimeStamp("",time4);//前一天同时间


        //查询资源总数
        if(!isES) {
            //查询数据库
            String sql = "select count(*) as num from item_snap where SiteId in ("+siteids+") and Active=1";
            count = getNum(sql);
            PublishCount = getNum(sql + " and Status=1");
            UnPublishCount = getNum(sql + " and Status=0");
            TodayCount = getNum(sql + " and CreateDate>="+nowTime+" and CreateDate<"+(nowTime+86400));
            DaysCount = getNum(sql+" and CreateDate>="+time2+" and CreateDate<"+(nowTime+86400));
            UserCount = getNum(sql + " and Status=1 and User="+userid);
            UserCount1 = getNum(sql + " and Status=1 and User="+userid+" and PublishDate>="+time4+" and PublishDate<"+time3);
        }else{
            count = getEsNum(siteids,0,0,false,0,"","");
            PublishCount = getEsNum(siteids,0,0,false,2,"","");
            UnPublishCount = getEsNum(siteids,0,0,false,1,"","");
            TodayCount = getEsNum(siteids,0,0,false,0,nowDate,date1);
            DaysCount = getEsNum(siteids,0,0,false,0,begintime,date1);
            UserCount = getEsNum(siteids,0,userid,false,2,"","");
            UserCount1 = getEsNum(siteids,0,userid,false,2,date4,date3);
        }

        json.put("count",count);
        json.put("PublishCount",PublishCount);
        json.put("UnPublishCount",UnPublishCount);
        json.put("TodayCount",TodayCount);
        json.put("DaysCount",DaysCount);
        json.put("UserCount",UserCount);
        json.put("UserCount1",UserCount1);
    }
    //获取资源数
    public static int getNum(String sql) throws SQLException, MessageException {
        int num = 0 ;

        TableUtil tu = new TableUtil();
        ResultSet Rs = tu.executeQuery(sql);
        if(Rs.next()) {
            num = Rs.getInt("num");
        }
        tu.closeRs(Rs);

        return num ;
    }
    public static int getEsNum(String siteids,int channelid,int userid,boolean listAll,int status,String startDate,String endDate){
        int num = 0 ;

        EsSeach esSeach = new EsSeach();
        esSeach.setSiteIds(siteids);
        esSeach.setChannelId(channelid);
        esSeach.setUserid(userid);
        esSeach.setListAll(listAll);
        esSeach.setStatus(status);
        esSeach.setStartDate(startDate);
        esSeach.setEndDate(endDate);
        num = esSeach.ReportData();

        return num ;
    }

    //查询站点数及频道数
    public static void getSite(int companyid, JSONObject json) throws MessageException, SQLException, JSONException {

        int sitenum = 0 ;
        String sql = "select * from channel where Parent=-1 and Type=5";
        TableUtil tu = new TableUtil();
        ResultSet Rs = tu.executeQuery(sql);
        while(Rs.next()) {
            int siteid = Rs.getInt("site");
            int channelID = Rs.getInt("id");
            String application_ = convertNull(Rs.getString("application"));
            Site site = CmsCache.getSite(siteid);

            //当前登录用户绑定了租户,站点不是公共站点,用户无站点权限，
            if(companyid!=0&&(!application_.equals("publishsite"))&&(companyid!=site.getCompany())){
                continue ;
            }
            if(!siteids.equals("")){
                siteids += ",";
            }
            siteids += Rs.getInt("Site");
            sitenum++;
        }
        tu.closeRs(Rs);

        //查询频道总数
        sql = "select count(*) as num from channel";
        if(companyid!=0){
            sql += " where Site in ("+siteids+")";
        }
        int channelnum = getNum(sql);

        json.put("sitenum",sitenum);
        json.put("channelnum",channelnum);

    }


    //数据库查询获取pv（频道id，开始时间，结束时间）
    public static int getPV(int id,String begintime,String endtime) throws SQLException,MessageException{

        int visiter = 0 ;

        String tableName = CmsCache.getChannel(id).getTableName();
        TableUtil tu = new TableUtil();

        String sql = "select sum(pv_virtual+pv) from "+tableName+" where status=1";
        if(!begintime.equals("")){
            sql =	"select sum(pv_virtual+pv),from_unixtime(PublishDate,'%Y-%m-%d') as PublishDate from "+tableName+" where status=1";
            sql +=  " and from_unixtime(PublishDate,'%Y-%m-%d %H-%m-%s') >= '"+begintime+"'" +
                    " and from_unixtime(PublishDate,'%Y-%m-%d %H-%m-%s')<'"+endtime +"'" +
                    " group by from_unixtime(PublishDate,'%Y-%m-%d')";
        }

        ResultSet rs1 = tu.executeQuery(sql);
        while(rs1.next())
        {
            int pv = rs1.getInt(1);
            visiter = visiter+pv ;

            if(!begintime.equals("")){
                String date_ = rs1.getTimestamp("PublishDate").toString();
                String day = date_.substring(8,10);
                if(!day.equals("")){
                    day = Integer.parseInt(day)+"";
                }
                int j = xaxis.indexOf(day);
                pv = pv + pvs.get(j);
                pvs.set(j,pv);
            }

        }
        tu.closeRs(rs1);

        return visiter ;

    }

    //ES库查询获取pv
    public static int getEsPvNum(int id,String begintime,String endtime) throws JSONException {
        int num = 0 ;

        EsSeach esSeach = new EsSeach();
        esSeach.setChannelId(id);
        esSeach.setStartDate(begintime);
        esSeach.setEndDate(endtime);
        JSONObject obj = esSeach.ReportPvData();

        if(!begintime.equals("")&&!endtime.equals("")){//7日内数据
            Iterator<String> iter =obj.keys();
            while(iter.hasNext()){
                String key = iter.next();
                int value = obj.getInt(key);
                num = num + value ;

                int j = xaxis.indexOf(key);
                value = value + pvs.get(j);
                pvs.set(j,value);
            }
        }else{//全部数据
            num = obj.getInt("count");
        }
        return num ;
    }

    //获取某天前的日期
    public static String getZeroDate(int days,String pattern){
        java.util.Date date = new java.util.Date();
        SimpleDateFormat df = new SimpleDateFormat(pattern);
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.DAY_OF_YEAR,calendar.get(Calendar.DAY_OF_YEAR) - days);
        return df.format(calendar.getTime());
    }

    //获取横坐标
    public static List<String> getDate(String start, String end) throws ParseException {

        List<String> xaxis= new ArrayList<String>();

        java.util.Date d1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(start);
        java.util.Date d2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(end);//定义结束日期

        Calendar dd = Calendar.getInstance();//定义日期实例

        dd.setTime(d1);//设置日期起始时间

        while(dd.getTime().before(d2)){//判断是否到结束日期

            SimpleDateFormat sdf = new SimpleDateFormat("dd");

            String str = sdf.format(dd.getTime());
            str = Integer.parseInt(str)+"";

            xaxis.add(str);
            pvs.add(0);

            dd.add(Calendar.DATE, 1);//进行当前日期加1
        }

        return xaxis;
    }

    public static void main(String[] args) {
        new EsSeach().ReportPvData();
    }

}
