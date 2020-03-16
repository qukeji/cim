<%@ page import="tidemedia.cms.system.*,
				java.sql.*,
				java.util.ArrayList"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	int		GlobalID			=	getIntParameter(request,"GlobalID");
	int		ChannelID		=	getIntParameter(request,"ChannelID");
	String	Keyword			= getParameter(request,"keyword");
	String	ByKeyword		= getParameter(request,"ByKeyword");
	String	ByTitle			= getParameter(request,"ByTitle");

	String url = CmsCache.getParameterValue("sys_related_doc_url");
	if(url.length()>0)
	{
		response.sendRedirect(url+"?GlobalID="+GlobalID+"&ChannelID="+ChannelID+"&keyword="+java.net.URLEncoder.encode(Keyword,"utf-8")+"&ByKeyword="+ByKeyword+"&ByTitle="+ByTitle);return;
	}
	//Keyword = new String(Keyword.getBytes("ISO-8859-1"),"UTF-8");
	ItemSnap item = new ItemSnap();
	item.setGlobalID(GlobalID);
//System.out.println(Keyword);
//System.out.println(new String(Keyword.getBytes("ISO-8859-1"),"UTF-8"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 相关文章</title>
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<link href="../style/9/main-content.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.sortable.js"></script>
<script language=javascript>
var ItemArray = new Array();
var CurrentID = 0;

function init()
{

}

function selectItem()
{
	var chk2=document.getElementsByName("chk2");
	//alert(chk2);
	if(chk1.checked && chk2)
	{
		for(var i=0;i<chk2.length;i++)
		{
			chk2[i].checked = true;
		}
	}
	else if(chk2)
	{
		for(var i=0;i<chk2.length;i++)
		{
			chk2[i].checked = false;
		}
	}
}

function getCheckedItem()
{
	var str = "";
	var chk2=document.getElementsByName("chk2");
	if(chk2)
	{
		for(var i=0;i<chk2.length;i++)
		{
			if(chk2[i].checked)
			{
				if(str=="")
					str += chk2[i].getAttribute("itemid");
				else
					str += "," + chk2[i].getAttribute("itemid");
			}
		}
	}
	//alert(str);
	return str;
}

</script>
</head>

<body style="background:none;">
<div class="viewpane_tbdoy">
<table width="100%" border="0"  id="oTable" class="view_table">
<thead>
<tr>
    				<th class="v1" width="25" align="center" valign="middle"><input name="input" type="checkbox" value=""  id="chk1" checked onclick="selectItem()"/></th>
    				<th class="v3" style="padding-left:10px;">标题</th>
    				<th class="v5" width="43" align="center" valign="middle">频道</th>
    				<th class="v7" width="64" align="center" valign="middle">全局编号 </th>
					<th class="v9" width="29" align="center" valign="middle">>></th>
  				</tr>
</thead>
<tbody>
<%
int j = 0;
ArrayList arraylist = item.listRelatedDoc();
for(int i=0;i<arraylist.size();i++)
{
	RelatedItem it = (RelatedItem)arraylist.get(i);
	j++;
%>
  <tr onDblClick ="double_click(this);">
    <td class="v1" width="25" align="center" valign="middle"><INPUT TYPE="checkbox" CHECKED  name="chk2" itemid="<%=it.getGlobalID()%>"></td>
    <td class="v3" style="font-weight:700;"><img src="../images/tree6.png" /><b><a href="document_preview.jsp?GlobalID=<%=it.getGlobalID()%>" target="_blank"><%=it.getTitle()%></a></b></td>
    <td class="v5" width="43" align="center" valign="middle" title="<%=it.getChannel().getParentChannelPath()%>">  <%=it.getChannel().getName()%></td>
    <td class="v6" width="64"><%=it.getGlobalID()%>4</td>
    <td class="v9" width="29">&nbsp;</td>
  </tr>
<%}%>
<%
j = 0;
ArrayList arraylist1 = item.listRelatedDocByKeyword(Keyword,arraylist,GlobalID,ChannelID,ByKeyword,ByTitle);
for(int i=0;i<arraylist1.size();i++)
{
	RelatedItem it = (RelatedItem)arraylist1.get(i);

	Channel ch = it.getChannel();

	if(ch.getTableName().equals("channel_video")) 
	{
		tidemedia.cms.video.Item vitem = new tidemedia.cms.video.Item(it.getItemID());
		if(vitem.getMediaType()!=3)
			continue;
	}
	j++;
%>
  <tr onDblClick ="double_click(this);">
    <td class="v1" width="25" align="center" valign="middle"><INPUT TYPE="checkbox" <%=(j<=4)?"CHECKED":""%>  name="chk2" itemid="<%=it.getGlobalID()%>"></td>
    <td class="v5"><img src="../images/tree6.png" /><a href="document_preview.jsp?GlobalID=<%=it.getGlobalID()%>" target="_blank"><%=it.getTitle()%></a></td>
    <td class="v5" width="43" align="center" valign="middle"  title="<%=ch.getParentChannelPath()%>"><%=ch.getName()%></td>
    <td class="v6" width="64"><%=it.getGlobalID()%></td>
    <td class="v9" width="29">&nbsp;</td>
  </tr>
<%}
if(arraylist.size()+arraylist1.size()==0){%><tr><td></td><td>没有相关文章.</td><td></td><td></td><td></td></tr><%}%>
</tbody>
</table>
</div>
<script>
jQuery("#oTable tbody").sortable({items:"tr",axis:"y"});
</script>
</body>
</html>