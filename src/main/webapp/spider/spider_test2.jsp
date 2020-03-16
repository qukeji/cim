<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				java.util.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!	public  String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("GBK");
			String temp = new String(temp_t, "iso-8859-1");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}
%>


<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
int flag = getIntParameter(request,"flag");

Spider  spider = new Spider(id);
String spider_url = spider.getParsed_Url_First();
if(spider_url.length()==0)
{
	spider_url = spider.getUrl();
}
if(spider_url.length()==0)
{
	out.println("缺少可以测试的采集地址");
	return;
}
if(flag==1)
{
	out.println("<br>一次性采集地址："+spider_url);
}

if(flag==2)
{
	String urls[] = Util.StringToArray(spider_url,"\r\n");
	String url = urls[0];
	HashMap hash = new SpiderJob().getContentHrefByListUrl(spider,url);
	String message = (String)hash.get("message");
	String content = (String)hash.get("content");
	ArrayList arr = (ArrayList)hash.get("items");
	out.println("<p class='mg-y-10'>采集地址："+spider_url+"</p>");
	out.println("<p class='mg-y-10'>"+message+"</p>");
	out.println("<p class='mg-y-10'>内容：</p><textarea class='form-control' style='height: 200px; width: 900px;color:#666;'> "+content+"</textarea>");
	for(int i = 0;i<arr.size();i++)
	{
		out.println("<br>"+(String)arr.get(i));
	}
}

if(flag==3)
{
	String urls[] = Util.StringToArray(spider_url,"\r\n");
	String url = urls[0];
	System.out.println("url="+url);
	HashMap hash = new SpiderJob().getContentHrefByListUrl(spider,url);
	String message = (String)hash.get("message");
	ArrayList arr = (ArrayList)hash.get("items");
	out.println("<p class='mg-y-10'>"+message+"total items："+arr.size()+"</p>");
	for(int i = 0;i<1;i++)
	{
		String url2 = (String)arr.get(i);
		
		out.println("<div class='d-flex align-items-center'><span>内容测试地址：</span><input class='form-control wd-500' type='text' value='"+url2+"' size='60' id='content_url'><a href='javascript:content_test();' class='btn btn-primary pd-x-15 pd-y-5 mg-x-10'>测试</a><a href='javascript:content_preview();' class='btn btn-primary pd-x-15 pd-y-5'>预览</a></div><br><div id='content_test_message'></div>");
		/*
		HashMap hash2 = new SpiderJob().getFieldValueByContentUrl(spider,url2,true);
		HashMap map = (HashMap)hash2.get("map");
		String message1 = (String)hash2.get("message");
		out.println(message1);
		ArrayList<SpiderField> arr2 = spider.getFields();
		for(int j = 0;j<arr2.size();j++)
		{
			SpiderField sf = (SpiderField)arr2.get(j);
			out.println("<br>"+sf.getField()+",内容："+(String)map.get(sf.getField()));
		}
		*/
	}
}

if(flag==4)
{
	String urls[] = Util.StringToArray(spider_url,"\r\n");

	out.println("<p class='mg-y-10'>要采集的地址：</p>");
	out.println("<ul id='urls'>");

	for(int i = 0;i<urls.length;i++)
	{
		out.println("<li href='"+java.net.URLEncoder.encode(urls[i])+"'>"+urls[i]+"<span class='message mg-l-20'></span></li>");
	}
	out.println("</ul><br><a href='javascript:spider_start();' class='btn btn-primary pd-x-15 pd-y-5'>开始采集</a>");
}

if(flag==5)
{
	String url = getParameter(request,"url");
	HashMap hash2 = new HashMap();
	out.println("代理程序：<a target='_blank' href='"+spider.getProgram().replace("localhost:889","cms.tidedemo.com")+"?url="+url+"&spiderid="+spider.getId()+"'>"+spider.getProgram()+"</a>");
	hash2 = new SpiderJob().getFieldValueTest(spider,url);
	HashMap map = (HashMap)hash2.get("map");
	String message1 = (String)hash2.get("message");
	out.println(message1);
	out.println("<br>字段分析结果：<br>");
	Iterator iter = map.entrySet().iterator(); 
	while (iter.hasNext()) { 
		    Map.Entry entry = (Map.Entry) iter.next(); 
		    String key = (String)entry.getKey(); 
		    String val = (String)entry.getValue();
		    out.println("<br><font color=blue><b>"+key+"</b></font> "+val);
	}
	/*
	String fields = ",";
	ArrayList<SpiderField> arr2 = spider.getFields();
	for(int j = 0;j<arr2.size();j++)
	{
		SpiderField sf = (SpiderField)arr2.get(j);
		if(!fields.contains(sf.getField()))
		{
			fields += sf.getField() + ",";
			out.println("<br>"+sf.getField()+",内容："+(String)map.get(sf.getField()));
		}
	}*/
}
%>
