<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.app.*,
				org.json.*,
				java.sql.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%@ include file="common.jsp"%>
<%
	Integer userid = getIntParameter(request,"userid");
	Integer site = getIntParameter(request,"site");
	String code = getParameter(request,"code");
	Integer itemid = getIntParameter(request,"itemid");
	CoinsInfo coinsInfo =new CoinsInfo(TIDE.get("channel_cms_goldaddition")+"",TIDE.get("channel_cms_golddetail")+"",CmsCache.getChannel((String)TIDE.get("channel_cms_golddetail_serialno")).getId());
	JSONObject json = new JSONObject();
	if (userid==0){
		json.put("message","操作人用户编号不得为空");
		json.put("status",0);
		json.put("type",0);
		out.println(json.toString());
		return;
	}
	if (code.equals("")){
		json.put("message","操作类型不得为空");
		json.put("status",0);
		json.put("type",0);
		out.println(json.toString());
		return;
	}

	coinsInfo.setUserid(userid);
	coinsInfo.setCode(code);
	coinsInfo.setItemid(itemid);
	try{
	    json = coinsInfo.add();
		
		if(json!=null&&json.getInt("status")==1){
			//��ȡ��Ҽӳ������õĽ����
			coinsInfo.getCoinsInfo(code);
			int num = coinsInfo.getCoins();
			
			//ʵʱ�����û��������
			String cms_register = (String)TIDE.get("cms_register");//�û�ע���
			String updateSql = "update "+cms_register+" set gold=gold + "+num+" where id = "+userid;
			//out.println("updateSql=="+updateSql);
			TableUtil tu = new TableUtil();
			tu.executeUpdate(updateSql);
		}
    }catch(Exception e){
        e.printStackTrace();
        json.put("status",0);
        json.put("type",0);
        json.put("message",e.toString());
    }
	out.println(json.toString());
%>
