<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.*,
				tidemedia.cms.email.*,
				java.sql.*,
				java.io.*,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}


DiskFileUpload upload = new DiskFileUpload();

String tempPath			= "";
String FolderName		= "";
String  LineString		= "";
String  TotalString		= "";
String	Sql				= "";
String	StrA			= "";
String	StrB			= "";
String	Type			= "";

TableUtil tu = new TableUtil();

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
		if(FieldName.equals("Type"))
			Type = item.getString();
    } 
}

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
		{//System.out.println(Path + "/" +FileName);
			BufferedReader in = new BufferedReader(new InputStreamReader(item.getInputStream()));

			if(Type.equals("1"))
			{
				EmailAddress ea = new EmailAddress();
				while ((LineString = in .readLine())!=null)
				{
					LineString = LineString.trim();
					String[] str_array = LineString.split("\t");
					StrA = str_array[0].trim();
					StrB = str_array[1].trim();

					if(StrA.indexOf("@")!=-1&&StrA.indexOf(".")!=-1)
					{
						ea.setEmailAddress(StrA);
						ea.setName(StrB);
							
						try{ea.Add();}catch(MessageException e){}
						//Sql = "insert into email_address(EmailAddress,Name) values('" + tu.SQLQuote(StrA) + "','" + tu.SQLQuote(StrB) + "',now())";
						//tu.executeUpdate(Sql);
					}
					//TotalString += LineString+"\r\n<br>";
				}
			}

			if(Type.equals("2"))
			{
				EmailAddress ea = new EmailAddress();
				while ((LineString = in .readLine())!=null)
				{
					LineString = LineString.trim();
					String[] str_array = LineString.split(",");
					//System.out.println(str_array.length);
					for(int i=0;i<str_array.length;i++)
					{
						StrA = str_array[i].trim();
//System.out.println(StrA);
						if(StrA.indexOf("@")!=-1&&StrA.indexOf(".")!=-1)
						{
							ea.setEmailAddress(StrA);
							ea.setName("");
							
							try{ea.Add();}catch(MessageException e){}
							//Sql = "insert into email_address(EmailAddress,Name,CreateDate) values('" + tu.SQLQuote(StrA) + "','',now())";
							//tu.executeUpdate(Sql);
						}
					}
					//TotalString += LineString+"\r\n<br>";
				}
			}

		}
    } 
}

response.sendRedirect("../close_pop.jsp");
%>
