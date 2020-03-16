<%@ page import="java.io.File,java.sql.*,
				java.text.SimpleDateFormat,
				tidemedia.cms.system.*,
				java.util.ArrayList,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				java.util.HashMap,
				java.util.*,
				java.util.Date,
java.io.FileOutputStream,
java.io.IOException,
java.io.PrintStream,
				org.json.JSONObject,
				tidemedia.cms.excel.*"
%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="../config.jsp"%>
<%!public static HashMap ClearFile(HashMap map) throws MessageException, SQLException {
		HashMap map_result = new HashMap();
		if (map != null) {
			//flag_exist_Template=true;
			String FileName = (String) map.get("excelname");
			map_result.put("filename", FileName);
			map_result.put("message", "");
		} else {
			map_result.put("message", "excel文件生成出现错误,请查看系统日志。");
		}
		return map_result;
	}%>
<%
	String tomcatPath = request.getRealPath("/");//获取tomcat所在目录
	int ChannelID = getIntParameter(request, "ChannelID");//频道编号
	int Status3 = getIntParameter(request, "Status3");//办理状态
	int id = 0;
	String name = "";
	String account = "";
	String amount = "";
	String Html_path = tomcatPath+"WEB-INF/exportExcelTemplate.html";
	PrintStream printStream = new PrintStream(new FileOutputStream(Html_path));
	HashMap map_result = new HashMap();//返回值map对象
	HashMap map = new HashMap();//获取后台程序返回值
	TableUtil tu = new TableUtil();
	tidemedia.cms.excel.ExcelDriver exceldriver = new tidemedia.cms.excel.ExcelDriver();
	StringBuffer sb = new StringBuffer();
	sb.append(
			"<table><tr><td>序号</td><td>标题</td><td>接收日期</td><td>状态</td></tr>");

	String TableName = CmsCache.getChannel(ChannelID).getTableName();
	
	String sql = "select * from " + TableName + " where Active = 1 ";
	String sql1 = "select count(*) total from " + TableName + " where Active = 1 ";
	if(Status3!=0){
		if(Status3==-1){
			sql+=" and Status3="+0;
			sql1+=" and Status3="+0;
		}else{
			sql+=" and Status3="+Status3;
			sql1+=" and Status3="+Status3;
		}
	}
	ResultSet Rs = tu.executeQuery(sql);
	while (Rs.next()) {
		String title = convertNull(Rs.getString("Title"));
		String itemid = convertNull(Rs.getString("Id"));
		String ModifiedDate = convertNull(Rs.getString("ModifiedDate"));
		ModifiedDate = datetoString(ModifiedDate);
		String Status3_ = convertNull(Rs.getString("Status3"));
		String Status3_Desc = "";
		if("0".equals(Status3_)){
			Status3_Desc="平台接收";
		}else if("1".equals(Status3_)){
			Status3_Desc="转办";
		}if("2".equals(Status3_)){
			Status3_Desc="办结";
		}
		sb.append("<tr>");
		sb.append("<td>" + itemid + "</td>");
		sb.append("<td>" + title + "</td>");
		sb.append("<td>" + ModifiedDate + "</td>");
		sb.append("<td>" + Status3_Desc + "</td>");
		sb.append("</tr>");
	}
	Rs = tu.executeQuery(sql1);
	int total = 0;
	if(Rs.next()){
		total = Rs.getInt("total");
	}
	tu.closeRs(Rs);
	sb.append("<tr><td></td><td></td><td>当前数据总计</td><td>"+total+"条</td></tr></table>");
	String str = new String(sb);
	printStream.println(str);
	map = exceldriver.exportExcell(Html_path, userinfo_session.getId(), tomcatPath,"1");//生成excel并删除模板文件然后下载
	map_result = ClearFile(map);
     JSONObject json=new JSONObject(map_result);
     String result_str=json.toString();
     out.println(result_str);
	
%>
<%!public static String datetoString(String str) {
		long time1 = Long.parseLong(str);
		String result1 = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date(time1 * 1000));
		return result1;
	}%>

