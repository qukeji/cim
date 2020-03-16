<%@ page import="java.sql.*,org.json.*,
				tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!(new UserPerm().canManageUser(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
UserInfo userinfo = new UserInfo(id);

if(userinfo.getRole()==1)
{
	if(!(new UserPerm().canManageAdminUser(userinfo_session)))
	{response.sendRedirect("../noperm.jsp");return;}
}

String Submit = getParameter(request,"Submit");
if(Submit.equals("Submit"))
{
//	String			=	getParameter(request,"");

	int DisableChangeConfig			= getIntParameter(request,"DisableChangeConfig");
	int DisableChangePublish		= getIntParameter(request,"DisableChangePublish");
	int DisableAddPublishScheme		= getIntParameter(request,"DisableAddPublishScheme");
	//int DisableEditPublishScheme	= getIntParameter(request,"DisableEditPublishScheme");
	int DisableEditPublishScheme	= 0;
	int DisableManageAdminUser		= getIntParameter(request,"DisableManageAdminUser");
	int DisableManageUser			= getIntParameter(request,"DisableManageUser");
	int DisableDeleteChannel		= getIntParameter(request,"DisableDeleteChannel");

	int EnableVblogPreApprove		= getIntParameter(request,"EnableVblogPreApprove");
	int EnableVblogApprove			= getIntParameter(request,"EnableVblogApprove");
	int EnableVblogPigeonhole		= getIntParameter(request,"EnableVblogPigeonhole");
	int EnableAddSpecialChannel		= getIntParameter(request,"EnableAddSpecialChannel");
	int	ManageFile					= getIntParameter(request,"ManageFile");
	int	ManageChannel				= getIntParameter(request,"ManageChannel");
	int	ManageSystem				= getIntParameter(request,"ManageSystem");
	int	OperateSystem				= getIntParameter(request,"OperateSystem");

	if(ManageFile==0){
		ManageFile=1 ;//未勾选，允许
	}else{
		ManageFile=0 ;//勾选，禁止
	}

	if(ManageChannel==0){
		ManageChannel=1 ;//未勾选，允许
	}else{
		ManageChannel=0 ;//勾选，禁止
	}

	if(ManageSystem==0){
		ManageSystem=1 ;//未勾选，允许
	}else{
		ManageSystem=0 ;//勾选，禁止
	}

	if(OperateSystem==0){
		OperateSystem=1 ;//未勾选，允许
	}else{
		OperateSystem=0 ;//勾选，禁止
	}
	String ChannelList				= getParameter(request,"ChannelList");
	String PermList					= getParameter(request,"PermList");
//System.out.println("channellist="+ChannelList+",PermList="+PermList+",EnableAddSpecialChannel="+EnableAddSpecialChannel+"DisableAddPublishScheme:"+DisableAddPublishScheme);
//	u.set();
	if(userinfo.getRole()==1 || userinfo.getRole()==4)
	{
		userinfo.addPermArray("DisableChangeConfig",DisableChangeConfig);
		userinfo.addPermArray("DisableChangePublish",DisableChangePublish);
		userinfo.addPermArray("DisableAddPublishScheme",DisableAddPublishScheme);
		if(DisableAddPublishScheme==1){
           DisableEditPublishScheme=1;
		}
		userinfo.addPermArray("DisableEditPublishScheme",DisableEditPublishScheme);
		userinfo.addPermArray("DisableManageAdminUser",DisableManageAdminUser);
		userinfo.addPermArray("DisableManageUser",DisableManageUser);
		userinfo.addPermArray("DisableDeleteChannel",DisableDeleteChannel);
		userinfo.addPermArray("ManageFile",ManageFile);
		userinfo.addPermArray("ManageChannel",ManageChannel);
		userinfo.addPermArray("ManageSystem",ManageSystem);
		userinfo.addPermArray("OperateSystem",OperateSystem);
	}else if(userinfo.getRole()==5)
	{
		userinfo.addPermArray("EnableVblogPreApprove",EnableVblogPreApprove);
		userinfo.addPermArray("EnableVblogApprove",EnableVblogApprove);
		userinfo.addPermArray("EnableVblogPigeonhole",EnableVblogPigeonhole);
	}
	else
	{
		userinfo.addPermArray("EnableAddSpecialChannel",EnableAddSpecialChannel);

		userinfo.setChannelList(ChannelList);
		userinfo.setPermList(PermList);
		//System.out.println(PermList);
	}
	//long beginTime = System.currentTimeMillis();
	userinfo.setMessageType(2);
	userinfo.setActionUser(userinfo_session.getId());
	userinfo.UpdatePerm();
//out.println("time:"+(System.currentTimeMillis()-beginTime)+"毫秒");
//out.close();
	out.println("<script>top.getDialog().Close();</script>");return;
}

Tree tree = new Tree();
JSONArray arr = tree.listChannel_json(userinfo_session);

%>
