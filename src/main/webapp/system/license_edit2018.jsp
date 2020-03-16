<%@ page import="java.sql.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String	Submit	= getParameter(request,"Submit");
int flag = 0;
if(!Submit.equals(""))
{
}
else
{
	flag = getIntParameter(request,"flag");
}

//获取机器码
String serverCode = CmsCache.getServerCode();
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
	function open(){
		  window.location = "license_edit2018.jsp";
				return;		
		
	//alert("请输入许可代码或代码编号");
	//	return false;
	  
  }
	
function update(){
	var code = $("#code").val();
	var license = $("#license").val();
	var notify = $("#notify");
	notify.html("");
	if(code=="" && license==""){
		
		              var dialog = new top.TideDialog();
                            dialog.setWidth(320);
                            dialog.setHeight(260); 
							//dialog.setSuffix('_2');
                           // dialog.setUrl(url);							
                            dialog.setTitle("提示");
							dialog.setMsg("请输入许可代码或代码编号");
							dialog.setMsgJs('(function open() )')
                            dialog.ShowMsg();
		}

	$("#submit_btn").attr("disabled","true").val("正在提交");
	var url="license_update.jsp?code=" + code + "&license="+license;
	$.ajax({
		type: "post",dataType:"json",url: url,
		success: function(msg){
			
			if(msg.status>0)
			{
				//window.console.info("a");
				window.location = "license2018.jsp";
				return;				
			}
			else
			{
				//alert(msg.message);
				notify.html("<font color=red>"+msg.message+"</font>");
				$("#submit_btn").attr("disabled","false").val("提交");
				return;	
			}

			//this.location = "license.jsp";
		}
	});
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
                <span class="breadcrumb-item active">系统管理 / 许可证设置<span id="notify"></span></span>
            </nav>
        </div>
        <!-- br-pageheader -->
        <form name="form" method="post" action="license_edit2018.jsp" onSubmit="return check();">
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
						 <%if(flag==0 || flag==1){%>
						    <tr>
                                <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;"></td>
                                <td class="hidden-xs-down"><font color=red><%if(flag==1){%>该系统的许可证无效或已经过期，请设置新的许可证代码。<%}else{%>系统需要设置正确的许可代码，请联系管理员进行设置。<%}%></font></td>
                            </tr>
						 
                            <tr>
                                <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">许可代码：</td>
                                <td class="hidden-xs-down"><textarea name="license" id="license" cols=62 rows=6  class="form-control wd-300" placeholder=""></textarea></td>
                            </tr>
                            <tr>
                                <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">代码编号：</td>
                                <td class="hidden-xs-down"><input class="form-control wd-300" placeholder="" type="text" size=60 name="code" id="code" ></td>
                            </tr>
                            <tr>
                                <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">机器码：</td>
                                <td class="hidden-xs-down"><span class="form-control wd-300" placeholder="" type="text"><%=serverCode%></span> </td>
                            </tr>  
                            <%}else if(flag==2){%>
							    <tr>
                                  <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;">许可类型：</td>
                                  <td class="hidden-xs-down">
                                              许可设置成功，请重新启动系统，然后重新登录使用。
                                  </td>
                                 </tr>
							 <%}%>
							 <%if(flag!=2){%>
                                <tr>
                                   <td class="hidden-xs-down" style="vertical-align: middle !important; text-align:right;"></td>
                                   <td class="hidden-xs-down">
                                 
                                    <button type="Submit" id="submit_btn" name="submit" class="btn btn-primary tx-size-xs" onClick="update()" >提交</button>
                                  <input type="button" name="btnCancel1" class="btn btn-secondary tx-size-xs" data-dismiss="modal" value="取消" onclick="location='license2018.jsp';"></button><span id="notify"></span>
                                </td>
                              </tr>
							  <%}%>
                        </tbody>
                    </table>
                </div>
            </div>
            <!--列表-->
        </form>
    </div>
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