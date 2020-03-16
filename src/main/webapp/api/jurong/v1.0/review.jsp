 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config1.jsp"%>
<%
//审核接口
%>
<%!
 public static HashMap<String, Object> review(int gid,int type,String reason,int userId,String photo,String reviewer,int data_type){
	HashMap<String, Object> map = new HashMap<String, Object>() ;

	try{		

		if(gid==0||type==0||data_type==0){

			map.put("status",501);
			map.put("message","参数缺少");

		}else{

			TideJson jurong = CmsCache.getParameter("jurong").getJson();//聚融接口信息
			int channel_reason = jurong.getInt("review_reason");

			UserInfo userinfo = new UserInfo(userId);
			Document doc = new Document(gid);
			int channelid = doc.getChannelID();
			//验证用户权限
			Boolean isShow = doc.getChannel().hasRight(userinfo,3);
			if(type==3){//如果是完成操作，不判断权限
				isShow = true ;
			}
			if(isShow){
				if(reviewer.equals("")){
					reviewer = userinfo.getName();
				}
				HashMap map_doc = new HashMap();
				if(data_type==1){//稿件
					int Status = 0 ;
					if(type==1){
						Status = type ;
					}
					map_doc.put("Status",Status+"");//状态
				}else{
					map_doc.put("task_status",type+"");//状态
				}
				ItemUtil.updateItemByGid(channelid, map_doc, gid, userId);
				
				if(data_type!=1){
					//发布
					doc.Approve(doc.getId()+"",channelid);
				}

				HashMap map_ = new HashMap();
				map_.put("Title",doc.getTitle());//任务名称
				map_.put("username",reviewer);//审核人
				map_.put("cms_userid",userId+"");//审核人
				map_.put("Photo",photo);//头像
				map_.put("parent",gid+"");//稿件编号
				map_.put("task_status_3",type+"");//状态
				map_.put("reason",reason);//不通过原因
				map_.put("review_date",System.currentTimeMillis()/1000+"");//审核时间
				ItemUtil.addItemGetGlobalID(channel_reason, map_);

				//小米推送
				String push_url = jurong.getString("push_url");
				if(!push_url.equals("")&&data_type==2){
					push_url = push_url+"?type="+(type+1)+"&id="+gid;
					push_url = Util.ClearPath(push_url);
					Util.connectHttpUrl(push_url);
				}

				map.put("status",200);
				map.put("message","成功");
			}else{
				map.put("status",500);
				map.put("message","用户无权限");
			}
		}
	}catch(Exception e){
		map.put("status",500);
		map.put("message","程序异常");
		e.printStackTrace();
	} 
	return map ;
}
%>
<%
	JSONObject json = new JSONObject();
	//判断用户是否登录
	tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();
	if(session.getAttribute("CMSUserInfo")!=null)
	{
		userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
	}
	if(userinfo_session==null || userinfo_session.getId()==0)
	{
		json.put("status",500);
		json.put("message","请先登录");
		out.println(json);
		return ;
	}

	int id = getIntParameter(request,"id");//选题编号globalid
	int type = getIntParameter(request,"type");//1通过2审核不通过3完成
	String reason = getParameter(request,"reason");//审核失败原因
	String photo = getParameter(request,"photo");//头像
	String reviewer = getParameter(request,"reviewer");//审核人
	int userid = userinfo_session.getId();//当前登录用户id(通过用户id获取该用户的审核权限)
	int data_type = getIntParameter(request,"data_type");//数据类型 1稿件/2选题
	if(data_type==0) data_type = 2 ;

	HashMap<String, Object> map = review(id,type,reason,userid,photo,reviewer,data_type);
	json = new JSONObject(map);
	out.println(json);

%>
