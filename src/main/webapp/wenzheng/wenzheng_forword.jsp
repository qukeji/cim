<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				 java.text.DecimalFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//问政转发弹出框

    int		GlobalID		=	getIntParameter(request,"GlobalID");
    int		ChannelID	=	getIntParameter(request,"ChannelID");
    int		ItemID	=	getIntParameter(request,"ItemID");
    int		operation	=	getIntParameter(request,"operation");
    
    Document doc=CmsCache.getDocument(ItemID,ChannelID);
    
    int categoryID = doc.getCategoryID();
    int ispublic = doc.getIntValue("ispublic");
    
%>
<!DOCTYPE HTML>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <title>TideCMS</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <style>
        html,
        body {
            width: 100%;
            height: 100%;
        }
    </style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript">
window.onload=function(){
//选中是否公开
$(":radio[name='ispublic'][value='<%=ispublic+1%>']").prop("checked", "checked");

var selectVal = <%=categoryID%>;
          $.ajax({
                 timeout: 3000,
                 async: false,
                 type: "POST",
                 url: "../lib/channel_json.jsp?ChannelID=16357",
                 dataType: "json",
                 success: function (data) {
                     for (var i = 0; i < data.length; i++) {
                    	 
                         $("#select_dept").append("<option value = '"+data[i].id+ "'>" + data[i].name + "</option>");

                         $("#select_dept").val(selectVal); 
                     }
                }
          });
    }
  




    function addoperation()
{        //是否公开
         var ispublic = $('input:radio[name="ispublic"]:checked').val()
		 //回复内容
         var reason=$("textarea[id='reason']").val();
         if(reason==""){
             TideAlert("提示","内容不能为空！");
             return false;
         }
         //部门选中
         var belong=document.getElementById('select_dept').value;
         if(belong==0){
             TideAlert("提示","请选择转交部门！");
             return false;
         }
         //操作
         var operation = <%=operation%>;

         var GlobalID=<%=GlobalID%>;
         var ChannelID=<%=ChannelID%>;
         var ItemID=<%=ItemID%>;
                                   
            $.ajax({
                type: "GET",
                url: "../wenzheng/wenzheng_dataupdate.jsp",
                data: {GlobalID:GlobalID,ChannelID:ChannelID,ItemID:ItemID,reason:reason,ispublic:ispublic,belong:belong,operation:operation},
                success: function(msg){
                    window.parent.location.reload();//刷新父窗口
                    window.parent.opener.document.location.reload();//刷新父级列表页
			        top.TideDialogClose();
                }
            });
           
					//var url="../content/content2018_livereview.jsp?id=16303&globalid=" + parentglobalid;
			

					//window.parent.location.reload();
					//top.TideDialogClose(window.location.href = url);
					//window.location.href = url;
}
</script>
</head>

<body>
<div class="bg-white modal-box">
        
        <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
            <div class="config-box">
                <ul>
                    
                    <li class="block">
                        <div class="row">
                            <label class="left-fn-title">是否公开：</label>
                            <label class="rdiobox mg-r-15"><input type="radio" value="1" id="ispublic_0" name="ispublic"><span class="d-inline-block" for='ispublic_0'>公开</span></label>
                            <label class="rdiobox mg-r-15"><input type="radio" value="2" id="ispublic_1" name="ispublic" ><span class="d-inline-block" for='ispublic_1'>不公开</span></label>
                        </div>
                        <%if(operation==4){%>
                        <div class="row">
                            <label class="left-fn-title">回复内容：</label>
                            <textarea id="reason" rows="3" class="form-control" placeholder="" name="reason" style="width:300px;height:100px"></textarea>
                        </div>
                        <%}%>
                        
                        <div class="row flex-row align-items-center mg-b-15" id="tr_select_dept">
                            <label class="left-fn-title wd-150" id="desc_select_dept">转交部门：</label>
                            <label class="wd-content-lable d-flex " id="field_select_dept">
                                <select name="select_dept" id="select_dept" class="form-control wd-230 ht-40 select1"></select>
                            </label>
                        </div>


                    </li>

                </ul>
            </div>
        </div>
        
        <!--modal-body-->

        <div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
            <div class="modal-footer">
                <button name="startButton" type="button" class="btn btn-primary tx-size-xs"  id="startButton" onclick="addoperation();">确定</button>
                <button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消
                </button>
            </div>
        </div>
</div>
<!-- modal-box -->
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

<script language=javascript>
    function init() {
        document.form.Template.focus();
    }

    function check() {
        for(var i=0;i<document.form1.elements.length-1;i++)
        {
         if(document.form1.elements[i].value=="")
         {
           TideAlert("当前表单不能有空项");
           document.form1.elements[i].focus();
           return false;
         }
        }
        return true;
        
    }
    
  function beforeSubmit(form){
if(form.operation.value==''){
	TideAlert("提示","内容不能为空！");
form.username.focus();
return false;
}

return true;
}
    
    
</script>

</html>
