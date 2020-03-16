<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.util.concurrent.*,
				java.util.*,
				tidemedia.cms.publish.*,
				org.json.JSONException,
				org.json.JSONObject,
				org.apache.commons.io.FileUtils,
				org.apache.tools.zip.ZipFile,
				org.apache.tools.zip.ZipEntry,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
//创建频道
public int createChannel(String Name,int parent,int Type,String Application) throws MessageException, SQLException{
	int channelId = 0 ;
	try{
		String SerialNo = CmsCache.getChannel(parent).getAutoSerialNo();

		int index = SerialNo.lastIndexOf("_"); 
		String FolderName = SerialNo;
		if(index!=-1){
			FolderName = SerialNo.substring(index+1);
		}
		
		Channel channel = new Channel();
		channel.setName(Name);//频道名
		channel.setParent(parent);//父编号
		channel.setType(Type);//独立表单
		channel.setSerialNo(SerialNo);//标识名
		channel.setFolderName(FolderName);//目录名
		channel.setApplication(Application);
		channel.Add();
		channelId = channel.getId();
	}catch(Exception e){
		System.out.println(e.getMessage());
	}
	return channelId ;
}
//创建字段
public void createField(String FieldName,String FieldDesc,String FieldType,String Default,int ChannelID,String Options,int DataType,int isHide) throws MessageException, SQLException{
	try{
		ArrayList <FieldGroup> fieldGroupArray = CmsCache.getChannel(ChannelID).getFieldGroupInfo();
		if(fieldGroupArray.size()>0){
			FieldGroup Gourp = fieldGroupArray.get(0);//内容编辑分组
			int GroupId = Gourp.getId();
			Field field = new Field();
			field.setChannelID(ChannelID);
			field.setGroupID(GroupId);
			field.setIsHide(isHide);
			field.setName(FieldName);
			field.setDescription(FieldDesc);
			field.setFieldType(FieldType);
			field.setOptions(Options);
			field.setDefaultValue(Default);
			field.setDataType(DataType);//单选、多选 、下拉列表    0字符Or 1数字
			field.Add();
		}
	}catch(Exception e){
		
	}
}
//增加系统参数
public void createParameter(String Name,String Code,int type,int value,int json,String Content) throws SQLException, MessageException{
	Parameter p = new Parameter();
	p.setName(Name);
	p.setCode(Code);
	p.setType2(type);
	p.setIntValue(value);
	p.setIsJson(json);
	p.setContent(Content);
	p.Add();
}
%>
<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();
TableUtil tu_user = new TableUtil("user");

Channel channel = new Channel();
int parent = 0 ;
%>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>站点升级结果</title>
<link rel="stylesheet" href="../style/2018/bracket.css">
</head>

<body>
<div class="container">

<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	<div class="config-box mg-t-15">	

<%
int Action = getIntParameter(request,"Action");
if(Action==0){
	out.println("<div class=\"row\"><h5>升级新界面相关字段：</h5></div>");
	out.println("<div class=\"row\"><h5>升级融合媒体新界面步骤：</h5></div>");
	out.println("<div class=\"row\"><h5>1.channel表增加标识</h5></div>");
	out.println("<div class=\"row\"><h5>2.视频库增加字段</h5></div>");
	out.println("<div class=\"row\"><h5>3.创建PGC相关频道</h5></div>");
	out.println("<div class=\"row\"><h5>4.创建租户相关系统参数</h5></div>");
	out.println("<div class=\"row\"><a href=\"update_vms_t20.jsp?Action=1\" class=\"btn btn-info mg-r-5 mg-b-10\">确定升级？</a></div>");
	return ;
}

//升级新界面相关字段
//field_desc增加EditorType字段
tu.executeUpdate("alter table field_desc add EditorType tinyint default 0,add Caption text");
out.println("<div class=\"row\"><h5>field_desc增加EditorType,Caption字段</h5></div>");
//音视频媒资列表页,内容页定制
tu.executeUpdate("update channel set ListProgram='../video/content2018.jsp',DocumentProgram='../video/document_video2018.jsp' where id=8800");
ChannelUtil.updateSubChannelsAttribute(8800,8,"../video/document_video2018.jsp");//应用到子频道
ChannelUtil.updateSubChannelsAttribute(8800,7,"../video/content2018.jsp");//应用到子频道
out.println("<div class=\"row\"><h5>音视频媒资列表页,内容页定制</h5></div>");
//拆条任务列表页定制
tu.executeUpdate("update channel set ListProgram='../chaitiao/chaitiao_task_list2018.jsp' where id=15099");
out.println("<div class=\"row\"><h5>拆条任务列表页定制</h5></div>");
//回收站列表页定制
tu.executeUpdate("update channel set ListProgram='../trash/recycle_content2018.jsp' where id=15101");
ChannelUtil.updateSubChannelsAttribute(15101,7,"../trash/recycle_content2018.jsp");//应用到子频道
out.println("<div class=\"row\"><h5>回收站列表页定制</h5></div>");

//1.频道表增加application字段,区分频道类型(vms库)
tu.executeUpdate("alter table channel add application varchar(255),add company int(11) default 0");
out.println("<div class=\"row\"><h5>频道表增加application字段,区分频道类型</h5></div>");
tu.executeUpdate("alter table site add company int(11) default 0");
out.println("<div class=\"row\"><h5>站点表增加company字段</h5></div>");

//2.视频库增加字段
createField("juxian_username","聚现用户名","text", "", 8800, "", 0, 0);
createField("juxian_phone","聚现用户手机号","text", "", 8800, "", 0, 0);
createField("position","聚现位置","text", "", 8800, "", 0, 0);
createField("juxian_companyid","聚现企业id","number", "", 8800, "", 0, 0);
createField("juxian_user","聚现用户id","number", "", 8800, "", 0, 0);
createField("juxian_sourceid","聚现资源id","number", "", 8800, "", 0, 0);
createField("ModifyDate","聚现修改时间","number", "", 8800, "", 0, 0);
out.println("<div class=\"row\"><h5>视频库增加字段</h5></div>");

//3.创建PGC内容库频道
parent = createChannel("PGC内容管理",8800,1,"pgc");
if(parent!=0){
	createChannel("视频",parent,1,"pgc_video");
	createChannel("收录库",parent,1,"pgc_record");
}
out.println("<div class=\"row\"><h5>创建PGC内容库频道</h5></div>");

//4.系统参数
createParameter("是否开启租户","zuhu",2,1,0,"");
out.println("<div class=\"row\"><h5>创建租户相关系统参数</h5></div>");

//初始化缓存
ConcurrentHashMap channels = CmsCache.getChannels();
channels.clear();

%>
	</div>	                   
</div>

</div>
</body>
</html>