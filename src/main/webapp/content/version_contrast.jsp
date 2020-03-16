<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.regex.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%!

public static String filterHtml(String str) {  
	String regxpForHtml = "<([^>]*)>"; // 过滤所有以<开头以>结尾的标签
	Pattern pattern = Pattern.compile(regxpForHtml);   
	Matcher matcher = pattern.matcher(str);   
	StringBuffer sb = new StringBuffer();   
	boolean result1 = matcher.find();   
	while (result1) {   
		matcher.appendReplacement(sb, "");   
		result1 = matcher.find();   
	}   
	matcher.appendTail(sb);   
	return sb.toString();   
}

%>
<%
/**
  *
  *用途：版本比对
  *
  *
  */
int	version_id1		=	getIntParameter(request,"id1");
int	version_id2		=	getIntParameter(request,"id2");
int	globalid		=	getIntParameter(request,"globalid");

JSONArray arr = new JSONArray();

String versionSql = "select * from article_replica where id in ("+version_id1+","+version_id2+")";
TableUtil verTu = new TableUtil();
ResultSet verRs = verTu.executeQuery(versionSql);
while(verRs.next()){
	JSONObject json = new JSONObject();
	String Title = convertNull(verRs.getString("Title"));
	String CreateDate = convertNull(verRs.getString("CreateDate"));
	CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm:ss",CreateDate);
	String Content = convertNull(verRs.getString("Content"));
	Content = Content.replaceAll("</p>","\n");//替换换行符
	Content = Content.replaceAll("&nbsp;"," ");//替换空格
	Content = filterHtml(Content);//过滤HTML标签

	json.put("date",CreateDate);
	json.put("title",Title);
	json.put("Content",Content);
	arr.put(json);
}
verTu.closeRs(verRs);

//当选择一个版本时，和当前版本对比
if(globalid != 0 && version_id2 == 0){

	//获取文章对象
	Document Doc = CmsCache.getDocument(globalid);
	JSONObject json1 = new JSONObject();	
	String Title1 =Doc.getTitle();
	String ModifiedDate	= Doc.getModifiedDate();
	String Content1 =Doc.getValue("Content");
	Content1 = Content1.replaceAll("</p>","\n");//替换换行符
    Content1 = Content1.replaceAll("&nbsp;"," ");//替换空格
    Content1 = filterHtml(Content1);//过滤HTML标签

	json1.put("title",Title1);
	json1.put("Content",Content1);
	json1.put("date",ModifiedDate);

	arr.put(json1);
}
out.println(arr);
%>
