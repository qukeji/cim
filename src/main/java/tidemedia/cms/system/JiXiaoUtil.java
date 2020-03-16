package tidemedia.cms.system;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.util.Util;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;

public class JiXiaoUtil extends Table {

    public String beforeOneDay = JiXiaoDateUtil.getDateTime(-1);//返回昨天日期
    public long end = JiXiaoDateUtil.getTimestamp(-1, 23, 59);//获取昨天23.59时间戳
    public int JIXIAOTONGJIID;//绩效明细频道ID
    public int JIXIAOREPORTID;//绩效报表频道ID
    public int USERPERFORMANCEID;//人员绩效分值频道ID
    public int JIXIAOPARTICIPANTID;//绩效参与人频道ID
    private static final String JIXIAOTONGJI = "jixiao_tongji";//绩效明细频道标识名
    private static final String JIXIAOREPORT = "jixiao_report";//绩效报表频道标识名
    private static final String USERPERFORMANCE = "user_performance";//人员绩效分值频道标识名
    private static final String JIXIAOPARTICIPANT = "jixiao_participant";//人员绩效分值频道标识名

    public JiXiaoUtil() throws MessageException, SQLException {
        String sql = "select id from channel where serialNo = '" + JIXIAOTONGJI + "'";
        String sql1 = "select id from channel where serialNo = '" + JIXIAOREPORT + "'";
        String sql2 = "select id from channel where serialNo = '" + USERPERFORMANCE + "'";
        String sql3 = "select id from channel where serialNo = '" + JIXIAOPARTICIPANT + "'";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if (rs.next()) {
            JIXIAOTONGJIID = rs.getInt("id");
        }
        tu.closeRs(rs);
        ResultSet rs1 = tu.executeQuery(sql1);
        if (rs1.next()) {
            JIXIAOREPORTID = rs1.getInt("id");
        }
        tu.closeRs(rs1);
        ResultSet rs2 = tu.executeQuery(sql2);
        if (rs2.next()) {
            USERPERFORMANCEID = rs2.getInt("id");
        }
        tu.closeRs(rs2);
        ResultSet rs3 = tu.executeQuery(sql3);
        if (rs3.next()) {
            JIXIAOPARTICIPANTID = rs3.getInt("id");
        }
        tu.closeRs(rs3);

    }

    /**
     * 遍历绩效审核表返回包含指定考核指标的绩效方案
     *
     * @param assessIndicator 考核指标
     * @return
     * @throws MessageException
     * @throws SQLException
     * @throws JSONException
     */
    public JSONArray traverseScheme(int assessIndicator) throws MessageException, SQLException, JSONException {
        JSONArray jsonArray = new JSONArray();
        String sql = "select * from channel_jixiao_scheme where active = 1 and enable = 1";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        boolean b = false;//是否包含该考核类型
        while (rs.next()) {//遍历绩效方案
            String assessIndicator1 = rs.getString("AssessIndicator");
            String[] assessIndicators = assessIndicator1.split(",");
            if (assessIndicator1.length() > 0) {
                for (int i = 0; i < assessIndicators.length; i++) {
                    if (assessIndicators[i].equals("" + assessIndicator)) {
                        b = true;
                        break;
                    }
                }
                if (b) {
                    int id = rs.getInt("id");
                    int companyId = rs.getInt("CompanyId");
                    int assessCycle = rs.getInt("AssessCycle");
                    String calculateType = rs.getString("CalculateType");
                    String participant = rs.getString("participant");
                    double score = Double.parseDouble(calculateType.split(",")[assessIndicator - 1]);
                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("schemeId", id);
                    jsonObject.put("companyId", companyId);
                    jsonObject.put("AssessCycle", assessCycle);
                    jsonObject.put("score", score);
                    jsonObject.put("participant", participant);
                    jsonArray.put(jsonObject);
                }
            }
            b = false;
        }
        tu.closeRs(rs);
        return jsonArray;
    }

    /**
     * 发稿量入库
     *
     * @param assessIndicator 考核指标
     * @param jsonArray       绩效方案数组
     * @throws JSONException
     * @throws MessageException
     * @throws SQLException
     */
    public void clientDocument(int assessIndicator, JSONArray jsonArray) throws JSONException, MessageException, SQLException {
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject = jsonArray.getJSONObject(i);
            int schemeId = jsonObject.getInt("schemeId");
            int assessCycle = jsonObject.getInt("AssessCycle");
            double score = jsonObject.getDouble("score");
            int companyId = jsonObject.getInt("companyId");
            String users = getUsersByJixiaoId(schemeId);
            String tableName = getTableNameByCompany(companyId, assessIndicator);//根据考核指标获取对应表名
            if (assessCycle == 1) {//日报表
                int reportId = getReportById(schemeId);
                long oneDayTimestamp = JiXiaoDateUtil.getOneDayTimestamp(-1);//获取昨天零点时间戳
                fun(tableName, oneDayTimestamp, reportId, users, score, assessIndicator);
            } else if (assessCycle == 2) {//周报表
                boolean weekend = JiXiaoDateUtil.isWeekStart();
                if (weekend) {//今天是周一
                    int reportId = getReportById(schemeId);
                    long sevenDayTimestamp = JiXiaoDateUtil.getOneDayTimestamp(-7);//获取上周周一零点时间戳
                    fun(tableName, sevenDayTimestamp, reportId, users, score, assessIndicator);
                }
            } else if (assessCycle == 3) {//月报表
                boolean monthend = JiXiaoDateUtil.isMonthStart();//今天是月初
                if (monthend) {
                    int reportId = getReportById(schemeId);
                    long monthStartTimestamp = JiXiaoDateUtil.getYearStartTimestamp(0, false);//获取上月初零点时间戳
                    fun(tableName, monthStartTimestamp, reportId, users, score, assessIndicator);
                }
            } else if (assessCycle == 4) {//季度报表
                String thisSeasonEnd = JiXiaoDateUtil.thisSeasonStart();//返回当前季度第一天
                String dateTime = JiXiaoDateUtil.getDateTime(0);//返回当天日期
                if (thisSeasonEnd.equals(dateTime)) {//今天是季度第一天
                    int reportId = getReportById(schemeId);
                    long quarterStartTimestamp = JiXiaoDateUtil.getYearStartTimestamp(0, true);//获取上个季度初零点时间戳
                    fun(tableName, quarterStartTimestamp, reportId, users, score, assessIndicator);
                }
            } else if (assessCycle == 5) {//年报表
                String thisYearEnd = JiXiaoDateUtil.thisYearStart();//返回年初日期
                String dateTime = JiXiaoDateUtil.getDateTime(0);//返回当天日期
                if (dateTime.equals(thisYearEnd)) {//今天是年初
                    int reportId = getReportById(schemeId);
                    long yearStartTimestamp = JiXiaoDateUtil.getYearStartTimestamp(Integer.parseInt(dateTime.substring(4)), false);//获取上一年初零点时间戳
                    fun(tableName, yearStartTimestamp, reportId, users, score, assessIndicator);
                }
            }
        }
    }

    /**
     * 稿件PV入库
     *
     * @param assessIndicator 考核指标
     * @param array           绩效方案数组
     * @throws JSONException
     * @throws MessageException
     * @throws SQLException
     * @throws ParseException
     */
    public void clientPvDocument(int assessIndicator, JSONArray array) throws JSONException, MessageException, SQLException, ParseException {
        int tongjiType = 0;//统计类型
        switch (assessIndicator) {
            case 2:
                tongjiType = 1;
                break;
            case 4:
                tongjiType = 2;
                break;
            case 6:
                tongjiType = 3;
                break;
        }
        for (int i = 0; i < array.length(); i++) {
            JSONObject o = array.getJSONObject(i);
            int schemeId = o.getInt("schemeId");
            int assessCycle = o.getInt("AssessCycle");
            double score = o.getDouble("score");
            int companyId = o.getInt("companyId");
            String users = getUsersByJixiaoId(schemeId);
            String tableName = getTableNameByCompany(companyId, assessIndicator);
            if (assessCycle == 1) {//日报表
                int reportId = getReportById(schemeId);
                long oneDayTimestamp = JiXiaoDateUtil.getOneDayTimestamp(-1);//获取昨天零点时间戳
                fun1(tableName, oneDayTimestamp, reportId, users, score, tongjiType, assessIndicator);
            } else if (assessCycle == 2) {//周报表
                boolean weekend = JiXiaoDateUtil.isWeekStart();
                if (weekend) {//今天是周一
                    int reportId = getReportById(schemeId);
                    long sevenDayTimestamp = JiXiaoDateUtil.getOneDayTimestamp(-7);//获取上周周一零点时间戳
                    fun1(tableName, sevenDayTimestamp, reportId, users, score, tongjiType, assessIndicator);
                }
            } else if (assessCycle == 3) {
                boolean monthend = JiXiaoDateUtil.isMonthStart();//今天是月初
                if (monthend) {
                    int reportId = getReportById(schemeId);
                    long monthStartTimestamp = JiXiaoDateUtil.getYearStartTimestamp(0, false);//获取上月初零点时间戳
                    fun1(tableName, monthStartTimestamp, reportId, users, score, tongjiType, assessIndicator);
                }
            } else if (assessCycle == 4) {
                String thisSeasonEnd = JiXiaoDateUtil.thisSeasonStart();//返回该季度第一天
                String dateTime = JiXiaoDateUtil.getDateTime(0);//返回当天日期
                if (thisSeasonEnd.equals(dateTime)) {//今天是该季度第一天
                    int reportId = getReportById(schemeId);
                    long quarterStartTimestamp = JiXiaoDateUtil.getYearStartTimestamp(0, true);//获取上个季度初零点时间戳
                    fun1(tableName, quarterStartTimestamp, reportId, users, score, tongjiType, assessIndicator);
                }
            } else if (assessCycle == 5) {
                String thisYearEnd = JiXiaoDateUtil.thisYearStart();//返回年初日期
                String dateTime = JiXiaoDateUtil.getDateTime(0);//返回当天日期
                if (dateTime.equals(thisYearEnd)) {//今天是年初
                    int reportId = getReportById(schemeId);
                    long yearStartTimestamp = JiXiaoDateUtil.getYearStartTimestamp(Integer.parseInt(dateTime.substring(4)), false);//获取上一年初零点时间戳
                    fun1(tableName, yearStartTimestamp, reportId, users, score, tongjiType, assessIndicator);
                }
            }
        }
    }

    //入库人员绩效分值表
    public synchronized void fun(String tableName, long begin, int reportId, String users, double score, int assessIndicator) throws SQLException, MessageException, JSONException {
        String assessIndicatorString = getAssessIndicator(assessIndicator);
        JSONArray jsonArray = new JSONArray();
        if (CmsCache.getParameter("jixiao_url").getJson() != null && assessIndicator == 3) {
            String appUrl = CmsCache.getParameter("jixiao_url").getJson().getString("app_url");
            if (appUrl.length() > 0) {
                String url = appUrl + "?begin=" + begin + "&end=" + end + "&users=" + users;
                String result = Util.connectHttpUrl(url);
                jsonArray = new JSONArray(result);
            }
        } else {
            String sql1 = "select user,count(*) sum from " + tableName + " where active = 1 and status = 1 and PublishDate between " + begin + " and " + end + " and user in (" + users + ") group by user";
            TableUtil tu = new TableUtil();
            ResultSet rs = tu.executeQuery(sql1);
            while (rs.next()) {
                int userid = rs.getInt("user");
                int sum = rs.getInt("sum");
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("user", userid);
                jsonObject.put("sum", sum);
                jsonArray.put(jsonObject);
            }
            tu.closeRs(rs);
        }
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject1 = jsonArray.getJSONObject(i);
            int userid = jsonObject1.getInt("userid");
            boolean b = hasPerforData(reportId, userid, assessIndicatorString);
            if (b){
                System.out.println("发稿量程序重复执行！");
                return;
            }
            int sum = jsonObject1.getInt("sum");
            boolean b1 = hasData(reportId, userid);
            double allPowerfulScore = Double.parseDouble(String.format("%.2f", sum * (1 / score)));//根据计算方式和发稿量计算出分值并保留两位小数
            if (b1) {//人员绩效表有记录，更新
                JSONObject o = getScoreByReportIDUserId(reportId, userid);//根据报表id和用户id获取总分值和id
                int id = o.getInt("id");
                double totalScore = o.getDouble("score");
                totalScore += allPowerfulScore;
                totalScore = Double.parseDouble(String.format("%.2f", totalScore));//保留两位小数
                HashMap<String, String> map1 = new HashMap<>();
                map1.put(assessIndicatorString, allPowerfulScore + "");
                map1.put("score", totalScore + "");
                ItemUtil.updateItemById(USERPERFORMANCEID, map1, id, 0);
            } else {//无记录，增加
                HashMap<String, String> map1 = new HashMap<>();
                map1.put("Title", CmsCache.getUser(userid).getName());
                map1.put("user_id", userid + "");
                map1.put("report_id", reportId + "");
                map1.put(assessIndicatorString, allPowerfulScore + "");
                map1.put("score", allPowerfulScore + "");
                map1.put("TongjiDate", beforeOneDay);
                ItemUtil.addItem(USERPERFORMANCEID, map1);
            }
        }
    }

    /**
     * 入库绩效明细表
     *
     * @param tableName       表名
     * @param begin           开始时间戳
     * @param reportId        绩效报表ID
     * @param users           参与人员
     * @param score           绩效方案表对应考核指标分值
     * @param tongjiType      绩效明细表对应统计类型
     * @param assessIndicator 考核指标
     * @throws SQLException
     * @throws MessageException
     * @throws JSONException
     */
    public void fun1(String tableName, long begin, int reportId, String users, double score, int tongjiType, int assessIndicator) throws SQLException, MessageException, JSONException {
        if (hasTongjiData(reportId, tongjiType)){//避免程序一天多次执行重复入库
            System.out.println("PV程序重复执行！");
            return;
        }
        String assessIndicatorString = getAssessIndicator(assessIndicator);
        JSONArray jixiaoTongjiArray = new JSONArray();
        if (CmsCache.getParameter("jixiao_url").getJson() != null && assessIndicator == 4) {
            String appPvUrl = CmsCache.getParameter("jixiao_url").getJson().getString("app_pv_url");
            if (appPvUrl.length() > 0) {
                String result = Util.connectHttpUrl(appPvUrl + "?begin=" + begin + "&end=" + end + "&users=" + users);
                JSONObject jsonObject = new JSONObject(result);
                jixiaoTongjiArray = jsonObject.getJSONArray("jixiaoTongji");
            }
        } else {
            String sql1 = "select GlobalID,user,pv num,Title,PublishDate from " + tableName + " where active = 1 and status = 1 and PublishDate between " + begin + " and " + end + " and user in (" + users + ")";
            if (assessIndicator == 6) {//微信稿件PV
                sql1 = "select GlobalID,news_read_count num,Title,PublishDate,user from " + tableName + " where active = 1 and status = 1 and PublishDate between " + begin + " and " + end + " and user in (" + users + ")";
            }
            TableUtil tu = new TableUtil();
            ResultSet rs = tu.executeQuery(sql1);
            while (rs.next()) {
                int userId = rs.getInt("user");
                int num = rs.getInt("num");
                int GlobalID = rs.getInt("GlobalID");
                String title = rs.getString("Title");
                int PublishDate = rs.getInt("PublishDate");
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("user", userId);
                jsonObject.put("num", num);
                jsonObject.put("GlobalID", GlobalID);
                jsonObject.put("title", title);
                jsonObject.put("PublishDate", PublishDate);
                jixiaoTongjiArray.put(jsonObject);
            }
            tu.closeRs(rs);
        }

        for (int i = 0; i < jixiaoTongjiArray.length(); i++) {
            JSONObject jsonObject1 = jixiaoTongjiArray.getJSONObject(i);
            int userId = jsonObject1.getInt("user");
            int num = jsonObject1.getInt("num");
            int GlobalID = jsonObject1.getInt("GlobalID");
            int PublishDate = jsonObject1.getInt("PublishDate");
            String title = jsonObject1.getString("title");
            String publishDate = Util.FormatTimeStamp("yyyy-MM-dd HH:mm:ss", (long) PublishDate);
            double allPowerfulScore = Double.parseDouble(String.format("%.2f", num * (1 / score)));//根据计算方式和发稿量计算出分值并保留两位小数
            //入库绩效明细表
            HashMap<String, String> map = new HashMap<>();
            map.put("Title", title);
            map.put("gid", GlobalID + "");
            map.put("user_id", userId + "");
            map.put("report_id", reportId + "");
            map.put("num", num + "");
            map.put("score", allPowerfulScore + "");
            map.put("TongjiType", tongjiType + "");
            map.put("TongjiDate_start", publishDate);
            map.put("TongjiDate_end", beforeOneDay);
            ItemUtil.addItem(JIXIAOTONGJIID, map);
        }
        //从绩效明细表查找数据入库绩效分值表
        String sql = "select user_id,sum(num) sum from channel_jixiao_tongji where report_id = " + reportId + " and TongjiType = " + tongjiType + " group by user_id";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        JSONArray jsonArray = new JSONArray();
        while (rs.next()) {
            int userid = rs.getInt("user_id");
            int sum = rs.getInt("sum");
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("userid", userid);
            jsonObject.put("sum", sum);
            jsonArray.put(jsonObject);
        }
        tu.closeRs(rs);
        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject jsonObject1 = jsonArray.getJSONObject(i);
            int userid = jsonObject1.getInt("userid");
            int sum = jsonObject1.getInt("sum");
            boolean b1 = hasData(reportId, userid);
            double allPowerfulScore = Double.parseDouble(String.format("%.2f", sum * (1 / score)));//根据计算方式和发稿量计算出分值并保留两位小数
            if (b1) {//人员绩效表有记录，更新
                JSONObject o = getScoreByReportIDUserId(reportId, userid);//根据报表id和用户id获取总分值和id
                int id = o.getInt("id");
                double totalScore = o.getDouble("score");
                totalScore += allPowerfulScore;
                totalScore = Double.parseDouble(String.format("%.2f", totalScore));//保留两位小数
                HashMap<String, String> map1 = new HashMap<>();
                map1.put(assessIndicatorString, allPowerfulScore + "");
                map1.put("score", totalScore + "");
                ItemUtil.updateItemById(USERPERFORMANCEID, map1, id, 0);
            } else {//无记录，增加
                HashMap<String, String> map = new HashMap<>();
                map.put("Title", CmsCache.getUser(userid).getName());
                map.put("user_id", userid + "");
                map.put("report_id", reportId + "");
                map.put(assessIndicatorString, allPowerfulScore + "");
                map.put("score", allPowerfulScore + "");
                map.put("TongjiDate", beforeOneDay);
                ItemUtil.addItem(USERPERFORMANCEID, map);
            }
        }
    }

    //根据报表ID和用户ID判断对应人员绩效分值表中有无数据
    public boolean hasData(int reportId, int userId) throws SQLException, MessageException {
        boolean b = false;
        String sql = "select * from channel_user_performance where report_id = " + reportId + " and user_id = " + userId;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if (rs.next()) {
            b = true;
        }
        tu.closeRs(rs);
        return b;
    }

    //根据绩效方案ID和统计日期查看是否有对应报表数据
    public int getReportById(int schemeId) throws SQLException, MessageException {
        String oneTheDay = JiXiaoDateUtil.getDateTime(-1);
        String sql = "select * from channel_jixiao_report where TongjiDate='" + oneTheDay + "' and jixiao_id=" + schemeId+" and Active = 1";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        int reportId = 0;
        if (rs.next()) {
            reportId = rs.getInt("id");
        }
        if (reportId == 0) {
            HashMap<String, String> map = new HashMap<>();
            map.put("jixiao_id", schemeId + "");
            map.put("report_name", beforeOneDay);
            map.put("TongjiDate", beforeOneDay);
            map.put("Title", beforeOneDay);
            reportId = ItemUtil.addItemGetID(JIXIAOREPORTID, map);
        }
        tu.closeRs(rs);
        return reportId;
    }

    //根据绩效方案ID获取用户ID
    public String getUsersByJixiaoId(int jixiaoId) throws SQLException, MessageException {
        String sql = "select user_id from channel_jixiao_participant where jixiao_id = " + jixiaoId;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        String userIds = "";
        while (rs.next()) {
            if (userIds == "") {
                userIds += rs.getInt("user_id");
            } else {
                userIds += "," + rs.getInt("user_id");
            }
        }
        tu.closeRs(rs);
        return userIds;
    }

    //根据报表id和用户id获取总分值和id
    public JSONObject getScoreByReportIDUserId(int reportId, int userId) throws SQLException, MessageException, JSONException {
        String sql = "select id,score from channel_user_performance where active = 1 and report_id = " + reportId + " and user_id = " + userId;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        double score = 0;
        int id = 0;
        JSONObject o = new JSONObject();
        if (rs.next()) {
            score = rs.getDouble("score");
            id = rs.getInt("id");
        }
        tu.closeRs(rs);
        o.put("id", id);
        o.put("score", score);
        return o;
    }

    public String getTableNameByCompany(int companyId, int assessIndicator) throws SQLException, MessageException {
        String tableName = "";
        String serialNo = "";
        if (assessIndicator == 3 || assessIndicator == 4) {//客户端发稿量
            if (companyId != 0) {//租户用户
                Channel channel = ChannelUtil.getChannelBySearal("a_a", companyId, 1);
                if (channel.getId() != 0) {//租户绑定的站点
                    serialNo = channel.getSerialNo();
                }
            } else {
                serialNo = "s53_a_a";
            }
            tableName = "channel_" + serialNo;
        } else if (assessIndicator == 5 || assessIndicator == 6) {
            serialNo = "s53_e_d";
            tableName = "channel_" + serialNo;
        }
        return tableName;
    }

    //获取考核类型
    public String getAssessIndicator(int assessIndicator) {
        String assessIndicatorString = "";
        switch (assessIndicator) {
            case 1:
                assessIndicatorString = "web_score";
                break;
            case 2:
                assessIndicatorString = "web_pv_score";
                break;
            case 3:
                assessIndicatorString = "app_score";
                break;
            case 4:
                assessIndicatorString = "app_pv_score";
                break;
            case 5:
                assessIndicatorString = "weixin_score";
                break;
            case 6:
                assessIndicatorString = "weixin_pv_score";
                break;
            case 7:
                assessIndicatorString = "subject_score";
                break;
            case 8:
                assessIndicatorString = "video_score";
                break;
        }
        return assessIndicatorString;
    }

    //pv避免程序多次调用生成重复数据
    public boolean hasTongjiData(int reportId, int tongjiType) throws MessageException, SQLException {
        String sql = "select * from channel_jixiao_tongji where report_id = " + reportId + " and TongjiType = " + tongjiType;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        boolean b = false;
        if (rs.next()) {
            b = true;
        }
        tu.closeRs(rs);
        return b;
    }

    //发稿量避免程序多次调用生成重复数据
    public boolean hasPerforData(int reportId, int userId, String assessIndicator) throws MessageException, SQLException {
        String sql = "select " + assessIndicator + " from channel_user_performance where report_id = " + reportId + " and user_id = " + userId;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        boolean b = false;
        if (rs.next()) {
            double d = rs.getDouble(assessIndicator);
            if (d != 0.0) {
                b = true;
            }
        }
        tu.closeRs(rs);
        return b;
    }

    @Override
    public void Add() throws SQLException, MessageException {

    }

    @Override
    public void Delete(int i) throws SQLException, MessageException {

    }

    @Override
    public void Update() throws SQLException, MessageException {

    }

    @Override
    public boolean canAdd() {
        return false;
    }

    @Override
    public boolean canUpdate() {
        return false;
    }

    @Override
    public boolean canDelete() {
        return false;
    }
}
