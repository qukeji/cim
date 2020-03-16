<%@ page import="tidemedia.cms.util.*,org.json.*,tidemedia.cms.system.*,java.io.File,java.util.*"%><%@ page contentType="text/html;charset=utf-8" %><%response.setContentType("text/xml");%><%response.setHeader("Pragma","No-cache"); response.setHeader("Cache-Control","no-cache"); response.setDateHeader("Expires", 0);%><?xml version="1.0"  encoding="utf-8"?>
<%@ include file="../config.jsp"%>
<%
	/**
	 *
	 *@author wanghailong
	 *@action add
	 *@date 2014/01/11
	 *@info 选择视频树形结构
	 *
	 */
String Path = getParameter(request,"Path");
int number = getIntParameter(request,"number");
TideJson tj = CmsCache.getParameter("sys_video").getJson();
JSONArray array = new JSONArray(tj.getString("select_folder"));
List<String> list = new ArrayList<String>();
for(int i=0;i<array.length();i++)
{
	JSONObject oo = array.getJSONObject(i);
	String value = oo.getString("value");
	list.add(value);
}

String root = list.get(number);
if (root.equals("")){
%>
<tree></tree>
<%
return;}
String RealPath = root+"/"+Path;
File file = new File(RealPath);
%>
<tree>
	<%
	 
	if(file.exists()&&file.listFiles().length>0){ 
	File[] files = file.listFiles();
    Arrays.sort(files);//按文件名排序
	//For each newNode in Root.SubFolders
	for(int i = 0;files!=null && i<files.length;i++)
	{
		if(files[i].isDirectory() && !(files[i].getName().equalsIgnoreCase("WEB-INF")))
		{
			String FolderName = files[i].getName();
			if(Util.isHasSubFolder(RealPath+"/"+FolderName))
			{
	%>
	<tree text="<%=FolderName%>" src="folder_xml.jsp?Path=<%=java.net.URLEncoder.encode(Path + "/" + FolderName,"utf-8")%>&amp;number=<%=number%>" action="javascript:ListFile()&quot;    
	  Number=&quot;<%=number%>&quot; FolderName=&quot;<%=Path + "/" + FolderName%>"/>
	<%
			}
			else
			{
	%>
	<tree text="<%=FolderName%>" action="javascript:ListFile()&quot; Number=&quot;<%=number%>&quot; FolderName=&quot;<%=Path + "/" + FolderName%>" />
	<%
			}
		}
	
	}}
	%>
</tree>
