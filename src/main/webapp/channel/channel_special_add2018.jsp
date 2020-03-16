<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");

String	ChannelID		=	Util.getParameter(request,"ChannelID");
String Type			=	Util.getParameter(request,"Type");
String ChannelName	=	Util.getParameter(request,"ChannelName");

int		SpecialTemplate			= getIntParameter(request,"SpecialTemplate");

if(SpecialTemplate>0)
{
	String	NewChannelName			= getParameter(request,"NewChannelName");
	int		Parent					= getIntParameter(request,"Parent");

	SpecialChannelUtil channelUtil = new SpecialChannelUtil();
	
	channelUtil.setSourceChannelID(SpecialTemplate);
	channelUtil.setNewChannelName(NewChannelName);
	channelUtil.setNewChannelParentID(Parent);
	channelUtil.generateSpecial();

	out.println("<script>top.TideDialogClose({refresh:'left'});</script>");
}
%>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>
<!--<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />-->
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/2018/common.css">

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>
<script language=javascript>
function check()
{
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

function showStep(step)
{
	if(step==2)
	{
		document.getElementById("step1").style.display = "none";
		document.getElementById("step2").style.display = "";

		document.getElementById("stepButton2").style.display = "none";
		document.getElementById("submitButton").style.display = "";
	}
}
</script>
</head>
<body scroll="no">

	<div class="bg-white modal-box">
		<form name="form" action="channel_special_add2018.jsp" method="post" onSubmit="return check();">
			<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
				<div id="step1">
				<table class="table mg-b-0" id="content-table">
					<thead>
					  <tr>
						<th class="tx-12-force tx-mont tx-medium">选择</th>
						<th class="tx-12-force tx-mont tx-medium">模板名称</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">描述</th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down">预览</th>
					  </tr>
					</thead>
					<tbody>
					  <tr>
						 <td class="">
							<label class="rdiobox mg-b-0">
								<input type="radio" name="SpecialTemplate" value="4114"><span></span>
							</label>
						 </td>
						 <td class="hidden-xs-down">测试</td>
						 <td class="hidden-xs-down">示例专题模板</td>
						 <td class="hidden-xs-down"><a href="javascript:Preview2();"><img src="../images/v9_button_2.gif" title="预览" /></a></td>
					  </tr>
					  <tr>
						 <td class="">
							<label class="rdiobox mg-b-0">
								<input type="radio" name="SpecialTemplate" value="4205"><span></span>
							</label>
						 </td>
						 <td class="hidden-xs-down">前沿讲座专题</td>
						 <td class="hidden-xs-down">前沿讲座专题</td>
						 <td class="hidden-xs-down"><a href="javascript:Preview2();"><img src="../images/v9_button_2.gif" title="预览" /></a></td>
					  </tr>
					  <tr>
						 <td class="">
							<label class="rdiobox mg-b-0">
								<input type="radio" name="SpecialTemplate" value="4227"><span></span>
							</label>
						 </td>
						 <td class="hidden-xs-down">长安论坛</td>
						 <td class="hidden-xs-down">长安论坛</td>
						 <td class="hidden-xs-down"><a href="javascript:Preview2();"><img src="../images/v9_button_2.gif" title="预览" /></a></td>
					  </tr>
					  <tr>
						 <td class="">
							<label class="rdiobox mg-b-0">
								<input type="radio" name="SpecialTemplate" value="4301"><span></span>
							</label>
						 </td>
						 <td class="hidden-xs-down">酷吧熊</td>
						 <td class="hidden-xs-down">酷吧熊</td>
						 <td class="hidden-xs-down"><a href="javascript:Preview2();"><img src="../images/v9_button_2.gif" title="预览" /></a></td>
					  </tr>
					  <tr>
						 <td class="">
							<label class="rdiobox mg-b-0">
								<input type="radio" name="SpecialTemplate" value="4335"><span></span>
							</label>
						 </td>
						 <td class="hidden-xs-down">中国音乐排行榜</td>
						 <td class="hidden-xs-down">中国音乐排行榜</td>
						 <td class="hidden-xs-down"><a href="javascript:Preview2();"><img src="../images/v9_button_2.gif" title="预览" /></a></td>
					  </tr>
					</tbody> 
				</table>
				</div>

				<div id="step2" style="display:none">
				<table class="table mg-b-0">
					<tr>
						<td align="right" class="hidden-xs-down">专题名称：</td>
						<td valign="middle">
							<label class="wd-230">
								<input type="text" name="NewChannelName" id="NewChannelName" class="form-control"/>
							</label>
						</td>
					</tr>
				</table>
				</div>
			</div>

			<div class="btn-box" >
      			<div class="modal-footer" >
					<input type="hidden" name="Parent" value="<%=ChannelID%>">
					<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
					<button name="startButton" type="button" class="btn btn-primary tx-size-xs" id="stepButton2" onClick="showStep(2)">下一步</button>
					<button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="submitButton" onClick="showStep(2)" style="display:none">确认</button>
					<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
				</div> 
			</div>
		</form>
	</div>
</body>
</html>
