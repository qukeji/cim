<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				tidemedia.cms.util.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
 *	姓名		日期		备注
 *	
 *	王海龙		20131231	添加采集周期字段
 */
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
Spider  s = new Spider(id);

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	Name			= getParameter(request,"Name");
	int		Channel			= getIntParameter(request,"Channel");
	String	Url				= getParameter(request,"Url");
	String	Url_First		= getParameter(request,"Url_First");
	String	ListStart		= getParameter(request,"ListStart");
	String	ListEnd			= getParameter(request,"ListEnd");
	String	ListReg			= getParameter(request,"ListReg");
	String	Charset			= getParameter(request,"Charset");
	String	ItemCharset		= getParameter(request,"ItemCharset");
	String	HrefReg			= getParameter(request,"HrefReg");
	String	ImageFolder		= getParameter(request,"ImageFolder");
	String	Program			= getParameter(request,"Program");
	String	TitleKeyword    = getParameter(request,"TitleKeyword");
	int		GroupID			= getIntParameter(request,"GroupID");
	int		ItemStatus		= getIntParameter(request,"ItemStatus");
	int		ItemGid		= getIntParameter(request,"ItemGid");
	int		IsDownloadImage	= getIntParameter(request,"IsDownloadImage");
    int		Period		= getIntParameter(request,"Period");
    
    String transfer = getParameter(request,"transfer");
	
	s.setName(Name);
	s.setChannel(Channel);
	s.setUrl(Url);
	s.setUrl_First(Url_First);
	s.setListStart(ListStart);
	s.setListEnd(ListEnd);
	s.setListReg(ListReg);
	s.setCharset(Charset);
	s.setItemCharset(ItemCharset);
	s.setHrefReg(HrefReg);
	s.setImageFolder(ImageFolder);
	s.setProgram(Program);
	s.setItemStatus(ItemStatus);
	s.setIsDownloadImage(IsDownloadImage);
	s.setGroup(GroupID);
	s.setTitleKeyword(TitleKeyword);
    s.setPeriod(Period);
	s.setIsGlobalID(ItemGid);

	s.setTransfer(transfer);
	
	s.Update();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/form-common.css" rel="stylesheet" />
<link href="../style/9/dialog.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script language=javascript>
function init()
{
	document.form.Code.focus();
}

function check()
{
	if(isEmpty(document.form.Code,"请输入代码."))
		return false;

	//document.form.Button2.disabled  = true;

	return true;
}
</script>
</head>
<body>
<form name="form" action="spider_edit.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
  <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><input type=text name="Name" class="textfield" value="<%=s.getName()%>"></td>
  </tr>
  <tr>
    <td align="right" valign="middle">转载地址：</td>
    <td valign="middle">
	<textarea name=transfer id="transfer" cols=46 rows=4 class="textfield"><%=s.getTransfer()%></textarea><br>(每行一个地址)
	</td>
  </tr>
  <tr>
    <td align="right" valign="middle">采集地址：</td>
    <td valign="middle">
	<textarea name="Url" id="Url" cols=46 rows=4 class="textfield"><%=s.getUrl()%></textarea>
	</td>
  </tr>
  <tr>
    <td align="right" valign="middle">一次性采集地址：</td>
    <td valign="middle">
	<textarea name="Url_First" id="Url_First" cols=46 rows=4 class="textfield"><%=s.getUrl_First()%></textarea>
	</td>
  </tr>
  <tr>
    <td align="right" valign="middle">列表开始代码：</td>
    <td valign="middle"><textarea name="ListStart" cols=46 rows=4 class="textfield"><%=s.getListStart()%></textarea></td>
  </tr>
  <tr>
    <td align="right" valign="middle">列表结束代码：</td>
    <td valign="middle"><textarea name="ListEnd" cols=46 rows=4 class="textfield"><%=s.getListEnd()%></textarea></td>
  </tr>
  <tr>
    <td align="right" valign="middle">标题关键词：</td>
    <td valign="middle"><textarea name="TitleKeyword" cols=46 rows=4 class="textfield"><%=s.getTitleKeyword()%></textarea><br/><br/>
	关键词用逗号分隔，填写以后只采集标题含有关键词的文章。</td>
  </tr>
  <tr>
    <td align="right" valign="middle">列表正则表达式：</td>
    <td valign="middle"><textarea name="ListReg" cols=46 rows=4 class="textfield"><%=s.getListReg()%></textarea></td>
  </tr>
  <tr>
    <td align="right" valign="middle">链接正则表达式：</td>
    <td valign="middle"><input type="text" name="HrefReg" id="HrefReg" size="32" class="textfield" value="<%=Util.HTMLEncode(s.getHrefReg())%>"/>(为空使用默认值)</td>
  </tr>
  <tr>
    <td align="right" valign="middle">内容分析代理程序：</td>
    <td valign="middle"><input type="text" name="Program" id="Program" size="32" class="textfield" value="<%=s.getProgram()%>"/></td>
  </tr>
  <tr>
    <td align="right" valign="middle">列表页编码：</td>
    <td valign="middle">
	<select name="Charset">
	<option <%=(s.getCharset().equals("utf-8")?"selected='selected'":"")%> value="utf-8">Unicode(UTF-8)</option>
	<option <%=(s.getCharset().equals("gb2312")?"selected='selected'":"")%> value="gb2312">简体中文(GB2312)</option>
	</select>
	</td>
  </tr>
  <tr>
    <td align="right" valign="middle">内容页编码：</td>
    <td valign="middle">
	<select name="ItemCharset">
	<option <%=(s.getItemCharset().equals("utf-8")?"selected='selected'":"")%> value="utf-8">Unicode(UTF-8)</option>
	<option <%=(s.getItemCharset().equals("gb2312")?"selected='selected'":"")%> value="gb2312">简体中文(GB2312)</option>
	</select>
	</td>
  </tr>
  <tr>
    <td align="right" valign="middle">对应频道编号：</td>
    <td valign="middle"><input type="text" name="Channel" id="Channel" class="textfield" value="<%=s.getChannel()%>"/></td>
  </tr>
  <tr>
    <td align="right" valign="middle">图片路径：</td>
    <td valign="middle"><input type="text" name="ImageFolder" id="ImageFolder" class="textfield" value="<%=s.getImageFolder()%>"/></td>
  </tr>
   <tr>
    <td align="right" valign="middle">采集周期：</td>
    <td valign="middle"><input type="text" name="Period" id="Period" class="textfield" value="<%=s.getPeriod()%>"/>分钟</td>
  </tr>
  <tr>
    <td align="right" valign="middle">图片是否本地化：</td>
    <td valign="middle">
	<input type="radio" name="IsDownloadImage" value="1" <%=s.getIsDownloadImage()==1?"checked":""%> id="IsDownloadImage_1"><label for="IsDownloadImage_1">需要</label>
	<input type="radio" name="IsDownloadImage" value="0" <%=s.getIsDownloadImage()==0?"checked":""%> id="IsDownloadImage_0"><label for="IsDownloadImage_0">不需要</label>
	</td>
  </tr>
  <tr>
    <td align="right" valign="middle">文档默认状态：</td>
    <td valign="middle">
	<input type="radio" name="ItemStatus" value="1" <%=s.getItemStatus()==1?"checked":""%> id="ItemStatus_1"><label for="ItemStatus_1">已发</label>
	<input type="radio" name="ItemStatus" value="0" <%=s.getItemStatus()==0?"checked":""%> id="ItemStatus_0"><label for="ItemStatus_0">草稿</label>
	</td>
  </tr>
  <tr>
    <td align="right" valign="middle">否需要文章编号：</td>
    <td valign="middle">
	<input type="radio" name="ItemGid" value="1" <%=s.getIsGlobalID()==1?"checked":""%> checked id="ItemStatus_1"><label for="ItemStatus_1">是</label>
	<input type="radio" name="ItemGid" value="0" <%=s.getIsGlobalID()==0?"checked":""%> id="ItemStatus_0"><label for="ItemStatus_0">否</label>
	</td>
  </tr>
   <tr>
    <td align="right" valign="middle">组名：</td>
    <td valign="middle"> <select name="GroupID">
             <option value="0">请选择</option>
            <%
            SpiderGroup userGroup=new SpiderGroup();
            List groups=userGroup.getGroups();
            Iterator iter=groups.iterator();
            while(iter.hasNext()){
            SpiderGroup  groupOne=(SpiderGroup)iter.next();
            if(groupOne.getId()!=s.getGroup()){
                        out.println("<option value=\""+groupOne.getId()+"\">"+groupOne.getName()+"</option>");
            }else{
            out.println("<option value=\""+groupOne.getId()+"\"  selected>"+groupOne.getName()+"</option>");
            }
            }
             %> 
             </select></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>

<div class="form_button">
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
<input type="hidden" name="Submit" value="Submit">
<input type="hidden" name="id" value="<%=id%>">
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>
