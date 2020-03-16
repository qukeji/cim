<%@ page import="tidemedia.cms.system.*,
				 tidemedia.cms.user.*,
				 tidemedia.cms.util.*,
				 tidemedia.cms.base.*,
				 java.sql.*,
				 java.util.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%!
    public String getParentChannelPath(Channel channel) throws MessageException, SQLException {

        String path = "";
        ArrayList arraylist = channel.getParentTree();

        if ((arraylist != null) && (arraylist.size() > 0)) {
            for (int i = 0; i < arraylist.size(); ++i) {
                Channel ch = (Channel) arraylist.get(i);

                if ((i + 1) == arraylist.size()) {//当前频道名
                    path = path + ch.getName();// + ((i < arraylist.size() - 1) ? "/" : "");
                } else {
                    path = path + ch.getName() + " / ";// + ((i < arraylist.size() - 1) ? "/" : "");
                }
            }
        }

        arraylist = null;

        return path;
    }

    //获取用户名
    public String getUserName(String users) {
        String userName = "";
        try {
            TableUtil tu = new TableUtil("user");
            String Sql = "select * from userinfo where id in(" + users + ")";
            ResultSet Rs = tu.executeQuery(Sql);
            while (Rs.next()) {
                String Name = convertNull(Rs.getString("Name"));
                if (!userName.equals("") && !Name.equals("")) {
                    userName += ",";
                }
                userName += Name;
            }
            tu.closeRs(Rs);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return userName;
    }
%>
<%
    //if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
    if ((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")) {
    } else {
        response.sendRedirect("../noperm.jsp");
        return;
    }

    int id = getIntParameter(request, "ChannelID");
    Channel channel = CmsCache.getChannel(id);
    Tree tree = new Tree();
//if(channel==null){out.println("该频道不存在，编号："+id+".");return;}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <title>TideCMS 列表</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

    <!-- <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet"> -->
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <style>.collapsed-menu .br-mainpanel-file {
        margin-left: 0;
        margin-top: 0;
    }</style>
    <script src="../lib/2018/jquery/jquery.js"></script>

    <%
        boolean booleanchild = channel.hasChild();
        String CategoryName = "";
        String CategorySerialNo = "";

        if (channel.getType() == 2) {
            response.sendRedirect("../page/page_info2018.jsp?ChannelID=" + id);
            return;
        }

        if (channel.getType() == 3) {
            response.sendRedirect("app_info.jsp?ChannelID=" + id);
            return;
        }

        String Action = getParameter(request, "Action");

        if (Action.equals("ChangeCanCategory")) {
            int Status = getIntParameter(request, "Status");
            channel.setCanCategory(Status);

            channel.UpdateCanCategory();

            response.sendRedirect("channel2018.jsp?ChannelID=" + id);
            return;
        }

        if (Action.equals("TemplateInherit")) {
            int flag = getIntParameter(request, "flag");
            channel.UpdateTemplateInherit(flag);

            response.sendRedirect("channel2018.jsp?ChannelID=" + id);
            return;
        }

        String PublishModeDesc = "静态发布";

        String SiteAddress = channel.getSite().getUrl();

//计算数据总条数
        int Count = 0;
        int countAudited = 0;
        int countUnaudited = 0;
        try {
            if (channel.getParent() == -1) { //站点频道
                Count = ReportUtil2.getEsNum(channel.getSiteID() + "", 0, userinfo_session.getId(), true, 0, "", "");
                countAudited = ReportUtil2.getEsNum(channel.getSiteID() + "", 0, userinfo_session.getId(), true, 2, "", "");
                countUnaudited = ReportUtil2.getEsNum(channel.getSiteID() + "", 0, userinfo_session.getId(), true, 1, "", "");

                //Count = tidemedia.cms.util.ESUtil.searchESDocument(channel.getSiteID()+"",0,true,0,"","");
                //countAudited = tidemedia.cms.util.ESUtil.searchESDocument(channel.getSiteID()+"",0,true,2,"","");
                //countUnaudited = tidemedia.cms.util.ESUtil.searchESDocument(channel.getSiteID()+"",0,true,1,"","");
            } else {
                Count = ReportUtil2.getEsNum("", id, userinfo_session.getId(), true, 0, "", "");
                countAudited = ReportUtil2.getEsNum("", id, userinfo_session.getId(), true, 2, "", "");
                countUnaudited = ReportUtil2.getEsNum("", id, userinfo_session.getId(), true, 1, "", "");

                //Count = tidemedia.cms.util.ESUtil.searchESDocument("",id,true,0,"","");
                //countAudited = tidemedia.cms.util.ESUtil.searchESDocument("",id,true,2,"","");
                //countUnaudited = tidemedia.cms.util.ESUtil.searchESDocument("",id,true,1,"","");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
//获取频道路径
        String parentChannelPath = getParentChannelPath(channel);

    %>
    <script language=javascript>

        var myObject = new Object();

        var ChannelID = "<%=channel.getId()%>";
        var ChannelName = "<%=tidemedia.cms.util.Util.JSQuote(channel.getName())%>";
        var booleanchild =<%=booleanchild%>;

        //新建
        function newChannel() {
            var ChannelName = '<%=java.net.URLEncoder.encode(channel.getName(),"UTF-8")%>';
            var url = "channel_add_pre2018.jsp?ChannelID=<%=channel.getId()%>&Type=0&ChannelName=" + ChannelName;
            var dialog = new top.TideDialog();
            dialog.setWidth(500);
            dialog.setHeight(370);
            dialog.setUrl(url);
            dialog.setTitle('新建子频道');
            dialog.setChannelName('<%=channel.getName()%>');
            dialog.show();
        }

        function addTemplate() {
            var url = '../channel/template_add2018.jsp?TemplateType=3&ChannelID=<%=channel.getId()%>';
            var dialog = new top.TideDialog();
            dialog.setWidth(650);
            dialog.setHeight(550);
            dialog.setUrl(url);
            dialog.setTitle("添加模板");
            dialog.setChannelName('<%=channel.getName()%>');
            dialog.show();
        }

        function editTemplate(id, type) {
            var url;
            var title;
            if (id == 0) {
                title = '添加板模'
                url = "../channel/template_add2018.jsp?TemplateType=" + type + "&ChannelID=<%=channel.getId()%>";
            } else {
                title = '修改模板'
                url = "../channel/template_edit2018.jsp?id=" + id + "&ChannelID=<%=channel.getId()%>";
            }
            var dialog = new top.TideDialog();
            dialog.setWidth(600);
            dialog.setHeight(600);
            dialog.setUrl(url);
            dialog.setTitle(title);
            dialog.setChannelName('<%=channel.getName()%>');
            dialog.show();
        }

        function deleteTemplate(i) {

            var url = "channel_template_delete2018.jsp?id=" + i;
            var dialog = new top.TideDialog();
            dialog.setWidth(320);
            dialog.setHeight(260);
            //dialog.setSuffix('_2');
            dialog.setUrl(url);
            dialog.setTitle("删除模板");
            dialog.show();
            /*	if(confirm('你确认要删除吗?'))
                {
                    this.location = "channel_template_delete.jsp?Action=Delete&id="+i+"&ChannelID=
            <%=channel.getId()%>";
    }  */
        }

        function defineForm() {
            var url = '../channel/form_view2018.jsp?ChannelID=<%=channel.getId()%>&ShowAll=1&Scrolling=auto';
            var dialog = new top.TideDialog();
            dialog.setWidth(800);
            dialog.setHeight(600);
            dialog.setUrl(url);
            dialog.setScroll('auto');
            dialog.setTitle("表单设置");
            dialog.setChannelName('<%=channel.getName()%>');
            dialog.show();
        }


        //张赫东 2013/5/28 删除频道判断
        function deleteChannel_1() {
            if (booleanchild == false) {

                var url = '../channel/channel_deletechannelNoChild.jsp?ChannelID=<%=channel.getId()%>';
                var dialog = new top.TideDialog();
                dialog.setWidth(400);
                dialog.setHeight(180);
                dialog.setUrl(url);
                dialog.setTitle("删除频道");
                dialog.setChannelName('<%=channel.getName()%>');
                dialog.show();

            } else {

                var url = '../channel/channel_deletechannel.jsp?ChannelID=<%=channel.getId()%>';
                var dialog = new top.TideDialog();
                dialog.setWidth(400);
                dialog.setHeight(300);
                dialog.setUrl(url);
                dialog.setTitle("删除频道");
                dialog.setChannelName('<%=channel.getName()%>');
                dialog.show();
            }
        }

        function deleteChannel() {
            var url = '../channel/channel_deletechannel2018.jsp?ChannelID=<%=channel.getId()%>';
            var dialog = new top.TideDialog();
            dialog.setWidth(530);
            dialog.setHeight(300);
            dialog.setUrl(url);
            dialog.setTitle("删除频道");
            dialog.setChannelName('<%=channel.getName()%>');
            dialog.show();
        }

        function editChannel() {
            var url = 'channel_edit2018.jsp?ChannelID=<%=channel.getId()%>';
            var dialog = new top.TideDialog();
            dialog.setWidth(700);
            dialog.setHeight(620);
            dialog.setUrl(url);
            dialog.setTitle('修改属性');
            dialog.setChannelName('<%=channel.getName()%>');
            dialog.show();
        }

        function listconfig() {
            var url = '${pageContext.request.contextPath}/channel/list/config?ChannelID=<%=channel.getId()%>';
            var dialog = new top.TideDialog();
            dialog.setWidth(800);
            dialog.setHeight(620);
            dialog.setUrl(url);
            dialog.setTitle('修改属性');
            dialog.setChannelName('<%=channel.getName()%>');
            dialog.show();
        }

        function setPrivilege() {
            var url = '../channel/channel_privilege.jsp?ChannelID=<%=channel.getId()%>';
            var dialog = new top.TideDialog();
            dialog.setWidth(500);
            dialog.setHeight(500);
            dialog.setUrl(url);
            dialog.setTitle('权限设置');
            dialog.setChannelName('<%=channel.getName()%>');
            dialog.setScroll('auto');
            dialog.show();
        }

        function Publish() {
            var url = '../channel/publish2018.jsp?ChannelID=<%=channel.getId()%>';
            var dialog = new top.TideDialog();
            dialog.setWidth(450);
            dialog.setHeight(350);
            dialog.setUrl(url);
            dialog.setTitle('发布频道');
            dialog.setChannelName('<%=channel.getName()%>');
            dialog.show();
        }

        function ChangeCanCategory(i) {
            if (i == 1)
                this.location = "channel.jsp?Action=ChangeCanCategory&ChannelID=<%=channel.getId()%>&Status=1";
            else
                this.location = "channel.jsp?Action=ChangeCanCategory&ChannelID=<%=channel.getId()%>&Status=0";
        }

        function ViewTemplate(TemplateID) {
            var url = "../template/template_edit2018.jsp?TemplateID=" + TemplateID;
            if (TemplateID != "")
                window.open(url);
        }

        function TemplateInherit(flag, id) {
            var url = "channel.jsp?Action=TemplateInherit&id=" + id + "&flag=" + flag;
            this.location.href = url;
        }

        function InheritTemplate() {
            var url = '../channel/template_inherit.jsp?ChannelID=<%=channel.getId()%>';
            var dialog = new top.TideDialog();
            dialog.setWidth(400);
            dialog.setHeight(300);
            dialog.setUrl(url);
            dialog.setTitle('模板继承');
            dialog.setChannelName('<%=channel.getName()%>');
            dialog.show();
        }

        function enable(id, flag) {
            var msg = "确实要";
            if (flag == 1) msg += "允许";
            else if (flag == 2) msg += "禁止";
            else return;
            msg += "该模板配置吗?会同步修改子频道模板";

            if (confirm(msg)) {
                var url = "channel_template_enable.jsp?id=" + id + "&flag=" + flag;
                $.ajax({
                    type: "GET", url: url, success: function (msg) {
                        document.location.href = document.location.href;
                    }
                });
            }
        }

        //排序
        function Sort() {

            var url = "channel_order2018.jsp?ChannelID=" +<%=id%>;
            var dialog = new top.TideDialog();
            dialog.setWidth(300);
            dialog.setHeight(230);
            dialog.setUrl(url);
            dialog.setTitle("排序");
            dialog.show();

        }

        //导入审核方案
        function import_scheme() {

            var url = "../approve/channel_approve_scheme.jsp?ChannelID=" +<%=id%>;
            var dialog = new top.TideDialog();
            dialog.setWidth(1000);
            dialog.setHeight(600);
            dialog.setUrl(url);
            dialog.setTitle('配置审核方案');
            dialog.show();
        }

        function edit(itemid, parent) {
            var url = "../approve/approve_items_edit.jsp?parent=" + parent + "&id=" + itemid + "&suffix=1";
            var dialog = new top.TideDialog();
            dialog.setWidth(500);
            dialog.setHeight(375);
            dialog.setUrl(url);
            dialog.setTitle("审核环节配置");
            dialog.show();
        }

        function del(itemid, parent) {
            var url = "../approve/approve_items_delete.jsp?parent=" + parent + "&ItemID=" + itemid + "&suffix=1";
            var dialog = new top.TideDialog();
            dialog.setWidth(300);
            dialog.setHeight(260);
            dialog.setUrl(url);
            dialog.setTitle("删除审核环节");
            dialog.show();
        }

        //刷新列表
        function setReturnValue(o) {
            if (o.refresh) {
                var s = "channel2018.jsp?ChannelID=" +<%=id%>;
                document.location.href = s;
            }
        }
    </script>
</head>
<body class="collapsed-menu email" id="channel-manage">
<div class="content_t1">
    <div class="br-mainpanel br-mainpanel-file mg-b-30" id="channel-manage">
        <div class="br-pageheader pd-y-15 pd-md-l-20">
            <nav class="breadcrumb pd-0 mg-0 tx-12">
                <span class="breadcrumb-item active"><%=parentChannelPath%></span>
            </nav>
        </div><!-- br-pageheader -->

        <!-- <div class="content_t1_nav">当前位置：<%=channel.getName()%></div> -->
        <div class="channel-name mg-l-30 mg-r-30">
            <div class="channel-name-box">
                <div class="set-img-box">
                    <!--<i class="icon ion-ios-gear-outline tx-52 lh-72"></i>     -->
                    <!--<i class="fa fa-gear tx-52 lh-72"></i>-->
                    <img src="../images/2018/channel-setting.png"/>
                </div>
                <div class="right-info">
                    <h5 class="tx-22"><%=channel.getName()%>
                    </h5>
                    <p class="tx-12">共计<span class="channel-data-total"><%=Count%></span>条内容资源，其中<span
                            class="channel-data-pub"><%=countAudited%></span>条为审核发布数据、<span
                            class="channel-data-no"><%=countUnaudited%></span>条未审核数据。</p>
                </div>
            </div>
        </div>

        <%if (channel.getType() == 3) {%>
        <div class="br-pagebody">
            <div class="br-section-wrapper pd-0-force">
                <div class="d-flex align-items-center justify-content-between tx-black tx-bold pd-x-20 pd-t-10">
                    <div class="channel-item-name wd-100">基础功能</div>
                    <div class="channel-handle ">
                        <div class="">
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="newChannel();">新建子频道</a>
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="editChannel();">修改频道属性</a>
                            <%if (channel.isTableChannel()) {%>
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="defineForm();">表单定义</a>
                            <%}%>
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="Sort();">排序</a>
                            <%if (!channel.isRootChannel()) {%><%if ((new UserPerm().canDeleteChannel(userinfo_session))) {%>
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="deleteChannel();">删除</a>
                            <%}%><%}%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%} else {%>
        <div class="br-pagebody">
            <div class="br-section-wrapper pd-0-force">
                <div class="d-flex align-items-center justify-content-between tx-black tx-bold pd-x-20 pd-t-10">
                    <div class="channel-item-name wd-100">基础功能</div>
                    <div class="channel-handle ">
                        <div class="">
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10" onClick="Publish()">发布频道</a>
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="editChannel();">修改频道属性</a>
                            <%if (channel.getIsListConfig() == 1) {%>
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="listconfig();">列表页配置</a>
                            <%}%>
                            <%if (channel.isTableChannel()) {%>
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="defineForm();">表单定义</a>
                            <%}%>
                            <!-- <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10" onClick="addTemplate()">添加频道模板</a> -->
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="newChannel();">新建子频道</a>
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="Sort();">排序</a>
                            <%if (channel.getTemplateInherit() == 1) {%>
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="InheritTemplate()">模板继承</a><%}%>
                            <%if (!channel.isRootChannel()) {%><%if ((new UserPerm().canDeleteChannel(userinfo_session))) {%>
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="deleteChannel();">删除</a>
                            <%}%><%}%>
                        </div>
                    </div>
                </div>
                <div class="bd-b"></div>
                <div class="channel-preview pd-20">
                    <span class="tx-14 mg-r-10">频道名称：<%=channel.getName()%></span>
                    <span class="tx-14 mg-r-10">目录名：<%=channel.getFolderName()%></span>
                    <span class="tx-14 mg-r-10">频道地址：<%=channel.getFullPath()%></span>
                    <input type="hidden" name="tide001" value="<%=channel.getChannelCode()%>">
                    <span title="<%=channel.getChannelCode()%>" onClick="$('#channel_code').show();">
					<span class="tx-14 mg-r-10">编号：<%=channel.getId()%></span>
					<span class="tx-14 mg-r-10">标识：<%=channel.getSerialNo()%></span><%if (channel.getType() == Channel.MirrorChannel_Type) {%>镜像频道：<span
                            class="font-blue"><%=channel.getLinkChannel().getName()%></span><%}%></span>
                </div>
            </div>
        </div>

        <div class="br-pagebody">
            <div class="br-section-wrapper pd-0-force">
                <div class="d-flex align-items-center justify-content-between tx-black tx-bold pd-x-20 pd-t-10">
                    <div class="channel-item-name wd-100">模板应用</div>
                    <div class="channel-handle">
                        <div class="">
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="addTemplate()">新增模板</a>
                        </div>
                    </div>
                </div>
                <div class="bd-b"></div>
                <table class="table mg-b-0" id="templet-table">
                    <thead>
                    <tr>
                        <th class="tx-12-force tx-mont tx-medium"><span class="pd-l-15">编号</span></th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">类型</th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">模板</th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">目标文件</th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-300">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        int IsInherit = 0;
                        int TemplateSortNumber = 0;
                        ArrayList cts = channel.getChannelTemplates(1);
                        if (cts != null && cts.size() > 0) {
                            for (int i = 0; i < cts.size(); i++) {
                                TemplateSortNumber++;
                                ChannelTemplate ct = (ChannelTemplate) cts.get(i);
                                String TargetName = ct.getTargetName();
                                int id_ = ct.getId();
                                int templateID = ct.getTemplateID();
                                TemplateFile tf = CmsCache.getTemplate(templateID);
                    %>
                    <tr>
                        <td><span class="pd-l-15"><%=TemplateSortNumber%></span></td>
                        <td class="hidden-xs-down">索引页模板</td>

                        <td class="hidden-xs-down"
                            title="<%=tf.getGroupTree()%>"><%=tf.getFileName()%> <%=ct.getLabel()%>
                        </td>
                        <td class="hidden-xs-down"><a
                                href="<%=Util.ClearPath(SiteAddress+(TargetName.startsWith("/")?"":channel.getFullPath()+"/")+TargetName)%>"
                                target="_blank"><span class="font-blue"><%=TargetName%></span></a></td>
                        <td class=" hidden-xs-down">
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13 " onclick="editTemplate('<%=id_%>',1);">
                                配置
                            </button>
                            <%if (templateID > 0) {%>
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13"
                                    onclick="ViewTemplate('<%=templateID%>');">查看
                            </button>
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="deleteTemplate(<%=id_%>);">删除
                            </button>
                            <%if (ct.getActive() == 1) {%>
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="enable(<%=id_%>,2);">禁止
                            </button>
                            <%} else if (ct.getActive() == 0) {%>
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="enable(<%=id_%>,1);">启用
                            </button>
                            <%}%>
                            <%}%>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                        TemplateSortNumber++;
                    %>
                    <tr>
                        <td><span class="pd-l-5"><%=TemplateSortNumber%></span></td>
                        <td class="hidden-xs-down">索引页模板</td>
                        <td class="hidden-xs-down"></td>
                        <td class="hidden-xs-down"></td>
                        <td class=" hidden-xs-down">
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="editTemplate('0',1);">配置
                            </button>
                        </td>
                    </tr>
                    <%
                        }
                        cts = channel.getChannelTemplates(2);
                        if (cts != null && cts.size() > 0) {
                            for (int i = 0; i < cts.size(); i++) {
                                TemplateSortNumber++;
                                ChannelTemplate ct = (ChannelTemplate) cts.get(i);
                                String TargetName = ct.getTargetName();
                                int id_ = ct.getId();
                                int templateID = ct.getTemplateID();
                                TemplateFile tf = CmsCache.getTemplate(templateID);
                    %>
                    <tr>
                        <td><span class="pd-l-5"><%=TemplateSortNumber%></span></td>
                        <td class="hidden-xs-down">内容页模板</td>
                        <td class="hidden-xs-down"
                            title="<%=tf.getGroupTree()%>"><%=tf.getFileName()%> <%=ct.getLabel()%>
                        </td>
                        <td class="hidden-xs-down"><a
                                href="<%=SiteAddress+(TargetName.startsWith("/")?"":channel.getFullPath()+"/")+TargetName%>"
                                target="_blank"><span class="font-blue"><%=TargetName%></span></a></td>
                        <td class=" hidden-xs-down">
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13 " onclick="editTemplate('<%=id_%>',2);">
                                配置
                            </button>
                            <%if (templateID > 0) {%>
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13"
                                    onclick="ViewTemplate('<%=templateID%>');">查看
                            </button>
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="deleteTemplate(<%=id_%>);">删除
                            </button>
                            <%if (ct.getActive() == 1) {%>
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="enable(<%=id_%>,2);">禁止
                            </button>
                            <%} else if (ct.getActive() == 0) {%>
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="enable(<%=id_%>,1);">启用
                            </button>
                            <%}%>
                            <%}%>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                        TemplateSortNumber++;
                    %>
                    <tr>
                        <td><span class="pd-l-5"><%=TemplateSortNumber%></span></td>
                        <td class="hidden-xs-down">内容页模板</td>
                        <td class="hidden-xs-down"></td>
                        <td class="hidden-xs-down"></td>
                        <td class=" hidden-xs-down">
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="editTemplate('0',2);">配置
                            </button>
                        </td>
                    </tr>
                    <%}%>
                    <tr>
                        <td><span class="pd-l-5">....</span></td>
                        <td class="hidden-xs-down">....</td>
                        <td class="hidden-xs-down">....</td>
                        <td class="hidden-xs-down">....</td>
                        <td class=" hidden-xs-down">....</td>
                    </tr>
                    <%
                        cts = channel.getChannelTemplates(3);
                        if (cts != null && cts.size() > 0) {
                            for (int i = 0; i < cts.size(); i++) {
                                TemplateSortNumber++;
                                ChannelTemplate ct = (ChannelTemplate) cts.get(i);
                                String TargetName = ct.getTargetName();
                                int id_ = ct.getId();
                                int templateID = ct.getTemplateID();
                                TemplateFile tf = CmsCache.getTemplate(templateID);
                    %>
                    <tr>
                        <td><span class="pd-l-5"><%=TemplateSortNumber%></span></td>
                        <td class="hidden-xs-down">附加页面模板</td>
                        <td class="hidden-xs-down"
                            title="<%=tf.getGroupTree()%>"><%=tf.getFileName()%> <%=ct.getLabel()%>
                        </td>
                        <td class="hidden-xs-down"><a
                                href="<%=SiteAddress+(TargetName.startsWith("/")?"/":channel.getFullPath()+"/")+TargetName%>"
                                target="_blank"><span class="font-blue"><%=TargetName%></span></a></td>
                        <td class=" dropdown hidden-xs-down">
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="editTemplate('<%=id_%>',3);">
                                配置
                            </button>
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13"
                                    onclick="ViewTemplate('<%=templateID%>');">查看
                            </button>
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="deleteTemplate(<%=id_%>);">删除
                            </button>
                            <%if (ct.getActive() == 1) {%>
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="enable(<%=id_%>,2);">禁止
                            </button>
                            <%} else if (ct.getActive() == 0) {%>
                            <button class="btn btn-primary btn-sm mg-r-8 tx-13" onclick="enable(<%=id_%>,1);">启用
                            </button>
                            <%}%>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
        <!--工作流-->


        <div class="br-pagebody">
            <div class="br-section-wrapper pd-0-force">
                <div class="d-flex align-items-center justify-content-between tx-black tx-bold pd-x-20 pd-t-10">
                    <div class="channel-item-name wd-100">配置审核方案</div>
                    <div class="channel-handle">
                        <div class="">
                            <a href="javascript:;" class="btn btn-primary btn-sm mg-r-5 mg-b-10"
                               onClick="import_scheme()">配置审核方案</a>
                        </div>
                    </div>
                </div>
                <div class="bd-b"></div>
                <table class="table mg-b-0" id="templet-table">
                    <thead>
                    <tr>
                        <th class="tx-12-force tx-mont tx-medium"><span class="pd-l-15">步骤</span></th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">名称</th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">方式</th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">用户</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        int ApproveScheme = channel.getApproveScheme();
                        TableUtil tu = new TableUtil();
                        String ListSql = "select * from approve_items where parent=" + ApproveScheme + " order by step asc";
                        ResultSet Rs = tu.executeQuery(ListSql);
                        while (Rs.next()) {
                            int tid = Rs.getInt("id");
                            int step = Rs.getInt("step");
                            String title = convertNull(Rs.getString("Title"));
                            int Type = Rs.getInt("Type");
                            String Type_ = "或签";
                            if (Type == 1) {
                                Type_ = "并签";
                            }
                            String users = convertNull(Rs.getString("users"));
                            String users_ = "";
                            if (!users.equals("")) {
                                users_ = getUserName(users);
                            }
                    %>

                    <tr>
                        <td class="hidden-xs-down"><span class="pd-l-15"><%=step%></span></td>
                        <td class="hidden-xs-down"><%=title%>
                        </td>
                        <td class="hidden-xs-down"><%=Type_%>
                        </td>
                        <td class="hidden-xs-down"><%=users_%>
                        </td>
                    </tr>
                    <%
                        }
                        tu.closeRs(Rs);
                    %>
                    </tbody>
                </table>
                <!--工作流end-->

            </div>
        </div>
        <%}%>
    </div>

</div>

</div>
<!--	br-mainpanel -->

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../common/2018/bracket.js"></script>
<script>
    $(function () {
        'use strict';

        //show only the icons and hide left menu label by default
        $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

        $(document).on('mouseover', function (e) {
            e.stopPropagation();
            if ($('body').hasClass('collapsed-menu')) {
                var targ = $(e.target).closest('.br-sideleft').length;
                if (targ) {
                    $('body').addClass('expand-menu');

                    // show current shown sub menu that was hidden from collapsed
                    $('.show-sub + .br-menu-sub').slideDown();

                    var menuText = $('.menu-item-label,.menu-item-arrow');
                    menuText.removeClass('d-lg-none');
                    menuText.removeClass('op-lg-0-force');

                } else {
                    $('body').removeClass('expand-menu');

                    // hide current shown menu
                    $('.show-sub + .br-menu-sub').slideUp();

                    var menuText = $('.menu-item-label,.menu-item-arrow');
                    menuText.addClass('op-lg-0-force');
                    menuText.addClass('d-lg-none');
                }
            }
        });

        $('.br-mailbox-list,.br-subleft').perfectScrollbar();

        $('#showMailBoxLeft').on('click', function (e) {
            e.preventDefault();
            if ($('body').hasClass('show-mb-left')) {
                $('body').removeClass('show-mb-left');
                $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
            } else {
                $('body').addClass('show-mb-left');
                $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
            }
        });


    });
</script>

<!--自定义函数-->

<!--16ms-->
</body>
</html>
