<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
                tidemedia.cms.system.Document,
                tidemedia.cms.system.ItemUtil,
				java.util.*,
				java.io.*,
				java.text.SimpleDateFormat,
				java.util.Date,
                java.text.*,
				java.util.HashMap,
				org.json.JSONArray,
				org.json.JSONObject,
                                org.json.JSONException,
                                java.sql.SQLException,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="../config1.jsp"%>
<%!
	public int channelid=16740;
	public JSONObject getContent(int channelid,int parentid)throws MessageException, SQLException,JSONException{
		JSONObject json = new JSONObject();
		Document document = new Document(parentid);
		if(document==null){
			return null;
		}

		String t = CmsCache.getParameterValue("sys_config_photo");
		JSONObject ooo = new JSONObject(t);
		int id  = ooo.getInt("channelid");//获取图片库频道编号  
		Channel ch = CmsCache.getChannel(id);
		String siteFolder = ch.getSite().getSiteFolder();  
		String url=ch.getSite().getExternalUrl2();


		String Title =document.getTitle();
		String Photo =document.getValue("Photo");
		json.put("title",Title);
		json.put("id",parentid);
		json.put("photo",url + "/" + Photo);
		JSONArray array = new JSONArray();
		 ArrayList<Document> doclists = ItemUtil.listItems(channelid," where active=1 and Parent="+parentid+" and isBind=1");
		 for(Document doc:doclists){
			 JSONObject loc = new JSONObject();
			 String title= doc.getTitle();
			 int globalid= doc.getGlobalID();
			 String top =doc.getValue("toplength");
			 String bottom= doc.getValue("lowlength");
			 String left =doc.getValue("leftlength");
			 String right =doc.getValue("rightlength");
			 String href =doc.getHttpHref();
			 loc.put("title",title);
			 loc.put("id",globalid);
			 loc.put("top",top);
			 loc.put("bottom",bottom);
			 loc.put("left",left);
			 loc.put("right",right);
			 loc.put("href",href);
			 array.put(loc);
		 }
		 json.put("location",array);
		return json;		
	}
%>
<%
	
	int id = getIntParameter(request,"id");
	JSONObject content = new JSONObject();
	Document doc = new Document(id);
	if(doc==null||doc.getChannelID()!=16739){
		content.put("status",0);
		content.put("message","版面不存在");
		out.print(content);
		return;
	}
	
	JSONObject result = new JSONObject();
	result =getContent(channelid,id);
	if(result!=null){
		content.put("status",1);
		content.put("message","成功");
		content.put("result",result);
	}else{
		content.put("status",0);
		content.put("message","失败");
		content.put("result",result);
	}
	out.print(content);
%>
