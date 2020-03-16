<%@ page import="java.io.*,tidemedia.cms.util.*,
				java.util.*,
				java.net.URL,
				tidemedia.cms.publish.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{out.close();return;}

String Action = getParameter(request,"Action");
int SiteId=Util.getIntParameter(request,"SiteId");

if(SiteId!=0){

tidemedia.cms.system.Site site=tidemedia.cms.system.CmsCache.getSite(SiteId);
String siteName=site.getName();
ArrayList publishSchemes=site.getPublishSchemes();

if(Action.equals("Del"))
{
	int id = getIntParameter(request,"id");

	PublishScheme pt = new PublishScheme();
	
	pt.setUserId(userinfo_session.getId());
	pt.Delete(id);
 //  CmsCache.getSite(SiteId).clearPublishSchemes();
	response.sendRedirect("setup.jsp?SiteId="+SiteId);return;
}


//InputStream in = getClass().getResourceAsStream("/cms.config.xml");
//Properties Props = new Properties();
//Props.load(in);

//String PublishMode = convertNull(Props.getProperty("PublishMode"));

String Publish = getParameter(request,"Publish");

if(!Publish.equals("")  && !userinfo_session.hasPermission("DisableChangePublish"))
{
	//Props.setProperty("PublishMode",Publish);

	URL path=this.getClass().getClassLoader().getResource("cms.config.xml");    
	FileOutputStream os = new FileOutputStream(path.getFile());
	//Props.store(os,"");
	os.close();
	
	//tidemedia.cms.system.Config config1 = new tidemedia.cms.system.Config();
//	config1.PublishMode = getIntParameter(request,"Publish");
//	application.setAttribute("Config",config1);
	response.sendRedirect("setup.jsp");return;
}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 列表</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script language=javascript>
	var myObject = new Object();
	myObject.title = "";

function Change(i)
{
	this.location.href = "setup.jsp?Publish="+i;
}

function addTask()
{
	var url="publish/publish_add.jsp?SiteId=<%=SiteId%>";
	var	dialog = new top.TideDialog();
		dialog.setWidth(680);
		dialog.setHeight(450);
		dialog.setUrl(url);
		dialog.setTitle("添加发布方案");
		dialog.show();
}

function editTask(id)
{
	var url="publish/publish_edit.jsp?id="+id;
	var	dialog = new top.TideDialog();
		dialog.setWidth(680);
		dialog.setHeight(450);
		dialog.setUrl(url);
		dialog.setTitle("编辑发布方案");
		dialog.show();
}

function testTask(id)
{
	var url="publish/publish_test.jsp?id="+id;
	var	dialog = new top.TideDialog();
		dialog.setWidth(450);
		dialog.setHeight(450);
		dialog.setUrl(url);
		dialog.setTitle("测试发布方案");
		dialog.show();
}

function Publish_Enable(id)
{
	
	var url = "change_status.jsp?Action=Enable&id="+id+"&SiteId=<%=SiteId%>";
	this.location.href = url;
	//$("#"+id).attr("disabled","disabled");
	
	
}

function Publish_Disable(id,o)
{
	var url = "change_status.jsp?Action=Disable&id="+id+"&SiteId=<%=SiteId%>";
	this.location.href = url;
}
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：<%=siteName%></div>
</div>
 
<div class="content_2012">
	
  	<div class="viewpane">
 
        <div class="viewpane_tbdoy">
<table width="100%" border="0" id="oTable" class="view_table">
<thead>
		<tr>
    				<th class="v1"	align="center" valign="middle" width="50">编号</th>
    				<th class="v8"  align="center" valign="middle">发布方案名</th>
					<th class="v8"  align="center" valign="middle">文件复制方式</th>
					<th class="v8"  align="center" valign="middle">目标</th>
    				<th class="v9" align="center" valign="middle" width="175">操作</th>
  				</tr>
</thead>
 <tbody>
<%
if(publishSchemes!=null && publishSchemes.size()>0)
{


	for(int j=0;j<publishSchemes.size();j++)
			{
			PublishScheme publishScheme=(PublishScheme)publishSchemes.get(j);
				String DestDesc = "";
				String CopyModeDesc = "";
				String Name = convertNull(publishScheme.getName());
				int Status =publishScheme.getStatus();
				int CopyMode =publishScheme.getCopyMode();
				if(CopyMode==1)
				{
					CopyModeDesc = "FTP上传";
					DestDesc = convertNull(publishScheme.getServer());
				}
				else if(CopyMode==2)
				{					
					CopyModeDesc = "文件拷贝";
					DestDesc = convertNull(publishScheme.getDestFolder());
				}
				else if(CopyMode==3)
				{					
					CopyModeDesc = "S3云存储";
					//DestDesc = convertNull(publishScheme.getDestFolder());
				}
				else if(CopyMode==4)
				{					
					CopyModeDesc = "OpenStack云存储";
					//DestDesc = convertNull(publishScheme.getDestFolder());
				}
				else if(CopyMode==5)
				{					
					CopyModeDesc = "阿里云存储";
					//DestDesc = convertNull(publishScheme.getDestFolder());
				}
				else if(CopyMode==6)
				{					
					CopyModeDesc = "百度云存储";
					//DestDesc = convertNull(publishScheme.getDestFolder());
				}

				int id =publishScheme.getId();

			
%>
  <tr>
	<td class="v1" align="center" valign="middle"><%=id%></td>
    <td class="v8"><%=Name%></td>
     <td class="v4"  style="color:#666666;"><%=CopyModeDesc%></td>
	 <td class="v4"  style="color:#666666;"><%=DestDesc%></td>
	<td class="v9">
	<div type="button" name=""  class="tidecms_btn <%=Status==0?"":"disabled"%>" onClick="Publish_Enable(<%=id%>)" style="padding: 0 5px;"id="<%=id%>"><div class="t_btn_txt">启动</div></div>
	<div type="button" name=""  class="tidecms_btn <%=Status==1?"":"disabled"%>" onClick="Publish_Disable(<%=id%>,this)" style="padding: 0 5px;"><div class="t_btn_txt">禁止</div></div>
				<%if(!userinfo_session.hasPermission("DisableEditPublishScheme")){%><input type="button" name="" class="submit" value="编辑"onClick="editTask(<%=id%>)"></input><%}%>
				<input type="button" name="" value="删除" class="submit" onClick="if(confirm('你确认要删除吗?')) location='setup.jsp?Action=Del&id=<%=id%>&SiteId=<%=SiteId%>'; else return false;"/>
				<%if(CopyMode==1){%><input type="button" name="" value="测试" class="submit" onClick="testTask(<%=id%>)"/><%}%>
	</td>
  </tr>
<%
			}
}

%>

   <tr>
	<td class="v1" align="center" valign="middle">……</td>
    <td class="v8">……</td>
    <td class="v4" style="color:#666666;">……</td>
	<td class="v4" style="color:#666666;">……</td>
	<td class="v9"><%if(!userinfo_session.hasPermission("DisableAddPublishScheme")){%><input name="Button4" type="button" class="submit" value="添加新发布方案" onClick="addTask();"><%}%></td>
  </tr>

 </tbody> 
</table>
        </div>   
        <div class="viewpane_pages"> </div>
  </div>
</div>
 
<!--16ms-->
</body>
</html>
<%}//end if(SiteId!=0){%>