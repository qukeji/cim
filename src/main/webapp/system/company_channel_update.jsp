<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.util.concurrent.*,
				java.util.*,
				java.net.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
/*
*
*关联站点，创建频道（租户编辑）
*/
%>
<%! 
//频道是否存在
public int getChannelId(String whereSql){
	int channelId_ = 0;
	try{
		String sql = "select id from channel"+whereSql;
		TableUtil tu=new TableUtil();
		ResultSet rs=tu.executeQuery(sql);
		if(rs.next()){
			channelId_ = rs.getInt("id");
		}
		tu.closeRs(rs);
	}catch (Exception e) {
		System.out.println(e.getMessage());
	}
	return channelId_ ;
}
//创建频道
public int createChannel(String Name,int parent,int Type,String SerialNo,String FolderName,int company,int TemplateInherit) throws MessageException, SQLException{
	int channelId = 0 ;
	try{
		if(SerialNo.equals("")){
			SerialNo = CmsCache.getChannel(parent).getAutoSerialNo();
		}
		if(FolderName.equals("")){
			int index = SerialNo.lastIndexOf("_"); 
			FolderName = SerialNo;
			if(index!=-1){
				FolderName = SerialNo.substring(index+1);
			}
		}		
		/*
		Channel channel = new Channel();
		channel.setName(Name);//频道名
		channel.setParent(parent);//父编号
		channel.setType(Type);//独立表单
		channel.setSerialNo(SerialNo);//标识名
		channel.setFolderName(FolderName);//目录名
		channel.setCompany(company);
		channel.setTemplateInherit(TemplateInherit);//继承上级模板
		channel.setListProgram("***");//列表页
		channel.setDocumentProgram("***");//内容页
		channel.Add();
		channelId = channel.getId();*/
	}catch(Exception e){
		System.out.println(e.getMessage());
	}
	return channelId ;
}
%>

<%
int company = getIntParameter(request,"company");//租户编号
String companyName = getParameter(request,"companyName");//租户名
companyName = URLDecoder.decode(companyName,"utf-8");
String	token	= getParameter(request,"token");//用于校验
//int jurong = getIntParameter(request,"jurong");//1.开启聚融
String sites = getParameter(request,"sites");//关联站点
	int userid =  getIntParameter(request,"userid");//当前操作用户

if(CmsCache.checkToken("channel_edit",token)&&company!=0){

	//关联站点
	TableUtil tu = new TableUtil();
	String sql = "";
	//先解除租户相关站点，再重新设置关联关系
	sql = "update site set company=0 where company="+company;
	tu.executeUpdate(sql);
	if(!sites.equals("")){
		sql = "update site set company="+company+" where id in ("+sites+")";
		tu.executeUpdate(sql);
	}	
	ConcurrentHashMap sites_ = CmsCache.getSites();
	sites_.clear();

	//创建频道
//	if(jurong==1){
	
		Channel channel = new Channel();
		Channel c = new Channel();
		int channelId = 0 ;

		//获取pgc_图文频道编号
		channel = ChannelUtil.getApplicationChannel("pgc_doc");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setActionUser(userid);
				c.setName(companyName);
				c.Update();
			}
		}

		//获取pgc_直播频道编号
		channel = ChannelUtil.getApplicationChannel("pgc_live");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取大屏频道编号
		channel = ChannelUtil.getApplicationChannel("screen");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取大屏图表类频道编号
		channel = ChannelUtil.getApplicationChannel("screen_charts");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取大屏终端频道编号
		channel = ChannelUtil.getApplicationChannel("screen_zd");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取大屏播控检测频道编号
		channel = ChannelUtil.getApplicationChannel("screen_bkjc");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取大屏指挥中心频道编号
		channel = ChannelUtil.getApplicationChannel("screen_zhzx");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取选题管理频道编号
		channel = ChannelUtil.getApplicationChannel("task_doc");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取选题管理频道编号
		channel = ChannelUtil.getApplicationChannel("task_subject");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取选题车辆频道编号
		channel = ChannelUtil.getApplicationChannel("task_car");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取选题设备频道编号
		channel = ChannelUtil.getApplicationChannel("task_device");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取选题评分频道编号
		channel = ChannelUtil.getApplicationChannel("task_score");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取移动审片频道编号
		channel = ChannelUtil.getApplicationChannel("shenpian");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取文稿频道编号
		channel = ChannelUtil.getApplicationChannel("shengao");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}
		//获取项目管理编号
		channel = ChannelUtil.getApplicationChannel("task_project");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}
		
		//获取工单记录编号
		channel = ChannelUtil.getApplicationChannel("workorder");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}

		//获取上报管理编号
		channel = ChannelUtil.getApplicationChannel("shangbao");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1);
			}else{
				c = CmsCache.getChannel(company_channel);
				c.setName(companyName);
				c.setActionUser(userid);
				c.Update();
			}
		}
//	}
}
%>
