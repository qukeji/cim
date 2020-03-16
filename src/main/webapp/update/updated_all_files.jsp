<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.net.*,
				java.text.*,
				java.io.*,
				org.json.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
public Long copyFile(String src, String des) throws FileNotFoundException
	  {
		  Long filelength=(long)0;
	  	FileInputStream FIS = new FileInputStream(src);
		FileOutputStream FOS = new FileOutputStream(des);
	    try
	    {

	      byte[] bt = new byte[1024];
	      int readNum = 0;
	      while ((readNum = FIS.read(bt)) != -1)
	      {
	        FOS.write(bt, 0, readNum);
	      }
	      FIS.close();
	      FOS.close();
	    }
	    catch (Exception e)
	    {
	    }

		File file =new File(src);
		filelength = file.length();
		return filelength;
	  }
%>
<%
	UserInfo userinfo = userinfo_session;
	String username=userinfo.getName();
	int userid = userinfo.getId();
	//out.println("username="+username);
	int channelid_file  =5048;
	Channel channel = CmsCache.getChannel(channelid_file);
	int total_file=0;
	int total_floder=0;
	int total_update=0;
	String site="d:\\web\\tidecms_update";
	String path_all=getParameter(request,"path");
	int itemid=getIntParameter(request,"itemid");
	int globalid=getIntParameter(request,"globalid");
	//out.println("globalid="+globalid);
	path_all=path_all.replace("/","\\");
	//out.println("path_all="+path_all+"    itemid="+itemid);
	String cmsPath=request.getSession().getServletContext().getRealPath("");
	//out.println("cmsPath="+cmsPath);
	String items[]=path_all.split(",");
	String onefilefrom="";
	String onefileto="";
	String filepath="";
	String filepathto="";
	String []onefilefloder=new String[2];

	TableUtil tu = new TableUtil();
	ItemUtil util = new ItemUtil();
	HashMap map =new HashMap();
	int gid=0;
	for(int i=0;i<items.length;i++){
		File file = new File(cmsPath+items[i]);
		if(file.isFile()){
			onefilefrom=cmsPath+items[i];
			onefileto=site+"\\"+itemid+items[i];
			filepath = onefilefrom.substring(0,onefilefrom.lastIndexOf("\\"));
			filepathto = onefileto.substring(0,onefileto.lastIndexOf("\\"));
			File onefile = new File(filepath+"\\");
			//out.println("filepath="+filepath);
			if(onefile.isDirectory()){
				//out.println("是文件夹");
				File onefile_=new File(filepathto);
				//out.println("filepathto="+filepathto);
				if(!onefile_.exists()){
					//out.println("文件夹不存在");
					onefile_.mkdirs();
					total_floder++;
					//out.println("创建文件夹");
				}else if(onefile_.exists()){
					//out.println("文件夹，filepathto="+filepathto+"存在");
				}
			}else if( onefile.isFile()){
				//out.println("是文件");
			}
			Long filesize=copyFile(onefilefrom,onefileto);
			
			//out.println("filelength="+filelength);
			
			//out.println("items[i]="+items[i]);
			String path=items[i].substring(0,items[i].lastIndexOf("\\")+1);
			path=path.replace("\\","/");
			//out.println("path="+path);
			String filename =items[i].substring(items[i].lastIndexOf("\\")+1);
			
			String PublishDate = Util.getCurrentDate("yyyy-MM-dd HH:mm:ss");
			
			map.put("Title",filename);
			map.put("PublishDate",PublishDate);
			map.put("folder",path);
			map.put("file",filename);
			map.put("filesize",filesize+"");
			map.put("tidecms_addGlobal", "1");
			map.put("User",userid+"");
			map.put("Parent",globalid+"");
			//out.println("userid="+userid);
			//out.println(filename+PublishDate+path+filename+filesize);

			String sql = "select * from "+channel.getTableName()+" where file='"+filename+"' and folder='"+path+"' and Active=1";
			//out.println("sql="+sql);
			ResultSet rs = tu.executeQuery(sql);
			if(rs.next()){
				gid = rs.getInt("GlobalID");
				util.updateItemByGid(channelid_file, map, gid, 0);
				total_update++;
				//out.println("update");
			}else{
				util.addItem(channelid_file, map);
				total_file++;
				//out.println("add");
			}
			//map.put("tidecms_addGlobal", "1");
			//out.println("filename="+filename+"    path="+path);
			
			//out.println("items[i]="+items[i]);
			//out.println("from="+onefilefrom+"    to="+onefileto+"    filepath="+filepath);
			
		}else if(file.isDirectory()){
			File onefile = new File(site+"\\"+itemid+items[i]);
			if(!onefile.exists()){
				onefile.mkdirs();
				total_floder++;
			}
			//out.println("it is dir,path="+site+"\\"+itemid+items[i]);
		}else {
			//out.println("the path is not a file or dir,path="+cmsPath+items[i]);
		}
	}

	out.println("共添加了，"+total_file+"个文件，更新了"+total_update+"个文件，添加了"+total_floder+"个文件夹");

%>