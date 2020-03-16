<%@ page
	import="java.sql.*,
			java.io.*,
			tidemedia.cms.base.MessageException"
	isErrorPage="true"
%>
<%@ page contentType="text/html;charset=utf-8" %>
<%	// Get parameter values
	String 	message	= request.getParameter("message");
	if(message==null)
		message = "";
%>
<%
//check user validate

/////////////////
// Init parameters
int messageType = 0;
String ClassName="";
String Message = "";

String Message2 =  "<a href=\"#\" onClick=\"history.go(-1)\">[返回]</a>";

ClassName = exception.getClass().getName();
if(ClassName.equals("tidemedia.cms.base.MessageException"))
{
	MessageException messageexception = (MessageException)exception;

	if(messageexception.getMessageType()==1)
	{
		messageType = 1;
		response.addHeader("Expires","0");
		response.addHeader("Pragma","no-cache");
		response.addHeader("Cache-Control","no-cache");
		out.println("<script language=javascript>");
		out.println("alert(\""+tidemedia.cms.util.Util.JSQuote(exception.getMessage())+"\");");
		out.println("history.back();");
		out.println("</script>");
		//out.flush();
		//out.close();
	}
	else if(messageexception.getMessageType()==0)
	{
		Message = exception.getMessage();

		if(Message.equals("This channel is not exist!"))
		{
			messageType = 4;
			Message = "无法访问该频道，可能已经被删除或者没有权限访问！";
		}
	}
	else if(messageexception.getMessageType()==2)
	{
		messageType = 2;
		response.addHeader("Expires","0");
		response.addHeader("Pragma","no-cache");
		response.addHeader("Cache-Control","no-cache");
		out.println("<script language=javascript>");
		out.println("alert(\""+tidemedia.cms.util.Util.JSQuote(exception.getMessage())+"\");");
		out.println("self.close();");
		out.println("</script>");
		//out.close();
	}
	else if(messageexception.getMessageType()==3)
	{
		messageType = 3;
		response.addHeader("Expires","0");
		response.addHeader("Pragma","no-cache");
		response.addHeader("Cache-Control","no-cache");
		out.println("<script language=javascript>");
		out.println("alert(\""+tidemedia.cms.util.Util.JSQuote(exception.getMessage())+"\");");
		out.println("window.location = document.referrer;");
		out.println("</script>");
		//out.close();
	}
	else if(messageexception.getMessageType()==4)
	{
		messageType = 4;
		Message = exception.getMessage();
		Message2 =  "<a href=\"#\" onClick=\"self.close();\">[关闭]</a>";
	}
	else if(messageexception.getMessageType()==5)
	{
		messageType = 5;
		Message = exception.getMessage();
		Message2 =  "该系统的许可证无效或已经过期，不能再继续使用.";
	}
}
else if(ClassName.equals("java.lang.ClassCastException"))
{
	Message = "Not found one class's Instance";
}
else if(ClassName.equals("java.sql.SQLException"))
{
	exception.printStackTrace();
	Message = "系统发生错误，如果继续发生的话，请联系系统管理员确定配置是否正确，或拨打400-0873-128寻求技术支持。";
}
else
{
	exception.printStackTrace();
	Message = "系统发生错误，如果继续发生的话，请联系系统管理员确定配置是否正确，或拨打400-0873-128寻求技术支持。";
}
%>
<html><head><title>TideCMS</title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link href="../style/2018/common.css" rel="stylesheet">

<%if(messageType==5){%><script language=javascript>if (top.location != self.location)top.location="<%=(request.getRequestURL()+"").replace("cms_error.jsp","cms_main.jsp?Flag=2")%>";</script><%}%>
</head>

<body class="collapsed-menu email" id="channel-manage">

	<!--<%if(messageType == 4 || messageType==5){%>
		<h1>系统提示 </h1>
	<%}else{%>
		<h1>系统正在调试或该功能未有配置 </h1>
	<%}%>-->
<div class="br-mainpanel mg-t-0 br-mainpanel-file mg-l-0-force" id="js-source">
	<div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
          <span class="breadcrumb-item active">提示</span>
        </nav>
    </div>
	<div class="channel-name mg-l-30 mg-r-30">
  		<div class="channel-name-box">
  			<div class="set-img-box">
  				<i class="fa fa-exclamation-triangle tx-50 lh-72" aria-hidden="true"></i>
  			</div>
  			<div class="right-info">
  				<h5 class="tx-22">不能获取数据</h5>
  				<p class="tx-12">
					<%if(messageType == 4 || messageType==5){%><%=Message%><%}else{%>请联系系统管理员确定配置是否正确，或拨打400-0873-128寻求技术支持。<%}%>
				</p>
  			</div>
  		</div>      	
	</div>

	<br>

	<!--<div class="pd-md-l-20">
		<%if(messageType == 4 || messageType==5){%><%=Message2%><%}else{%><a href="javascript:showinfo('info_id')" style="color:#FF6600">详细了解&gt;&gt;</a><%}%>
	</div>-->

	<!--<HR size="1" noshade="noshade">-->

	<script language="javascript">
		function showinfo(id){
		 document.getElementById(id).style.display="";
		}
	</script>

	<br>
		
	<!--<HR size="1" noshade="noshade">-->

	<div id="info_id" style="display:none" class="pd-md-l-20">
		<%=Message%>
		<br>
		<br>
	</div>
</div>
</body>
</html>