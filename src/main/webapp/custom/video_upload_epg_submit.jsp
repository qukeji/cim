<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.TableUtil,tidemedia.cms.publish.*,tidemedia.cms.video.*,org.json.JSONArray,org.json.JSONObject,java.sql.*,java.util.*,magick.*,java.io.File,java.io.*,java.net.URLDecoder,java.util.Date,java.text.*,org.apache.commons.fileupload.*,com.tidemedia.auto.encode.*"%>
<%@ page contentType="text/html;charset=utf8" %>

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
int itemid				=0;//文档编号
String colunm_name		= "";



String browser			= "";
String Username			= "";
String Password			= "";
boolean isCan			=false;

tidemedia.cms.system.Site defaultSite1 = tidemedia.cms.system.CmsCache.getDefaultSite();
//request.setCharacterEncoding("gbk");
tempPath = request.getRealPath("/temp");

upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);
upload.setHeaderEncoding("UTF-8");
List items = new ArrayList();;

try{
	

	 items = upload.parseRequest(request);

	java.util.Iterator iter = items.iterator();
	while (iter.hasNext()) {
		FileItem item = (FileItem) iter.next();

		if (item.isFormField()) {
	
			String FieldName = item.getFieldName();
			//System.out.println(FieldName)
			if(FieldName.equals("ChannelID"))
				ChannelID = getIntParameter(item.getString());
			else if(FieldName.equals("Type"))
				Type = getParameter(item.getString());
			else if(FieldName.equals("Watermark"))
				Watermark = getParameter(item.getString());
			else if(FieldName.equals("itemid"))
				itemid = getIntParameter(item.getString());
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
			//else if(FieldName.equals("colunm_name"))
			//colunm_name = URLDecoder.decode(item.getString(), "UTF-8");
	//System.out.println("epg ------------colunm_name----"+colunm_name);
		} 

	}
}
catch(org.apache.commons.fileupload.FileUploadException e){}

tidemedia.cms.user.UserInfo userinfo_session1 = new tidemedia.cms.user.UserInfo();
if(browser.equals("msie")){

	if(session.getAttribute("CMSUserInfo")!=null)
	{
		userinfo_session1 = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
	}
	if(userinfo_session1!=null && userinfo_session1.getId()!=0)
	{

		isCan=true;
	}
}else if(browser.equals("mozilla")){
	TableUtil tu=new TableUtil();
	String Sql = "select * from userinfo where Username='" +tu.SQLQuote(Username) + "' and Password='" +tu.SQLQuote(Password) + "'";
	ResultSet Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		userinfo_session1.setId(Rs.getInt("id"));

		isCan=true;
	}
	tu.closeRs(Rs);
}

 
String Photo = "";
//int transcode_channelid = CmsCache.getParameter("sys_channelid_transcode").getIntValue();
//int video_channelid = CmsCache.getParameter("sys_channelid_video").getIntValue();

if(isCan){

	//int channelid = CmsCache.getParameter("channelid_jiemudan").getIntValue();

	//int channelid = getIntParameter(request,"channelid");


	int channelid = Integer.parseInt(CmsCache.getParameterValue("channelid_jiemudan"));
	//System.out.println("-------jin-------"+channelid);

	Channel channel = CmsCache.getChannel(channelid);
	String channelname = channel.getTableName();
	String Path = "/test/cvs/";
	String SiteFolder = channel.getSite().getSiteFolder();
	//String SiteFolder ="/cms/custom/";
	//String Path="epg/";
	String RealPath = SiteFolder + (SiteFolder.endsWith("/")?"":"/") + Path;
	//System.out.println("RealPath:"+RealPath);
	File file = new File(RealPath);

	if(!file.exists())
			file.mkdirs();

	java.util.Iterator iter2 = items.iterator();
	while (iter2.hasNext()) {
		FileItem item = (FileItem) iter2.next();

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

				CmsFile cmsfile = new CmsFile();
				String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session1.getId());
				File uploadedFile = new File(RealPath + "/" +NewFileName);
				item.write(uploadedFile);
				ReturnValue = Util.ClearPath(Path + "/" + NewFileName);
				int m = ReturnValue.lastIndexOf(".");

				String FileFullPath = Util.ClearPath(channel.getSite().getSiteFolder() + Path + "/" + NewFileName);

				/***********************节目单导入******************/
					int channelid2 = channelid;


			String argPath = FileFullPath;
			//File cvsFile = new File(argPath);
			FileReader fileReader = null;
			InputStreamReader inputread=null;
			BufferedReader bufferedReader = null;
			BytesEncodingDetect s = new BytesEncodingDetect(); 
			String file1Code = BytesEncodingDetect.nicename[s.detectEncoding(new File(argPath))];
			String myCode = file1Code!=null&&!"".equals(file1Code) ? file1Code : "utf8"; 
			//System.out.println("mycode----"+myCode);
			if(myCode.equals("GB2312")){
				myCode = "GBK";
			}
			try {
					inputread = new InputStreamReader(new FileInputStream(  
							argPath), myCode); 
					//    fr = new BufferedReader(read);  
					//fileReader = new FileReader(cvsFile);
					bufferedReader = new BufferedReader(inputread);

					// test
				   // System.out.println(regExp);
					String strLine = "";
					String str = "";   
					int line = 0;
					List list = new ArrayList();
					List list2 = new ArrayList();
					List list3 = new ArrayList();
			 
					String liveid="";
					String dianshitai="";
					String column_name="";
					String jm_title = "";
					String date_time = "";
					while ((strLine = bufferedReader.readLine()) != null) {
					//	strLine = new String(strLine.getBytes("ISO-8859-1"), "UTF-8");
						line ++;
						if(line==1){
							dianshitai = strLine.split(",")[1];
							//System.out.println("dianshitai:"+dianshitai);
						}
						if(line==2){
							column_name = strLine.split(",")[1];
							//System.out.println("column_name:"+column_name);
						}
						if(line==3){
							liveid = strLine.split(",")[1];
							 System.out.println("liveid:"+liveid);
						}
						if(line ==4){
							date_time = strLine.split(",")[1];
							String y = date_time.split("/")[2];
							String mm = date_time.split("/")[0];
							String d = date_time.split("/")[1];
							date_time = y+"/"+mm+"/"+d;	
						}
						if(line>5)
						{      
							strLine = strLine.replaceFirst("'", "‘");
							strLine = strLine.replace("'", "’");
							strLine = strLine.replace("_", "");
							strLine = strLine.replace(",","_,");
							 System.out.println("strLine:---"+strLine);
							list.add(strLine);
							list2.add(strLine);
							
						}  
					}   
					List list4 = new ArrayList();
					int[] array = new int[list2.size()];

					for (int i = 0; i < list2.size(); i++) {
						String str2 = ((String) list2.get(i)).split("_,")[0];
						int h = Integer.parseInt(str2.split(":")[0]);
						int mmm = Integer.parseInt(str2.split(":")[1]);
						int second = Integer.parseInt(str2.split(":")[2]);
						int min = h * 60*60 + mmm*60+second;
						String timeinfo = min + "__" + str2;
						array[i] = min;
					}
					Arrays.sort(array);
					for (int i = 0; i < array.length; i++) {
						int t = array[i];
						int h2 = t/3600;
						int m2 = t%3600/60;
						int s2 = t%3600%60;
						String time2 = "";
						if(m2<10){
						  time2 = h2+":0"+m2;
						}else{
						  time2 = h2+":"+m2;
						}
						 if(s2<10){
							time2 = time2+":0"+s2;
						}else{
							time2 = time2+":"+s2;
						}
						for(int k = 0; k<list2.size() ; k++){
							String str4 = (String) list2.get(k);
								//System.out.println(str4+"=indexof=="+time2);
							if(str4.indexOf(time2)==0){
								list4.add(str4);
							}
						}
					}
					list=list4;
					list2 = list4;
					DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					DateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
					String flag_date = format2.format(new Date(date_time));
					for(int i = 0 ;i < list2.size() ; i ++){
						String str2 = (String) list2.get(i);
						String starttime="";
						for(int k = 0 ; k < list.size() ; k ++){
							String str3 ="";
							if(i<list.size()-1){
								str3 = (String)list.get(i+1);
								String date_time_time = date_time+" "+str3.split("_,")[0];
								starttime  = format.format(new Date(date_time_time));
								long length = 0;
							}
						}
						if(i<list2.size()-1){
							String s_0 = str2.split("_,")[0];
							String stime1 = date_time+" "+s_0;
							stime1 = format.format(new Date(stime1));
							str2 = str2.replace(s_0, stime1+"_,"+starttime);
						}
						if(i == list2.size()-1){
							String s_1 = str2.split("_,")[0];
							String stime2 = date_time+" "+s_1;
							stime2 = format.format(new Date(stime2));
							str2 = str2.replace(str2.split("_,")[0], stime2+"_,");
						}
						System.out.println("before replace:"+str2);
						str2 = str2.replace("_", "");
						System.out.println("after replace:"+str2);
						list3.add(str2+"_");
						
					}
					System.out.println("list3_size:"+list3.size());
					//先删除 后增加
					//判断电视台（dianshitai）是否对应
					ArrayList channels = channel.listSubChannels();
					for(int i = 0;i<channels.size();i++){
						Channel ca = (Channel)channels.get(i);
						String dst = ca.getName();
						
						ArrayList channels_3 = ca.listSubChannels();
						if(dst.equals(dianshitai)){
						//System.out.println("电视台：-----"+dst);
						//System.out.println("dianshitai-----"+dianshitai);
							for(int k = 0;k<channels_3.size();k++){
								Channel cb = (Channel)channels_3.get(k);
								if((cb.getName()).equals(column_name)){
									String channelname_ = cb.getTableName();
									int channelid_ = cb.getId();
									TableUtil tu_ = new TableUtil();
									String sql_ = "delete from "+channelname_+" where Category="+channelid_+" and Status=1 and  column_name='"+column_name+"' and dianshitai='"+dianshitai+"' and start_time like '"+flag_date+"%'" ;

									tu_.executeUpdate(sql_);
								 System.out.println("channel_table:"+channelname_);
									for(int j = 0 ; j < list3.size() ; j ++){
										
										String outString = (String)list3.get(j);
										System.out.println("outString"+j+":"+outString);
										try {
											String temp = new  String(outString.getBytes(), "utf-8");
											String fullString = outString;
											String[] simpleString = fullString.split(",");
											String start_time = simpleString[0];
											String end_time = simpleString[1];
											String proname = simpleString[2];
											
											String protype = simpleString[3];
											String copyright = simpleString[4];
											String operation = simpleString[5];
											String description = simpleString[6];
											System.out.println(protype+"---"+copyright+"---"+operation+"---"+description);
											if(description.indexOf("_")>=0){
												description = description.replace("_","");
											}
											HashMap map = new HashMap();
											map.put("Title",proname.trim());
											map.put("PublishDate",format.format(new Date()));
											//map.put("Parent",GlobalID+"");
											map.put("start_time",start_time);
											if(j==list3.size()-1){
												map.put("end_time",flag_date+" 23:59:00");
											}else{
												map.put("end_time",end_time);
											}
											map.put("protype",protype);
											map.put("copyright",copyright.trim());
											map.put("operation",operation.trim());
											map.put("description",description.trim());
											
											map.put("column_name",column_name.trim());
											map.put("dianshitai",dianshitai.trim());
											map.put("liveid",liveid+"");
											map.put("Status","1");
											map.put("User",userinfo_session1.getId()+"");
											//System.out.println("channelcode:"+cb.getChannelCode());
											map.put("Category",channelid_+"");
											//map.put("tidecms_addGlobal","1");
											ItemUtil util_ = new ItemUtil();
											util_.addItem(channelid_,map);
											 
											
										} catch (UnsupportedEncodingException e) {
										 
											// TODO Auto-generated catch block
											e.printStackTrace();
										}
									}
								 
									int parent = CmsCache.getChannel(channelid_).getParent();
									int parentID = CmsCache.getChannel(parent).getParent();
								 	System.out.println(parent+"=="+parentID);
									PublishManager publishmanager = PublishManager.getInstance();
									publishmanager.ChannelPublish(parentID,0,userinfo_session1.getId(),0);
									System.out.println(channelid_+"----");
								}
							}
						}
					}
					
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} 	 
			} 

		}
	}
	//删除20天之前的数据 24*3600*20=1728000, channelname为节目单的tablename
	TableUtil tu_delete = new TableUtil();
	String sql_delete = "delete from "+channelname+" where CreateDate<(unix_timestamp(now())-1728000)";
	//System.out.println(sql_delete);
	tu_delete.executeUpdate(sql_delete);	
}
%>
top.TideDialogClose({refresh:'right'});
