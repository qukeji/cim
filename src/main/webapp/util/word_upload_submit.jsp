<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.video.*,
				com.artofsolving.jodconverter.*,
				com.artofsolving.jodconverter.openoffice.connection.*,
				com.artofsolving.jodconverter.openoffice.converter.*,
				java.text.*,
				java.util.*,
				java.io.*,
				java.sql.*,
				java.net.*,
				tidemedia.cms.word.*,
				org.json.*,
				magick.*,
				java.io.File,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%!
public int getIntParameter(String tempstr)
{
	if(tempstr.equals(""))
		return 0;
	else
	{
		int i = 0;
		try{
			i = Integer.valueOf(tempstr).intValue();
		}catch(Exception e){}
		return i;
	}
}

public String getParameter(String tempstr)
{
	if(tempstr==null)
		return "";
	else
		return tempstr;
}
%>
<%
/**
*		修改人		修改时间		备注
*		郭庆光		20130702		修改 Photo字段
*		张赫东		2013/8/22		word导入功能
**/
//System.out.println("12---2------:");
DiskFileUpload upload = new DiskFileUpload();
String tomcatPath = request.getRealPath("/");
String tempPath			= "";
String FolderName		= "";
String fieldname2		= "";
String ReturnValue		= "";
String ReturnValue2		= "";
String Type				= "";
String Watermark		= "";
String Client			= "";
String transcode_need	= "";//是否需要转码
String videotype2		= "";//不转码时对应的格式
int ChannelID			= 0;
int itemid				= 0;//文档编号
int globalid			= 0;
String videotype		= "";



String browser			= "";
String Username			= "";
String Password			= "";
boolean isCan			=false;

tidemedia.cms.system.Site defaultSite = tidemedia.cms.system.CmsCache.getDefaultSite();

tempPath = request.getRealPath("/temp");

upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);
upload.setHeaderEncoding("UTF-8");
java.util.List items;

items = upload.parseRequest(request);


java.util.Iterator iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (item.isFormField()) {
		String FieldName = item.getFieldName();
		//System.out.println(FieldName);
		if(FieldName.equals("ChannelID"))
			ChannelID = getIntParameter(item.getString());
		else if(FieldName.equals("Type"))
			Type = getParameter(item.getString());
		else if(FieldName.equals("Watermark"))
			Watermark = getParameter(item.getString());
		else if(FieldName.equals("itemid"))
			itemid = getIntParameter(item.getString());
		else if(FieldName.equals("globalid"))
			globalid = getIntParameter(item.getString());
		else if(FieldName.equals("Client"))
			Client = getParameter(item.getString());
		else if(FieldName.equals("fieldname"))
			fieldname2 = getParameter(item.getString());
		else if(FieldName.equals("browser"))
			browser = item.getString();
		else if(FieldName.equals("Username"))
			Username = item.getString();
		else if(FieldName.equals("Password"))
			Password = item.getString();
		else if(FieldName.equals("videotype"))
			videotype = item.getString();
		else if(FieldName.equals("transcode_need"))
			transcode_need = item.getString();
		else if(FieldName.equals("videotype2"))
			videotype2 = item.getString();
    } 
}

tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();
if(browser.equals("msie")){
	if(session.getAttribute("CMSUserInfo")!=null)
	{
		userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
	}
	if(userinfo_session!=null && userinfo_session.getId()!=0)
	{
		isCan=true;
	}
}else if(browser.equals("mozilla")){
	TableUtil tu=new TableUtil("user");
	String Sql = "select * from userinfo where Username='" +tu.SQLQuote(Username) + "' and Password='" +tu.SQLQuote(Password) + "'";
	ResultSet Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		userinfo_session.setId(Rs.getInt("id"));
		isCan=true;
	}
	tu.closeRs(Rs);
}


int userid=userinfo_session.getId();
if(isCan){





iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (!item.isFormField()) {
		String FieldName = item.getFieldName();
		String FileName = item.getName();
		String FileExt = "";
		FileName = FileName.substring(FileName.lastIndexOf("\\")+1);

		int index = FileName.lastIndexOf(".");
		if(index!=-1)
		{
			FileExt = FileName.substring(index+1);
		}
		WordParseHtml  wordparsehtml=new WordParseHtml();
		String filename_doc=wordparsehtml.getflag_random();
		String new_file_doc=tomcatPath +"/temp/"+filename_doc+"."+FileExt;
		File file=new File(tomcatPath +"/temp/"+filename_doc+"."+FileExt);
		item.write(file);
		boolean flag_=wordparsehtml.convert2Html(new_file_doc,userid,ChannelID,FileName);
		
    } 
 }
}
%>
