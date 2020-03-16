<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.base.TableUtil,
				java.util.*,			
				org.json.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ include file="../config1.jsp"%>
<%
	/**
	**1.更改频道表中的Category,OrderNumber.
	**2.更改item_snap表中信息
	**3.
	**
	**/
	
	int DestChannelID=0;//目标频道编号
	int userid=0;
		JSONObject o = new JSONObject();
	
	try{
	int GlobalID=getIntParameter(request,"globalid");
	DestChannelID=getIntParameter(request,"destchannelid");
	String Token=getParameter(request,"Token");
	
	String		ItemID		=	"";
	int	ChannelID_Source	=	0;
	int	ChannelID_Dest		=	0;
	int Type				=	1;
	


	int login = 0;
	if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token);
	//out.println(login+"--------");



	if(GlobalID==0)
	{
		o.put("status",0);
		o.put("message","缺少内容编号");
	}
	if(DestChannelID==0)
	{	
		o.put("status",0);
		o.put("message","缺少目标频道编号");
	}
	/*
	if(Token.length()==0)
	{
		o.put("status",0);
		o.put("message","缺少登录令牌");
	}
	else if(login!=1)
	{
		o.put("status",0);
		o.put("message","登录失败");
	}*/
	else
	{
		
			int isFlag=0;

			TableUtil tu=new TableUtil();
			String sql="select * from channel where id="+DestChannelID;
			ResultSet rs=tu.executeQuery(sql);
			while(rs.next())
			{
				isFlag=1;
			}
			tu.closeRs(rs);


			
			Document doc=new Document(GlobalID);
            ItemID=doc.getId()+"";
			int channelid=doc.getChannelID();
			ChannelID_Source=channelid;
			ChannelID_Dest=DestChannelID;
        
			if(ChannelID_Source!=0 && ChannelID_Dest!=0 && !ItemID.equals("")&&isFlag!=0)
			{
				userid=UserInfoUtil.AuthUserByToken(Token);
				Document document = new Document();
				document.setUser(userid);
				document.CopyDocuments(ItemID,ChannelID_Source,ChannelID_Dest,Type);
				
			
				o.put("status",1);
				o.put("message","success");	  
			}else{
				o.put("status",0);
				o.put("message","迁移文章失败！");
			}

		
			
		
	
	}
	}catch(Exception e){
		o.put("status",0);
		o.put("message","调用接口失败");
	}
	out.println(o.toString());



%>