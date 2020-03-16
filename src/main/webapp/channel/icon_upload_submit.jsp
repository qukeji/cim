<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				java.sql.*,
				java.io.File,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
DiskFileUpload upload = new DiskFileUpload();

String tempPath			= "";
String FolderName		= "";
String  Path			= "";
int SiteId				=0;
String alertMessage		= "";
String ReWrite			= "";
String browser			= "";
String Username			= "";
String Password			= "";
boolean isCan			=false;

tempPath = request.getRealPath("/temp");

upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);
upload.setHeaderEncoding("utf-8");

java.util.List items = upload.parseRequest(request);

java.util.Iterator iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();
    if (item.isFormField()) {
		String FieldName = item.getFieldName();
		if(FieldName.equals("FolderName"))
			FolderName = item.getString("utf-8");
	    else if(FieldName.equals("SiteId"))
			SiteId = Integer.parseInt(item.getString());
		else if(FieldName.equals("ReWrite"))
			ReWrite = item.getString();
		else if(FieldName.equals("browser"))
			browser = item.getString();
		else if(FieldName.equals("Username"))
			Username = item.getString();
		else if(FieldName.equals("Password"))
			Password = item.getString();
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
	TableUtil tu=new TableUtil();
	String Sql = "select * from userinfo where Username='" +tu.SQLQuote(Username) + "' and Password='" +tu.SQLQuote(Password) + "'";
	ResultSet Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		userinfo_session.setId(Rs.getInt("id"));
		isCan=true;
	}
	tu.closeRs(Rs);
}

if(isCan){

Path = request.getRealPath("/") + "images\\channel_icon\\";

iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (!item.isFormField()) {
		String FieldName = item.getFieldName();
		String FileName = item.getName();
		String FileExt = "";

		FileName = FileName.substring(FileName.lastIndexOf("\\")+1);
//System.out.println((FileName));
		int index = FileName.lastIndexOf(".");
		if(index!=-1)
		{
			FileExt = FileName.substring(index+1);
		}

		if(FileExt.equals("jpg") || FileExt.equals("png") || FileExt.equals("gif"))
		{
			if(!FileName.equals(""))
			{//System.out.println(Path + "/" +FileName);
				Util.consumeTime(100);
				File uploadedFile = new File(Path + "/" + System.currentTimeMillis()+"."+FileExt);	
				if(!ReWrite.equals("Yes") && uploadedFile.exists())
				{
				   alertMessage += FileName	+ " 已经存在，没有覆盖!";
				}
				else
				{
					item.write(uploadedFile);

					//new Log().FileLog("上传图标文件",FileName,userinfo_session.getId(),0);
				}
			}
		}
		else
		{
			alertMessage += FileName	+ " 文件类型不符合要求!";
		}
    } 
}
}
//System.out.println("alertMessage:"+alertMessage);
if(alertMessage.length()>0){out.println(alertMessage);}%>