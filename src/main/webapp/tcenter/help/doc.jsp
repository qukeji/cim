<%@ page import="java.sql.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8">
<title>主页_帮助中心_tidemedia center</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<link href="../style/9/main-content.css" type="text/css" rel="stylesheet" />
<link href="../style/9/form-common.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
 
 <script type="text/javascript" src="../common/TideDialog.js"></script>
<script>
function downLoadFile(type)
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(270);
	dialog.setHeight(130);
	dialog.setUrl("help/download.jsp?type=" + type);
	dialog.setTitle("文档下载");
	dialog.show();
}


</script>
</head>

<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：产品文档</div>
</div>
<div class="content_2012">
<table width="100%" border="0" class="view_table">
	<tr>
    		<th class="v1">TideCMS</th>
  	</tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/tcenter/TideCMS编辑操作手册v1.01.20151105.doc')" target="_blank">TideCMS编辑操作手册v1.01.20151105.doc</a></td>
        </tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/tcenter/TideCMS系统管理员手册v1.06.20140207.doc')">TideCMS系统管理员手册v1.06.20140207.doc</a></td>
        </tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/tcenter/TideCMS模板编写参考指南v2.06.20151029.docx')">TideCMS模板编写参考指南v2.06.20151029.docx</a></td>
        </tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/tcenter/TideCMS接口文档.docx')">TideCMS接口文档.docx</a></td>
        </tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/tcenter/TideCMS二次开发参考指南v1.00.20140704.doc')">TideCMS二次开发参考指南v1.00.20140704.doc</a></td>
        </tr>
		
</table>
<br>
<br>
<table width="100%" border="0" class="view_table">
	<tr>
    		<th class="v1">TideVMS</th>
  	</tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/vms/TideVMS编辑操作手册v1.00.20150108.doc')">TideVMS编辑操作手册v1.00.20150108.doc</a></td>
        </tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/vms/TideVMS媒资管理系统操作手册v1.00.20150108.doc')">TideVMS媒资管理系统操作手册v1.00.20150108.doc</a></td>
        </tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/vms/TideVMS接口文档20141222.doc')">TideVMS接口文档20141222.doc</a></td>
        </tr>
		
</table>
<br>
<br>
<table width="100%" border="0" class="view_table">
	<tr>
    		<th class="v1">直播系统</th>
  	</tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/live/Tide直播系统编辑使用手册v1.00.20150202.docx')">Tide直播系统编辑使用手册v1.00.20150202.docx</a></td>
        </tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/live/Tide直播系统管理员使用手册v1.00.20150202.docx')">Tide直播系统管理员使用手册v1.00.20150202.docx</a></td>
        </tr>
		
</table>
<br>
<br>
<table width="100%" border="0" class="view_table">
	<tr>
    		<th class="v1">拆条系统</th>
  	</tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/air/Tide拆条系统编辑操作手册v1.00.20141222.doc')">Tide拆条系统编辑操作手册v1.00.20141222.doc</a></td>
        </tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/air/Tide拆条系统管理员手册v1.01.20150206.doc')">Tide拆条系统管理员手册v1.01.20150206.doc</a></td>
        </tr>
		
</table>
<br>
<br>
<table width="100%" border="0" class="view_table">
	<tr>
    		<th class="v1">统计系统</th>
  	</tr>
        <tr> 
                <td style="padding-bottom: 10px;padding-top: 10px;"><a href="javascript:downLoadFile('/tongji/Tide统计系统操作手册v1.00.20141228.docx')">Tide统计系统操作手册v1.00.20141228.docx</a></td>
        </tr>
		
</table>
</div>
</body>
</html>
