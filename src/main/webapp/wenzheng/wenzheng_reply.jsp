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
    //问政回复界面接口
    
%>
<%
    if(!userinfo_session.isAdministrator())
    { response.sendRedirect("../noperm.jsp");return;}

    int		ChannelID	=	getIntParameter(request,"ChannelID");
    int		ItemID		=	getIntParameter(request,"ItemID");
    String  reasonR1	= getParameter(request,"Extra1");//回复内容
    String  message="回复内容不能为空";
    TideJson politicsreason = CmsCache.getParameter("politicsreason").getJson();//问政接口信息
    int channelid = politicsreason.getInt("politicsreasonid");//问政编号信息



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
</head>

<body>
<div class="bg-white modal-box">
    <form name="form" action="wenzheng_reason_submit.jsp" method="post" onSubmit="return beforeSubmit(this);">

        <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
            <div class="config-box">
                <ul>
                    <%
                        //查到问政详情
                        Channel channel = CmsCache.getChannel(ChannelID);
                        String sql="select * from "+channel.getTableName()+" where id="+ItemID;
                        TableUtil tu = new TableUtil();
                        ResultSet rs = tu.executeQuery(sql);
                        while(rs.next()){
                            String Title=rs.getString("Title");
                            int GlobalID=rs.getInt("GlobalID");
                            Channel channel1 = CmsCache.getChannel(channelid);
                    %>

                    <li class="block">
                        <div class="row">
                            <label class="left-fn-title">主题：</label>
                            <label class="wd-230">
                                <span><%=Title%></span>
                            </label>
                        </div>
                        <%
                        //查到回复内容
                            String sql1="select * from "+channel1.getTableName()+" where Active=1 and parent="+GlobalID+" ORDER BY CreateDate asc";
                            ResultSet rs1 = tu.executeQuery(sql1);
                            while(rs1.next()){
                                String TitleR=rs1.getString("Title");
                                String Reason=rs1.getString("reason");
                                int Gid=rs1.getInt("parent");
                                String SummaryR=rs1.getString("Summary");
                        %>

                        <%if(SummaryR!=null){%>
                        <div class="row">
                            <label class="left-fn-title">问：</label>
                            <label class="wd-230">
                                <span><%=SummaryR%></span>
                            </label>
                        </div>
                        <%}%>
                       
                        <%if(Reason!=null){%>
                        <div class="row">
                            <label class="left-fn-title">答：</label>
                            <label class="wd-230">
                                <span><%=Reason%></span>
                            </label>
                        </div>
                        <%}%>
                    <%}%>
                <%}%>
                        <div class="row">
                            <label class="left-fn-title">回复：</label>
                            <textarea id="reasonR1" rows="3" class="form-control" placeholder="" name="Extra1" style="width:300px;height:100px"></textarea>
                        </div>
                        
                    </li>

                </ul>
            </div>
        </div>
        <!--modal-body-->

        <div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
            <div class="modal-footer">
                <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
                <input type="hidden" name="ItemID" value="<%=ItemID%>">
                <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确认</button>
                <button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消
                </button>
                <input type="hidden" name="Submit" value="Submit">
            </div>
        </div>
        <div id="ajax_script" style="display:none;"></div>
    </form>
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
if(form.Extra1.value==''){
	TideAlert("提示","回复内容不能为空！");
form.username.focus();
return false;
}

return true;
}
    
    
</script>

</html>
