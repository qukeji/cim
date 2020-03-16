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
    
     Channel task_doc = ChannelUtil.getApplicationChannel("task_doc");
    int channelid = task_doc.getId() ;
    Channel channel = CmsCache.getChannel(channelid);
	String callback=getParameter(request,"callback");
    JSONArray array = new JSONArray();
    TableUtil tu = new TableUtil();
     ResultSet Rs = null;
    int num=0;//选题用户数量
    String whereSql = " where Active=1 ";
    String sql = "select *,count(1) as num from " + channel.getTableName() + whereSql+" group by User order by num desc";
    int companyid = userinfo_session.getCompany();
    if(companyid!=0){
        sql = "select id from channel where company="+companyid+" and parent="+channelid;
         Rs = tu.executeQuery(sql);
        if(Rs.next()){
        	int id = Rs.getInt("id");
        	String tablename = CmsCache.getChannel(id).getTableName();
        	sql = "select *,count(1) as num from " + tablename + whereSql+ " and category="+id+" group by User order by num desc";
        }
        tu.closeRs(Rs);
    }
    ResultSet rs = tu.executeQuery(sql);
    int  User=0;
    while(rs.next()){
        JSONObject json = new JSONObject();
        num=rs.getInt("num");
          User=rs.getInt("User");
        
        String 	sql1 = "select LastLoginDate,Name from userinfo where id="+User;
        TableUtil tu1 = new TableUtil("user");
		ResultSet Rs1= tu1.executeQuery(sql1);
		while(Rs1.next()) {
		   String loginDate = convertNull(Rs1.getString("LastLoginDate")).replace(".0","");
		    json.put("loginDate",loginDate);
		}
		tu1.closeRs(Rs1);
        String UserName	= CmsCache.getUser(User).getName();
        String phone	= CmsCache.getUser(User).getTel();
        
        json.put("UserName",UserName);
        json.put("phone",phone);
        json.put("num",num);
        array.put(json);
    }
    tu.closeRs(rs);
     
    out.println(array);
    

%>
