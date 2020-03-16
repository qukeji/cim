package tidemedia.cms.system;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.util.FileUtil;
import tidemedia.cms.util.TideJson;
import tidemedia.cms.util.Util;
import tidemedia.cms.base.TableUtil;

/**
 * @author 李永海(yonghai2008@gmail.com)
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class CmsFile extends Table{

	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public CmsFile() throws MessageException, SQLException {
		super();
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canAdd()
	 */
	public boolean canAdd() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canUpdate()
	 */
	public boolean canUpdate() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canDelete()
	 */
	public boolean canDelete() {
		return false;
	}

	public String getNewFileName(String filename,String folder,int userid) throws SQLException, MessageException
	{
		String NewFileName = "";
		String FileExt = "";
		
		if(filename.lastIndexOf(".")!=-1)
			FileExt = filename.substring(filename.lastIndexOf("."));
		
		java.util.Calendar nowDate = new java.util.GregorianCalendar();
		int year = nowDate.get(Calendar.YEAR);
		int month = nowDate.get(Calendar.MONTH) + 1;
		int day = nowDate.get(Calendar.DATE);
		NewFileName = year+""+month+""+day;
		NewFileName += nowDate.getTimeInMillis();
		NewFileName += "_" + userid;
		NewFileName += FileExt;
		
		String Sql = "";
		
		Sql = "select * from files_info where Name='" + SQLQuote(NewFileName) + "'";
		
		if(isExist(Sql))
		{
			return getNewFileName(filename,folder,userid);
		}
		
		Sql = "insert files_info(OriginalName,Name,Folder,User,CreateDate";
		Sql += ") values(";
		Sql += "'" + SQLQuote(filename) + "'";
		Sql += ",'" + SQLQuote(NewFileName) + "'";
		Sql += ",'" + SQLQuote(folder) + "'";
		Sql += "," + userid;
		Sql += ",now()";
		
		Sql += ")";
		
		executeUpdate(Sql);
		
		return NewFileName;
	}
	
	public String getNewFileName(String filename,String folder,int userid,int channelid) throws SQLException, MessageException
	{
		String NewFileName = "";
		String FileExt = "";
		
		if(filename.lastIndexOf(".")!=-1)
			FileExt = filename.substring(filename.lastIndexOf("."));
		
		java.util.Calendar nowDate = new java.util.GregorianCalendar();
		int year = nowDate.get(Calendar.YEAR);
		int month = nowDate.get(Calendar.MONTH) + 1;
		int day = nowDate.get(Calendar.DATE);
		NewFileName = year+""+month+""+day;
		NewFileName += nowDate.getTimeInMillis();
		NewFileName += "_" + userid;
		NewFileName += FileExt;
		
		String Sql = "";
		
		Sql = "select * from files_info where Name='" + SQLQuote(NewFileName) + "'";
		
		if(isExist(Sql))
		{
			return getNewFileName(filename,folder,userid);
		}
		
		Sql = "insert files_info(OriginalName,Name,Folder,User,CreateDate,ChannelID";
		Sql += ") values(";
		Sql += "'" + SQLQuote(filename) + "'";
		Sql += ",'" + SQLQuote(NewFileName) + "'";
		Sql += ",'" + SQLQuote(folder) + "'";
		Sql += "," + userid;
		Sql += ",now()";
		Sql +=","+channelid;
		Sql += ")";
		
		executeUpdate(Sql);
		
		return NewFileName;
	}
	
	public String listFile_JS(String parent) throws SQLException,MessageException, UnsupportedEncodingException 
	{
		TableUtil tu = new TableUtil();
		String js = "";

		int sitenumber = 0;
		String icon = "../images/tree/16_channel_site_icon.png";
		
		String sql = "select count(*) from channel where Parent=-1 and Type=5";
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next())
			sitenumber = rs.getInt(1);
		tu.closeRs(rs);
		
		sql = "select Site from channel where Parent=-1 and Type=5 order by OrderNumber,id";

		rs = executeQuery(sql);
		while (rs.next()) 
		{
			int SiteId=rs.getInt("Site");
			//System.out.println("SiteID:"+SiteId);
			Site site=CmsCache.getSite(SiteId);
			//System.out.println("name:"+site.getName());
		    if(site!=null)
		    {

				String Name = Util.JSQuote(convertNull(site.getName()));
				if (sitenumber == 1) {
					js += "var varName=new WebFXTreeItem(\"" + Name + "\",";
					js += ("\"javascript:ListFile('\')\\\" ChannelType=5 FolderName=\\\\  SiteId="
							+ SiteId + "  \",\"\",");
					js += ("\"" + icon + "\",");
					js += ("\"" + icon + "\");\r\n");

					// String
					// RealPath=Util.JSQuote(convertNull(site.getSiteFolder()));
					// System.out.println("RealPath:"+RealPath);
					File file = new File(site.getSiteFolder());
					File[] files = file.listFiles();
					Arrays.sort(files);// 按文件名排序

					if (files != null) {
						for (int i = 0; i < files.length; i++) {
							String FolderName = Util.JSQuote(files[i].getName());

							if (files[i].isDirectory()
									&& !files[i].getName().equals("cms")
									&& !(files[i].getName().equalsIgnoreCase("WEB-INF"))) {
								if (Util.isHasSubFolder(site.getSiteFolder() + "/" + FolderName)) {
									String Path = Util.JSQuote(java.net.URLEncoder.encode(FolderName, "utf-8"));
									js += ("var folder=new WebFXLoadTreeItem(\""
											+ FolderName + "\",");
									js += ("\"folder_xml.jsp?Path=" + Path
											+ "&SiteId=" + SiteId + "\",");
									js += ("\"javascript:ListFile('"
											+ FolderName + "')\\\" FolderName="
											+ FolderName + "  SiteId=" + SiteId + "  \");\r\n");
									js += (" varName.add(folder);\r\n");
								} else {
									js += ("var folder=new WebFXTreeItem(\""
											+ FolderName + "\",");
									js += ("\"javascript:ListFile('"
											+ FolderName
											+ "')\\\"  FolderName="
											+ FolderName + "  SiteId=" + SiteId + " \");\r\n");
									js += (" varName.add(folder);\r\n");
								}
							}
						}
					}// end if(files!=null)
		      }
			  else
			  {
		  	  		js += "var varName=new WebFXLoadTreeItem(\""+Name+"\",";
		  	  		js += "\"folder_xml.jsp?Path=/&SiteId="+SiteId+"\",";
		  	  	    js += "\"javascript:ListFile('/')\\\" ChannelType=5 FolderName=/  SiteId="+SiteId+"  \",\"\",";
				    js += "\""+icon+"\",";
				    js += "\""+icon+"\");\r\n";
				    //);\r\n");
			   }
		      
		      js += (parent+".add(varName);\r\n");
		    }

		
		}
		//System.out.println(js);
		tu.closeRs(rs);
		return js;
	}
	
	//把图片插入图片库
	//title 标题 ImgPath 图片路径，相对路径，比如/image/2015-6-16/a.jpg
	//返回值 1 成功 0 图片库没配置 -1 图片文件不存在 compress 是否需要压缩
	public int addImgToLibrary(String Title,String ImgPath,boolean compress) throws MessageException, SQLException
	{
		TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
		if(photo_config==null)
		{
			Log.SystemLog("图片库", "图片及图片库没有配置，请联系系统管理员.");
			return 0;
		}
			
		int sys_channelid_image = photo_config.getInt("channelid");
		
		Channel channel = CmsCache.getChannel(sys_channelid_image);
		Site site = channel.getSite();
		
		String FileExt = Util.getFileExt(ImgPath);//文件扩展名
		String real_path = site.getSiteFolder() + ImgPath;
		File file_img = new File(real_path);
		if(!file_img.exists())
		{
			return -1;
		}
		
		//优化图片文件
		FileUtil.optimizeImage(real_path);
		long Filesize = file_img.length();
		
		HashMap map = new HashMap();
		map.put("Title",Title);
		map.put("Status","1");		

		map.put("Photo",site.getExternalUrl()+ImgPath);
		map.put("Filesize",Filesize+"");
		
		if(compress){//需要压缩
		try {
			JSONArray ImageLibrary = photo_config.getJSONArray("ImageLibrary");
			for(int i =0;i<ImageLibrary.length();i++)
			{
				JSONObject oo;
				
				oo = ImageLibrary.getJSONObject(i);
	
				//System.out.println(oo.getString("field"));
				String field = oo.getString("field");
				int width = oo.getInt("width");
				int height = oo.getInt("height");
				
				String mark = "";
				if(field.equals("Field")) mark = "p";
				if(field.equals("Field_wap")) mark = "w";
				if(field.equals("Field_app")) mark = "a";
				
				if(mark.length()>0 && (width>0 || height>0))
				{
					//需要压缩
					String ImgPath_ = ImgPath.replace("."+FileExt, "."+mark);
					String compressFile1 = site.getSiteFolder() + ImgPath_;
					FileUtil.compressImage2IM(real_path,compressFile1,width,height,1);
					map.put(field,site.getExternalUrl()+ImgPath_);
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		}

		ItemUtil.addItemGetNull(sys_channelid_image,map);
		
		return 1;
	}
}
