<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.JSONArray,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    String ids = getParameter(request,"ids");
    Integer channelid = getIntParameter(request,"channelid");
    TideJson json = CmsCache.getParameter("weixinlist").getJson();
    JSONArray weixinArray = json.getJSONArray("weixin");
    TideJson weiboJson = CmsCache.getParameter("weibolist").getJson();
    JSONArray weiboArray = weiboJson.getJSONArray("weibo");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="/cms2018/favicon.ico">
    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">
    <title>TideCMS</title>

    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script src="../lib/2018/jquery/jquery.js"></script>

    <style>
        html,body{
            width: 100%;
            height: 100%;
        }
        .lock-unlock{
            min-width: 20px;
        }

    </style>

    <!-- <style>
    .edit-main{margin:0;position:Static;}
    .edit-con .bot{position:absolute;bottom:36px;right:0;left:0;}
    .edit-con{position:Static;margin:-1px 0 0;}
    .edit-con .center_main{position:absolute;top:44px;bottom:50px;right:0;left:0;}
    </style>  -->
</head>
<body class="" >

<div class="bg-white modal-box">
        <form name="form" id="submitForm">
            <div class="modal-box">
                        <input id="channelid" type="hidden" name="channelid" value="<%=channelid%>"/>
                        <input id="ids" type="hidden" name="ids" value="<%=ids%>"/>
                        <div class="row" style="margin-right:0px;margin-left:5px">
                            <label class="left-fn-title">微信列表：</label>
                        </div>
                        <div class="row ckbox-row" style="margin-right:0px;margin-left:5px">
                            <%
                                for(int i=0;i<weixinArray.length();i++){
                                    out.println("<label class='ckbox' style='margin-left:10px'>");
                                    out.println("<input type='checkbox' name='weixin_id' value='"+(weixinArray.getJSONObject(i)).getString("weixin_id")+"'><span>"+(weixinArray.getJSONObject(i)).getString("weixin_name")+"</span>");
                                    out.println("</label>");
                                }
                            %>
                
                        </div>
                        <div class="hr_line"></div>
                        <div class="row" style="margin-right:0px;margin-left:5px">
                            <label class="left-fn-title">微博列表：</label>
                        </div>
                            <div class="row ckbox-row" style="margin-right:0px;margin-left:5px">
                                <%
                                for(int i=0;i<weiboArray.length();i++){
                                    out.println("<label class='ckbox' style='margin-left:10px'>");
                                    out.println("<input type='checkbox' name='weibo_id' value='"+(weiboArray.getJSONObject(i)).getString("weibo_token")+"'><span>"+(weiboArray.getJSONObject(i)).getString("weibo_name")+"</span>");
                                    out.println("</label>");
                                }
                            %>
                            </div>
            </div>
        <div class="btn-box" >
            <div class="modal-footer" >
                <input type="hidden" id="Icon" name="Icon" value="">
                <button name="startButton" type="button" onclick="pushWeixin()" class="btn btn-primary tx-size-xs" id="startButton">确认</button>
                <button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消
                </button>
            </div>
        </div>
    </form>
</div>
</body>
<!-- br-mainpanel -->
<!-- ########## END: MAIN PANEL ########## -->
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

<script src="../lib/2018/select2/js/select2.min.js"></script>

<script src="../common/2018/bracket.js"></script>
<script src="../common/2018/TideDialog2018.js"></script>

<script>

    function lockUnlock(_this){
        var textBox = $(_this).parent(".row").find(".textBox") ;
        if($(_this).find("i").hasClass("fa-lock")){
            $(_this).find("i").removeClass("fa-lock").addClass("fa-unlock");
            textBox.removeAttr("disabled","").removeClass("disabled")
        }else{
            $(_this).find("i").removeClass("fa-unlock").addClass("fa-lock");
            textBox.attr("disabled",true).addClass("disabled")
        }
    }

    $(function(){
        $("#form_nav li").click(function(){
            var _index = $(this).index();
            console.log(_index)
            $(".config-box ul li").removeClass("block").eq(_index).addClass("block");
        })

        //推荐设置锁定图片切换
//    $(".lock-unlock").click(function(){
//     	var textBox = $(this).parent(".row").find(".textBox") ;
//     	if($(this).find("i").hasClass("fa-lock")){
//     	 	$(this).find("i").removeClass("fa-lock").addClass("fa-unlock");
//     	 	textBox.removeAttr("disabled","").removeClass("disabled")
//     	}else{
//     	 	$(this).find("i").removeClass("fa-unlock").addClass("fa-lock");
//     	 	textBox.attr("disabled",true).addClass("disabled")
//     	}
//    })
//


    });
</script>

<script type="text/javascript">
    var ids = "<%=ids%>";
    var channelid = <%=channelid%>;

    $(function () {
        $(".FieldValueType").each(function(){
            //追加按钮
            var field = $(this).attr("value2");
            if($(this).val()==1)
            {

                var html ="<a href=\"javascript:cT('"+field+"');\" class=\"mg-l-25 tx-20 lock-unlock\" onclick=\"lockUnlock(this)\" ><i class=\"fa fa-unlock\" title=\"继承上级\"></i></a>";

            }else{

                //继承
                $("#"+field).attr("class","textinput_disabled").attr('disabled','disabled');
                $("#"+field).addClass("form-control textBox disabled");

                var html ="<a href=\"javascript:cT('"+field+"');\" class=\"mg-l-25 tx-20 lock-unlock\" onclick=\"lockUnlock(this)\" ><i class=\"fa fa-lock\" title=\"继承上级\"></i></a>";
            }

            html += " <a class=\"tx-20 mg-l-15 lock-unlock\" href=\"javascript:applySubChannel('"+field+"')\"><i class=\"fa fa-download\" aria-hidden=\"true\" title=\"应用到子频道\"></i></a>";


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
            $("#"+field).attr("class","form-control textBox").removeAttr('disabled');

        }
        else
        {
            $("#"+field+"_Type").val("0");
            $("#"+field+"_img1").attr("src","../images/icon/13.png");
            $("#"+field).attr("class","textinput_disabled form-control textBox disabled").attr('disabled','disabled');
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

        if(isEmpty(document.form.FolderName,"请输入目录名."))
            return false;
        if(isEmpty(document.form.SerialNo,"请输入标识名."))
            return false;


        if(isExist(document.form.FolderName,"目录名已存在."))
        {
//		TideConfirm("提示","目录名已存在.","","")
            return true;
        }

        return true;
    }

    function isExist(field,msg)
    {
        var flag = false;
        var url="checkFolderName.jsp?FolderName=" + field.value + "&parent=16218&type=1";
        $.ajax({
            type: "GET",
            url: url,
            async:false,
            dataType:"json",
            success: function(data){
                if(data.id != 0){//目录已存在

                    alert(msg);
                    field.focus();
                    flag = true;
                }
            }
        });
        return flag;
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

        if(document.form.SerialNo.value!="" && document.form.FolderName.value=="")
            document.form.FolderName.value = document.form.SerialNo.value;

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
        dialog.setUrl("../channel/icon_list.jsp");
        dialog.setTitle("选择图标");
        dialog.setScroll('auto');
        dialog.show();
    }

    function setReturnValue(o){
        //alert(o.icon);return;
        if(o.icon!=null){
            $("#iconimg").attr("src","/tcenter/images/channel_icon/"+o.icon).show();
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
    var submit = true;
    var weiboSend= true;
    var close = false;
    function sendWeibo(ids,channelid,weibo_id){
                $.ajax({
                    type: "GET",
                    url: "shareWeibo.jsp",
                    dataType: "json",
                    data: {ids: ids, channelid: channelid,weibo_id:weibo_id},
                    success: function (json) {
                        if (json.code == 500) {
                            alert(json.message);
                            weiboSend =true;
                            return ;
                        } 
                        if(close){
                            top.TideDialogClose();
                        }
                    }
                });
    }
    function sendWeixin(ids,channelid,weixin_id){
            $.ajax({
                type: "GET",
                url: "pushWeixin.jsp",
                dataType: "json",
                data: {ids: ids, channelid: channelid, weixin_id: weixin_id},
                success: function (json) {
                    if (json.code == 500) {
                        alert(json.message);
                        submit = true;
                    } else if (json.code == 200) {
                        top.TideDialogClose();
                    } else {
                        alert(json);
                    }
                }
            });
    }
  
    function pushWeixin(){
        var ids = $("#ids").val();
        var channelid =$("#channelid") .val();
        var checkboxObj =$('input[name="weixin_id"]:checked');
        var weixin_id = "";
        var weibo_id="";
        var weibocheckboxObj=$('input[name="weibo_id"]:checked');
        for(var i = 0 ;i<weibocheckboxObj.length;i++){
            if(i==weibocheckboxObj.length-1){
                weibo_id = weibo_id +(weibocheckboxObj[i]).value;
            }else{
                weibo_id = weibo_id +(weibocheckboxObj[i]).value+",";
            }
        }
        for(var i = 0 ;i<checkboxObj.length;i++){
            if(i==checkboxObj.length-1){
                weixin_id = weixin_id +(checkboxObj[i]).value;
            }else{
                weixin_id = weixin_id +(checkboxObj[i]).value+",";
            }
        }
        if(checkboxObj.length==0){
            close=true;
        }
        if(weibocheckboxObj.length>0){
             if(weiboSend){
                weiboSend=false;
                sendWeibo(ids,channelid,weibo_id);
            }
        }
        if(checkboxObj.length>0){
             if(submit){
                submit=false;
                sendWeixin(ids,channelid,weixin_id);
            }
        }
        
    }
</script>

</html>
