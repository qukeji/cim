<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.util.*,
				org.json.JSONException,
				org.json.JSONObject,
				org.apache.commons.io.FileUtils,
				org.apache.tools.zip.ZipFile,
				org.apache.tools.zip.ZipEntry,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%! 
public  String DeCode(String str) {
	if (str == null)
		return "";
	try {
		String temp_p = str;
		byte[] temp_t = temp_p.getBytes("GBK");
		String temp = new String(temp_t, "iso-8859-1");
		return temp;
	} catch (Exception e) {
	}
	return "";
}

//频道是否存在
public int getChannelId(String SerialNo){
	int channelId_ = 0;
	try{
		String sql = "select id from channel where SerialNo='"+SerialNo+"'";
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
public int createChannel(String Name,int parent,int Type,String SerialNo,String FolderName) throws MessageException, SQLException{
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
		channel.Add();
		channelId = channel.getId();
		delGroup(channelId);
	}catch(Exception e){
		System.out.println(e.getMessage());
	}
	return channelId ;
}
//合并内容编辑，基本属性分组
public void delGroup(int channelid) throws MessageException, SQLException{
	ArrayList <FieldGroup> fieldGroupArray = CmsCache.getChannel(channelid).getFieldGroupInfo();
	for (int i = 0; i < fieldGroupArray.size(); i++){
		FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
		String fieldGroupName = fieldGroup.getName();//新表单组名
		if(fieldGroupName.equals("基本属性")){
			fieldGroup.Delete();
		}
	}
}
//获取表单分组id
public int getGroup(int channelid) throws MessageException, SQLException{
	int groupid = 0 ;
	ArrayList <FieldGroup> fieldGroupArray = CmsCache.getChannel(channelid).getFieldGroupInfo();
	for (int i = 0; i < fieldGroupArray.size(); i++){
		FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
		String fieldGroupName = fieldGroup.getName();//新表单组名
		if(fieldGroupName.equals("按钮集合组")){
			groupid = fieldGroup.getId();
		}
	}
	return groupid ;
}
//更新频道目录名
public void updateChannel(String FolderName,int channelId) throws MessageException, SQLException{

	Channel channel = new Channel(channelId);
	channel.setFolderName(FolderName);
	channel.UpdateFullPath();
}
//创建分组
public int createGroup(int ChannelID,String fieldGroupName,int Type) throws MessageException, SQLException{
	int groupid = 0 ;
	try{
		FieldGroup fieldGroup = new FieldGroup();
		fieldGroup.setChannel(ChannelID);
		fieldGroup.setName(fieldGroupName);
		fieldGroup.setType(Type);
		fieldGroup.Add();
		groupid = fieldGroup.getId();
	}catch(Exception e){
	}
	return groupid ;
}
//创建字段
public void createField(String FieldName,String FieldDesc,String FieldType,String Default,int ChannelID,String Options,int DataType,int isHide,String Caption,int DisableBlank,int groupid) throws MessageException, SQLException{
	try{
		ArrayList <FieldGroup> fieldGroupArray = CmsCache.getChannel(ChannelID).getFieldGroupInfo();
		if(fieldGroupArray.size()>0){
			FieldGroup Gourp = fieldGroupArray.get(0);//内容编辑分组
			int GroupId = Gourp.getId();
			if(groupid!=0){
				GroupId = groupid ;
			}
			Field field = new Field();
			field.setChannelID(ChannelID);
			field.setGroupID(GroupId);//分组id
			field.setIsHide(isHide);//是否隐藏
			field.setName(FieldName);//字段名
			field.setDescription(FieldDesc);//字段描述
			field.setFieldType(FieldType);//字段类型
			field.setOptions(Options);//选项
			field.setDefaultValue(Default);//默认值
			field.setDataType(DataType);//单选、多选 、下拉列表    0字符Or 1数字
			field.setCaption(Caption);//说明
			field.setDisableBlank(DisableBlank);//不允许为空
			field.Add();
		}
	}catch(Exception e){
		
	}
}
//更新字段（默认值,不允许为空）
public void updateField(String fieldName,int channelId,String DefaultValue,int DisableBlank) throws MessageException, SQLException{

	Field field = new Field(fieldName,channelId);
	field.setDefaultValue(DefaultValue);
	field.setDisableBlank(DisableBlank);//不允许为空
	field.Update();
}
//创建模板
public int createTemplate(String url ,String fileName,String name,int GroupID) throws MessageException, SQLException{
	int new_templateId = 0;//新模板ID
	try{
		//判断模板是否存在
		String sql = "select id from template_files where Name='"+name+"' and FileName='"+fileName+"' and GroupID="+GroupID;
		TableUtil tu=new TableUtil();
		ResultSet rs=tu.executeQuery(sql);
		if(rs.next()){
			new_templateId = rs.getInt("id");
		}
		tu.closeRs(rs);
		//不存在则新建
		if(new_templateId==0){
			File file = new File(url);
			String content = FileUtils.readFileToString(file); 
			TemplateFile tf_new = new TemplateFile();
			tf_new.setFileName(fileName);
			tf_new.setName(name);
			tf_new.setContent(content);
			tf_new.setGroup(GroupID);
			tf_new.Add();
			new_templateId = tf_new.getId();
		}
	}catch(Exception e){
		
	}
	return new_templateId ;
}
//频道引入模板
public void useTemplate(int channelId , int templateId, String Label,String TargetName,int TemplateType,int FileNameType,String FileNameField) throws MessageException, SQLException{
	String message1 ="";
	try{
		//判断模板是否引入
		String sql = "select id from channel_template where TemplateID="+templateId+" and Channel="+channelId;
		TableUtil tu=new TableUtil();
		ResultSet rs=tu.executeQuery(sql);
		int id = 0 ;
		if(rs.next()){
			id = rs.getInt("id");
		}
		tu.closeRs(rs);
		if(id==0){
			ChannelTemplate ct_new = new ChannelTemplate();
			ct_new.setTemplateType(TemplateType);//模板类型
			ct_new.setTargetName(TargetName);//对应程序文件名
			ct_new.setLabel(Label);//标识
			ct_new.setChannelID(channelId);//频道编号			
			ct_new.setTemplateID(templateId);//模板ID
			ct_new.setFileNameType(FileNameType);
			ct_new.setFileNameField(FileNameField);
			ct_new.Add();
			message1 = TargetName+"模板引用成功、";
		}else{
			message1 = TargetName+"模板已引用、";
		}
	}catch(Exception e){
		
	}
}
//获取模板id
public int getTemplateID(int channelId,String TargetName,int TemplateType){
	int TemplateID = 0;
	try{
		String sql = "select TemplateID from channel_template where Channel="+channelId+" and TargetName='"+TargetName+"' and TemplateType="+TemplateType;
		TableUtil tu=new TableUtil();
		ResultSet rs=tu.executeQuery(sql);
		if(rs.next()){
			TemplateID = rs.getInt("TemplateID");
		}
		tu.closeRs(rs);
	}catch (Exception e) {
		System.out.println(e.getMessage());
	}
	return TemplateID ;
}
//修改模板内容
public void UpdateContent(int TemplateID,String filecontent,int userId) throws SQLException, MessageException{
	
	TemplateFile tf = new TemplateFile(TemplateID);
	tf.setContent(filecontent);
	tf.setActionUser(userId);
	tf.UpdateContent();
}
//修改模板配置
public void UpdateTemplate(int TemplateID,int FileNameType,String FileNameField) throws SQLException, MessageException{
	
	ChannelTemplate ct = new ChannelTemplate(TemplateID);
	ct.setFileNameType(FileNameType);
	ct.setFileNameField(FileNameField);
	ct.Update();
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
//解压zip文件
public void unZipFiles(File zipFile,String descDir) throws IOException{  
	File pathFile = new File(descDir);  
	if(!pathFile.exists()){  
		pathFile.mkdirs();  
	}  
	if(!descDir.endsWith("/")){descDir += "/";}
	ZipFile zip = new ZipFile(zipFile);  
	for(Enumeration entries = zip.getEntries();entries.hasMoreElements();){  
		ZipEntry entry = (ZipEntry)entries.nextElement();  
		String zipEntryName = entry.getName();  
		InputStream in = zip.getInputStream(entry);  
		String outPath = (descDir+zipEntryName).replaceAll("\\*", "/");;  
		//判断路径是否存在,不存在则创建文件路径  
		File file = new File(outPath.substring(0, outPath.lastIndexOf('/')));  
		if(!file.exists()){  
			file.mkdirs();  
		}  
		//判断文件全路径是否为文件夹,如果是上面已经上传,不需要解压  
		if(new File(outPath).isDirectory()){  
			continue;  
		}                
		OutputStream out = new FileOutputStream(outPath);  
		byte[] buf1 = new byte[1024];  
		int len;  
		while((len=in.read(buf1))>0){  
			out.write(buf1,0,len);  
		}  
		in.close();  
		out.close();  
	}  
	System.out.println("******************解压完毕********************");  
}  
%>