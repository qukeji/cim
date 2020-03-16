<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

    /**
     *        时间          修改人            详情
     *     2015-12-09     曲科籍       修改拼到时显示数据源参数，当前显示的规则是：DataSource此参数不为空或者null *时候显示，目前调用SetDataSource()时候无法修改属性，
     *
     *
     *
     **/


    if(!userinfo_session.isAdministrator())
    { response.sendRedirect("../noperm.jsp");return;}

    request.setCharacterEncoding("utf-8");

    int itemid = getIntParameter(request,"itemid");
    int channelid = getIntParameter(request,"channelid");
    Document doc = new Document(itemid,channelid);

    Channel channel = new Channel(channelid);
    String IconFolder = request.getContextPath() + "/images/channel_icon/";
//System.setProperty("file.encoding","gb2312");

    String start = Util.convertNull(doc.getModifiedDate());
    System.out.println("参数start："+start);
    if(!start.equals("")){
        start=Util.FormatDate("yyyy-MM-dd HH:mm:ss",start);
    }

%>
<!DOCTYPE html>
<html >
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <!-- Meta -->
    <!--  <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">  -->
    <!-- <meta name="author" content="ThemePixels"> -->
    <!-- <link rel="Shortcut Icon" href="../favicon.ico">  -->
    <title>TideCMS</title>

    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <script type="text/javascript">

        $(function () {
            $(".FieldValueType").each(function(){
                //追加按钮
                var field = $(this).attr("value2");
                var img1 = "13.png";
                if($(this).val()==1)
                {
                    img1 = "14.png";
                }
                else
                {
                    //继承
                    $("#"+field).attr("class","textinput_disabled").attr('disabled','disabled');;
                }

                var html = "<a href=\"javascript:cT('"+field+"')\"><img id=\""+field+"_img1\" src=\"../images/icon/"+img1+"\" title=\"继承上级\" /></a>";
                html += " <a href=\"javascript:applySubChannel('"+field+"')\"><img src=\"../images/icon/43.png\" title=\"应用到子频道\" /></a>";
                //alert($(this));
                $(this).after(html);
            });
        });

        function cT(field)
        {
            if($("#"+field+"_Type").val()==0)
            {
                //继承
                $("#"+field+"_Type").val("1");
                $("#"+field+"_img1").attr("src","../images/icon/14.png");
                $("#"+field).attr("class","textfield").removeAttr('disabled');

            }
            else
            {
                $("#"+field+"_Type").val("0");
                $("#"+field+"_img1").attr("src","../images/icon/13.png");
                $("#"+field).attr("class","textinput_disabled").attr('disabled','disabled');
            }
            //alert($("#"+field+"_img1").attr("src"));
        }

        function init()
        {

        }

        function check()
        {
            if(isEmpty(document.form.Name,"请输入名称."))
                return false;
            <%if(channel.getType()==0 && !channel.isRootChannel()){%>
            if(isEmpty(document.form.FolderName,"请输入目录名."))
                return false;
            if(isEmpty(document.form.SerialNo,"请输入标识名."))
                return false;
            <%}%>
            return true;
        }

        function isEmpty(field,msg)
        {
            if(field.value == "")
            {
                alert(msg);
                field.focus();
                return true;
            }
            return false;
        }

        function initOther()
        {
            <%if(channel.getType()==0 ){%>
            if(document.form.SerialNo.value!="" && document.form.FolderName.value=="")
                document.form.FolderName.value = document.form.SerialNo.value;
            <%}%>
        }

        function showRecommend()
        {
            var o = document.getElementById("RecommendArea");
            if(o)
            {
                if(o.style.display =="")
                    o.style.display = "none";
                else
                    o.style.display = "";
            }
        }

        function showTab(form,form_td)
        {
            var num = 5;
            for(i=1;i<=num;i++)
            {
                jQuery("#form"+i).hide();
                jQuery("#form"+i+"_td").removeClass("cur");
            }

            jQuery("#"+form).show();
            jQuery("#"+form_td).addClass("cur");
        }

        function autoChange(id)
        {
            var o = document.getElementById(id);
            if(o)
            {
                if(o.rows==4)
                {o.rows=20;}
                else
                {o.rows=4;}
            }
        }

        function openIconList()
        {
            var	dialog = new top.TideDialog();
            dialog.setWidth(600);
            dialog.setHeight(450);
            dialog.setSuffix('_2');
            dialog.setUrl("channel/icon_list.jsp");
            dialog.setTitle("选择图标");
            dialog.setScroll('auto');
            dialog.show();
        }

        function setReturnValue(o){
            //alert(o.icon);return;
            if(o.icon!=null){
                $("#iconimg").attr("src","<%=IconFolder%>"+o.icon).show();
                $("#Icon").val(o.icon);
            }
        }

        function applySubChannel(field)
        {
            var v = $("#"+field).val();
            if(confirm('当前频道及其所有子频道的对应属性都会被覆盖，请确认要复制该属性到子频道吗？属性内容是：'+v))
            {
                var url="channel_attribute_copy.jsp";
                $.ajax({
                    type: "POST",
                    url: url,
                    data: {id:$("#ChannelID").val(),field:field,value:v},
                    success: function(msg){alert("应用成功.");}});
            }
        }

    </script>
    <style>
        html,body{
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body class="" onload="" >
<div class="bg-white modal-box">
    <form  name="form" action="job_edit2018.jsp" method="POST"  id="jobform">
        <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
            <div class="config-box">
                <ul>
                    <!--基本信息-->
                    <li class="block">
                        <div class="row">
                            <label class="left-fn-title">所属栏目：</label>
                            <label class="mg-l-5"><%=channel.getName()%></label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">选题名称：</label>
                            <label class="mg-l-5"><%=Util.convertNull(doc.getTitle())%></label>
                        </div>
                        <div class="row">
                            <label class="left-fn-title">选题人：</label>
                            <label class="mg-l-5"><%=Util.convertNull(doc.getValue("publisher_name"))%></label>
                        </div>
                        <div class="row">
                             <label class="left-fn-title">选题时间：</label>
                            <label class="mg-l-5"><%=start%></label>
                        </div>
                        <div class="row">

                            <label class="left-fn-title">选题内容：</label>
                            <label class="mg-l-5"><%=Util.convertNull(doc.getSummary())%></label>
                        </div>
                         <div class="row">

                            <label class="left-fn-title">预约车辆：</label>
                            <label class="mg-l-5"><%=Util.convertNull(doc.getValue("bespeak"))%></label>
                        </div>
                       
                    </li>
                </ul>
            </div>
        </div><!-- modal-body -->
      
        <div id="ajax_script" style="display:none;"></div>
    </form>
</div><!-- br-mainpanel -->
<!-- ########## END: MAIN PANEL ########## -->
</body>
<script src="../common/2018/common2018.js"></script>
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
</html>
