<%@ page import="tidemedia.cms.system.*,
				 tidemedia.cms.base.*,
				 tidemedia.cms.util.*,
				 tidemedia.cms.user.*,
				 java.util.*,
				 org.json.*,
				 java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
/*
*获取聚现直播信息
*/
%>
<%!
//判断表中是否存在某数据
public static int exists(String sql){
	int id=0;
	try {
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);			
		if(rs.next()){//数据存在，返回ID
			id = rs.getInt("id");
		}
		tu.closeRs(rs);
	} catch (Exception e) {
		e.printStackTrace();
	}
	return id;
}
//渠道企业入库（入库频道编号，渠道编号，入库表名，企业信息）
public static boolean addCompany(int channelId , int jty_id , String tableName , JSONObject json_company)throws Exception{
	boolean isNull = true ;

	int id = json_company.getInt("id");//企业编号

	String sql1 = "select id from "+tableName+" where Active=1 and company_id="+id;
	if(exists(sql1)!=0){//说明以获取过此活动
		isNull = false ;
	}else{

		String title	= json_company.getString("company");//企业名称
		String summary  = json_company.getString("summary");//企业介绍
		String logo		= json_company.getString("logo");//企业LOGO
		String phone	= json_company.getString("phone");//手机号
		String token_    = json_company.getString("token");//访问令牌
		String address	= json_company.getString("address");//企业地址

		HashMap<String,String> log_ = new HashMap<String,String>();
		log_.put("Title",title);
		log_.put("Summary",summary);
		log_.put("Photo",logo);
		log_.put("phone",phone);
		log_.put("token",token_);
		log_.put("address",address);
		log_.put("company_id",id+"");
		log_.put("parent",jty_id+"");
		ItemUtil.addItemGetGlobalID(channelId,log_);
	}
	return isNull ;
}
%>
<%
String message = "同步完成";
try{

	String   jsontext= CmsCache.getParameterValue("sync_juxian_live");
	JSONObject json = new JSONObject(jsontext);
	String url_ = json.getString("company_url");//聚现企业列表接口
	
	JSONArray Siteinfo=json.getJSONArray("list");
	
	
	//String token = json.getString("token");//聚现企业号访问令牌
	//int channelId = json.getInt("company_channelId");//入库频道编号
	
	
	
	
		for(int l=0;l<Siteinfo.length();l++){
				JSONObject siteObj=Siteinfo.getJSONObject(l);
				String token = siteObj.getString("token");
				int siteid	 = siteObj.getInt("site");
				int channelId = 0;
				try{
					TableUtil tu_company=new TableUtil();
					String Sql_company="select id from channel  where  SerialNo='company_s"+siteid+"_info' ";
					ResultSet rs_company=tu_company.executeQuery(Sql_company);
					if(rs_company.next()){
						 channelId=rs_company.getInt("id");
					}
					tu_company.closeRs(rs_company);
				}catch(Exception e){
					Log.SystemLog("获取各个站点下企业库失败", "错误信息:  " + e.toString());
				}
				int company_id = 0 ;//上次同步企业编号
				String tableName = CmsCache.getChannel(channelId).getTableName();
				TableUtil tu = new TableUtil();
				String sql = "select company_id from " + tableName + " where Active=1 order by company_id desc";
				ResultSet rs = tu.executeQuery(sql);
				if(rs.next())
				{
					company_id = rs.getInt("company_id");
				}
				tu.closeRs(rs);

				while(true){
					//获取聚现直播列表
					String url_path = url_+"?access_token="+token+"&id="+company_id;
					out.println(url_path+"<br>") ;
					String result = Util.connectHttpUrl(url_path);
					JSONObject json_ = new JSONObject(result);
					
					if(json_.getInt("code")==200){//请求接口成功

						JSONObject json_result = json_.getJSONObject("result");
						JSONObject json_own = json_result.getJSONObject("own");
						int jty_id = json_own.getInt("id");//菁体育企业编号
						addCompany(channelId,0,tableName,json_own);//增加企业

						JSONArray arr = json_result.getJSONArray("channel");       
						for(int i=0;i<arr.length();i++){

							JSONObject json_company = (JSONObject) arr.get(i);
							int id = json_company.getInt("id");//企业编号

							boolean isNull = addCompany(channelId,jty_id,tableName,json_company);//增加企业
							if(!isNull){//此活动已存在
								continue;
							}
							company_id = id;//遍历接口
						}
						if(arr.length()<10){
							break;
						}
					}else{
						message = "同步失败";
						Log.SystemLog("同步聚现企业失败", "错误信息:  " + json_.getString("message"));
					}
				}
				
		}		
} catch (Exception e) {
	message = "同步失败";
	e.printStackTrace();
}


			out.println(message) ;
%>
