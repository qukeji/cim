<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
				tidemedia.cms.video.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*,
				java.text.*,
				java.util.*,
				java.io.File,
				java.net.URLDecoder"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%!
public String getParameter(HttpServletRequest request,String str)
	{
	if(request.getParameter(str)==null)
		return "";
	else
		return request.getParameter(str);
	}

public int getIntParameter(HttpServletRequest request,String str)
	{
		String tempstr = getParameter(request,str);
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

%>
<%
System.out.println("-----sns_upload_start-----");
request.setCharacterEncoding("utf-8");
String FolderName		= "";
String fieldname2		= "";
String ReturnValue		= "";
String ReturnValue2		= "";
String Type				= "";
String Watermark		= "";
String Client			= "";
String transcode_need	= "";//是否需要转码
String videotype2		= "";//不转码时对应的格式
int ChannelID			= 0;
int itemid				= 0;//文档编号
int globalid			= 0;
String videotype		= "";
String browser			= "";
String Username			= "";
String Password			= "";
boolean isCan			=true;

tidemedia.cms.system.Site defaultSite = tidemedia.cms.system.CmsCache.getDefaultSite();

String str =	getParameter(request,"str");
DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 	
int gid = 0;
String filepath = "";
String filesize_="";
String Title = "";
String Category="";
String video_source_folder="";

JSONObject jo = new JSONObject(str);
String uid = jo.getString("uid");
String username = jo.getString("username");
String PublishDate = jo.getString("PublishDate");
PublishDate = df.format(new java.util.Date(Long.parseLong(PublishDate)*1000));
String postip = jo.getString("postip");
Title = jo.getString("Title");
filepath = jo.getString("filepath");
filesize_ = jo.getString("filesize");
video_source_folder = jo.getString("video_source_folder");

HashMap map = new HashMap();
map.put("Title", Title);
map.put("uid", uid);
map.put("username", username);
map.put("PublishDate", PublishDate);
map.put("postip", postip);
map.put("filepath", filepath);
map.put("filesize", filesize_);
map.put("tidecms_addGlobal", "1");

ItemUtil util_ = new ItemUtil();
gid = util_.addItem(14216,map).getGlobalID();

ItemUtil util = new ItemUtil();
int transcode_channelid = CmsCache.getParameter("sys_channelid_transcode").getIntValue();	
String[] a = filepath.split("\\.");
String video_dest = a[0].substring(3, a[0].length())+"_2.mp4";

HashMap map2 = new HashMap();
map2.put("Title",Title);
map2.put("video_source",filepath);
map2.put("video_type","2");
map2.put("video_dest",video_dest);
map2.put("video_source_folder",video_source_folder);
map2.put("Parent",globalid+"");
map2.put("Status","1");
map2.put("Status2","0");

util.addItemGetID(transcode_channelid,map2);//转码频道
TranscodeManager tm = TranscodeManager.getInstance();
tm.Start();

TableUtil tu_sns = new TableUtil("sns");
String sql_sns = "update channel_channel_podcast set mp4='http://113.107.140.6:81"+video_dest+"' where GlobalID='"+gid+"'";
tu_sns.executeUpdate(sql_sns);

%>
