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
	//if(!userinfo_session.isAdministrator())
	//{ response.sendRedirect("../noperm.jsp");return;}
	request.setCharacterEncoding("utf-8");
	String info="";
	int	ChannelID		=	getIntParameter(request,"ChannelID");
	//out.println("ChannelID"+ChannelID);
	int	pagenum		=	getIntParameter(request,"pagenum");
	String Type			=	getParameter(request,"Type");
	String ChannelName	=	getParameter(request,"ChannelName");
	String pageName = request.getServletPath();
	int pindex = pageName.lastIndexOf("/");
	if(pindex!=-1){
		pageName = pageName.substring(pindex+1);
	}
	int		SpecialTemplate			= getIntParameter(request,"SpecialTemplate");

	ChannelPrivilege cp = new ChannelPrivilege();

	if(SpecialTemplate>0)
	{
		String	NewChannelName			= getParameter(request,"NewChannelName");
		String	NewFolder				= getParameter(request,"NewFolder");
		String	keyword					= getParameter(request,"keyword");
		String	description				= getParameter(request,"description");

		int		Parent					= getIntParameter(request,"Parent");

		SpecialChannelUtil special = new SpecialChannelUtil();

		special.setSourceChannelID(SpecialTemplate);
		special.setNewChannelName(NewChannelName);
		special.setNewFolder(NewFolder);
		special.setNewChannelParentID(Parent);
		special.setKeyword(keyword);
		special.setDescription(description);
		special.generateSpecial();



		//Page pageitem = new Page();
		//pageitem.updatePageSeo(keyword, description);

		out.println("<script>top.TideDialogClose({refresh:'left'});</script>");return;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="noindex, nofollow">
	<link rel="Shortcut Icon" href="../favicon.ico">
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

	<script language=javascript>
	
	    var selectType = 0;
        function init()
        {

        }

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
        function showStep(step)
        {
            $("#pages").remove();
            if(step==2)
            {
                document.getElementById("step1").style.display = "none";
                document.getElementById("step2").style.display = "";

                document.getElementById("stepButton2").style.display = "none";
                document.getElementById("submitButton").style.display = "";
            }

            if(step==3)
            {
                if(selectType==1){
                        document.getElementById("submitButton").disabled=true;
                        document.getElementById("submitButton").style.cursor="default";
                        document.getElementById("submitButton").style.color="#cccccc";
                        document.getElementById("tishi").innerHTML="正在生成专题...";
                        var cloud_id=$('input[type=checkbox]:checked').eq(0).val();
                        var cloud_sourceid=$('input[type=checkbox]:checked').eq(0).attr("channelid");
                        $.getJSON("special_cloud.jsp?id="+cloud_id+"&parent="+$("#ChannelID").val()+"&sourceid="+cloud_sourceid, function(o){
                                 if(o.status==0){parent.location.reload();}
                                 else{alert(o.message)}
                                 document.getElementById("submitButton").disabled=false;
                                 
                            });
                }else{
                    
                    if(check())
                    {
                        $.get("channel_special_checkfolder1.jsp?id="+$("#ChannelID").val()+"&Folder="+$("#NewFolder").val(), function(o){
                            if(o==1)
                            {
                                if(confirm("目录已经存在，新的专题可能会覆盖原有的文件，请问是否继续？")){
                                    document.getElementById("submitButton").disabled=true;
                                    document.getElementById("submitButton").style.cursor="default";
                                    document.getElementById("submitButton").style.color="#cccccc";
                                    document.getElementById("tishi").innerHTML="正在生成专题...";
                                    document.form.submit();
                                }
                            }
                            if(o==0){
                                document.getElementById("submitButton").disabled=true;
                                document.getElementById("submitButton").style.cursor="default";
                                document.getElementById("submitButton").style.color="#cccccc";
                                document.getElementById("tishi").innerHTML="正在生成专题...";
                                document.form.submit();
                            }
                        });
                    }
                }
            }
        }
        function Preview(id)
        {
            window.open("special_preview.jsp?id=" + id);
        }

        function select(o)
        {
           /* $(":input[name='SpecialTemplate']").attr("checked",false);
            alert($(o).find(":input[name='SpecialTemplate']").prop("checked"));
            $(o).find(":input[name='SpecialTemplate']").attr("checked", true);*/
        }
	</script>
	<style>
		html,body{
			width: 100%;
			height: 100%;
		}
		.lock-unlock{
			min-width: 20px;
		}
		.modal-body{top:0}
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
	<!-- <div class="ht-60 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
		<ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
			<li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#" role="tab">本地模板</a></li>
			<li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab"  >云专题</a></li>
		</ul>
	</div> -->
	<form name="form" action="channel_special_add.jsp" method="post" onSubmit="return check();">
		<div class="modal-body pd-20 overflow-y-auto" id="step1">
			<div class="config-box">
				<ul>
					<!--鍩烘湰淇℃伅-->
					<li class="block">
						<div class="card bd-0 shadow-base" >
							<table   class="table mg-b-0 view_table" id="content-table">
								<tr style="text-align:center">
									<th class="wd-5p wd-50">选择</th>
									<th class="tx-12-force tx-mont tx-medium wd-250">模板名称</th>
									<!-- <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-250" >鎻忚堪</th>-->
									<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-30" style="text-align:center">预览</th>
								</tr>
								<tbody>

								<%
									String special_id="";
									String special_name="";
									String special_template = CmsCache.getParameterValue("sys_special_template_json");
									JSONArray o1;
									int count=0;
									int max=100;
									int count_page=0;
									try {
										o1 = new JSONArray(special_template);
										count = o1.length();
										if(count%max==0){
											count_page = count/max;
										}else{
											count_page = (count/max)+1;
										}
								%>
								<script>
                                    function gopage(pagenum){

                                        /*if(parseInt(count/max)+1==pagenum){
                                            pages();
                                        }*/
                                        window.location="<%=request.getContextPath()%>/special/channel_special_add1.jsp?pagenum="+pagenum+"&ChannelID="+$("#ChannelID").val();

                                    }
								</script>
								<%
									if(pagenum==0){
										pagenum=1;
									}
									int count_1=max*pagenum;
									if(count_1>count-1)
									{
										count_1=count;
									}

									for(int i =max*(pagenum-1);i<=count_1-1;i++)
									{
										JSONObject oo = o1.getJSONObject(i);
										special_id = oo.getString("id");
										special_name = oo.getString("name");

								%>
								<tr class="tide_item" id="num_<%=i%>" style="" onClick="select(this)">
									<td class="valign-middle">
										<label class="ckbox mg-b-0">
											<input type="checkbox" name="SpecialTemplate" value="<%=special_id%>"><span></span>
										</label>
									</td>
									<td class="hidden-xs-down">
										<%=special_name%>
									</td>
									<td class="dropdown hidden-xs-down" style="text-align:center">
										<a href="javascript:Preview(<%=special_id%>);" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
									</td>
								</tr>
								<%}
								}catch (JSONException e1) {
									ErrorLog.Log("专题", "配置json读取错误", "");
								}
								%>
								</tbody>
							</table>
						</div>

					</li>
					<!--姝や綅缃師jsp涓湁涓€涓户缁柊寤洪€夐」 闈欐€侀〉涓病鏈� 浠ラ潤鎬侀〉涓哄噯-->
					<!--鎷撳睍淇℃伅-->
					<li >
						<div class="card bd-0 shadow-base ">
							<table   class="table mg-b-0 view_table" id="">
								<tr style="text-align:center">
									<th class="wd-5p wd-50">选择</th>
									<th class="tx-12-force tx-mont tx-medium wd-250">模板名称</th>
									<!-- <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-250" >鎻忚堪</th>-->
									<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-30" style="text-align:center">预览</th>
								</tr>
								<tbody class="tide_item2">


								</tbody>
							</table>
						</div>
					</li>
					<!--鎺ㄨ崘璁剧疆-->


				</ul>
			</div>
		</div><!-- modal-body -->

		<div class="modal-body modal-body-btn pd-20 overflow-y-auto" id="step2" style="display:none;margin-top:90px">
			<div style="border:none;" class="config-box">


				<table  width="80%" border="0" class="mg-l-60">
					<tr><td></td><td><span id="tishi"></span></td></tr>
					<div class="row">
						<label class="left-fn-title">专题名称：</label>
						<label class="wd-230">
							<input name="NewChannelName" id="NewChannelName" class="form-control" placeholder="" type="text" >
						</label>
					</div>
					<div class="row">
						<label class="left-fn-title">专题路径：</label>
						<label class="wd-230">
							<input name="NewFolder" id="NewFolder" class="form-control" placeholder="" type="text" >
						</label>
					</div>
					<div class="row">
						<label class="left-fn-title">关键词：</label>
						<label class="wd-230">
							<input name="keyword" id="keyword" class="form-control" placeholder="" type="text" >
						</label>
					</div>
					<div class="row">
						<label class="left-fn-title">描述：</label>
						<label class="wd-150">
							<textarea name="description" id="description" type="textarea" value="" rows="6" cols="38"  class="form-control wd-400" placeholder=""></textarea>
						</label>
					</div>


				</table>


			</div>
		</div>

		<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
			<div class="modal-footer" style="border-top: none">

				<input name="startButton" type="button" class="btn btn-primary tx-size-xs" value=" 下一步 " id="stepButton2" onClick="showStep(2)"/>
				<input name="startButton" type="button" class="btn btn-primary tx-size-xs" value=" 确定 " id="submitButton" onClick="showStep(3)" style="display:none" />
				  <input name="Submit2" type="button" class="btn btn-primary tx-size-xs" value="  取  消 " onClick="top.TideDialogClose();">

				<input type="hidden" name="Parent" value="<%=ChannelID%>">
				<input type="hidden" name="ChannelID" id="ChannelID" value="<%=ChannelID%>">
			</div>
		</div>
	</form>
</div>

<script>
    //	var infos='<%=info%>';

    function pages(){
        var infos='<%=info%>';
        $("#stepButton2").before(infos);
    }

    $(function(){
        pages();
    })
</script>
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

    });
</script>

<script type="text/javascript">
    /* $(function()
    {
        var url="http://jushi.tidemedia.com/cms//api/special_cloud_list.jsp";
		break ;
        $.ajax({
            type:"GET",
            url: url,
            dataType:"jsonp",
            jsonpCallback:"specialJSON",
            success: function(res){
                var html = "";
                for(var i in res)
                {
                    html += '<tr class="tide_item"  id="item_'+res[i].id +'" onClick="select(this)" >' +
                        '<td class="valign-middle" >' +
                        '<label class="ckbox mg-b-0">'+
                        '<input name="SpecialTemplate" value="'+res[i].id+'" channelid="'+res[i].sourceid+'" type="checkbox"/>' +
                        '<span>'+
                        '</span>'+
                        '</lable>'+
                        '</td>';
                    html += '<td class="hidden-xs-down">'+res[i].name+'</td>';
                    html += '<td class="dropdown hidden-xs-down" style="text-align:center">'+
                    '<a href="javascript:Preview()>); class="btn pd-0 mg-r-5" title="预览">'+
                    '<i class="fa fa-search tx-18 handle-icon" aria-hidden="true">'+
                    '</i>'+
                    '</a>'
                    '</td>';
                }
                var oContent = $('.tide_item2');
                oContent.html(html);
            }
        });
    }); */
</script>

</html>
