<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.io.File"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String	FolderName		=Util.getParameter(request,"FolderName");
String	suffix			=Util.getParameter(request,"suffix");//关闭弹出框使用
int 	GroupID			=Util.getIntParameter(request,"GroupID");
int		ItemID			=Util.getIntParameter(request,"ItemID");
TemplateFile tf;
if(ItemID==0){
	tf = new TemplateFile();
}else{
	tf=new TemplateFile(ItemID);
}

//System.out.println("模板描述：" + tf.getDescription());
TemplateGroup	group=new TemplateGroup(GroupID);
String URL = request.getRequestURL().toString();
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
                    <script  type="text/javascript">
function check()
{
	if(isEmpty(document.form.FileName,"请输入文件名."))
		return false;

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
function selectImage(fieldname)
{
	var dialog = new TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(240);
	dialog.setLayer(2);
	dialog.setUrl("../content/insertfile.jsp?ChannelID=11454&Type=Image&fieldname="+fieldname);
	dialog.setTitle("上传图片");
	dialog.show();
} 
function previewFile(fieldname)
{
	var name = document.getElementById(fieldname).value;
	if(name=="") 
		return;
	if(name.indexOf("http://")!=-1)
		window.open(name);
	else{
		var url = document.URL.split("template/")[0];
		
		window.open(url+"images/template/"+ name);
	}
		

		
}
function uploadFile()
{
	tidecms.dialog("../template/template_image_upload.jsp",600,400,"上传图片");
}
function setReturnValue(o){ 
	//alert(o.photo);
	//return; 	
	if(o.photo!=null){
		$("#Photo").val(o.photo); 
		//$("#Icon").val(o.icon);
	} 
}

function init(){
}
</script>
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
                        <form name="form" action="newfile_submit.jsp" enctype="multipart/form-data" method="post" onSubmit="return check();">

                            <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
                                <div class="config-box">
                                    <ul>
                                        <li class="block">
										<%if(ItemID==0){%>
                                            <div class="row">
                                                <label class="left-fn-title">上级目录：</label>
                                                <label class="wd-230">
				                                   <span><%=group.getName()%></span>
			                                    </label>
                                            </div>
											<div class="row">
                                                <label class="left-fn-title">文件名：</label>
                                                <label class="wd-230">
				                                   <input class="form-control" placeholder="" value="" type="text" name="FileName" id="FileName" />
			                                    </label>
                                            </div>
											 <%}else{%>
											 <div class="row">
                                                <label class="left-fn-title">文件名：</label>
                                                <label class="wd-230">
				                                   <span><%=tf.getFileName()%></span>
			                                    </label>
                                            </div>
											 <%}%>
											 <div class="row">
                                                <label class="left-fn-title">名称：</label>
                                                <label class="wd-230">
				                                   <input class="form-control" placeholder="" type="text" name="Name" id="Name" value="<%=tf.getName()%>"/>
			                                    </label>
                                            </div>
                                            <!--<div id="field_Photo" class="row">
                                                <label class="left-fn-title">上传图片：</label>
                                                <label class="wd-230">
				                                   <input class="form-control" size="80" placeholder="" type="text" value="<%=tf.getPhoto().replace("../images/template/","")%>" id="Photo" name="Photo">
			                                       <br/>注:为空使用系统默认图片
												</label>
                                                <input class="btn btn-primary tx-size-xs mg-l-10" href="javascript:;" name="" type="button" value="选择" onclick="uploadFile()">
                                                <input class="btn btn-primary tx-size-xs mg-l-10" href="javascript:;" name="" type="button" value="预览" onclick="previewFile('Photo')">
                              
                                            </div>-->
											
                                           <div class="row">                   		  	  	
	   		  	  		                       <label class="left-fn-title">模板描述：</label>
			                                   <div class="pd-l-0 pd-r-0 wd-300">
				                                     <textarea name="Description" id="Description" rows="3" class="form-control" placeholder=""><%=tf.getDescription()%></textarea>				                                  
 						                       </div>	
	       		  	                       </div>                                                                           
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <!--modal-body-->

                            <div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
                                <div class="modal-footer">
                                    <input type="hidden" name="suffix" value="<%=suffix%>">
	                                <input type="hidden" name="FolderName" value="">
	                                <input type="hidden" name="GroupID" id="GroupID" value="<%=GroupID%>">
	                                <input type="hidden" name="ItemID" value="<%=ItemID%>">
	                                <%if(!(ItemID==0)){%>
	                                <input type="hidden" name="Action" value="Edit">
	                                <input type="hidden" name="FileName" value="<%=tf.getFileName()%>">
	                                <%}else{%>
	                                <input type="hidden" name="Action" value="Add">
	                                <%}%>
                                    <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确认</button>
                                    <button name="btnCancel1" type="button" onclick="top.TideDialogClose({suffix:'<%=suffix%>'});" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>                       
                                </div>
                            </div>
                            <div id="ajax_script" style="display:none;"></div>
                        </form>
                    </div>
                    <!-- modal-box -->
                </body>

                  <script src="../lib/2018/jquery/jquery.js"></script>
                  <script src="../common/2018/common2018.js"></script>
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
                        if (isEmpty(document.form.Template, "请输入模板."))
                            return false;
                        if (isEmpty(document.form.TemplateType, "请选择模板类型."))
                            return false;
                        if (isEmpty(document.form.TargetName, "请输入对应程序文件名称."))
                            return false;

                        return true;
                    }

                    function selectTemplate() {
                        var dialog = new top.TideDialog();
                        dialog.setWidth(1000);
                        dialog.setHeight(620);
                        dialog.setSuffix('_2');
                        dialog.setUrl("../channel/selecttemplate2018.jsp");
                        dialog.setTitle("选择模板");
                        //dialog.setScroll('auto');
                        dialog.show();
                    }

                    function setReturnValue(o) {
                        if (o.TemplateID != null) {
                            document.form.TemplateID.value = o.TemplateID;
                            var scr = document.createElement('script')
                            scr.src = '../channel/template_add_js.jsp?id=' + o.TemplateID;
                            document.getElementById('ajax_script').appendChild(scr);
                        }
                    }

                    function change() {
                        $("#tr01").hide();
                        $("#tr02").hide();
                        $("#tr03").hide();

                        var type = document.form.TemplateType.value; //alert(type);
                        if (type == "1") {
                            $("#tr01").show(); //tr01.style.display = "";
                        } else if (type == "2") {
                            $("#tr02").show(); //tr02.style.display = "";
                        } else if (type == "3") {
                            $("#tr03").show(); //tr03.style.display = "";
                        }

                    }

                    function changeFolderType() {
                        var t = "";
                        if (document.form.SubFolderType.value == "0") {
                            t = "没有子目录";
                        } else if (document.form.SubFolderType.value == "1") {
                            t = "如：/2018/";
                        } else if (document.form.SubFolderType.value == "2") {
                            t = "如：/2018/08/";
                        } else if (document.form.SubFolderType.value == "3") {
                            t = "如：/2018/08/08/";
                        } else if (document.form.SubFolderType.value == "4") {
                            t = "如：/2018-08-08/";
                        } else if (document.form.SubFolderType.value == "5") {
                            t = "目录由文档中的Path字段指定.";
                        } else if (document.form.SubFolderType.value == "6") {
                            t = "如：/20180808/";
                        }

                        $("#FolderTypeDesc").html(t);
                    }

                    function ViewTemplate() {
                        TemplateID = document.form.TemplateID.value;

                        if (TemplateID == "") return;

                        var foldername = "";
                        var filename = "";
                        var width = Math.floor(screen.width * .8);
                        var height = Math.floor(screen.height * .8);
                        var leftm = Math.floor(screen.width * .1) + 30;
                        var topm = Math.floor(screen.height * .05) + 30;
                        var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm + ",top=" + topm + ", width=" + width + ", height=" + height;

                        var url = "../template/template_edit.jsp?TemplateID=" + TemplateID;
                        window.open(url, "", Feature);
                    }
                </script>

         
