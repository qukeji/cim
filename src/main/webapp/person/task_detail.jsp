<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
int id = getIntParameter(request,"id");

MyTask mytask = new MyTask(id);

String StatusDesc	= "";
if(mytask.getStatus()==0)
	StatusDesc = "未处理";
else if(mytask.getStatus()==1)
	StatusDesc = "处理中";
else if(mytask.getStatus()==2)
	StatusDesc = "处理完毕";
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<script language=javascript>

function check()
{
	if(isEmpty(document.form.Name,"请输入任务名称."))
		return false;

	return true;
}

function isEmpty(field,msg)
{	
	if(field.value == "")
	{
		alert(msg);
		field.focus();
		return true;
	}
	return false;
}

function Complete(id)
{
	if(confirm('要完成此任务吗?'))
		this.location = "task_change.jsp?id="+id;
}

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="auto">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<form name="form" action="task_add.jsp" method="post" onSubmit="return check();">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="8">
        <tr> 
          <td width="25%" align="right">任务名称：</td>
          <td width="75%" class="lin28">
            <%=mytask.getName()%>
          </td>
        </tr>
        <tr valign="top" > 
          <td align="right">描述：</td>
          <td class="lin28"><%=Util.convertNewlines(mytask.getContent())%></td>
        </tr>
        <tr> 
          <td align="right">状态：</td>
          <td class="lin28">
          <%=StatusDesc%>
          </td>
        </tr>
        <tr> 
          <td align="right">操作：</td>
          <td class="lin28">
          <input name="Button2" type="button" class="tidecms_btn3" value=" 完成 " onClick="Complete(<%=id%>);">
          </td>
        </tr>
	  </table>
    </td>
  </tr>
  <tr>
    <td height="50" align="center" class="box-gray">
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn3" value="  关  闭  " onclick="self.close();">
	</td>
  </tr>
</form>
</table>
</body>
</html>
