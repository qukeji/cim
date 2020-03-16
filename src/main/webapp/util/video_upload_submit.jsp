<%@ page import="java.sql.*,
				java.io.File,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
DiskFileUpload upload = new DiskFileUpload();
String tempPath			= "";
String FolderName		= "";
String  Path			= "";
String alertMessage		= "";
String ReWrite			= "";
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
	 	if(FieldName.equals("ReWrite"))
			ReWrite = item.getString();
    } 
}


if(isCan){
	String SiteFolder="";
	Path = SiteFolder + "/" + FolderName;
	
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
	
			if(!FileName.equals(""))
			{//System.out.println(Path + "/" +FileName);
			    File uploadedFile = new File(Path + "/" +FileName);	
	
				if(!ReWrite.equals("Yes") && uploadedFile.exists())
				{
				   alertMessage += FileName	+ " 已经存在，没有覆盖!\\r\\n";
				}
				else
				{
					item.write(uploadedFile);
				}
			}
	    } 
	}
}
%>