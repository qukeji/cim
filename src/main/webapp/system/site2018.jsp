<%@ page import = "java.sql.*,
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
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<!--<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">-->
<link href="../style/2018/bracket.css" rel="stylesheet" >
<link href="../style/2018/common.css" rel="stylesheet">
<script src="../lib/2018/jquery/jquery.js"></script>
<script>			     
				
    function newSite() {
        var url = 'site_add2018.jsp';
        var dialog = new top.TideDialog();
        dialog.setWidth(350);
        dialog.setHeight(330);
        dialog.setUrl(url);
        dialog.setTitle("新建站点");
        dialog.show();
    }

    function edit() {
        this.location = 'site_edit2018.jsp?id=<%=id%>';
    }
	function delSite() {
	    var url = "site_delete2018.jsp?id="+<%=id%>;
        var dialog = new top.TideDialog();
        dialog.setWidth(320);
        dialog.setHeight(260); 
		//dialog.setSuffix('_2');
        dialog.setUrl(url);							
        dialog.setTitle("删除站点");							
        dialog.show();
    }
     
    /* function delSite() {
        if(confirm('你确认要删除吗?'))
       {
            this.location = "site_delete.jsp?id=<%=id%>;
        }
    } */

    function apache() {
        $("#notify").html("<font color='red'><b>正在配置...</b></font>");
        jQuery.ajax({
            type: "get",
            dataType: "json",
            url: "site_apache.jsp?site=<%=id%>",
            success: function(o) {
                if (o.status == 0) {
$("#notify").html("<font color='red'><b>配置失败：" + o.msg + "</b></font>");
                } else if (o.status == 1) {
$("#notify").html("<font color='red'><b>配置完成，未重启apache</b></font>");
                } else if (o.status == 2) {
$("#notify").html("<font color='red'><b>配置完成，并重启apache</b></font>");
                }
                setTimeout("$('#notify').html('');", 3000 * 1);
            }
        });
    }

    $(function() {
        $.getJSON("site_status.jsp?id=<%=id%>", function(o) {
            if (o) $("#code1").html(o.code1);
            if (o) $("#code2").html(o.code2);
        });
    });
</script>
<style>
    .collapsed-menu .br-mainpanel-file {
        margin-left: 0;
        margin-top: 0;
    }
</style>
</head>
<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active">站点管理 / 内容站点管理 / <%=site.getName()%><span id="notify"></span></span>
        </nav>
        <div class="btn-group mg-l-auto hidden-xs-down">
            <a href="javascript:;" class="btn btn-info mg-b-10" onClick="newSite();">新建站点</a>
        </div>
    </div>
    <!-- br-pageheader -->

    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <div class="card bd-0 shadow-base">
            <table class="table mg-b-0" id="content-table">
                <thead>
					<tr>
						<th class="tx-12-force tx-mont tx-medium wd-50p"> </th>
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-50p" style="padding-left:10px;text-align:center;"> </th>
					</tr>
					</thead>
				<tbody>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">站点编号：</td>
						<td class="hidden-xs-down">
							<%=id%>
						</td>
					</tr>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">站点类型：</td>
						<td class="hidden-xs-down">
							<%if(site.getSiteType()==0){%>
							      其他
							<%}else if(site.getSiteType()==1){%>
							      APP
							<%}else{%>
							      网站
							<%}%>
					</tr>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">本地站点目录：</td>
						<td class="hidden-xs-down">
							<%=site.getSiteFolder()%>
						</td>
					</tr>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">本地站点地址：</td>
						<td class="hidden-xs-down">
							<a href="<%=site.getUrl()%>" target="_blank">
								<%=site.getUrl()%>
							</a> <span id="code1"></span> <a href="javascript:apache()">配置apache</a></td>
					</tr>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">外部站点地址：</td>
						<td class="hidden-xs-down">
							<a href="<%=site.getExternalUrl()%>" target="_blank">
								<%=site.getExternalUrl()%>
							</a> <span id="code2"></span></td>
					</tr>
					
					<%if(site.getType()!=0){%>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">管理员Email：</td>
						<td class="hidden-xs-down">
							<%=CmsCache.getExpiresDateStr()%>
						</td>
					</tr>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">备份文件目录：</td>
						<td class="hidden-xs-down"><%=site.getBackupFolder()%></td>
					</tr>
    				<%}%>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">内容管理对应频道标识：</td>
						<td class="hidden-xs-down"><%=site.getContentChannelSerialNo()%></td>
					</tr>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">图片目录：</td>
						<td class="hidden-xs-down"><%=site.getImageFolder()%></td>
					</tr>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">图片目录规则：</td>
						<td class="hidden-xs-down"><%=imagedesc%></td>
					</tr>
        			<%if(site.getType()!=0){%>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">静态发布时页面扩展名：</td>
						<td class="hidden-xs-down"><%=site.getFileExt()%></td>
					</tr>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">后台发布周期：</td>
						<td class="hidden-xs-down"><%=site.getSleepTime()%>分钟</td>
					</tr>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">文件默认编码：</td>
						<td class="hidden-xs-down"><%=site.getCharset()%></td>
					</tr>
					<tr>
						<td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">其他模块链接地址：</td>
						<td class="hidden-xs-down"><%=site.getOtherModuleAddress()%></td>
					</tr>
            		<%}%>
					<tr>
						<td class="hidden-xs-down" colspan="2" style="text-align:center">
							<%if(!userinfo_session.hasPermission("DisableChangeConfig")){%>
								<button name="button1" type="button" class="btn btn-primary tx-size-xs" onClick="edit();">编辑</button>
								<%if(site.getType()==0){%>
									<button name="button1" type="button" onClick="delSite();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">删除</button>
									<%}%>
										<%}%>
						</td>
					</tr>
                </tbody>
            </table>
        </div>
    </div>
    <!--列表-->
</div>
</body>
</html>
