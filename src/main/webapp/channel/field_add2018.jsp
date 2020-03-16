<%@ page import="tidemedia.cms.system.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
   *	2016.10.11 王海龙 tidecms.css 改成dialog.css
   *
   */
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int		ChannelID			= getIntParameter(request,"ChannelID");
int		GroupID				= getIntParameter(request,"GroupID");
int ContinueAdd				=	getIntParameter(request,"ContinueAdd");

String	Submit	= getParameter(request,"Submit");
if(!Submit.equals(""))
{

	int		IsHide				= getIntParameter(request,"IsHide");
	int		DisableBlank		= getIntParameter(request,"DisableBlank");
	int		DisableEdit			= getIntParameter(request,"DisableEdit");
	String	FieldName			= getParameter(request,"FieldName");
	String	Description			= getParameter(request,"Description");
	String	FieldType			= getParameter(request,"FieldType");
	String	Options				= getParameter(request,"Options");
	String  Other				= getParameter(request,"Other");
	String  DefaultValue		= getParameter(request,"DefaultValue");
	String  Style				= getParameter(request,"Style");
	String  RecommendChannel	= getParameter(request,"RecommendChannel");
	String  RecommendValue		= getParameter(request,"RecommendValue");
	String  GroupChannel		= getParameter(request,"GroupChannel");
	int		Size				= getIntParameter(request,"Size");
	String  HtmlTemplate		= getParameter(request,"HtmlTemplate");
	String  DictCode			= getParameter(request,"DictCode");
	String  Caption				= getParameter(request,"Caption");
	int		DataType			= getIntParameter(request,"DataType");
	int		RelationChannelID	= getIntParameter(request,"RelationChannelID");
	int		Watermark	= getIntParameter(request,"Watermark");//是否水印
	int		IsCompress	= getIntParameter(request,"IsCompress");//是否压缩
	String  Width				= getParameter(request,"Width");//压缩宽度
	String  Height				= getParameter(request,"Height");//压缩高度
	if(ChannelID>0 && !FieldName.equals(""))
	{
		Field field = new Field();

		field.setChannelID(ChannelID);
		field.setGroupID(GroupID);
		field.setIsHide(IsHide);
		field.setDisableBlank(DisableBlank);
		field.setDisableEdit(DisableEdit);
		field.setName(FieldName);
		field.setDescription(Description);
		field.setFieldType(FieldType);
		field.setOptions(Options);
		
		field.setDefaultValue(DefaultValue);
		field.setOther(Other);
		if("image".equals(FieldType)){
			JSONObject oo = new JSONObject();
			oo.put("Watermark", Watermark);
			oo.put("IsCompress", IsCompress);
			if(IsCompress==1){
				oo.put("Width", Width);
				oo.put("Height", Height);
			}
			field.setOther(oo.toString());
		}
		field.setHtmlTemplate(HtmlTemplate);
		field.setDictCode(DictCode);
		field.setSize(Size);
		field.setStyle(Style);
		field.setRecommendChannel(RecommendChannel);
		field.setRecommendValue(RecommendValue);
		field.setGroupChannel(GroupChannel);
		field.setDataType(DataType);
		field.setRelationChannelID(RelationChannelID);
		field.setCaption(Caption);

		field.Add();
		//重新调用页面生产程序,产生新的页面;
		Channel channel = CmsCache.getChannel(ChannelID);
		if(channel.getType()==3)
		{
			App p = new App(ChannelID);
			p.GenerateFormFile(userinfo_session);
		}
		//生成成功;

		if(ContinueAdd==0)
		{
		out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true,field:"+field.getId()+"}});</script>");
		return;
		}
	}
}
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
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>添加字段</title>

    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <!--<link href="../../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">-->
    <!--<link href="../../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">-->
    
    <!--<link href="../lib/highlightjs/github.css" rel="stylesheet">-->
    
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
  <style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  	.modal-body .config-box .row{
  		margin-bottom: 10px;
  	}
  	.modal-body .config-box label.ckbox{
  		width: auto;
  		margin-right: 10px;
  	}
  	.modal-body .config-box label.ckbox input{
  		
  		margin-right: 2px;
  	}
  </style>
  <script language="javascript">
function check()
{
	if(isEmpty(document.form.FieldName,"请输入字段名称."))
		return false;

	var smallch="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"; 

	for(var i=0;i<document.form.FieldName.value.length;i++)
	{
		var exist = false;
		for(var j=0;j<smallch.length;j++)
		{
			if(document.form.FieldName.value.charAt(i)==smallch.charAt(j))
			{
				exist = true;
			}
		}

		if(!exist)
		{
			alert("字段名称必须由英文字母或数字或下划线组成.");
			document.form.FieldName.focus();
			return false;
		}

	}
	var fieldtype = document.form.FieldType.options[document.form.FieldType.options.selectedIndex].value;
	if(fieldtype!="label"){		
		if(isEmpty(document.form.Description,"请输入字段描述."))
			return false;
	}
	if($("#IsCompress").prop("checked")){
		if($("#Width").val()==""&&$("#Height").val()==""){
			alert("请填写宽高尺寸.");
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


function InsertItem()
{
	if(document.all.Item.value!="")
	{
		var myNewRow = document.all.myTable.insertRow();
		var myNewCell  = myNewRow.insertCell();
		myNewCell.innerHTML = document.all.Item.value;
		myNewCell = myNewRow.insertCell();
		myNewCell.innerHTML = "<input type='radio' name='IsDefault' value='"+document.all.Item.value+"'>";
		document.all.Item.value = "";
	}
}

function isselect()
{
	
  show_item();
  var fieldtype = document.form.FieldType.options[document.form.FieldType.options.selectedIndex].value; 

  for(var i = 1;i<=10;i++)
	{
	  $("#f_"+i).hide();
	}

  if (fieldtype =="select" || fieldtype=="checkbox" || fieldtype=="radio")
  {
	  $("#f_2").show();
	  $("#f_3").show();
  }
  else if (fieldtype =="select_dict" || fieldtype=="checkbox_dict" || fieldtype=="radio_dict")
  {
	  $("#f001").show();
  }
  else if(fieldtype=="text"){
  	  $("#f001").show();
  }
  else if (fieldtype=="recommend"){
    $("#f_4").show();
  }
  else if (fieldtype=="recommendout"){
    $("#f_4").show();
  }
  else if (fieldtype=="group_parent" || fieldtype=="group_child"){
    $("#f_3").show();
  }
  else if (fieldtype=="relation"){
    $("#f_6").show();
  }
  else if (fieldtype=="image"){
    $("#f_7").show();
	$("#f_8").show();
	if($("#IsCompress").prop("checked")){
		$("#f_9").show();
		$("#f_10").show();
	}
  }
  
}
function checkIsCompress(){
    if($("#IsCompress").prop("checked")){
		$("#f_9").show();
		$("#f_10").show();
	}else{
		$("#f_9").hide();
		$("#f_10").hide();
	}
}
function init()
{
	document.form.FieldName.focus();
	var Obj = top.Obj;
	if(Obj)
	{
		document.form.ChannelID.value = Obj.ChannelID;
		document.form.GroupID.value = Obj.GroupID;
		document.getElementById("textsize").style.display="";
	}
}

function InputField(fieldname)
{
	if(fieldname=="image")
	{
		document.form.FieldType.value = "image";
		document.form.FieldName.value = "Photo";
		document.form.Description.value = "图片";
	}
	else if(fieldname=="href")
	{
		document.form.FieldType.value = "text";
		document.form.FieldName.value = "Href";
		document.form.Description.value = "链接";
	}
}

function show_item(){
jQuery("#Description_id").show();
jQuery("#textsize").show();
jQuery("#Style_id").show();
jQuery("#DefaultValue_id").show();
jQuery("#Other_text").html("其它:");
}
function hide_item(){
jQuery("#Description_id").hide();
jQuery("#textsize").hide();
jQuery("#Style_id").hide();
jQuery("#DefaultValue_id").hide();
jQuery("#Other_text").html("字段描述:");
}

function showTab(form,form_td)
{
	var num = 2;
	for(i=1;i<=num;i++)
	{
		jQuery("#form"+i).hide();
		jQuery("#form"+i+"_td").removeClass("cur");
	}
	
	jQuery("#"+form).show();
	jQuery("#"+form_td).addClass("cur");
}
</script>
  </head>
  <body class="" onload="init();">
    <div class="bg-white modal-box">
	 <form name="form" method="post" action="field_add2018.jsp" onsubmit="return check();">
      <div class="ht-60 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
        <ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
          <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#" role="tab" id="form1_td">基本属性</a></li>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab"  id="form2_td">扩展属性</a></li>
          
        </ul>
      </div>
	    <div class="modal-body pd-20 overflow-y-auto">
	        <div class="config-box">
	       	  <ul>
	       	  	<!--基本信息-->
	       	    <li class="block">
				  <div class="row">                   	  	  	
	   		  	  		  <label class="left-fn-title">类型：</label>               		  	  		 
		  	  		  	  <select size="1" name="FieldType" onChange="isselect();" class="form-control wd-230 ht-40 select2">         
				                <option selected value="text">单行文本</option>
                                <option value="textarea">多行文本</option>
			                    <option value="number">整数</option>
			                    <option value="float">小数</option>
                                <option value="select">下拉列表</option>
                                <option value="checkbox">多选</option>
                                <option value="radio">单选</option>
                                <option value="select_dict">下拉列表(字典)</option>
                                <option value="checkbox_dict">多选(字典)</option>
                                <option value="radio_dict">单选(字典)</option>
                                <option value="image">图片</option>
                                <option value="video">视频</option>
	    	                    <option value="file">文件</option>
								 <option value="switch">开关</option>
                                <option value="datetime">日期</option>
                                <option value="label">标签</option>
			                    <option value="recommend">引用</option>
			                    <option value="recommendout">荐出</option>
			                    <option value="group_parent">父集</option>
			                    <option value="group_child">子集</option>
			                    <option value="relation">关联</option>
						    </select>               		  	  		 						            
	       		  	  </div>	       		  	 
	       		  	  <div class="row">                  		  	  	
	   		  	  		  <label class="left-fn-title">名称：</label>
			               <label class="wd-230">
			                <input name="FieldName" size="20" class="form-control" placeholder="" value="" type="text">
			              </label>
						  <label class="mg-l-5">(字母和数字以字母开头)</label>
	       		  	  </div>
					  <div class="row" id="Description_id">                  		  	  	
	   		  	  		  <label class="left-fn-title">描述：</label>
			               <label class="wd-230">
			                <input name="Description" size="20" class="form-control" placeholder="" value="" type="text">
			              </label>
                           <label class="mg-l-5">(用于表单中的左侧显示)</label>						  
	       		  	  </div> 
					  <div class="row" id="Caption_id">                  		  	  	
	   		  	  		  <label class="left-fn-title">说明：</label>
			               <label class="wd-230">
			                <input name="Caption" size="20" class="form-control" placeholder="" value="" type="text">
			              </label>
                           <label class="mg-l-5">(用于表单中的说明提示，在输入框下方)</label>						  
	       		  	  </div> 
	       		  	  <div class="row" >
	   		  	  		  <label class="left-fn-title">长度：</label>
			              <label class="wd-230">
			                <input class="form-control" placeholder="" name="Size" size="8" type="text">
			              </label>
                           <label class="mg-l-5">(规定单行文本框的长度)</label>						  
	       		  	  </div>
					  <div class="row" id="Style_id" style="display:none;">                   		  	  	
	   		  	  		  <label class="left-fn-title">样式：</label>
			              <label class="wd-230">
			                <input class="form-control" name="Style" size="8" placeholder="" type="text">
			              </label>	
                           <label class="mg-l-5">(用于指定表单的样式)</label>								  
	       		  	  </div>
	       		  	  <div class="row" id="DefaultValue_id">                   		  	  	
	   		  	  		  <label class="left-fn-title">默认值：</label>
			              <label class="wd-230">
			                <input class="form-control" name="DefaultValue" size="20" placeholder="" value="" type="text">
			              </label>			
                           <label class="mg-l-5">(用于指定表单的默认值)</label>								  
	       		  	  </div>
					   <div class="row" id="f_2" style="display:none"> 
	       		  	  	 <label class="left-fn-title">数据类型：</label>
			              <label class="rdiobox">
			                <input type="radio" name="DataType" id="DataType1" value="0" checked><span>字符</span>
										</label>	
						 			<label class="rdiobox">
						 				<input type="radio" name="DataType" id="DataType2" value="1" ><span>数字</span>
									</label>	
       		  	  	  </div>
					  <div class="row" id="f_3" style="display:none">                   		  	  	
	   		  	  		  <label class="left-fn-title">选项：</label>
			              <label class="wd-230">
			                <textarea class="form-control"  placeholder="" name="Options" rows="3"></textarea>
							<br>每行一个选项，例如：足球或足球(1)
			              </label>			            
	       		  	  </div>
					  <div class="row" id="f_1" style="display:none">                   		  	  	
	   		  	  		  <label class="left-fn-title">选项字典代码：</label>
			              <label class="wd-230">
			                <input class="form-control" name="DictCode" size="20" placeholder="" type="text">
			              </label>		            
	       		  	  </div>
					  <div class="row" id="f_6" style="display:none">                   		  	  	
	   		  	  		  <label class="left-fn-title">选项字典代码：</label>
			              <label class="wd-230">
			                <input class="form-control" name="RelationChannelID" size="20" placeholder="" type="text">
			              </label>		            
	       		  	  </div>
	       		  	 <div class="row ckbox-row"> 
	       		  	  	 <label class="left-fn-title"> </label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsHide" id="s1" value="1" ><span class="d-inline-block">隐藏</span>
			              </label>
			              <label class="ckbox">
			                <input type="checkbox" name="DisableBlank" id="s2" value="1" ><span class="d-inline-block">不允许为空</span>
			              </label>	
			              <label class="ckbox">
			                <input type="checkbox" name="DisableEdit" id="s3" value="1" ><span class="d-inline-block">禁止编辑</span>
			              </label>			              		           
       		  	  	  </div>
					  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">常用字段：</label>
			              <label class="ckbox">
			                <a href="javascript:InputField('image')">图片字段</a> <a href="javascript:InputField('href')">链接字段</a>
			              </label>								             
	       		  	  </div>
					  <div class="row ckbox-row"> 
	       		  	  	 <label class="left-fn-title">继续新建：</label>
			              <label class="ckbox">
			                <input type="checkbox" name="ContinueAdd" id="s1" value="1" <%=ContinueAdd==1?"checked":""%>><span class="d-inline-block"></span>
			              </label>	              		           
       		  	  	  </div>
					  <div class="row" id="f_7" style="display:none">                   		  	  	
	   		  	  		  <label class="left-fn-title">启用水印：</label>
			              <label class="ckbox">
			                <input type="checkbox" name="Watermark" id="Watermark" value="1" checked="checked"><span class="d-inline-block"></span>
			              </label>		            
	       		  	  </div>
					  <div class="row" id="f_8" style="display:none">                   		  	  	
	   		  	  		  <label class="left-fn-title">是否压缩：</label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsCompress" id="IsCompress" value="1" onclick="checkIsCompress();"><span class="d-inline-block"></span>
			              </label>		            
	       		  	  </div>
						<div class="row" id="f_9" style="display:none">                   		  	  	
	   		  	  		  <label class="left-fn-title">压缩尺寸：</label>
			              <label class="mg-r-10">宽度：</label>
						  <label class="wd-100">
			                    <input class="form-control" name="Width" id="Width" size="4" placeholder="" type="text">
			              </label><label class="mg-r-30"></label>
							<label class="mg-r-10">高度：</label>
							<label class="wd-100">
			                    <input class="form-control" name="Height" id="Height" size="4" placeholder="" type="text">
			              </label>
	       		  	  </div>
	       		  	  <div class="row" id="f_10" style="display:none">
	       		  	  <label class="left-fn-title"></label>
	       		  	  <label >
	       		  	    <a href="../tcenter/media_help.html" target="_blank">
                           <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                      </a>
	       		  	  如只填宽度/高度，则高度/宽度进行等比压缩；如宽高都填写，则使用智能裁剪，将图片等比压缩后，智能裁剪指定宽高。</label>
			         </div>
	       		  </li>
       	      <!--拓展信息-->
       	      <li>
			      <div class="row" id="f_4" style="display:none">                   		  	  	
	   		  	  		  <label class="left-fn-title">推荐栏目：</label>
			              <label class="col-lg pd-l-0 pd-r-0 wd-350">
			                <textarea class="form-control"  placeholder="" name="RecommendChannel" rows="3"></textarea>
							<br>每行一个栏目
			              </label>
                  </div>	
                  <div class="row" id="f_4" style="display:none">  					   
                          <label class="left-fn-title">对应关系：</label>
			              <label class="col-lg pd-l-0 pd-r-0 wd-350">
			                <textarea class="form-control"  placeholder="" name="RecommendValue" rows="3"></textarea>
							<br>每行一个对应条件
			              </label>							  
	       		  </div>
				   <div class="row" id="f_5" style="display:none">  					   
                          <label class="left-fn-title">集合栏目：</label>
			              <label class="col-lg pd-l-0 pd-r-0 wd-350">
			                <textarea class="form-control"  placeholder="" name="GroupChannel" rows="3"></textarea>
							<br>每行一个栏目
			              </label>							  
	       		  </div>		  
       		  	  <div class="row" >                   		  	  	
   		  	  		  <label class="left-fn-title" id="Other_text">其他：</label>
		              <div class="col-lg pd-l-0 pd-r-0 wd-350">
			              <textarea name="Other" rows="3" class="form-control" placeholder=""></textarea>
			            </div>									            
       		  	  </div> 
       		  	  <div class="row" >                   		  	  	
   		  	  		  <label class="left-fn-title" id="Other_text">显示模板：</label>
		              <div class="col-lg pd-l-0 pd-r-0 wd-350">
			              <textarea name="HtmlTemplate" rows="3" class="form-control" placeholder=""></textarea>
			            </div>										            
       		  	  </div> 
       		  	 
	       		  </li>
	       		  <!--推荐设置-->
       	    </ul>
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box" >
      	<div class="modal-footer" >
		      <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
		      <input type="hidden" name="GroupID" value="<%=GroupID%>">
		      <input type="hidden" name="Submit" value="Submit">
		      <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确认</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose({suffix:'_2'});" id="btnCancel1" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		    </div> 
      </div>
<div id="ajax_script" style="display:none;"></div>	    
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->

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
    
    <script>
      $(function(){
      	$("#form_nav li").click(function(){
      		var _index = $(this).index();
      		console.log(_index)
      		$(".config-box ul li").removeClass("block").eq(_index).addClass("block");
			var fieldtype = document.form.FieldType.options[document.form.FieldType.options.selectedIndex].value;
			if(fieldtype=="image"){
				if(_index==1){
					if($("#Watermark").prop("checked")){
						var Watermark = 1;
					}else{
						var Watermark = 0;
					}
					if($("#IsCompress").prop("checked")){
						var IsCompress = 1;
					}else{
						var IsCompress = 0;
					}
					var Width = $("#Width").val();
					var Height = $("#Height").val();
					if($("#IsCompress").prop("checked")){
						$("[name='Other']").text('{"Height":"'+Height+'","Width":"'+Width+'","Watermark":'+Watermark+',"IsCompress":'+IsCompress+'}');
					}else{
						$("[name='Other']").text('{"Watermark":'+Watermark+',"IsCompress":'+IsCompress+'}');
					}
				}
			}
		
      })
       
       //推荐设置锁定图片切换
      $(".lock-unlock").click(function(){    
       	var textBox = $(this).parent(".row").find(".textBox") ;       	
       	if($(this).find("i").hasClass("fa-lock")){      	 
       	 	$(this).find("i").removeClass("fa-lock").addClass("fa-unlock");       	 	
       	 	textBox.removeAttr("disabled","").removeClass("disabled")
       	}else{      	 	
       	 	$(this).find("i").removeClass("fa-unlock").addClass("fa-lock");
       	 	textBox.attr("disabled",true).addClass("disabled")
       	}
      })
		   
      });
    </script>
  </body>
</html>
