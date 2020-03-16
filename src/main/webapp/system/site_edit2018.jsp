<%@ page import="java.io.*,
				java.util.*,
				java.net.URL,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.Util"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!(new UserPerm().canEditConfig(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

int id =Util.getIntParameter(request,"id");
//Site site=new Site(id);
Site site=CmsCache.getSite(id);

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
//	String			=	getParameter(request,"");
    System.out.println("id------我是站点--------"+id);
     site.setId(id);
     site.setName(Util.getParameter(request,"Name"));
	 site.setSiteFolder(Util.getParameter(request,"SiteFolder"));
	 System.out.println("SiteType="+Util.getIntParameter(request, "SiteType"));
	 site.setSiteType(Util.getIntParameter(request, "SiteType"));
	 site.setUrl(Util.getParameter(request,"SiteAddress"));
	 site.setExternalUrl(Util.getParameter(request,"ExternalUrl"));
	 site.setTemplateFolder(Util.getParameter(request,"TemplateFolder"));
	 site.setBackupFolder(Util.getParameter(request,"BackupFolder"));
	 site.setFileExt(Util.getParameter(request,"FileExt"));
	 site.setSleepTime(Util.getIntParameter(request,"SleepTime"));
	 site.setCharset(Util.getParameter(request,"Charset"));
	 site.setOtherModuleAddress(Util.getParameter(request,"OtherModuleAddress"));
	 site.setContentChannelSerialNo(Util.getParameter(request,"ContentChannelSerialNo"));
	 site.setImageFolder(Util.getParameter(request,"ImageFolder"));
	 site.setImageFolderType(Util.getIntParameter(request,"ImageFolderType"));
	 site.setActionUser(userinfo_session.getId());
	 site.Update();
	response.sendRedirect("site2018.jsp?id="+id+"&isreload=1");return;
}

String code1desc = "";
String code2desc = "";
String code1 = "";//site.getUrlCode(site.getUrl());
String code2 = "";//site.getUrlCode(site.getExternalUrl());
if(code1.endsWith("(200)"))
	code1desc = "<img title='"+code1+"' src='../images/icon/03_02.png'>";
else
	code1desc = "<img title='"+code1+"' src='../images/icon/50.png'>";

if(code2.endsWith("(200)"))
	code2desc = "<img title='"+code2+"' src='../images/icon/03_02.png'>";
else
	code2desc = "<img title='"+code2+"' src='../images/icon/50.png'>";
%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
   <!-- <link rel="Shortcut Icon" href="../favicon.ico"> -->
   <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="/cms2018/favicon.ico">
    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">  
  <title>TideCMS</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">

   
    <script language=javascript>
        function edit() {
            this.location = 'edit.jsp';
        }

        function check() {
            //	if(isEmpty(document.form.Username,"请输入登录名."))
            //		return false;

            return true;
        }

        function isEmpty(field, msg) {
            if (field.value == "") {
                alert(msg);
                field.focus();
                return true;
            }
            return false;
        }
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
                <span class="breadcrumb-item active">系统管理 / 系统配置 / <%=site.getName()%><span id="notify"></span></span>
            </nav>
        </div>
        <!-- br-pageheader -->
        <form name="form" method="post" action="site_edit2018.jsp" onSubmit="return check();">
            <div class="br-pagebody pd-x-20 pd-sm-x-30">
                <div class="card bd-0 shadow-base">
                    <table class="table mg-b-0" id="content-table">
                        <thead>
                            <tr>
                                <th class="tx-12-force tx-mont tx-medium"> </th>
                                <th class="tx-12-force tx-mont tx-medium hidden-xs-down" style="padding-left:10px;text-align:center;"> </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">本地站点名称：</td>
                                <td class="hidden-xs-down"><input size=40 name="Name" class="form-control wd-300" placeholder="" type="text" value="<%=site.getName()%>"></td>
                            </tr>
                            <tr>
                                <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">本地站点目录：</td>
                                <td class="hidden-xs-down"><input class="form-control wd-300" placeholder="" type="text" size=40 name="SiteFolder" value="<%=site.getSiteFolder()%>"></td>
                            </tr>
                            <tr>
                                <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">本地站点地址：</td>
                                <td class="hidden-xs-down"><input class="form-control wd-300" placeholder="" type="text" size=40 name="SiteAddress" value="<%=site.getUrl()%>"> 地址后面不要带/</td>
                            </tr>
                            <tr>
                                <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">外部站点地址：</td>
                                <td class="hidden-xs-down"><input class="form-control wd-300" placeholder="" type="text" size=40 name="ExternalUrl" value="<%=site.getExternalUrl2()%>"> 地址后面不要带/</td>
                            </tr>
                            <tr>
                                <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">站点类型：</td>
                                <td class="hidden-xs-down" style="display: flex;">
                                    <label class="rdiobox" style="margin-left: 20px;">
			                			<input type="radio" name="SiteType" id="SiteType0" value="0" <%=site.getSiteType()==0?"checked":""%>><span>其他</span>
			              			</label>
                                	<label class="rdiobox" style="margin-left: 20px;">
			                			<input type="radio" name="SiteType" id="SiteType1" value="1" <%=site.getSiteType()==1?"checked":""%>><span>APP</span>
			              			</label>
			              			<label class="rdiobox" style="margin-left: 20px;">
			                			<input type="radio" name="SiteType" id="SiteType2" value="2" <%=site.getSiteType()==2?"checked":""%>><span>网站</span>
			              			</label>
			              		</td>
                            </tr>
                            <%if(site.getType()!=0){%>
                                <tr>
                                    <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">管理员Email：</td>
                                    <td class="hidden-xs-down"><input class="form-control wd-300" placeholder="" type="text" size=40 name="Email" value=""></td>
                                </tr>
                                <tr>
                                    <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">备份文件目录：</td>
                                    <td class="hidden-xs-down"><input class="form-control wd-300" placeholder="" type="text" size=40 name="BackupFolder" value="<%=site.getBackupFolder()%>">
                                        <br>说明：用于存放数据库备份文件，网站备份文件，网站模板备份文件的目录
                                    </td>
                                </tr>
                                <%}%>
                                    <tr>
                                        <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">内容管理对应频道标识：</td>
                                        <td class="hidden-xs-down"><input class="form-control wd-300" placeholder="" type="text" size=40 name="ContentChannelSerialNo" value="<%=site.getContentChannelSerialNo()%>"></td>
                                    </tr>
                                    <tr>
                                        <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">图片目录：</td>
                                        <td class="hidden-xs-down"><input class="form-control wd-300" placeholder="" type="text" size=40 name="ImageFolder" value="<%=site.getImageFolder()%>"></td>
                                    </tr>
                                    <tr>
                                        <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">图片目录规则：</td>
                                        <td class="hidden-xs-down">
                                            <select name="ImageFolderType" class="form-control wd-230 ht-40 select2">         				               
				                               <option selected value="0">系统默认</option>
											   <option value="1">按年份命名，每年一个目录</option>
								               <option value="2">按年月命名，每月一个目录</option>
								               <option value="3">按年月日命名，每日一个目录</option>
								               <option value="4">按每天一个目录</option>
										    </select>
                                        </td>
                                    </tr>
                                    <%if(site.getType()!=0){%>
                                        <tr>
                                            <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">静态发布时页面扩展名：</td>
                                            <td class="hidden-xs-down"><input class="form-control wd-300" placeholder="" type="text" name="FileExt" value="<%=site.getFileExt()%>"></td>
                                        </tr>
                                        <tr>
                                            <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">后台发布周期：</td>
                                            <td class="hidden-xs-down"><input class="form-control wd-300" placeholder="" type="text" name="SleepTime" value="<%=site.getSleepTime()%>" size="4" maxlength="2">					 
                                                <br>范围：0-20分钟,0表示立即发布，修改以后需要重新启动此系统才能生效
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">文件默认编码：</td>
                                            <td class="hidden-xs-down">
                                                <select name="Charset" class="form-control wd-230 ht-40 select2">         				               
												   <option value="gb2312">简体中文(GB2312)</option>
												   <option value="utf-8">Unicode(UTF-8)</option>
												 </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">其他模块链接地址：</td>
                                            <td class="hidden-xs-down">
                                                <input class="form-control wd-300" placeholder="" type="text" size=40 name="OtherModuleAddress" value="<%=site.getOtherModuleAddress()%>">
                                            </td>
                                        </tr>
                                        <%}%>
                                            <tr>
                                                <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;"></td>
                                                <td class="hidden-xs-down">
												<input type="hidden" name="id" value="<%=id%>">
                                                <input type="hidden" name="Submit" value="Submit">
                                                <button type="Submit" name="submit" class="btn btn-primary tx-size-xs">提交</button>
                                     <input type="button" name="Reset" class="btn btn-secondary tx-size-xs" data-dismiss="modal" value="取消" onclick="location='site2018.jsp?id=<%=id%>';"></button>
                              </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <!--列表-->
        </form>
    </div>
</body>
 <script type="text/javascript" src="../common/common.js"></script>
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
  <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script> 
<script language=javascript>
    <%if(!site.getCharset().equals("")){%>
    document.form.Charset.value = "<%=site.getCharset()%>";
    <%}%>
    document.form.ImageFolderType.value = "<%=site.getImageFolderType()%>";
</script>

</html>
