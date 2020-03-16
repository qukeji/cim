 <%@ page import="org.jsoup.Jsoup,
				org.jsoup.nodes.*,
				tidemedia.cms.util.*,
				tidemedia.cms.system.CmsCache,
				tidemedia.cms.system.Channel,
				tidemedia.cms.system.CmsFile,
				org.jsoup.select.Elements,
				org.json.*,
				tidemedia.cms.spider.Spider,
				tidemedia.cms.spider.SpiderField,
				java.util.regex.Matcher,
				java.util.ArrayList,
				java.util.List,
				java.net.URL,
				java.util.regex.Pattern,
				org.apache.commons.io.FileUtils"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@page import="java.util.Iterator"%>
<%@page import="tidemedia.cms.base.MessageException"%>
<%@page import="java.sql.SQLException"%>
<%@ include file="../config.jsp" %>
<%!
	public String getResult(String field,String rule,Document doc)
	{
			 StringBuffer buffer = new StringBuffer();
			//内容字段
	     	if(field.equals("Content"))
	     	{
				String content = doc.select(rule).first().html();//内容  带HTML标签  这句一定要路径替换之后写，否则路径还是相对的
				buffer.append("var RecommendContent='"+Util.JSQuote(content)+"';initRecommendContent();"); 	
	     	}
	     	else if(rule.startsWith("meta[name="))
			{
				 Elements elements = doc.select(rule);
				 String value = "";
				 if(elements!=null)
				 	  value = elements.first().attr("content");
				 buffer.append("$('#Keyword').tagit('addTags','"+value+"');");
			}
	     	else
	     	{
		     	String value = doc.select(rule).first().text();
		     	buffer.append("setValue('"+field+"','"+value+"');");
		     }
		return buffer.toString() ; 
	}
	//提取图片链接地址
	public List<String> getImgStr(String htmlStr){     
	     String img="";     
	     List<String> pics = new ArrayList<String>();  
	  
	     String regEx_img = "<img.*src=(.*?)[^>]*?>"; //图片链接地址     
	     Pattern p_image = Pattern.compile(regEx_img,Pattern.CASE_INSENSITIVE);     
	     Matcher m_image = p_image.matcher(htmlStr);   
	    while(m_image.find())
	    {     
	         img = img + "," + m_image.group();     
	         Matcher m  = Pattern.compile("src=\"?(.*?)(\"|>|\\s+)").matcher(img); //匹配src  
	         while(m.find()){  
	            pics.add(m.group(1));  
	         }  
	     }     
	        return pics;     
	 } 
	 
	 //图片本地化
	 public String localizeImg(int channelid,String img,int user)
	 	throws Exception
	 {
	 	 Channel channel = CmsCache.getChannel(channelid);
		 String SiteFolder = channel.getSite().getSiteFolder();
		 String Path = channel.getRealImageFolder();
		 String SiteUrl =  channel.getSite().getExternalUrl();
		 
		  CmsFile cmsfile = new CmsFile();
		 String NewFileName = cmsfile.getNewFileName(Util.getFileName(img),Path,user,channelid);
		 String file = SiteFolder+"/"+Path+"/"+NewFileName;
		 java.io.File imgFile =  new java.io.File(file);
		 FileUtils.copyURLToFile(new URL(img),imgFile);
		 img = Util.ClearPath(SiteUrl+"/"+Path+"/"+NewFileName);
		 
		 
		 return img ;
	 }
 %>
<%
	/**
	  *add by whl 2015.3.27 客户端转载程序 
	  *
	  *modify by whl 2015.8.9 图片本地化
	  *
	  */
	
	 TideJson tj = CmsCache.getParameter("sys_config_photo").getJson();
	 //{"channelid":"14296","force_httpurl":"1"}
	 int channelid = tj.getInt("channelid");
	 
	 request.setCharacterEncoding("UTF-8");
	 
     String url = getParameter(request,"url");
    //uri 提取
    String uri = "";
	//String regex  = "(http|https)://((\\w{1,}.){2}\\w{1,})|(\\d{1,}.){2}\\d{1,}";//提取ip,域名
	String regex  = "(http|https)://((\\w{1,}\\.)+\\w{1,})|(\\d{1,}\\.)+\\d{1,}";//提取ip,域名
	Pattern p = Pattern.compile(regex,Pattern.CASE_INSENSITIVE);
	Matcher matcher = p.matcher(url);
	if(matcher.find())uri=matcher.group();
     
     StringBuffer buffer = new StringBuffer();
     Spider spider = new Spider();
     spider = spider.getSpiderByUri(uri);
     
     if(spider!=null)
     {
     	 //html 解析
	     org.jsoup.nodes.Document doc = Jsoup.connect(url).get();      
	     //把图片的相对路径换成绝对路径
		 //Elements imgs = doc.select("img[src]"); 
		 Elements imgs = doc.select("[src]");//把转载页面中所有属性有src的值中的相对路径转成绝对路径
		 for(Element img : imgs)
		 {
			 String src = img.attr("abs:src");
			 //图片本地化
			 if(img.tagName().equalsIgnoreCase("img"))
			 {
				src = localizeImg(channelid,src,userinfo_session.getId());
			 }
			 img.attr("src", src);//把相对路径换成绝对路径
		 } 
		 
		 Elements hrefs = doc.select("[href]");//把转载页面中所有属性有src的值中的相对路径转成绝对路径
		 for(Element href : hrefs)
		 {
			 String href_ = href.attr("abs:href");
			 href.attr("href", href_);//把相对路径换成绝对路径
		 } 
     	
	     ArrayList<SpiderField> list = spider.getFields();
	     
	     for(SpiderField sf : list)
	     {
	     	String field = sf.getField();
	     	String rule = sf.getRule(); 
	     	if(rule==null||rule.equals(""))continue;
	     	String temp = getResult(field,rule,doc);
     		buffer.append(temp);
	     }
	     out.println(buffer.toString());
     }
     else 
     {
     	//调用Tide云采集
     	// String res = Util.connectHttpUrl("http://115.29.150.217:888/cms_cloud/api/api_transfer_article.jsp?url="+url, "utf-8");
		//out.println(res.replace("\r","").replace("\n",""));
		 String res = Util.connectHttpUrl("http://115.29.150.217:888/cms_cloud/api/api_transfer_article.jsp?type=json&url="+url, "utf-8");
		 JSONObject obj = new JSONObject(res);
		 StringBuffer buffer_ = new StringBuffer();
		 Iterator iter = obj.keys();
		 while(iter.hasNext())
		 {
		 	String key = (String)iter.next();
			String value = obj.getString(key);
			if(key.equals("transfer_from"))
			{
				buffer_.append("var transfer_from='"+value+"';");
			}
			else if(key.equals("Keyword"))
			{
				 buffer_.append("$('#Keyword').tagit('addTags','"+value.trim()+"');");
			}
			else if(key.equals("Content"))
			{
				
				//图片本地化
				List<String> list = getImgStr(value);
				for(String s: list)
				{
					String src = localizeImg(channelid,s,userinfo_session.getId());
					value = value.replace(s,src);
				}
				
				buffer_.append("var RecommendContent='"+Util.JSQuote(value)+"';initRecommendContent();"); 	
			}
			else
			{
				buffer_.append("setValue('"+key+"','"+value+"');");
			}
		 }
		 out.println(buffer_.toString());
      	 
     }
    
	
%>
function initRecommendContent()
{
	try{
	var editor = document.getElementById("FCKeditor1___Frame").contentWindow;
	var FCK			= editor.getFCK() ;
	FCK.SetHTML(RecommendContent);
	}catch(er){	window.setTimeout("initRecommendContent()",5);}
}
