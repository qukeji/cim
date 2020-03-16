<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.app.*,
				java.sql.*,
				org.json.*,
				java.util.*
"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%@ include file="common.jsp"%>
<% 

	/*
	*	金币消费接口
	*/
	JSONObject json = new JSONObject();
	String cms_register = TIDE.get("cms_register")+"";
	String channel_s53_goldaddition = TIDE.get("channel_cms_goldaddition")+"";
	Integer channelId =CmsCache.getChannel((String)TIDE.get("channel_cms_golddetail_serialno")).getId() ;
	Integer userid = getIntParameter(request,"userid");
	String title = getParameter(request,"title");
	String code = getParameter(request,"code");
	Integer coin = getIntParameter(request,"coin");
	String site = getParameter(request,"site");
	if(userid!=null&&title.length()>0&&code.length()>0&&coin!=null&&site.length()>0){
	    TableUtil tu = new TableUtil();
	    //判断金币加成表里是否有code=buy_的记录
	    String queryCodeSql = "select * from "+channel_s53_goldaddition+" where code = '"+code+"'";
	    ResultSet rs1 = tu.executeQuery(queryCodeSql);
	    //有
	    if(rs1.next()){
	        //查询用户金币判断当前金币余额是否充足
        	String queryGoldSql = "select gold from "+cms_register+" where id = " + userid;
        	ResultSet rs2 = tu.executeQuery(queryGoldSql);
        	int goldNum = 0;
        	while(rs2.next()){
        	    goldNum = rs2.getInt("gold");
        	}
        	tu.closeRs(rs2);
        	//余额充足
        	if(coin <= goldNum){
        		
        		HashMap map = new HashMap();
        		map.put("Title",title);
        		map.put("userid",userid+"");
        		map.put("code",code);
        		map.put("coins",coin+"");
        		try{
        		    ItemUtil.addItemGetGlobalID(channelId, map);
        		}catch(Exception e){
        		    e.printStackTrace();
        		}
            	//实时更新用户金币总数
            	String updateSql = "update "+cms_register+" set gold=gold - "+coin+" where id = "+userid;
            	tu.executeUpdate(updateSql);
            	json.put("status",200);
                json.put("Message","消费成功，祝您生活愉快！");
        	}else{
                json.put("status",500);
                json.put("Message","对不起,您的余额不足,请充值！");
        	}
	    }else{
	        json.put("status",500);
            json.put("Message","消费失败！");
	    }
	    tu.closeRs(rs1);
	}else{
	        json.put("status",500);
            json.put("Message","对不起,请提供足够的参数！");
	}
   
	out.println(json.toString());
%>
