 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
				tidemedia.cms.util.*,
				java.sql.SQLException,
				java.sql.Timestamp,
				java.text.ParseException,
				java.text.SimpleDateFormat,
				java.util.Date,
				java.util.regex.Pattern"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>

<%
	//用户评价接口
	
	JSONObject oo = new JSONObject();

	try{
		int		globalID		=	getIntParameter(request,"globalID");
		int		evaluation	=	getIntParameter(request,"evaluation");//评价。满意(1)一般(2)不满意(3)

		TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
		int wenzhengchannelid = politics.getInt("politicsid");//问政编号信息

		Channel wenzhengchannel = CmsCache.getChannel(wenzhengchannelid);

		//String keywords = CmsCache.getParameterValue("keywords");
		//int videoroot = CmsCache.getParameter("wenzheng_operating_record").getIntValue();

		if(globalID==0){
				oo.put("status",0);
				oo.put("message","问政编号出错");
		}else if(evaluation==0){
				oo.put("status",0);
				oo.put("message","评价参数出错");
		}else{

			HashMap<String, String> map = new HashMap<String, String>();
			map.put("globalID",globalID+"");
			map.put("evaluation",evaluation+"");
			//获取文章对象
			Document doc = new Document(globalID);
			if(doc.getIntValue("probstatus")!=7){
			    oo.put("status",0);
				oo.put("message","当前问题未完结");
			}else{
			    	//更新
    			ItemUtil.updateItemById( doc.getChannelID(),map, doc.getId(),1);
                //发布
    			doc.Approve(doc.getId()+"",doc.getChannelID());
                oo.put("message","评价成功！");
                oo.put("status",1);
			}
		
        }
			
	}catch(Exception e){
			oo.put("message","接口调用失败，请检查传值参数");
			oo.put("status",0);
	}
	 
	out.println(oo.toString());
%>



