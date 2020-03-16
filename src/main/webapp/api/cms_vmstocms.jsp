<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.report.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*,
				java.text.*,
				java.io.*,
				java.net.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
	public static String Token = "";
	public static int  vmsRootChannelID = 0;
	public static int  cmsRootChannelID = 0;
	public static String api_vms_getchannels="";
//	public static int PublishStatus=0;
	public static void sysInit()throws JSONException, MessageException, SQLException{
		TideJson json =  CmsCache.getParameter("sys_VmsToCms").getJson();
		Token = json.getString("Token");
		vmsRootChannelID = json.getInt("vmsRootChannelID");
		cmsRootChannelID = json.getInt("cmsRootChannelID");
		api_vms_getchannels = json.getString("api_vms_getchannels");
		//PublishStatus = json.getInt("PublishStatus");
	}
	public static void executeChannel(JSONObject jo, int cmsParent) throws Exception{
		//String  Extra1					= "";
		boolean hasSubChannel = false;
		int catalogId	= jo.getInt("id");//栏目id
		//Extra1 = "{vmsChannelID:\""+catalogId+"\"}";//拼凑extra1字符串
		JSONArray ja = jo.getJSONArray("subchannel");
		if(ja.length()>0){
			hasSubChannel = true;
		}
		//String isLeaf	= item.elementText("isLeaf");//是否为子节点
		//String name	= item.elementText("name");//名字
		int vmsChannelID = 0;
		String vmsChannelName = "";
		vmsChannelID = jo.getInt("id");
		vmsChannelName = jo.getString("name");
		int PID =getCmsChannelIDbyVmsChannelID(catalogId);
		//System.out.println("catalogId="+catalogId+",PID="+PID+",cmsParent="+cmsParent);
		int newChannelID = 0;
		if(PID==0){
			System.out.println("jo="+jo+",cmsParent="+cmsParent);
			newChannelID=addChannel(jo,cmsParent);
			PID = newChannelID;
		}else if(PID>0){
			Channel channel = CmsCache.getChannel(PID);
			if(!channel.getName().equals(vmsChannelName))
			{
				channel.setName(vmsChannelName);
				channel.Update();
				CmsCache.delChannel(channel.getId());
			}
		}
		
		if(hasSubChannel&&PID>0){//有子频道的 遍历
			for(int i=0;i<ja.length();i++){
				executeChannel(ja.getJSONObject(i),PID);
			}
		}
	}
	private static int addChannel(JSONObject jo, int cmsParent) throws JSONException, MessageException, SQLException {
		// TODO Auto-generated method stub

		//System.out.println("jo="+jo.toString());
		int vmsChannelID = jo.getInt("id");
		String Extra1 = "{\"vmsChannelID\":"+vmsChannelID+"}";
		String vmsChannelName = jo.getString("name");
		Channel parent = CmsCache.getChannel(cmsParent);
		Channel channel = new Channel();

		channel.setName(vmsChannelName);
		channel.setParent(cmsParent);
		//channel.setFolderName(p.getFolderName());
		channel.setImageFolderName(parent.getImageFolderName());
		
		String serialno = parent.getAutoSerialNo();
		int i = serialno.lastIndexOf("_");
		String foldername = serialno.substring(i+1);
		
		channel.setSerialNo(serialno);
		channel.setFolderName(foldername);
		channel.setIsDisplay(1);

		channel.setType(1);
		channel.setHref(parent.getHref());
		channel.setAttribute1("");
		channel.setAttribute2("");
		channel.setRecommendOut(parent.getRecommendOut());
		channel.setRecommendOutRelation(parent.getRecommendOutRelation());
		channel.setExtra1(Extra1);
		channel.setExtra2("");
		channel.setListJS(parent.getListJS());
		channel.setDocumentJS(parent.getDocumentJS());
		channel.setListProgram(parent.getListProgram());
		channel.setDocumentProgram(parent.getDocumentProgram());
		channel.setTemplateInherit(1);
		channel.setActionUser(0);
		channel.Add();
		
		int channelid = channel.getId();
		return channelid;
	}
	private static int getCmsChannelIDbyVmsChannelID(int vmsParent) throws MessageException, SQLException {
		// TODO Auto-generated method stub
		Channel ch = CmsCache.getChannel(cmsRootChannelID);
		String sql = "";
		sql = "select id from channel where ChannelCode like '"+ch.getChannelCode()+"%' and Extra1 like '%\"vmsChannelID\":"+vmsParent+"%'";
		TableUtil tu = ch.getTableUtil();
		ResultSet rs = tu.executeQuery(sql);
		int id=0;
		if(rs.next()){
			id = rs.getInt("id");
		}
		tu.closeRs(rs);
		return id;
	}
	//根据vmsGlobalID，查询cms中是否有该 文档信息，如果有，则返回cms中GlobalID，如不存在 返回0
	private static int getActiveStatusbyVmsGlobalID(int vmsGlobalID) throws MessageException, SQLException {
		// TODO Auto-generated method stub
		Channel ch = CmsCache.getChannel(cmsRootChannelID);
		String tablename = ch.getTableName();
		String sql = "";
		
		sql = "select * from "+tablename+" where vmsGlobalID="+vmsGlobalID+" and Active=1";
		System.out.println(sql);
		TableUtil tu = ch.getTableUtil();
		ResultSet rs = tu.executeQuery(sql);
		int id=0;
		if(rs.next()){
			id = rs.getInt("GlobalID");
		}
		tu.closeRs(rs);
		return id;
	}
public static String postHttpUrl(String httpurl,String data)
	{
		String content = "";
		URL url;
		try {
			url = new URL(httpurl);
			java.net.HttpURLConnection connection = (java.net.HttpURLConnection) url.openConnection();
			connection.setDoOutput(true);  
			connection.setUseCaches(false);
			connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded");  
			connection.setRequestMethod("POST");
			connection.connect();
			OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream());
			
			out.write(data);
			out.flush();
			
			String sCurrentLine = "";
			
			java.io.InputStream l_urlStream = connection.getInputStream(); 
			java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream,"UTF-8")); 
			while ((sCurrentLine = l_reader.readLine()) != null) 
			{
				content+=sCurrentLine; 
			}		
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
%>
<%
	System.out.println(" vms/api/cms_vmstocms.jsp      test");
	sysInit();
	JSONObject o = new JSONObject();
	String Action = getParameter(request,"Action");
	if(Action.equals("")){
		o.put("message","Action 不能为空");
		o.put("status",0);
	}else if(Action.equals("getChannelID")){
		int vmsChannelID = getIntParameter(request,"vmsChannelID");
		if(vmsChannelID>0){
			int res=getCmsChannelIDbyVmsChannelID(vmsChannelID);
			o.put("ChannelID",res);
			o.put("status",1);
		}else{
			o.put("message","vmsChannelID必须大约0");
			o.put("status",0);
		}
	}else if(Action.equals("syncChannel")){
		String data = "";
		data = "Token="+Token +"&id="+vmsRootChannelID;
		System.out.println("url==syncChannel================"+api_vms_getchannels+"?"+data);
		//String content = Util.connectHttpUrl(api_vms_getchannels+"?"+data).trim();
		String content =  postHttpUrl(api_vms_getchannels,data).trim();
		//content = content.replace(" ","").trim();
		System.out.println(content);
		JSONArray ja = new JSONArray(content);
		for(int i=0;i<ja.length();i++){
			JSONObject jo = ja.getJSONObject(i);
			executeChannel(jo,cmsRootChannelID);
			//System.out.println(jo.get("id"));
			o.put("message","同步频道完成");
			o.put("status",1);
		}
	}else if(Action.equals("docIsExist")){
		int vmsGlobalID = getIntParameter(request,"vmsGlobalID");
		if(vmsGlobalID>0){
			int res2=getActiveStatusbyVmsGlobalID(vmsGlobalID);
			//o.put("ChannelID",res);
			o.put("id",res2);
			o.put("status",1);
		}else{
			o.put("message","vmsGlobalID必须大约0");
			o.put("status",0);
		}
	}else {
		o.put("message","未知Action");
		o.put("status",0);
	}
	out.println(o);
	
%>