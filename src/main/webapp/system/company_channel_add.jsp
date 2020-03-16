<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.util.*,
				java.net.*,
				org.json.JSONException,
				org.json.JSONObject,
				org.apache.commons.io.FileUtils,
				org.apache.tools.zip.ZipFile,
				org.apache.tools.zip.ZipEntry,
				java.util.concurrent.ConcurrentHashMap,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
/*
*
*关联站点，创建频道（租户新建）
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
public int createChannel(String Name,int parent,int Type,String SerialNo,String FolderName,int company,int TemplateInherit,int Version,int actionuser) throws MessageException, SQLException{
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
		channel.setVersion(Version);//版本功能
		channel.setActionUser(actionuser);
		channel.Add();
		channelId = channel.getId();
	}catch(Exception e){
		System.out.println(e.getMessage());
	}
	return channelId ;
}
//创建站点
public void addSite(String Name,int userid,int company,int SiteType,int web) throws MessageException, SQLException, IOException{
	Site site = new Site();
	site.setName(Name);
	site.setSiteType(SiteType);
    site.setActionUser(userid);
	site.setCompany(company);
	site.Add();

	/*int siteid = site.getId();
	int parent = 0 ;
	String sql = "select id from channel where Parent=-1 and Site="+siteid;
	TableUtil tu = new TableUtil();
	ResultSet Rs = tu.executeQuery(sql);
	if (Rs.next()) {
		parent = Rs.getInt("id");
	}
	tu.closeRs(Rs);

	if(parent!=0){//导入频道
		if(SiteType==1){

			import_channel("15893.zip",parent,userid);
			import_channel("16319.zip",parent,userid);
			import_channel("15963.zip",parent,userid);
			import_channel("15964.zip",parent,userid);
			if(web!=0){
				import_channel("15933.zip",parent,userid);
			}
		}else{
			import_channel("15933.zip",parent,userid);
		}
	}*/
}
public void import_channel(String file,int channelid,int userid) throws MessageException, SQLException, IOException{

	ChannelImport channel_import = new ChannelImport();
	channel_import.setChannelid(channelid);
	channel_import.setFilename(file);
	channel_import.setUserid(userid);

	channel_import.setImport_document(true);
	channel_import.setImport_template(true);
	channel_import.setImport_channel(true);

	String result = channel_import.start();
}
%>

<%
int company = getIntParameter(request,"company");//租户编号
String companyName = getParameter(request,"companyName");//租户名
companyName = URLDecoder.decode(companyName,"utf-8");
String	token	= getParameter(request,"token");//用于校验
int userid =  getIntParameter(request,"userid");//当前操作用户

int web = getIntParameter(request,"web");
int app = getIntParameter(request,"app");
String	siteName	= getParameter(request,"siteName");
siteName = URLDecoder.decode(siteName,"utf-8");

if(CmsCache.checkToken("channel_add",token)&&company!=0){

	//创建站点
	if(app!=0){
		if(web==0){
			addSite(siteName,userid,company,1,0);
		}else{
			addSite(siteName,userid,company,1,1);
		}
	}else if(web!=0){
		addSite(siteName,userid,company,2,1);
	}

	//创建频道
//	if(jurong==1){
	
		Channel channel = new Channel();
		int channelId = 0 ;

		//获取pgc_图文频道编号
		channel = ChannelUtil.getApplicationChannel("pgc_doc");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
			}
		}

		//获取选题任务频道编号
		channel = ChannelUtil.getApplicationChannel("task_subject");
		channelId = channel.getId() ;
		if(channelId!=0){
			//判断租户频道是否已存在
			int company_channel = getChannelId(" where parent="+channelId+" and company="+company);
			//不存在创建频道
			if(company_channel==0){
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,0,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,1,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,1,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,1,userid);
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
				createChannel(companyName,channelId,1,"","",company,1,1,userid);
			}
		}
		
//	}
}



%>
