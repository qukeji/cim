<%@ page import="tidemedia.cms.system.Document,tidemedia.cms.user.UserInfo,org.json.JSONObject"%><%@ page contentType="application/json;charset=utf-8" %><%@ include file="../config.jsp"%><%

	/**
	*  创建/修改人       修改时间        				    备注
	*   郭庆光         	 2013-05-07 19:41		编辑互斥的判断，开始编辑的时间与最后修改时间比较
	*   郭庆光	 2013-05-07 12:11		在前台js里做 比较,jsp里返回 modifileddate
	*	王海龙	 2016-07-16				判断当前登陆的用户和modifieduer是否是一个人
	*/
	int user_id = userinfo_session.getId();
	int gid = getIntParameter(request,"globalid");
	Document doc = new Document(gid);
	//doc.getValue("")方法获取不到
	long mtime=doc.getModifiedDateL();
	int last_modify_user = doc.getModifiedUser();
        JSONObject obj = new JSONObject();
        obj.put("modify_time",mtime);
	if(user_id==last_modify_user)
	{//同一个人 无需进行编辑互斥提示
                 obj.put("status",1);
                 obj.put("message","保存成功");
		 
	}
	else
	{
                 obj.put("status",0);
                 obj.put("message",new UserInfo(last_modify_user).getName()+" 正在编辑文章！");
		 
	}
         out.println(obj.toString());	
%>
