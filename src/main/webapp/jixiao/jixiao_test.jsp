<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.base.*,
                tidemedia.cms.util.*,
                tidemedia.cms.user.*,
                java.util.*,
                java.sql.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    //String sql = "select * from channel_jixiao_scheme";
    //String sql = "show create table channel_jixiao_scheme";
    //String sql  =  "select * from  channel where id=17766";
  // String sql  =  "update channel set application = 'jixiao_manage' where id=17766";
    String sql  = "insert into channel_jixiao_report (jixiao_id,report_name,TongjiDate,Title) values (3,'191022',now(),'191022')";
    out.println("jixiao_sql=========="+sql);
    TableUtil tu = new TableUtil();
   tu.executeUpdate(sql);
    //String sql1  =  "select * from  channel where id=17766";
   /* ResultSet rs = tu.executeQuery(sql);
    int i = 1;
    while(rs.next()){
        int  id = rs.getInt("id");
        String  Title = rs.getString("Title");
        String  AssessIndicator = rs.getString("AssessIndicator");

       // String  createTable = rs.getString("create table");
       // String  jixiao_application = rs.getString("application");
        //out.print("jixiao_application="+jixiao_application);
        out.println(id);
        out.println(Title);
        out.println(AssessIndicator);
        out.println(i);
        i++;
    }
    rs.close();*/
    out.println("执行成功");
%>
