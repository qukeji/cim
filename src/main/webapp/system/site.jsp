<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.util.Util"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int isreload=Util.getIntParameter(request,"isreload");
if(isreload==1){
 out.print("<script>top.tidecms.getLeftIfm().location.reload();</script>");
}
int id=Util.getIntParameter(request,"id");

Site site = new Site();

if(id!=0)
     site=CmsCache.getSite(id);

String imagedesc = "";
if(site.getImageFolderType()==0)
	imagedesc = "系统默认";
else if(site.getImageFolderType()==1)
	imagedesc = "按年份命名，每年一个目录";
else if(site.getImageFolderType()==2)
	imagedesc = "按年月命名，每月一个目录";
else if(site.getImageFolderType()==3)
	imagedesc = "按年月日命名，每日一个目录";
else if(site.getImageFolderType()==4)
	imagedesc = "按每天一个目录";

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script language=javascript>
function newSite()
{
	var url='system/site_add.jsp';
	var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(200);
		dialog.setUrl(url);
		dialog.setTitle("新建站点");
		dialog.show();
}

function edit()
{
	this.location='site_edit.jsp?id=<%=id%>';
}

function delSite()
{
  var bln = window.confirm("你确认要删除吗?");   
  if(bln){
   this.location='site_delete.jsp?id=<%=id%>';
  }
}

function apache()
{
	$("#notify").html("<font color='red'><b>正在配置...</b></font>");
	jQuery.ajax({
	 type:"get",
	 dataType :"json",
	 url:"site_apache.jsp?site=<%=id%>",
	 success:function(o){
		 if(o.status==0)
		 {
			 $("#notify").html("<font color='red'><b>配置失败："+o.msg+"</b></font>");
		 }
		 else if(o.status==1)
		 {
			$("#notify").html("<font color='red'><b>配置完成，未重启apache</b></font>");
		 }
		 else if(o.status==2)
		 {
			$("#notify").html("<font color='red'><b>配置完成，并重启apache</b></font>");
		 }
		 setTimeout("$('#notify').html('');",3000*1);
	 } 
	}); 
}

$(function(){
	$.getJSON("site_status.jsp?id=<%=id%>", function(o){
	  if(o)$("#code1").html(o.code1);
	  if(o)$("#code2").html(o.code2);
	}); 
 });
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">  
<div class="content_t1">
	<div class="content_t1_nav">站点名称：<%=site.getName()%> <span id="notify"></span></div>
    <div class="content_new_post">

		<!-- <div class="top_button button_inline_block" onClick="newSite();">
			<div class="top_button_outer button_inline_block">
				<div class="top_button_inner button_inline_block">
					<span class="img"><img src="../images/icon/add.png" /></span>
					<span class="txt">新建</span>
				</div>
			</div>
		</div> -->
		<div class="tidecms_btn" onClick="newSite();">
			<div class="t_btn_pic"><img src="../images/icon/add.png" /></div>
			<div class="t_btn_txt">新建</div>
		</div>

    </div>
</div>

 
<div class="content_2012">
  	<div class="viewpane">
        <div class="viewpane_tbdoy">
            <table width="100%" border="0" id="oTable" class="view_table">
			<thead>
				<tr>
    				<th class="v1" width="25" align="center" valign="middle">&nbsp;</th>
    				<th class="v3" style="padding-left:10px;text-align:left;">&nbsp;</th>
  				</tr>
			</thead>
			<tbody>
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">本地站点目录：</div></td>
                <td width="422"><%=site.getSiteFolder()%></td>
              </tr>
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">本地站点地址：</div></td>
                <td width="422"><a href="<%=site.getUrl()%>" target="_blank"><%=site.getUrl()%></a> <span id="code1"></span> <a href="javascript:apache()">配置apache</a></td>
              </tr>
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">外部站点地址：</div></td>
                <td width="422"><a href="<%=site.getExternalUrl()%>" target="_blank"><%=site.getExternalUrl()%></a> <span id="code2"></span></td>
              </tr>
              <%if(site.getType()!=0){%>  
              <tr class="rows1"> 
               <td width="153" > 
                  <div align="right">管理员Email：</div></td>
                <td width="422"></td> 
              </tr>
           
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">备份文件目录：</div></td>
                <td width="422"><%=site.getBackupFolder()%></td>
              </tr>
			  <%}%>
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">内容管理对应频道标识：</div></td>
                <td width="422"><%=site.getContentChannelSerialNo()%></td>
              </tr>
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">图片目录：</div></td>
                <td width="422"><%=site.getImageFolder()%></td>
              </tr>
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">图片目录规则：</div></td>
                <td width="422"><%=imagedesc%></td>
              </tr>
			  <%if(site.getType()!=0){%> 
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">静态发布时页面扩展名：</div></td>
                <td width="422"><%=site.getFileExt()%></td>
              </tr>
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">后台发布周期：</div></td>
                <td width="422"><%=site.getSleepTime()%>分钟</td>
              </tr>
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">文件默认编码：</div></td>
                <td width="422"><%=site.getCharset()%></td>
              </tr>
     
              <tr class="rows1"> 
                <td width="153" > 
                  <div align="right">其他模块链接地址：</div></td>
                <td width="422"><%=site.getOtherModuleAddress()%></td>
              </tr>
       <%} %>       
              <tr class="rows1"> 
                <td width="153" ></td>
                <td width="422">
                  <%if(!userinfo_session.hasPermission("DisableChangeConfig")){%>
                  <input type="button" name="button1" class="tidecms_btn2" value="编辑" onClick="edit();">
                        <%if(site.getType()==0){%>  
                  <input type="button" name="button1" class="tidecms_btn2" value="删除" onClick="delSite();">
                         <%}%>
                  <%}%></td>
              </tr>
			  </tbody>
            </table>
</div>
</div>
</div>

 
</body>
</html>
