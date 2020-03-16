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
int SiteId				= 0;
String alertMessage		= "";
String ReWrite			= "";
String Username			= "";
String Password			= "";
boolean isCan			= false;

tempPath = request.getSession().getServletContext().getRealPath("/temp/import");
//System.out.println(tempPath);
upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);
upload.setHeaderEncoding("utf-8");

java.util.List items = null;
//try{
items = upload.parseRequest(request);
//}catch(Exception e){System.out.println(e.getMessage());}

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
		else if(FieldName.equals("Username"))
			Username = item.getString();
		else if(FieldName.equals("Password"))
			Password = item.getString();
    } 
}

tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();
if(session.getAttribute("CMSUserInfo")!=null)
{
	userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
}
if(userinfo_session!=null && userinfo_session.getId()!=0)
{
	isCan=true;
}

if(!isCan)
{
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

if(isCan){

	Path = tempPath ;

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

			if(!FileName.equals(""))
			{
				File uploadedFile = new File(Path + "/" +FileName);	

				if(!ReWrite.equals("Yes") && uploadedFile.exists())
				{
				   alertMessage += FileName	+ " 已经存在，没有覆盖!";
				}
				else
				{
					item.write(uploadedFile);

					new Log().FileLog(LogAction.file_add, "/" + FolderName + "/" + FileName ,userinfo_session.getId(),SiteId);
				}
			}
		} 
	}
}

//System.out.println("alertMessage:"+alertMessage);
if(alertMessage.length()>0){out.println(alertMessage);}%>