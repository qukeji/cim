<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				java.net.*,
				java.text.*,
				java.sql.*,
				java.util.*,
				java.io.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!


public static String postHttpUrl(String httpurl,String data,String token){
	String content = "";
	URL url;
	try {
	url = new URL(httpurl);
	java.net.HttpURLConnection connection = (java.net.HttpURLConnection) url.openConnection();
	connection.setDoOutput(true);
	connection.setUseCaches(false);
	if(token.length()>0)
	connection.addRequestProperty("Authorization", "Token " + token);
	
	connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
	connection.setRequestMethod("POST");
	connection.connect();
	OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream());

	out.write(data);
	out.flush();

	String sCurrentLine = "";

	java.io.InputStream l_urlStream = connection.getInputStream();
	java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream,"utf-8"));
	while ((sCurrentLine = l_reader.readLine()) != null)
	{
		content+=sCurrentLine;
	}

	//System.out.println(content);
	out.close();
	out = null;
	connection.disconnect();
	connection = null;
	} catch (MalformedURLException e) {
	System.out.println(e.getMessage());
	} catch (IOException e) {
	System.out.println(e.getMessage());
	}

	return content;
} 
 

	public static String timeStampDate(String timestampString){   
		  Long timestamp = Long.parseLong(timestampString);   
		  String date = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(timestamp));   
		  return date;
	}

%>



<%

	String api = "http://api.video.mywtv.cn/login";
	String data = "email=cms%40mywtv.cn&passwd=" + ("mywtv.cn");
	String content = postHttpUrl(api, data,"");
	//out.println(content);
	JSONObject json = new JSONObject(content);
	String token = (json.getString("token"));
	api = "http://api.video.mywtv.cn/getVideoById";
	


	//data = "videoId=87934948354293762";
	String videoId = getParameter(request,"videoId");
	data = "videoId=" +videoId;
	content = postHttpUrl(api, data,token);
	
	DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");			
    	//int channelid = CmsCache.getParameter("channleid_sx").getIntValue();
	int channelid = 13672;//测试频道id
   	String tablename = CmsCache.getChannel(channelid).getTableName();
	JSONObject jo = new JSONObject(content);
	String publisherId = jo.getString("publisherId");
	String managerId = jo.getString("managerId");
	String folderId = jo.getString("folderId");
	String title = jo.getString("title");
	String description = jo.getString("description");
	String status = jo.getString("status");
	Boolean deleted = jo.getBoolean("deleted");//ture
	Long fileSize = jo.getLong("fileSize");
	String width=jo.getString("width")+"";
	String height=jo.getString("height")+"";
	Long duration = jo.getLong("duration");
	int kbps=jo.getInt("kbps");
	int frameRate=jo.getInt("frameRate");
	int audioChannels=jo.getInt("audioChannels");
	int audioSampleRate=jo.getInt("audioSampleRate");
	String tags=jo.getString("tags");
	String videoKey = jo.getString("videoKey");
	String videoUrl = jo.getString("videoUrl");
	String thumbnailUrl = jo.getString("thumbnailUrl");
	String snapshotUrl = jo.getString("snapshotUrl");
	String coverUrl = jo.getString("coverUrl");
	String errorMessage = jo.getString("errorMessage");
	String snapshotGroupId = jo.getString("snapshotGroupId");
	String renditionGroupId = jo.getString("renditionGroupId");
	Boolean ipRestriction = jo.getBoolean("ipRestriction");//flase  怎么改？
	Boolean publicRestriction = jo.getBoolean("publicRestriction");//flase  怎么改？
	String fileType=jo.getString("fileType");
	String linkText=jo.getString("linkText");
	String linkUrl=jo.getString("linkUrl");
	String id=jo.getString("id");
	int version = jo.getInt("version");	
	Long creationTime=jo.getLong("creationTime");
	Long modifiedTime=jo.getLong("modifiedTime");
	//	out.print("---------id"+id);
	//	out.print("--------tablename:"+tablename);
	TableUtil tu = new TableUtil();
   	String sql = "select * from "+tablename+" where id_='"+id+"' and active=1";
   	ResultSet rs = tu.executeQuery(sql);
	//out.print("sql");
    if(rs.next()){
   	int itemid = rs.getInt("id");
  	TableUtil tu2 = new TableUtil();
   	String sql2 = "update "+tablename+" set";
   	sql2 +=" linkUrl='"+linkUrl+"',";
   	sql2 +=" errorMessage='"+errorMessage+"',";
	sql2 +=" publicRestriction='"+publicRestriction+"',";
    sql2 +=" renditionGroupId='"+renditionGroupId+"',";
    sql2 +=" version='"+version+"',";
    sql2 +=" folderId='"+folderId+"',";
    sql2 +=" id_='"+id+"',";
    sql2 +=" fileSize='"+fileSize+"',";
    sql2 +=" Title='"+title+"',";
    sql2 +=" kbps='"+kbps+"',";
    sql2 +=" linkText='"+linkText+"',";
    sql2 +=" height='"+Integer.parseInt(height)+"',";
    sql2 +=" description='"+description+"',";
    sql2 +=" Photo='"+thumbnailUrl+"',";
    sql2 +=" videoKey='"+videoKey+"',";
    sql2 +=" snapshotGroupId='"+snapshotGroupId+"',";
    sql2 +=" frameRate='"+frameRate+"',";
    sql2 +=" Tag='"+tags+"',";
    sql2 +=" fileType='"+fileType+"',";
    sql2 +=" publisherId='"+publisherId+"',";
    sql2 +=" coverUrl='"+coverUrl+"',";
    sql2 +=" status_='"+status+"',";
    sql2 +=" videoUrl='"+videoUrl+"',";
	sql2 +=" creationTime='"+timeStampDate(creationTime+"")+"',";
    sql2 +=" modifiedTime='"+timeStampDate(modifiedTime+"")+"',";
    sql2 +=" width='"+Integer.parseInt(width)+"',";
    sql2 +=" deleted='"+deleted+"',";
    sql2 +=" audioChannels='"+audioChannels+"',";
    sql2 +=" duration='"+duration+"',";
    sql2 +=" managerId='"+managerId+"',";
    sql2 +=" snapshotUrl='"+snapshotUrl+"',";
    sql2 +=" audioSampleRate='"+audioSampleRate+"',";
    sql2 +=" ipRestriction='"+ipRestriction+"'";
    sql2 +=" where id='"+itemid+"'";				
    tu2.executeUpdate(sql2);
				
//	out.print("修改成功");
    }else{			
    HashMap map = new HashMap();
    map.put("Title",title);				
    map.put("errorMessage",errorMessage);
    map.put("linkUrl",linkUrl);
    map.put("publicRestriction",publicRestriction+"");
    map.put("renditionGroupId",renditionGroupId);
    map.put("version",version+"");
    map.put("folderId",folderId); 					
    map.put("fileSize",fileSize+"");
    map.put("kbps",kbps+"");
    map.put("linkText",linkText);
    map.put("height",height);
    map.put("description",description);
    map.put("Photo",thumbnailUrl);
    map.put("videoKey",videoKey);
    map.put("snapshotGroupId",snapshotGroupId);
    map.put("frameRate",frameRate+"");
    map.put("Tag",tags);
    map.put("fileType",fileType);
    map.put("publisherId",publisherId);
    map.put("coverUrl",coverUrl);
    map.put("status_",status);
    map.put("videoUrl",videoUrl);
	map.put("creationTime",timeStampDate(creationTime+""));
    map.put("modifiedTime",timeStampDate(modifiedTime+""));
//	out.print("creationTime________"+creationTime);
//	out.print("-----:"+timeStampDate(creationTime+""));
    map.put("width",width);
    map.put("deleted",deleted+"");
    map.put("audioChannels",audioChannels+"");
    map.put("duration",duration+"");
    map.put("managerId",managerId);
    map.put("snapshotUrl",snapshotUrl);
    map.put("audioSampleRate",audioSampleRate+"");			
    map.put("ipRestriction",ipRestriction+"");		
    map.put("PublishDate",Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
	map.put("id_",id);
 //	map.put("tidecms_addGlobal","1");	
    ItemUtil util = new ItemUtil();
//	out.print("addItem前");
//	out.print(channelid);				
    util.addItem(channelid, map);				
//	out.print("添加成功");
    }
    tu.closeRs(rs);




%>
