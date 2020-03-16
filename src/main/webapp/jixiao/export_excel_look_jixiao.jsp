<%@ page import="org.json.JSONObject,
                 tidemedia.cms.base.TableUtil,
                 tidemedia.cms.system.CmsCache,
                 tidemedia.cms.util.Util,
                 java.io.FileOutputStream,
                 java.io.PrintStream,
                 java.sql.ResultSet,
                 java.text.SimpleDateFormat,
                 java.util.Date"%>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%!
    public static HashMap ClearFile(HashMap map){
        HashMap map_result = new HashMap();
        if (map != null) {
            String FileName = (String) map.get("excelname");
            map_result.put("filename", FileName);
            map_result.put("message", "");
        } else {
            map_result.put("message", "excel文件生成出现错误,请查看系统日志。");
        }
        return map_result;
    }
%>
<%
    String tomcatPath = request.getRealPath("/");//获取tomcat所在目录
    int reportid = getIntParameter(request, "reportid");//报表ID
    int schemeId = getIntParameter(request, "schemeId");//审核方案ID
    String Html_path = tomcatPath + "WEB-INF/exportExcelTemplate.html";
    PrintStream printStream = new PrintStream(new FileOutputStream(Html_path));
    HashMap map_result = new HashMap();//返回值map对象
    HashMap map = new HashMap();//获取后台程序返回值
    TableUtil tu = new TableUtil();
    String sql1 = "select AssessIndicator from channel_jixiao_scheme where id=" + schemeId;
    ResultSet rs1 = tu.executeQuery(sql1);
    StringBuffer sb = new StringBuffer();
    sb.append("<table><tr><td>排名</td><td>姓名</td>");
    String assessIndicator = "";
    if (rs1.next()){
        assessIndicator = rs1.getString("AssessIndicator");
        if (assessIndicator.contains("1")){
            sb.append("<td>网站发稿量分值</td>");
        }
        if (assessIndicator.contains("2")){
            sb.append("<td>网站稿件PV分值</td>");
        }
        if (assessIndicator.contains("3")){
            sb.append("<td>客户端发稿量分值</td>");
        }
        if (assessIndicator.contains("4")){
            sb.append("<td>客户端稿件PV分值</td>");
        }
        if (assessIndicator.contains("5")){
            sb.append("<td>微信发稿分值</td>");
        }
        if (assessIndicator.contains("6")){
            sb.append("<td>微信稿件PV分值</td>");
        }
        if (assessIndicator.contains("7")){
            sb.append("<td>选题采用量分值</td>");
        }
        if (assessIndicator.contains("8")){
            sb.append("<td>视频上传量分值</td>");
        }
    }
    sb.append("<td>总分值</td></tr>");
    tidemedia.cms.excel.ExcelDriver exceldriver = new tidemedia.cms.excel.ExcelDriver();
    String tableName = CmsCache.getChannel("user_performance").getTableName();
    String ListSql = "select * from " + tableName + " where report_id = " + reportid + " order by score desc";
    String CountSql = "select count(*) total from " + tableName + " where report_id = " + reportid + " order by score desc";
    ResultSet rs = tu.executeQuery(ListSql);
    int j = 0;
    while (rs.next()) {
        int user_id = rs.getInt("user_id");
        double score = rs.getDouble("score");
        String userName = Util.connectHttpUrl("http://183.58.24.156:888/jushi/jixiao/getUserNameById.jsp?userid=" + user_id, "UTF-8");
        double web_score = rs.getDouble("web_score");
        double web_pv_score = rs.getDouble("web_pv_score");
        double app_score = rs.getDouble("app_score");
        double app_pv_score = rs.getDouble("app_pv_score");
        double weixin_score = rs.getDouble("weixin_score");
        double weixin_pv_score = rs.getDouble("weixin_pv_score");
        double subject_score = rs.getDouble("subject_score");
        double video_score = rs.getDouble("video_score");
        j++;
        sb.append("<tr>");
        sb.append("<td>" + j + "</td>");
        sb.append("<td>" + userName + "</td>");

        if (assessIndicator.contains("1")){
            sb.append("<td>" + web_score + "</td>");
        }
        if (assessIndicator.contains("2")){
            sb.append("<td>" + web_pv_score + "</td>");
        }
        if (assessIndicator.contains("3")){
            sb.append("<td>" + app_score + "</td>");
        }
        if (assessIndicator.contains("4")){
            sb.append("<td>" + app_pv_score + "</td>");
        }
        if (assessIndicator.contains("5")){
            sb.append("<td>" + weixin_score + "</td>");
        }
        if (assessIndicator.contains("6")){
            sb.append("<td>" + weixin_pv_score + "</td>");
        }
        if (assessIndicator.contains("7")){
            sb.append("<td>" + subject_score + "</td>");
        }
        if (assessIndicator.contains("8")){
            sb.append("<td>" + video_score + "</td>");
        }
        sb.append("<td>"+score+"</td></tr>");
    }
    ResultSet Rs = tu.executeQuery(CountSql);
    int total = 0;
    if (Rs.next()) {
        total = Rs.getInt("total");
    }
    tu.closeRs(Rs);
    sb.append("<tr><td></td><td></td><td>当前数据总计</td><td>" + total + "条</td></tr></table>");
    String str = new String(sb);
    printStream.println(str);
    map = exceldriver.exportExcell(Html_path, userinfo_session.getId(), tomcatPath, "1");//生成excel并删除模板文件然后下载
    map_result = ClearFile(map);
    JSONObject json = new JSONObject(map_result);
    String result_str = json.toString();
    out.println(result_str);

%>
<%!
    public static String datetoString(String str) {
        long time1 = Long.parseLong(str);
        String result1 = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date(time1 * 1000));
        return result1;
    }
%>

