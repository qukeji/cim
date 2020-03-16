<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%
//----程序名称: showsurvey.jsp
//----程序简介: 显示问卷
ResultSet rsSurvey;
String sSql,sID;
sID = request.getParameter("SurveyID");
if(sID==null) sID = "";

tidemedia.cms.base.TableUtil tu = new tidemedia.cms.base.TableUtil("survey");
tidemedia.cms.base.TableUtil tu2 = new tidemedia.cms.base.TableUtil("survey");

String url = "http://122.11.50.232:888/survey";
%>

<%
sSql = "SELECT * FROM surveylist WHERE ID = " + sID;
rsSurvey = tu.executeQuery(sSql);

if(!rsSurvey.next()){
%><%
	return;
}else{
%>
<%}
tu.closeRs(rsSurvey);%>
<script langauge="javascript" src="<%=url%>/inc/function.js"></script>
<script language="javascript">
function view_result()
{
	window.open("<%=url%>/manage/sresultays1.jsp?SurveyID=<%=sID%>","survey_<%=sID%>"); 
}
</script>
<%
//取出问问卷中的所有问题及其选项
ResultSet rsQuestion,rsOptions;
int iSerialNo;
String sQsType,sStyle,sOptionsHtml,sCtlType;

iSerialNo = 1;
sSql = "SELECT * FROM question WHERE SurveyID = " + sID + " ORDER BY SerialNumber ASC,ID ASC";
rsQuestion = tu.executeQuery(sSql);
%>
<form method='post' action='<%=url%>/product/dosurvey.jsp' target="survey_<%=sID%>">
<%
	out.print("<input type='hidden' name='SurveyID' value='" + sID + "'>");
	while(rsQuestion.next()){
		out.print(iSerialNo + "." + rsQuestion.getString("Title"));
		out.print(((rsQuestion.getString("IsMustAnswer").equals("1"))?"<font color='red'>*</font>":""));
		out.print("<br>");
		sQsType = rsQuestion.getString("QsType");

		if(sQsType.equals("2")){
			out.print("&nbsp;&nbsp;答：<input name='Question" + iSerialNo + "' size=30 class='smallinput'><br><br>");
		}else{
			//取出所有选项
			sSql = "SELECT * FROM options WHERE SurveyID=" + sID + " AND QuestionID=" + rsQuestion.getString("ID") + " ORDER BY SerialNumber ASC,ID ASC";
			rsOptions = tu2.executeQuery(sSql);

			sStyle = rsQuestion.getString("Style");
			sOptionsHtml = "";
			sCtlType = (sQsType.equals("0"))?"radio":"checkbox";

			if(sStyle.equals("0"))
			{
                while(rsOptions.next())
				{
	                	               	if(rsOptions.getString("Type").equals("0"))
							sOptionsHtml = sOptionsHtml + "&nbsp;&nbsp;<input type='" + sCtlType + "' name='Question" + iSerialNo + "' value='" + rsOptions.getString("ID") + "'>&nbsp;" + rsOptions.getString("Title") + "<br>";
						else{
                                               		sOptionsHtml = sOptionsHtml + "&nbsp;&nbsp;<input type='" + sCtlType + "' name='Question" + iSerialNo + "' value='O" + rsOptions.getString("ID") + "'>&nbsp;" + rsOptions.getString("Title") + "&nbsp;<input name='QuestionOther" + iSerialNo + "' size=10 class='smallinput'><br>";
						}
				}
              }else
			  {
                        		sOptionsHtml = "&nbsp;&nbsp;<select size='" + ((sQsType.equals("0"))?"1":"3") + "' " + ((sQsType.equals("0"))?"":"multiple") + " name='Question" + iSerialNo + "' class='smallsel'>";
                   while(rsOptions.next())
					{
						sOptionsHtml = sOptionsHtml + "<option value='" + rsOptions.getString("ID") + "' >" + rsOptions.getString("Title") + "</option>";
					}
					sOptionsHtml = sOptionsHtml + "</select>";
			   }

			   tu2.closeRs(rsOptions);
			   out.print(sOptionsHtml + "<br><br>");
		}
		iSerialNo = iSerialNo + 1;
	}
	tu.closeRs(rsQuestion);
%>
<input type='submit' value='投票' class='smallbutton'> &nbsp;<input type='button' value='结果' class='smallbutton' onClick="view_result();">
</form>