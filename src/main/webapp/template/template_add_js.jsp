<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		TemplateID		=	getIntParameter(request,"id");

String js = "";
//System.out.println(SChannelID);
if(TemplateID!=0)
{//System.out.println(SChannelID);
	TemplateFile tf = new TemplateFile(TemplateID);

	js += "document.form.Template.value='"+Util.JSQuote(tf.getFileName())+"';";
	js += "var FileName = document.form.Template.value;";
	js += "document.form.TargetName.value = document.form.Template.value.substring(FileName.lastIndexOf('/')+1);";
	js += "document.form.TemplateID.value = " + TemplateID + ";";
}
%><%=js%>