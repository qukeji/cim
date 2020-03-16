<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.util.Util"%>
    <%@ page contentType="text/html;charset=utf-8" %>
        <%@ include file="../config.jsp"%>
            <%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
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
                    <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
                    <link rel="stylesheet" href="../style/2018/bracket.css">
                    <link rel="stylesheet" href="../style/2018/common.css">
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
                                <span class="breadcrumb-item active">系统配置管理 / 平台许可证</span>
                            </nav>
                        </div>
                        <!-- br-pageheader -->
                        <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
                            <div class="btn-group mg-l-10 hidden-xs-down">

                            </div>
                            <!-- btn-group -->
                        </div>
                        <div class="br-pagebody pd-x-20 pd-sm-x-30">
                            <div class="card bd-0 shadow-base">
                                <table class="table mg-b-0" id="content-table">
                                    <thead>
                                        <tr>
                                            <th class="tx-12-force tx-mont tx-medium">&nbsp;</th>
                                            <th class="tx-12-force tx-mont tx-medium hidden-xs-down" style="padding-left:10px;text-align:center;">&nbsp</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td class="hidden-xs-down w-50p" style="vertical-align: middle !important; text-align:right;">公司：</td>
                                            <td class="hidden-xs-down w-50p">
                                                <%=CmsCache.getCompany()%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">许可类型：</td>
                                            <td class="hidden-xs-down">
                                                <%=CmsCache.getLicenseType()%>
                                            </td>
                                        </tr>
                                        <%if(CmsCache.getLicenseType().equals("Evaluation")){%>
                                            <tr>
                                                <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">有效期至：</td>
                                                <td class="hidden-xs-down">
                                                    <%=CmsCache.getExpiresDateStr()%>
                                                </td>
                                            </tr>
                                            <%}%>
                                                <tr>
                                                    <td class="hidden-xs-down" colspan="2" style="text-align:center;"><a href="javascript:;" class="btn btn-primary tx-size-xs" onClick="location='license_edit2018.jsp';">更新许可证</a></td>
                                                </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!--列表-->
                    </div>
                </body>

                </html>