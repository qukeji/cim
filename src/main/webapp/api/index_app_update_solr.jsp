<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.util.*,java.net.*,java.io.*,
				java.sql.*,java.util.*,
				java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
	public long parse(String s)
	{
		if(s==null||"".equals(s))
				return 0;
		else
			return Long.parseLong(s);
	}
	public String format(String patter,String date)
	{
	if("".equals(date))return "";
	SimpleDateFormat dateFormat = new SimpleDateFormat(patter); 
	return dateFormat.format(parse(date)*1000);
	}
%>
<%
	int globalid = getIntParameter(request,"globalid");//文章编号
	System.out.println("文章编号："+globalid);
	int sys_photo_channelid=0;
	TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
	sys_photo_channelid = photo_config.getInt("channelid");
	Document doc = new Document(globalid);
	String xml = "";
	if(doc.getStatus()==1&&doc.getIntValue("Parent")==0&&doc.getIntValue("juxian_liveid")==0&&doc.getIntValue("item_type")!=4&&doc.getIntValue("item_type")!=6&&doc.getIntValue("doc_type")!=6)
	{ 

			int showcomment=0;
			int showread=0;
			int allowcomment=0;
			int showtime=0;
			int showtype=0;
		
		Channel channel=doc.getChannel();
		String channelcode=channel.getChannelCode();
		TableUtil tu=new TableUtil();
		String sql="select showcomment,showread,allowcomment,showtime,showtype from channel_s"+doc.getChannel().getSite().getId()+"_config where active=1 ";
		ResultSet rs=tu.executeQuery(sql);
		if(rs.next()){
			showcomment=rs.getInt("showcomment");
			showread=rs.getInt("showread");
			allowcomment=rs.getInt("allowcomment");
			showtime=rs.getInt("showtime");
			showtype=rs.getInt("showtype");
		}
		tu.closeRs(rs);
		
		xml += "<add><doc>";
		xml += "<field name=\"id\">"+globalid+"</field>";
		xml += "<field name=\"channelid\">"+channel.getId()+"</field>";	
		//if(!Util.XMLQuote(doc.getDocFrom()).equals("")){
			xml += "<field name=\"docfrom\">"+Util.XMLQuote(doc.getDocFrom())+"</field>";
		//}
		
		xml += "<field name=\"isphotonews\">"+doc.getIsPhotoNews()+"</field>";
		xml += "<field name=\"channelcode\">"+channelcode+"</field>";
		xml += "<field name=\"title\">"+Util.XMLQuote(doc.getTitle())+"</field>";
		xml += "<field name=\"dateline\">"+doc.getValue("PublishDate")+"</field>";
		xml += "<field name=\"siteid\">"+channel.getSiteID()+"</field>";
		if(!Util.XMLQuote(doc.getSummary()).equals("")){
			xml += "<field name=\"summary\">"+Util.XMLQuote(doc.getSummary())+"</field>";
		}
		String Photo="";
                if(doc.getIntValue("item_type")==5||doc.getIntValue("item_type")==2){
                     Photo=doc.getValue("Photo4");
                }else{
                     Photo=doc.getValue("Photo");
                }
		if(!Photo.equals("")){
			xml += "<field name=\"photo\">"+Photo+"</field>";
		}
		if(!doc.getValue("photo2").equals("")){
			xml += "<field name=\"photo2\">"+doc.getValue("photo2")+"</field>";
		}
		if(!doc.getValue("photo3").equals("")){
			xml += "<field name=\"photo3\">"+doc.getValue("photo3")+"</field>";
		}
		
		if(!doc.getValue("content_type").equals("")){
			xml += "<field name=\"contenttype\">"+doc.getValue("content_type")+"</field>";
		}
		
		xml += "<field name=\"doctype\">"+doc.getValue("doc_type")+"</field>";
		xml += "<field name=\"itemtype\">"+doc.getValue("item_type")+"</field>";
		xml += "<field name=\"videoid\">"+doc.getValue("videoid")+"</field>";
		xml += "<field name=\"href\">"+Util.XMLQuote(doc.getHttpHref())+"</field>";
		xml += "<field name=\"showcomment\">"+showcomment+"</field>";
		xml += "<field name=\"showread\">"+showread+"</field>";
		xml += "<field name=\"allowcomment\">"+allowcomment+"</field>";
		xml += "<field name=\"showtime\">"+showtime+"</field>";
		xml += "<field name=\"showtype\">"+showtype+"</field>";
		
		if(!doc.getValue("href_app").equals("")){
			xml += "<field name=\"hrefapp\">"+doc.getValue("href_app")+"</field>";
		}else{
                if(doc.listChildItems(sys_photo_channelid).size()>0){
                             xml += "<field name=\"hrefapp\">"+doc.getHttpHref("pic")+"</field>";
                       }else{
                              xml += "<field name=\"hrefapp\">"+doc.getHttpHref("app")+"</field>";
                       }
                }
		if(!doc.getValue("frame").equals("")){
			xml += "<field name=\"frame\">"+doc.getValue("frame")+"</field>";
		}
		if(!doc.getValue("secondcategory").equals("")){
			xml += "<field name=\"secondcategory\">"+doc.getValue("secondcategory")+"</field>";
		}
		if(!doc.getValue("jumptype").equals("")){
			xml += "<field name=\"jumptype\">"+doc.getValue("jumptype")+"</field>";
		}
		
		
		xml += "</doc></add>";

	}
	else
	{
	   if(doc.getStatus()==0){
		 xml += "<delete><id>"+globalid+"</id></delete>";
		}
	}
	if(xml.length()>0)
	{
	    System.out.println("测试2："+xml);
		String httpurl = "http://127.0.0.1:888/tidesolr/app/update?commit=true";
		URL url = new URL(httpurl);
		java.net.HttpURLConnection connection = (java.net.HttpURLConnection) url.openConnection();
		connection.setDoOutput(true);
		connection.setUseCaches(false);
		connection.setRequestProperty("Content-Type","text/xml;charset=utf-8");
		connection.setRequestMethod("POST");
		connection.connect();
		OutputStreamWriter out1 = new OutputStreamWriter(connection.getOutputStream(), "utf-8");

		out1.write(xml);
		out1.flush();

		String sCurrentLine = "";
		String content = "";

		java.io.InputStream l_urlStream = connection.getInputStream();
		java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream));
		while ((sCurrentLine = l_reader.readLine()) != null)
		{
			content+=sCurrentLine;
		}
		out1.close();
		out1 = null;
		connection.disconnect();
		connection = null;
	}
%>
