<%@ page import="tidemedia.cms.system.*,	
				tidemedia.cms.base.*,
				org.json.JSONArray,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
String templateName = getParameter(request,"name");//模板名字
int flag = getIntParameter(request,"flag");//模板设置、取消
int templateId = getIntParameter(request,"id");//模板ID
String template_json= CmsCache.getParameter("sys_special_template_json").getContent();
TableUtil tu1 = new TableUtil();
if(templateId>0&&!templateName.equals("")){
	 String temp = "\\{\"id\":\""+templateId+"\",\"name\":\""+templateName+"\"\\},";
	 if(flag==1)//设为模板
		 template_json=template_json.replaceAll("]",temp+"]");
	 if(flag==0)////移除模板
		 template_json=template_json.replaceAll(temp,"");
	 String templateSql = "update parameter set content= '"+template_json+"' where code='sys_special_template_json'";
	 //System.out.println(templateSql+"===");
	 int res = tu1.executeUpdate(templateSql); 
	 CmsCache.delParameter("sys_special_template_json");
	 String result = "{\"res\":\""+res+"\",\"flag\":\""+flag+"\"}";
     out.println(result);
}else{
	out.println("{'res':'-1'}");
}

%>