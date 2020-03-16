<%@ page import="tidemedia.cms.system.*,
                    tidemedia.cms.util.*,
                    tidemedia.cms.page.*,
                    tidemedia.cms.base.*,
                    tidemedia.cms.user.*,
	                java.sql.*,

                    org.json.*"%>

<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
    int	sourceid		=	getIntParameter(request,"id");
    int	cloud_id1		=	getIntParameter(request,"cloud_id");
    int	ChannelID		=	getIntParameter(request,"ChannelID");
    String ChannelName	=	getParameter(request,"ChannelName");
    int	type		=	getIntParameter(request,"type");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">

    <title>聚视后台</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/highlightjs/github.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
</head>
<style>
    html,body{width:100%;height:100%}
	.channel-all{display:flex;flex-direction:row;flex-wrap:wrap;justify-content:space-between;margin:5px 0 20px 0}
	.channel-all a{background:#639ad7;color:#FFFFFF;width:45%}
	.fa-question-circle{color:#639ad7}
	.mg-auto{margin:0 auto}
	#newspecial>.row{margin-left:0;margin-right:0}
</style>
<script>
    function check()
    {
        if(isEmpty(document.form.NewChannelName,"请输入专题名称"))
            return false;

        if(isEmpty(document.form.NewFolder,"请输入专题路径，比如:guoqing."))
            return false;

        var smallch="abcdefghijklmnopqrstuvwxyz_0123456789";

        for(var i=0;i<document.form.NewFolder.value.length;i++)
        {
            var exist = false;
            for(var j=0;j<smallch.length;j++)
                if(document.form.NewFolder.value.charAt(i)==smallch.charAt(j))
                {
                    exist = true;
                }


            if(!exist)
            {
                alert("路径名称必须由以下字母组成："+smallch);
                document.form.NewFolder.focus();
                return false;
            }

        }

        return true;
    }
    function showStep(step)
    {
        $("#pages").remove();

        if(step==3)
        {
            

            var cloud_id=<%=cloud_id1%>;
            var cloud_sourceid=<%=sourceid%>;
            var NewChannelName=$("input[name='NewChannelName']").val();
            var type=<%=type%>;
            if(typeof (NewChannelName)=="undefined"||NewChannelName==""||NewChannelName==null){
                alert("专题名称不能为空");
                return;
            }
            var NewFolder=$("input[name='NewFolder']").val();
            if(typeof (NewFolder)=="undefined"||NewFolder==""||NewFolder==null){
                alert("请输入专题路径比如：guoqing");
                return;
            }else {
                var smallch="abcdefghijklmnopqrstuvwxyz_0123456789";

                for(var i=0;i<NewFolder.length;i++)
                {
                    var exist = false;
                    for(var j=0;j<smallch.length;j++)
                        if(NewFolder.charAt(i)==smallch.charAt(j))
                        {
                            exist = true;
                        }


                    if(!exist)
                    {
                        alert("路径名称必须由以下字母组成："+smallch);
                        document.form.NewFolder.focus();
                        return false;
                    }

                }
            }
            var keyword=$("input[name='keyword']").val();
            var description=$("textarea[name='description']").val();
            document.getElementById("newspecial").style.display = "none";
            document.getElementById("newspecialfinsh").style.display = "";
           
            document.getElementById("submitButton").disabled=true;
            document.getElementById("submitButton").style.cursor="default";
            document.getElementById("submitButton").style.color="#cccccc";
            var process1="";
            $.ajax({
                type:"GET",
                url: "special_cloud.jsp?id="+cloud_id+"&parent="+$("#ChannelID").val()+"&sourceid="+cloud_sourceid+"&NewChannelName="+NewChannelName+"&NewFolder="+NewFolder+"&keyword="+keyword+"&description="+description+"",
                dataType:"json",
                beforeSend:function(XMLHttpRquesr){
                    $(".loading").show();
                },
                success: function(res) {
                    console.log(res.status);
                    
                    document.getElementById("submitButton").disabled=false;
                    $(".loading").fadeOut("slow");
                    
                    if(res.status==0){
                        
                        if (type==1){
                        document.getElementById("newspecial").style.display = "none";
                        document.getElementById("newspecialfinsh").style.display = "none";
                        document.getElementById("newspecialfinsh2").style.display = "block";
                        document.getElementById("submitButton").style.display = "none";
                        document.getElementById("submitButton2").style.display = "block";
                        
                           
                        }else{
                           top.opener.location.reload();
                            top.TideDialogClose();
                            top.close(); 
                        
                        }
                        
                    }else{
                        alert(res.message)
                    }
                }
            });
        }
    }
</script>
<body class="" >

<div class="bg-white modal-box">
    <div class="d-flex justify-content-center flex-column" id="newspecialfinsh" style="display:none!important;" >
        <div style="margin-top:150px " class="loading">

            <p class="tx-center tx-16"><img src="../images/video_loading.gif" width=50px height=50px></p>
            <p class="tx-center tx-16">正在创建节点</p>
            <p class="tx-center tx-16">正在复制模板</p>
            <p class="tx-center tx-16 mg-b-20">正在复制文件......</p>

        </div>
    </div>
     <div class="d-flex justify-content-center flex-column" id="newspecialfinsh2" style="display:none!important;" >
        <div style="margin-top:150px ">
            <p class="tx-center tx-32">创建成功</p>
        </div>
    </div>

    <div class="modal-body-nomal pd-20 overflow-y-auto" id="newspecial">
        <tr><td></td><td><span id="tishi"></span></td></tr>
        <div class="row">
            <label class="left-fn-title wd-120">专题名称：</label>
            <label class="wd-230">
                <input name="NewChannelName" id="NewChannelName" class="form-control" placeholder="" type="text" >
            </label>
        </div>

        <div class="row">
            <label class="left-fn-title wd-120">专题路径：</label>
            <label class="wd-230">
                <input name="NewFolder" id="NewFolder" class="form-control" placeholder="" type="text" >
            </label>
        </div>
        <div class="row">
            <label class="left-fn-title wd-120">关键词：</label>
            <label class="wd-230">
                <input name="keyword" id="keyword" class="form-control" placeholder="" type="text" >
            </label>
        </div>
        <div class="row">
            <label class="left-fn-title wd-120" >描述：</label>
            <label class="wd-150">
                <textarea name="description" id="description" type="textarea" value="" rows="6" cols="38"  class="form-control wd-400" placeholder=""></textarea>
            </label>
        </div>
    </div>
    <div class="btn-box">
        <div class="modal-footer">
            <button type="button" class="btn btn-primary tx-size-xs" id="submitButton" onClick="showStep(3)">确认</button>
             <button type="button" class="btn btn-primary tx-size-xs" id="submitButton2" onclick="top.TideDialogClose();"  style="display:none!important;">确认</button>
            <button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs"  data-dismiss="modal">取消</button>
            <input type="hidden" name="Parent" value="<%=ChannelID%>">
            <input type="hidden" name="ChannelID" id="ChannelID" value="<%=ChannelID%>">
        </div>
    </div>

</div><!-- br-mainpanel -->

<!-- ########## END: MAIN PANEL ########## -->

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
<script src="../lib/highlightjs/highlight.pack.js"></script>
<!--<script src="../../lib/2018/datatables/jquery.dataTables.js"></script>
<script src="../../lib/2018/datatables-responsive/dataTables.responsive.js"></script>-->
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>

</body>
</html>
