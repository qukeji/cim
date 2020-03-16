<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.user.*,
				java.util.ArrayList,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
	int		ChannelID				= getIntParameter(request,"ChannelID");
	int		ItemID					= getIntParameter(request,"ItemID");
	int		RecommendItemID			= getIntParameter(request,"RecommendItemID");
	int		RecommendChannelID		= getIntParameter(request,"RecommendChannelID");
	int		RecommendOutItemID		= getIntParameter(request,"ROutItemID");
	int		RecommendOutChannelID	= getIntParameter(request,"ROutChannelID");
	int		parentGlobalID			= getIntParameter(request,"pid");

	int		FieldSize				= getIntParameter(request,"FieldSize");

	if(FieldSize==0)	FieldSize	= 80;

	int ContinueNewDocument			= getIntParameter(request,"ContinueNewDocument");
	int NoCloseWindow				= getIntParameter(request,"NoCloseWindow");
	String From						= getParameter(request,"From");

	int GlobalID					= 0;

	ChannelPrivilege cp = new ChannelPrivilege();
	if(!cp.hasRight(userinfo_session,ChannelID,2))
	{
		response.sendRedirect("../close_pop.jsp");return;
	}


	Document item = null;
	Channel channel = CmsCache.getChannel(ChannelID);

	if(channel.getDocumentProgram().length()>0)
		response.sendRedirect(channel.getDocumentProgram()+"?ChannelID="+ChannelID+"&ItemID="+ItemID);

	if(channel.isVideoChannel())
	{
		response.sendRedirect("../video/document.jsp?ItemID="+ItemID+"&ChannelID="+ChannelID);return;
	}

	if(ItemID>0)
		item = new Document(ItemID,ChannelID);
	
	if(item!=null)
		GlobalID = item.getGlobalID();
	
	ArrayList fieldGroupArray = channel.getFieldGroupInfo();
	String SiteAddress = channel.getSite().getUrl();

	String check2 = "";

	boolean editCategory = false;

	if(channel.isTableChannel() && channel.getType2()==8) editCategory = true;

	String userGroup = "";

	try{
		userGroup = new UserGroup(userinfo_session.getGroup()).getName();
	}
	catch(Exception e){}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>内容编辑 - <%=item!=null?item.getTitle():"新建文档"%> TideCMS</title>
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<link href="../style/9/edit-content.css" type="text/css" rel="stylesheet" />

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="init();">
<textarea cols="120" rows="30">

<div class="edit-main">
	<div class="edit-nav">
    	<ul>
<%for (int i = 0; i < fieldGroupArray.size(); i++) 
{
	FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
%>
        	<li>
			<a href="javascript:showTab('<%=i+1%>')" <%=(i==0?"class='cur'":"")%> id="form<%=i+1%>_td" groupid="<%=fieldGroup.getId()%>">
			<span ><%=fieldGroup.getName()%></span></a></li>
<%}%>
        </ul>
        <div class="clear"></div>
    </div>

    <div class="edit-con">
    	<div class="top">
        	<div class="left"></div>
            <div class="right"></div>
        </div>
<%
int j = 0;
do
//for (int j = 0; j < fieldGroupArray.size(); j++) 
{
FieldGroup fieldGroup = null;
int fieldGroupID = 0;
if(fieldGroupArray.size()>0) 
{
	fieldGroup = (FieldGroup) fieldGroupArray.get(j);
	fieldGroupID = fieldGroup.getId();
}

String url = "";
if(fieldGroupArray.size()>0) 
{
	url = fieldGroup.getUrl().replace("$globalid",GlobalID+"");
	url = url.replace("$itemid",ItemID+"");
}
out.println("<div class=\"center\" url=\""+url+"\" id=\"form"+(j+1)+"\" "+(j!=0?"style=\"display:none;\"":"")+">");

if(fieldGroupID>0 && !fieldGroup.getUrl().equals(""))
	{
out.println("<iframe id=\"iframe"+(j+1)+"\" frameborder=\"0\" style=\"width:100%;height:500px\" marginheight=\"0\" marginwidth=\"0\" scrolling=\"auto\" src=\"../null.jsp\"></iframe>");
	}
else
	{
%>
        
		<table width="100%">
<%if(j==0){%>
<tr><td><div class="line" id="tr_Title"><%=channel.getFieldByFieldName("Title").getDescription()%>：</div></td><td><div class="line" id="field_Title"><input type="text" class="textfield" size="80" id="Title" name="Title" value="<%=item!=null?Util.HTMLEncode(item.getValue("Title")):""%>" onkeyup="checkTitle();">	<span id="TitleCount"></span>&nbsp;&nbsp;&nbsp;&nbsp;<%if(editCategory){%>分类：<select name="ChannelID" id="ChannelID">
<%ArrayList categorys = channel.listAllSubChannels(Channel.Category_Type);if(categorys!=null && categorys.size()>0){for(int i = 0;i<categorys.size();i++){Channel subcategory = (Channel)categorys.get(i);%>
                    <option value="<%=subcategory.getId()%>" <%=(item!=null&&subcategory.getId()==item.getCategoryID())?"selected":""%>><%=subcategory.getName()%></option>
<%}}%>
                  </select><%}%></div></td></tr>
<%}%>
<%

//FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(j);
ArrayList arraylist = channel.getFieldsByGroup(fieldGroupID,j);
//System.out.println(j+":"+arraylist.size());
int jj = 0;
for (int i = 0; i < arraylist.size(); i++) 
{
	Field field = (Field)arraylist.get(i);
	if(channel.isShowField(field.getName()) && field.getIsHide()==0)
	{
		if(field.getDisableBlank()==1)
		{
			check2 += "	if(isEmpty(document.form." + field.getName() + ",'请输入" + field.getDescription() + ".'))";
			check2 += "	return false;";
		}
%>
			<%if(field.getName().equalsIgnoreCase("Content")){%>
<tr><td colspan="2">
<div class="edit">
					<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath	= '../editor/' ;
oFCKeditor.Height	= 400 ;
//oFCKeditor.Config['FullPage'] = true ;
<%if(item!=null){item.setCurrentPage(1);%>var currcontent = '<%=Util.JSQuote(item.getContent())%>';//Oracle not need JsQuote;
<%if(!SiteAddress.equals("")){%>currcontent = currcontent.replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/' ) ;<%}%>
oFCKeditor.Value	= currcontent ;<%}%>
var ChannelID=<%=ChannelID%>;
oFCKeditor.Create() ;
//-->
		</script>
<table id="tabTable" STYLE="width:100%;height:20px;" CELLPADDING=0 CELLSPACING=0>
	<tr id="tabTableRow" onclick="changeTabs()">
		<td id="t1" class="selTab" page="1" height="20">第1页</td>
	</tr>
</table>
	<input type="button" value="删除当前页" onclick="DeletePage();" class="textfield">
	<input type="button" value="插入一页" onclick="AddPage();" class="textfield">&nbsp;&nbsp;&nbsp;
</div>
</td></tr>
<%}else if(field.getFieldType().equals("label")){%>
	<tr><td><div class="line"><%if(!field.getFieldType().equals("label")){%><%=field.getDescription()%>：<%}%></div></td><td><div class="line"><%=field.getOther()%></div></td></tr>
	<%}else{%>
	<%if(field.getName().equals("PublishDate")){%>
	<tr><td><div class="line"><%=field.getDescription()%>：</div></td><td><div><%=field.getDisplayHtml(item!=null?item.getPublishDate():Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"))%>&nbsp;&nbsp;<%=channel.getFieldByFieldName("Weight").getDisplayHtml(item!=null?item.getWeight()+"":"")%></div></td></tr>
	<%}else if(field.getName().equals("Keyword")){%>
	<tr id="tr_<%=field.getName()%>"><td><div class="line"><%=field.getDescription()%>：</div></td><td><div class="line" id="field_<%=field.getName()%>"><%=field.getDisplayHtml(item!=null?item.getValue(field.getName()):"")%>
	</td></tr>
	<tr><td>&nbsp;</td><td>
	<input type="text" class="textfield" size="80" name="ByKeywordText" value="<%=(item!=null?item.getValue(field.getName()):"")%>">
	<input name="kewwordselect" type="button" class="tidecms_btn3" value="查询" onclick="selectByKeyword()">	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	关键词<input type=checkbox name="ByKeyword" id="ByKeyword" value="1" class="textfield" checked>
	标题<input type=checkbox name="ByTitle" id="ByTitle" value="1" class="textfield" checked></div></td></tr>
	<tr valign="top"><td><div class="line">相关文章：</div></td><td><iframe id="related_doc_list" frameborder="0" height="400" width="650" marginheight="0" marginwidth="0" scrolling="auto" src="../content/related_doc_list.jsp?GlobalID=<%=item!=null?(item.getGlobalID()):""%>&ChannelID=<%=ChannelID%>"></iframe></td></tr>
	<%}else if(field.getName().equals("Keyword2")){%>
	<tr><td><div class="line"><%=field.getDescription()%>：</div></td><td><div class="line"><%=field.getDisplayHtml(item!=null?item.getValue(field.getName()):"")%><input name="kewwordselect" type="button" class="tidecms_btn3" value="按关键词选择" onclick="selectByKeyword2()"></div></td></tr>
	<tr><td>相关视频：</td><td><iframe id="related_video_list" frameborder="0" height="400" width="650" marginheight="0" marginwidth="0" scrolling="auto" src="../video/related_video_list.jsp?id=<%=ItemID%>&ChannelID=<%=ChannelID%>"></iframe></td></tr>
	<%}else{
		if(field.getHtmlTemplate().length()>0){%>
		<%=field.getDisplayHtmlTemplate(item!=null?item.getValue(field.getName()):"")%>
		<%}else{%>
	<tr id="tr_<%=field.getName()%>"><td>
	<div class="line"><%=field.getDescription()%>：</div></td><td><div class="line" id="field_<%=field.getName()%>"><%=field.getDisplayHtml("<%=item!=null?item.getValue(\""+field.getName()+"\"):\"\"%\>")%></div>
	</td></tr><%}}%><%}%><%}}%>
	
	</table>
<%}out.println("</div>");j++;}while(j < fieldGroupArray.size());%>
        <div class="bot">
        	<div class="left"></div>
            <div class="right"></div>
        </div>
    </div>
</div>
</textarea>

<form action="form_tools.jsp" method="_get">
<input type="text" name="ChannelID" value="<%=ChannelID%>">
<input typ="text" name="FieldSize" value="80">
<input type="submit">
</form>
</body>
</html>