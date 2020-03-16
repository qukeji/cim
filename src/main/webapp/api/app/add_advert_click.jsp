<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				 org.json.JSONObject,
				 org.json.JSONException,
				 org.json.JSONArray,
				 tidemedia.cms.app.*,
				 java.util.Date,
                 java.util.Calendar,
				 java.util.*,
				 java.sql.ResultSet,
				 org.apache.commons.lang.StringUtils
"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
	/**
	*	用途：客户端点击广告时跳转到jsp接口
	*	1.接收参数：id(广告id)、table(表名)
	*	2.数据库获取广告信息
	*	3.判断不为空的情况下重定向广告链接 
	*       第三步，去掉重定向广告，返回jsonObject 对象
	*/
	JSONObject jsonObject = new JSONObject();
	try {
		//1.接收参数：id(广告id)、table(表名)
		Integer advertisementId = getIntParameter(request,"id");//接收的广告ID
		String tableName = getParameter(request,"table");//接收的表名
		if(advertisementId==0||tableName.equals("")){
			//out.println("参数不全");
			jsonObject.put("code",500);
			jsonObject.put("message","参数不全");
			out.println(jsonObject);
			return;
		}

		//2.数据库获取广告信息
		String advertisementURL = "";//定义广告外链接接收参数

		TableUtil tu = new TableUtil();// 建立JDBC对象
		String sql = "select * from " + tableName + " where id = " + advertisementId;
		ResultSet rs = tu.executeQuery(sql);// 执行SQL
		while (rs.next()) {
			advertisementURL = rs.getString("href");//查找出来的广告外链接
		}
		tu.closeRs(rs);// 关闭数据库对象

		
		//response.sendRedirect(advertisementURL);//重定向广告地址
		jsonObject.put("code",200);
		jsonObject.put("url",advertisementURL);
		out.println(jsonObject);
		
	} catch (Exception e) {
	    jsonObject.put("code",500);
		jsonObject.put("message","接口异常");
		System.out.println(e.getMessage());
		out.println(jsonObject);
	}

	
	
%>
