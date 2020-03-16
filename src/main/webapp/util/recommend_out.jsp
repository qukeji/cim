<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int itemid = getIntParameter(request,"ItemID");
int channelid = getIntParameter(request,"ChannelID");

Channel channel = CmsCache.getChannel(channelid);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/main-content.css" type="text/css" rel="stylesheet" />
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script language="javascript">
function out(itemid,channelid)
{
	document.location.href = "../content/recommend_out_index.jsp?ChannelID="+channelid+"&ItemID="+itemid;
}
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前文档：</div>
    <div class="content_new_post">
        <a href="javascript:out(<%=itemid%>,<%=channelid%>);" class="second">荐出</a>
    </div>
</div>
<div class="content-top">
	<div class="left"></div>
    <div class="right"></div>
</div>
<div class="content">
  	<div class="viewpane">
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v3" style="padding-left:10px;text-align:left;">标题</th>
    				<th class="v1" width="106" align="center" valign="middle">频道</th>
    				<th class="v5" width="43" align="center" valign="middle">状态</td>
    				<th class="v8" width="78" align="center" valign="middle">日期</th>
    				<th class="v4" width="46" align="left" valign="middle" style="padding-left:10px;">推荐人</th>
  				</tr>
</thead>
 <tbody> 
<%
String listSql = "select * from recommend where ChannelID="+channelid+" and SourceID="+itemid;

TableUtil tu = new TableUtil();

ResultSet Rs = tu.executeQuery(listSql);

while(Rs.next())
{
	int childGlobalID = Rs.getInt("ChildGlobalID");
	long date = Rs.getLong("CreateDate");
	//System.out.println(date);
	int userid = Rs.getInt("User");
	UserInfo user = (UserInfo)CmsCache.getUser(userid);
	Document item_ = new Document(childGlobalID);
	Channel ch = item_.getChannel();
%>
  <tr >
    <td class="v3" style="font-weight:700;"><img src="../images/tree6.png" /><%=item_.getTitle()%></td>
    <td class="v1" align="center" valign="middle"><%=ch.getParentChannelPath()%></td>
    <td class="v5" align="center" valign="middle"><%=item_.getStatusDesc()%></td>
    <td class="v8" ><%=Util.FormatTimeStamp("MM-dd HH:mm",date)%></td>
     <td class="v4" style="color:#666666;"><%=user.getName()%></td>
  </tr>
  <%}
tu.closeRs(Rs);
%>
 </tbody> 
</table>
<div style="position:absolute;right:0;top:120px;display:none;"  id="jTipId">
        <ul class="toolbar2">
               <!--<li><a href="#">归档</a></li> -->
                <li  class="first"><a href="javascript:approve();">审核</a></li>
                <li><a href="javascript:Publish();">发布</a></li>
                <li><a href="javascript:Preview();">预览</a></li>
                <li><a href="javascript:editDocument1();">编辑</a></li>
                <li class="last list" id="otherOperation2">
                	<p>其他<img src="../images/toolbar2_list.gif" /></p>
                    <ul id="ul1" style="display:none;">
                    	<li onclick="deleteFile();">删除</li>
                    	<li onclick="deleteFile2();">撤稿</li>
                        <!--<li class="list_no">内容复制</li>-->
                    </ul>
                </li>
            </ul>
    	</div>

        </div>          
  </div>
</div>
<div class="content_bot">
	<div class="left"></div>
    <div class="right"></div>
</div>
</body>
</html>