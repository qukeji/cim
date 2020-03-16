<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
				tidemedia.cms.user.*,
				java.text.SimpleDateFormat.*,
				java.sql.*,
				java.util.*,
				java.text.*,
				magick.*,
				java.io.*,
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
//System.out.println("this is insertfile_submit.jsp");
DiskFileUpload upload = new DiskFileUpload();

String tempPath			= "";
String FolderName		= "";
String fieldname2		= "";
String ReturnValue		= "";
String ReturnValue2		= "";
String Type				= "";
String Watermark		= "";
String Client			= "";
int ChannelID			= 0;
int Width				= 0;
int Height				= 0;
int CompressWidth		= 0;
int	CompressHeight		= 0;
int IsCompress			=0;//是否压缩
int UseCompress			=0;//是否使用压缩后图片
String filepath="";

String browser			= "";
String Username			= "";
String Password			= "";
boolean isCan			=false;
String tempitemid="";
String action="";
int itemid=0;
String globalid="";

tidemedia.cms.system.Site defaultSite = tidemedia.cms.system.CmsCache.getDefaultSite();

tempPath = request.getRealPath("/temp");

upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);
upload.setHeaderEncoding("UTF-8");
java.util.List items;

//try{
items = upload.parseRequest(request);
//}
//catch(org.apache.commons.fileupload.FileUploadException e){}

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
		else if(FieldName.equals("IsCompress"))
			IsCompress = getIntParameter(item.getString());
		else if(FieldName.equals("UseCompress"))
			UseCompress = getIntParameter(item.getString());
		else if(FieldName.equals("CompressHeight"))
			CompressHeight = getIntParameter(item.getString());
		else if(FieldName.equals("CompressWidth"))
			CompressWidth = getIntParameter(item.getString());
		else if(FieldName.equals("Width"))
			Width = getIntParameter(item.getString());
		else if(FieldName.equals("Height"))
			Height = getIntParameter(item.getString());
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
		else if(FieldName.equals("filepath"))
			filepath = item.getString();
		else if(FieldName.equals("itemid"))
			tempitemid = item.getString();
		else if(FieldName.equals("action"))
			action = item.getString();
		else if(FieldName.equals("globalid"))
			globalid = item.getString();
		

		//System.out.println(FieldName+":"+item.getString("utf-8"));
    } 
}
//System.out.println("globalid="+globalid);
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

Channel channel = CmsCache.getChannel(ChannelID);

String Path = "";
String SiteFolder = "";
String SiteUrl = "";
String RealPath = "";
Site site = null;


	Path = channel.getRealImageFolder();
	site = channel.getSite();
	SiteUrl = site.getUrl();

	
SiteFolder = site.getSiteFolder();

RealPath = "d:/web/tidecms_update/"+tempitemid+filepath;

File file = new File(RealPath);
if(!file.exists())
	file.mkdirs();
long filesize = file.length();
iter = items.iterator();
String FileName="";
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();
	
    if (!item.isFormField()) {
		
		String FieldName = item.getFieldName();
		FileName = item.getName();
		String FileExt = "";
		FileName = FileName.substring(FileName.lastIndexOf("\\")+1);
		
		int index = FileName.lastIndexOf(".");
		if(index!=-1)
		{
			FileExt = FileName.substring(index+1);
		}
		if(!FileName.equals(""))
		{
			
			CmsFile cmsfile = new CmsFile();
			String NewFileName = FileName;//cmsfile.getNewFileName(FileName,Path,userinfo_session.getId());
		    File uploadedFile = new File(RealPath + "/" +NewFileName);
		    item.write(uploadedFile);


				ReturnValue += Util.ClearPath(Path + "/" + NewFileName);
			
			
			//ReturnValue.replace("//","/");

			String FileFullPath = Util.ClearPath(SiteUrl + Path + "/" + NewFileName);

				if(Watermark.equals("Yes"))
				{
					String maskFile = defaultSite.getTemplateFolder() + "/watermask.png";
					File mfile = new File(maskFile);
					if(mfile.exists())
					{
					System.setProperty("jmagick.systemclassloader","no");
					ImageInfo imageinfo = new ImageInfo(RealPath + "/" + NewFileName);
					MagickImage mask = new MagickImage(new ImageInfo(maskFile));
					MagickImage image = new MagickImage(imageinfo);

					int w = image.getDimension().width;
					int h = image.getDimension().height;
					int w1 = mask.getDimension().width;
					int h1 = mask.getDimension().height;

					image.compositeImage(CompositeOperator.AtopCompositeOp,mask,w-10-w1,h-10-h1);
					image.writeImage(imageinfo);

					if (mask != null) mask.destroyImages(); 
					if (image != null) image.destroyImages(); 
					}
				}

				if(IsCompress==1 && (CompressWidth>0 || CompressHeight>0))
				{
					String compressFile = RealPath + "/" +NewFileName.replace(".","_s.");
					FileUtil.compressImage2IM(RealPath + "/" +NewFileName,compressFile,CompressWidth,CompressHeight,0);

					if(UseCompress==1)
					{
						uploadedFile.delete();
						NewFileName = NewFileName.replace(".","_s.");
					}
					else
					{
						ReturnValue2 = "parent.$('#" + fieldname2 + "_s" + "').val('" + Util.ClearPath(Path + "/" + NewFileName.replace(".","_s.")) + "');";
					}
				}
				ReturnValue = Util.ClearPath(NewFileName);
			

		}
//		}
    } 
}
if(action.equals("do_after_updated")){
DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
File file2=new File(RealPath+FileName);
filesize= file2.length();
long data = file2.lastModified();
UserInfo userinfo = userinfo_session;
int userid = userinfo.getId();
HashMap map = new HashMap();
map.put("Title",FileName);
map.put("folder",filepath);
map.put("file",FileName);
map.put("Parent",globalid);
map.put("User",userid+"");
map.put("filesize",filesize+"");
Channel channel2 = CmsCache.getChannel(5048);

TableUtil tu = new TableUtil();

String sql = "select * from "+channel2.getTableName()+" where file='"+FileName+"' and folder='"+filepath+"' and Active=1 and Parent='"+globalid+"'";

ItemUtil util = new ItemUtil();


ResultSet rs = tu.executeQuery(sql);
int gid=0;
if(rs.next()){
	gid = rs.getInt("GlobalID");
	util.updateItemByGid(5048, map, gid, 0);
	
	System.out.println("update");
}else{
	map.put("tidecms_addGlobal", "1");
	util.addItem(5048, map);
	
	System.out.println("add");
}
}

%>
<%if(Client.equals("editor")){%>
<script language=javascript>
var dialog		= window.parent ;
var oEditor		= dialog.InnerDialogLoaded() ;
var FCK			= oEditor.FCK ;//alert(FCK);
FCK.InsertHtml("<%=Util.JSQuote(ReturnValue)%>");
dialog.CloseDialog() ;
</script>
<%}else{%>
parent.getDialog().Close({close:function(){parent.$("#<%=fieldname2%>").val('<%=Util.JSQuote(ReturnValue)%>');<%=ReturnValue2%>}});
<%}%>
<%}else{%>
	alert('上传失败,请重试!');
<%}%>
