<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.page.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
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
	if(!cp.hasRight(userinfo_session,ChannelID,ChannelPrivilege.AddItem))
	{
		out.println("<script>top.getDialog().Close();</script>");return;
	}

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
		special.setActionUser(userinfo_session.getId());
		special.setKeyword(keyword);
		special.setDescription(description);
		special.generateSpecial();

		userinfo_session.initChannelPermArray();

		//Page pageitem = new Page();
		//pageitem.updatePageSeo(keyword, description);

		out.println("<script>top.TideDialogClose({refresh:'left'});</script>");return;
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>TideCMS</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
	<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
	<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
	<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
	<link rel="stylesheet" href="../style/2018/bracket.css">
	<link rel="stylesheet" href="../style/2018/common.css">
	<link href="../style/contextMenu.css" type="text/css" rel="stylesheet" />
	<style>
		.collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
		table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word}
		table.table-fixed,table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;
			border-collapse: collapse !important;}
		.list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;}
		.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}
		@media (max-width: 575px){
			#content-table .hidden-xs-down {word-break: normal;	}
		}
	</style>

	<script src="../lib/2018/jquery/jquery.js"></script>
	<script type="text/javascript" src="../common/2018/common2018.js"></script>
	<script type="text/javascript" src="../common/2018/content.js"></script>

	<script language=javascript>
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
        function Preview(id)
        {
            window.open("special_preview.jsp?id=" + id);
        }

        function select(o)
        {
            $(o).find(".radio").attr("checked", "checked");
        }
	</script>

	<style>
		body{background:none;}
		.content-top,.content,.content_bot{margin:0;}
	</style>
</head>
<body onLoad="init();" scroll="no" class="collapsed-menu email">
<div class="ht-60 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
	<ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
		<li class="nav-item"><a class="nav-link " data-toggle="tab" href="../special/channel_special_add1.jsp" role="tab"  onClick="showStep(1)">本地模板</a></li>
		
		<li class="nav-item"><a class="nav-link active" data-toggle="tab" href="../special/channel_special_add_colud.jsp" role="tab"  >云模板</a></li>
	</ul>
</div>
<form name="form" action="channel_special_add.jsp" method="post" onSubmit="return check();">

	<!-- content -->
	<div class="br-pagebody pd-x-20 pd-sm-x-30 modal-body pd-20 overflow-y-auto" id="step1" style="margin-top:10px">
		<div class="card bd-0 shadow-base">
		
				<table   class="table mg-b-0 view_table" id="content-table">
					<tr style="text-align:center">
						<th class="wd-5p wd-50">选择</th>
						<th class="tx-12-force tx-mont tx-medium wd-250">模板名称</th>
						<!-- <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-250" >描述</th>-->
						<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-30" style="text-align:center">浏览</th>
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
			<!-- <%
	if(count_page>0){%>
			<div id="tide_content_tfoot">
				<span class="mg-r-20 ">共<%=count%>条</span>
				<span class="mg-r-20 "><%=pagenum%>/<%=count_page%>页</span>
				<div class="each-page-num mg-l-auto" style="margin-right: 380px">
					<label class="wd-80 mg-b-0" >
						<a href="javascript:gopage(1);" title="首页"><img src="../images/viewpane_pages1.png" alt="首页" /></a>
						<%if(pagenum>1){%><a href="javascript:gopage(<%=pagenum-1%>);" title="上一页"><img src="../images/viewpane_pages2.png" alt="上一页" />上一页</a>
						<%}%><%if(pagenum<count_page){%><a href="javascript:gopage(<%=pagenum+1%>);" title="下一页">下一页<img src="../images/viewpane_pages3.png" alt="下一页" /></a>
						<%}%><a href="javascript:gopage(<%=count_page%>);" title="末页"><img src="../images/viewpane_pages4.png" alt="末页" /></a>
					</label>
				</div>
			</div>
			<!--分页
				<%
		}
	%>-->
	</div>
	</div>
	</div>
	<div class="modal-body modal-body-btn pd-20 overflow-y-auto" id="step2" style="display:none;margin-top:90px">
		<div style="border:none;" class="config-box">
			<ul>
				<li class="block">

					<table  width="90%" border="0">
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

			</ul>
			</li >
		</div>
	</div>
	<div class="content_bot">
		<div class="left"></div>
		<div class="right"></div>
	</div>
	<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
		<div class="modal-footer" style="border-top: none">

			<input name="startButton" type="button" class="btn btn-primary tx-size-xs" value=" 下一步 " id="stepButton2" onClick="showStep(2)"/>
			<input name="startButton" type="button" class="btn btn-primary tx-size-xs" value=" 确定 " id="submitButton" onClick="showStep(3)" style="display:none" />
			  <input name="Submit2" type="button" class="btn btn-primary tx-size-xs" value="  取  消  " onClick="top.TideDialogClose();">

			<input type="hidden" name="Parent" value="<%=ChannelID%>">
			<input type="hidden" name="ChannelID" id="ChannelID" value="<%=ChannelID%>">
		</div>
	</div>

</form>
</form>
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
</html>
