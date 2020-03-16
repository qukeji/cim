<%@page import="java.net.URLDecoder"%>
<%@ page
	import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				java.net.*,
				java.text.SimpleDateFormat,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="../../config1.jsp"%>
<%
/**
* 媒体号注册入库
* 
*/	
	TideJson tidejson = CmsCache.getParameter("juxian_api").getJson();
	String url = tidejson.getString("check_companyCode_url");//	企业码是否存在接口地址
	JSONObject json = new JSONObject();
	String message = "";
	String action = getParameter(request,"action") ;
	String site =getParameter(request,"site") ;
	String userid =getParameter(request,"userid") ;
	String type =getParameter(request,"type") ;
	String name =getParameter(request,"name") ;
	String email =getParameter(request,"email") ;
	String summary =getParameter(request,"summary") ;
	String company_type =getParameter(request,"company_type") ;
	String avatar =getParameter(request,"avatar") ;
	String photo =getParameter(request,"photo") ;
	String company_code = getParameter(request,"company_code") ;
	ItemUtil itemutil = new ItemUtil();
	HashMap<String,String> map = new HashMap<String,String>();
	if("".equals(type)){
		json.put("code",500);
		json.put("message","类型不能为空");
		out.println(json);
		return;
	}
	
	String channel_SerialNo = "company_s"+site+"_info";
	Channel channel=CmsCache.getChannel(channel_SerialNo);
	int channelid = channel.getId();
	if("0".equals(type)){
		if("".equals(site)||"".equals(userid)||"".equals(name)||"".equals(email)||"".equals(summary)){
			json.put("code",500);
			json.put("message","参数不全");
			out.println(json);
			return;
		}else{	
					if(!"".equals(company_code)){
						String result = Util.connectHttpUrl(url + "?code="+company_code);
						JSONObject jsonresult = new JSONObject(result);
						if(jsonresult.getInt("code")==200){
							map.put("jushi_userid",userid);
			            	map.put("Site",site);
			            	map.put("Type",type);
			            	map.put("Title",name);
			            	map.put("Email",email);
			            	map.put("Summary",summary);
			            	map.put("company_code",company_code);
						}else{
							json.put("code",500);
			                json.put("message","企业码不存在请重新输入.");
			                out.println(json);
			    			return;
						}
					}else{
						map.put("jushi_userid",userid);
		            	map.put("Site",site);
		            	map.put("Type",type);
		            	map.put("Title",name);
		            	map.put("Email",email);
		            	map.put("Summary",summary);
					}
					
		}
	}

	if("1".equals(type)){
		if("".equals(site)||"".equals(userid)||"".equals(photo)||"".equals(name)||"".equals(email)||"".equals(summary)||"".equals(company_type)||"".equals(avatar)){
			json.put("code",500);
			json.put("message","参数不全");
			out.println(json);
			return;
		}else{
		    map.put("jushi_userid",userid);
        	map.put("Site",site);
        	map.put("Type",type);
        	map.put("Title",name);
        	map.put("Email",email);
        	map.put("Summary",summary);
        	map.put("company_type",company_type);
        	map.put("Avatar",avatar);
        	map.put("Photo",photo);
		}
	}
	
	
    String channel_SerialNo_user = "register";//注册用户信息频道
	Channel channel_user=CmsCache.getChannel(channel_SerialNo_user);
	int channelid_user = channel_user.getId();
	
	TableUtil tu = new TableUtil();
	String sql1 = "select * from " + channel_user.getTableName() +" where Active=1 and id="+userid;	
	ResultSet Rs = tu.executeQuery(sql1);
	String phone = "";
	if(Rs.next()){
		phone = tu.convertNull(Rs.getString("phone"));
		map.put("phone",phone);
	}
	try{
	    String sql = "select * from " + channel.getTableName() +" where Active=1 and jushi_userid="+userid;	
	    Rs = tu.executeQuery(sql);
    	int itemid = 0;
    	int Status1 = 0;
		if(Rs.next()){
    		 itemid=Rs.getInt("id");
    		 Status1 = Rs.getInt("Status1");
	    }
        tu.closeRs(Rs);
        if(itemid==0){
        	itemutil.addItemGetGlobalID(channelid,map);
    		json.put("code",200);
    		json.put("message","已提交审核");
        }else{
        	if("1".equals(action)&&Status1==2){
       	        map.put("Status1","0");
       	        itemutil.updateItemById(channelid, map,itemid , 1);
       	        json.put("code",200);
    	        json.put("message","已提交审核");
       	    }else{
       	        json.put("code",500);
                json.put("message","用户已注册过媒体号");
                
       	    }
        }
	}catch(Exception e){
		json.put("code",500);
		json.put("message","接口异常");
		e.printStackTrace();
	}finally{
		out.println(json);
	}
	
%>
