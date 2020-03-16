<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.util.StringUtils,
				tidemedia.cms.email.*,
				java.util.ArrayList,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String SiteAddress = defaultSite.getUrl();

int		ItemID			= getIntParameter(request,"ItemID");
EmailContent ec = new EmailContent();
EmailConfig econfig = new EmailConfig();

String Title = getParameter(request,"Title");

if(!Title.equals(""))
{
	String Content		= getParameter(request,"Content");
	String Sender		= getParameter(request,"Sender");
	String SenderName	= getParameter(request,"SenderName");
	int		Send		= getIntParameter(request,"Send");
	int emailid = 0;

	if(ItemID==0)
	{
		ec = new EmailContent();
		
		ec.setTitle(Title);
		ec.setContent(Content);
		ec.setSender(Sender);
		ec.setSenderName(SenderName);

		if(Send==1) ec.setStatus(1);

		emailid = ec.Add_GetID();
	}
	else
	{
		ec = new EmailContent(ItemID);

		ec.setTitle(Title);
		ec.setContent(Content);
		ec.setSender(Sender);
		ec.setSenderName(SenderName);

		if(Send==1) ec.setStatus(1);

		ec.Update();

		emailid = ItemID;
	}

	if(Send==1)	{EmailSend es = new EmailSend(emailid);}

	response.sendRedirect("../close_pop.jsp?Type=1");return;
}

if(ItemID>0) ec = new EmailContent(ItemID);
%>
<html>
<head>
<title>新建文档</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">

<script type="text/javascript" src="../editor/fckeditor.js"></script>
<script>
<!--

function ControlEditor()
{
	if(document.all("Label1").innerText=="隐藏编辑器")
	{
		document.all.Editor.style.display="none";
		document.all("Label1").innerText = "显示编辑器";
	}
	else
	{
		document.all.Editor.style.display="";
		document.all("Label1").innerText = "隐藏编辑器";
	}
}

function Save_Content()
{
	//保存正文,内容
	document.ContentEditor.preparesubmit();

	var localhost = document.location.protocol+ "//" + document.location.hostname;
	if (document.location.port!="80")
  		localhost = localhost + ":" + document.location.port;
<%if(!SiteAddress.equals("")){%>localhost = "<%=SiteAddress%>";<%}%>
	var Pages = document.all.ContentEditor.GetPages();
	if(Pages<=1)
	{
		var str = document.all.ContentEditor.GetContent(1);
		str = vbs_Replace(str,localhost,"");

		document.form.Content.value = str;
		//document.form.Page.value = "1";
	}
	else
	{
		for(var i=1;i<=Pages;i++)
		{
			var str = document.all.ContentEditor.GetContent(i);
			//alert(i+":"+str);
			str = vbs_Replace(str,localhost,"");

			if(i==1)
				document.form.Content.value = str;
			else
			{
				var oInput = document.createElement("<input type='hidden' name='Content"+i+"' value=''>");
				document.form.appendChild(oInput);
				oInput.value = str;
			}
		}
		
		document.form.Page.value = Pages + "";
	}
}

function Save()
{
	if(check())
	{

	//有内容拦的情况下，保存前先处理内容栏
	if(document.ContentEditor)
		Save_Content();

	Image1Href.href = "javascript:void(0);";

	//alert("ok");
	document.form.submit();

	return;
	}
}

function Save_Publish()
{
	document.form.Send.value = 1;
	Save();
}

function check()
{
	if(document.form.Title.value=="")
	{
		alert("请输入标题!");
		document.form.Title.focus();
		return false;
	}

	if(document.form.Title.value.length>100)
	{
		alert("标题太长!");
		document.form.Title.focus();
		return false;
	}

	if(!checkEmail(document.form.Sender.value))
	{
		alert("请输入正确的邮件地址!");
		document.form.Sender.focus();
		return false;
	}

	return true;
}

function checkEmail(str)
{
    //如果为空，则通过校验
    if(str == "")
        return true;
    if (str.charAt(0) == "." || str.charAt(0) == "@" || str.indexOf('@', 0) == -1 || str.indexOf('.', 0) == -1 || str.lastIndexOf("@") == str.length-1 || str.lastIndexOf(".") == str.length-1)
        return false;
    else
        return true;
}

function checkIsValidDate(str)
{
    //如果为空，则通过校验
    if(str == "")
        return true;
//    var pattern = ((\\d{4})|(\\d{2}))-(\\d{1,2})-(\\d{1,2})$/g;
//    if(!pattern.test(str))
//        return false;
	var str1 = str.split(" ");
	if(str1.length==1)
		str1[1]="00:00:00";
	if(str1.length>2)
		return false;

    var arrDate = str1[0].split("-");
	if(arrDate.length!=3)
		return false;
	var arrDate1 = str1[1].split(":");
	if(arrDate1.length!=3)
		return false;
    if(parseInt(arrDate[0],10) < 100)
        arrDate[0] = 2000 + parseInt(arrDate[0],10) + "";

	var year = arrDate[0];
	var month = (parseInt(arrDate[1],10)-1);
	var day = parseInt(arrDate[2],10);
	var hour = parseInt(arrDate1[0],10);
	var min = parseInt(arrDate1[1],10);
	var sec = parseInt(arrDate1[2],10);
    var date =  new Date(year,month,day,hour,min,sec);
	//alert(date.getMonth()+":"+date.getDate()+":"+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds());
    if(date.getYear() == year
        && date.getMonth() == month
		&& date.getDate() == day 
		&& date.getHours()==hour 
		&& date.getMinutes()==min 
		&& date.getSeconds()==sec)
        return true;
    else
        return false;
}

function init()
{		

}

function initContent1()
{
<%if(ItemID>0){%>
	if(document.ContentEditor)
		try{
		{
			var content = '<%=Util.JSQuote(ec.getContent())%>';
			<%if(!SiteAddress.equals("")){%>content = content.replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/' ) ;<%}%>
			document.ContentEditor.SetContent(1,content)

		}
		}catch(er){	window.setTimeout("initContent1()",5);}
<%}%>
}

function initContent()
{
	window.setTimeout("initContent1()",1);
}

function selectFile(fieldname)
{
	var myObject = new Object();
    myObject.title = "上传文件";

 	var Feature = "dialogWidth:24em; dialogHeight:12em;center:yes;status:no;help:no";
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=content/insertfile.jsp",myObject,Feature);
	if(retu!=null)
		document.all(fieldname).value = retu;
}

function selectdate(fieldname){
	var args="font-size:10px;dialogWidth:286px;dialogHeight:290px;center:yes;status:no;help:no";
	var Feature=new Array();
	var selectdate=window.showModalDialog("selectdate.htm",Feature,args);
	//alert(document.all(fieldname));
	if (selectdate!=null)
	{
		if(document.all(fieldname).value!="")
		{
			arrayOfStrings = document.all(fieldname).value.split(" ");
			if(arrayOfStrings.length==1)
				document.all(fieldname).value = selectdate;
			else
				document.all(fieldname).value = selectdate + " " + arrayOfStrings[1];
		}
		else
			document.all(fieldname).value=selectdate;
	}
} 

function AddPage()
{
	document.all.ContentEditor.addTab();
}

function DeletePage()
{
	document.all.ContentEditor.DeleteTab();
}
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="init();">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td height="50" align="center" class="box-gray"><div align="left"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td width="10">&nbsp;</td>
            <td width="65"><a id="Image1Href" href="javascript:Save();" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image1','','../images/icon_save_s.gif',1)"><img src="../images/icon_save_n.gif" width="32" height="32" border="0" align="absmiddle" id="Image1"> 
              保存</a></td>
            <td width="10">&nbsp;</td>
			<td width="100">
			<a id="Image2Href" href="javascript:Save_Publish();" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Image2','','../images/icon_publish_s.gif',1)">
			<img src="../images/icon_publish_n.gif" width="32" height="32" align="absmiddle" id="Image2" border="0"> 保存并发送</a>
			</td>
            <td></td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </div></td>
  </tr>
  <tr> 
    <td valign="top" class="box-tint"><br> 
	<table width="90%" border="0" align="center" cellpadding="0" cellspacing="6">
<form name="form" action="document.jsp" method="post">
<tr>
	<td width="70" align="right">标题：</td>
	<td>
	<input type="text" class="textfield" size="100" name="Title" value="<%=ec.getTitle()%>">
	</td>
</tr>
<tr>
	<td width="70" align="right">发件人：</td>
	<td>
	<input type="text" class="textfield" size="100" name="Sender" value="<%=ec.getSender().equals("")?econfig.getEmail():ec.getSender()%>">
	</td>
</tr>
<tr>
	<td width="70" align="right">发件人名称：</td>
	<td>
	<input type="text" class="textfield" size="100" name="SenderName" value="<%=ec.getSenderName().equals("")?econfig.getPersonal():ec.getSenderName()%>">
	</td>
</tr>
<tr>
<td width="70" align="right" valign="top">内容：</td>
	<td>
<OBJECT data="../editor/tabspt.jsp" id="ContentEditor" type="text/x-scriptlet" frameBorder=no width="618" scrolling=no height="440"></OBJECT>
	</td>
</tr>
<tr >
<td width="70" align="right" valign="top"></td>
<td>
<input type="hidden" name="Content" value="">
<input type="hidden" name="ItemID" value="<%=ItemID%>">
<input type="hidden" name="Send" value="0">
</td>
</tr>
</form>
      </table></td>
  </tr>
</table>
</body>
</html>
<script language="vbscript">
Function vbs_Replace(str1,str2,str3)
  vbs_Replace = Replace(str1,str2,str3)
End Function
</script>
