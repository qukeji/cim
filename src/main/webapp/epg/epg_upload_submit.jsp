<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.base.*,
				java.util.ArrayList,
				java.util.List,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf8"%>
<%@ include file="../config.jsp"%>

<%
	DiskFileUpload upload = new DiskFileUpload();
	String tempPath = "";
	String result = "导入节目单失败！";
	int ChannelID = 0;
	boolean uploadResult = false;
	
	
	List items = new ArrayList();

	request.setCharacterEncoding("utf-8");
	tempPath = request.getRealPath("/temp");

	upload.setSizeThreshold(16000);
	upload.setSizeMax(-1);
	upload.setRepositoryPath(tempPath);
	upload.setHeaderEncoding("utf-8");
	try
	{
		items = upload.parseRequest(request);
		java.util.Iterator iter = items.iterator();
		
		while (iter.hasNext())
		{
			
			FileItem item = (FileItem) iter.next();

			if (item.isFormField())
			{
				String FieldName = item.getFieldName();
				if (FieldName.equals("ChannelID")) 
					ChannelID = Integer.parseInt(item.getString());
			}
			else
			{ 
				//uploadResult = Epg.epgDeal(item,ChannelID,userinfo_session.getId());
				uploadResult = Epg.epgDeal(item,ChannelID,userinfo_session.getId());
			}
		}
	}
	catch (org.apache.commons.fileupload.FileUploadException e)
	{
	    uploadResult = false;
		e.printStackTrace();
	}
		
	if(uploadResult)
	{
		//result = "成功导入了"+Epg.totalNum+"条数据！";
		result = "成功导入节目单！";
		
	}
	else if(Epg.errorDay.length()>0)
		result = Epg.errorDay+"的节目单已存在！";

%>
 alert("<%=result %>");
 top.TideDialogClose({refresh:'right'});
 
		

