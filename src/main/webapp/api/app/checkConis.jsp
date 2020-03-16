<%@ page import="tidemedia.cms.util.*,
				 tidemedia.cms.system.*,
				 org.json.JSONObject,
				 org.json.JSONException,
				 org.json.JSONArray,
				 tidemedia.cms.app.*,
				 java.util.*,
                 tidemedia.cms.base.TableUtil,
                 java.sql.ResultSet,
                  java.text.SimpleDateFormat,
                java.util.Date,
                java.util.Calendar

"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%@ include file="common.jsp"%>
<%
	String cms_register = TIDE.get("cms_register")+"";
	Integer userid = getIntParameter(request,"userid");
	String code = "qiandao";
    JSONObject json  = new JSONObject();
    json.put("status",1);
	json.put("message","金币可添加");
	String coinsListTableName = TIDE.get("channel_cms_golddetail")+"";		
	if(code.equals("qiandao")){
		String sql = "select CreateDate from "+coinsListTableName+" where code = '"+code+"'  and userid='"+userid+"' order by createdate desc limit 0 ,1";
        System.out.println(sql);
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next()){
			Calendar calendar = Calendar.getInstance();
	        calendar.setTime(new Date());
	        calendar.set(Calendar.HOUR_OF_DAY, 0);
	        calendar.set(Calendar.MINUTE, 0);
	        calendar.set(Calendar.SECOND, 0);
	        Long zero = calendar.getTime().getTime();
	        Long lastQiandao =  rs.getLong("CreateDate")*1000;
	        if(lastQiandao>zero){
	        	json.put("status",0);
				json.put("message","金币不可添加");
	    	}
	    }
		tu.closeRs(rs);
	}
	CoinsInfo coinsInfo =new CoinsInfo(TIDE.get("channel_cms_goldaddition")+"",TIDE.get("channel_cms_golddetail")+"",CmsCache.getChannel((String)TIDE.get("channel_cms_golddetail_serialno")).getId());
	//int coins = coinsInfo.getCoins(userid);
	TableUtil tu2 = new TableUtil();
	String queryGoldSql = "select gold from "+cms_register+" where id = " + userid;
	ResultSet rs2 = tu2.executeQuery(queryGoldSql);
	int coins = 0;
	while(rs2.next()){
	    coins = rs2.getInt("gold");
	}
	tu2.closeRs(rs2);
	json.put("coins",coins);
	out.println(json.toString());
%>
