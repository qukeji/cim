<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
				java.sql.*,
				magick.*,
				java.io.File,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

tidemedia.cms.system.Site defaultSite1 = tidemedia.cms.system.CmsCache.getDefaultSite();
String TemplateFolder=defaultSite1.getTemplateFolder();

DiskFileUpload upload = new DiskFileUpload();

String tempPath			= "";
String FileName			= "";
String Path				= "";
String Name				= "";
String Title			= "";
String Description		= "";
String Photo			= "";
String Action			= "";
String	GroupID			="0";
String 	ItemID			="0";
String	suffix			="";

tempPath = request.getRealPath("/temp");

upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);
upload.setHeaderEncoding("UTF-8");

java.util.List items = upload.parseRequest(request);

java.util.Iterator iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (item.isFormField()) {
		String FieldName = item.getFieldName();
		if(FieldName.equals("FileName"))
			FileName = item.getString("UTF-8");
		if(FieldName.equals("Name"))
			Name = item.getString("UTF-8");
		if(FieldName.equals("Title"))
			Title = item.getString("UTF-8");
		if(FieldName.equals("Description"))
			Description = item.getString("UTF-8");
		if(FieldName.equals("Action"))
			Action = item.getString("UTF-8");
		if(FieldName.equals("GroupID"))
			GroupID=item.getString("UTF-8");
		if(FieldName.equals("ItemID"))
			ItemID=item.getString("UTF-8");
		if(FieldName.equals("suffix"))
			suffix=item.getString("UTF-8");
		if(FieldName.equals("Photo"))
			Photo=item.getString("UTF-8");
    } 
}

Path = TemplateFolder;

TemplateFile tf = new TemplateFile();
//tf.setTemplateName("/" + FolderName + "/" + Name);
tf.setFileName(FileName);
tf.setName(Name);
tf.setPhoto(Photo);
tf.setDescription(Description);
tf.setGroup(Integer.parseInt(GroupID));

tf.setActionUser(userinfo_session.getId());

if(Action.equals("Add")){

	tf.Add();

}else if(Action.equals("Edit")){

	tf.setId(Integer.parseInt(ItemID));	
	tf.Update();

}
if(suffix.equals("_3"))
{
	out.println("<script>top.TideDialogClose({refresh:'var w =window.frames[\"popiframe_2\"].frames[\"right\"];w.location=w.location;',suffix:'"+suffix+"'});</script>");
}
else
	out.println("<script>top.TideDialogClose({refresh:'right',suffix:'"+suffix+"'});</script>");
%>
