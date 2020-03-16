<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,org.json.*,
				java.util.ArrayList"%>
    <%@ page contentType="text/html;charset=utf-8" %>
        <%@ include file="../config.jsp"%>
            <%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int		FieldID		= getIntParameter(request,"FieldID");
//int		ChannelID	= getIntParameter(request,"ChannelID");

Field field = new Field(FieldID);
String fieldType = field.getFieldType();
JSONObject oo = null;
if("image".equals(fieldType)&&field.getOther()!=null&&(!"".equals(field.getOther()))&&(!"null".equals(field.getOther()))){
	 oo = new JSONObject(field.getOther());
}
String	Submit	= getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	Description			= getParameter(request,"Description");
	String	Options				= getParameter(request,"Options");
	int		IsHide				= getIntParameter(request,"IsHide");
	int		DisableBlank		= getIntParameter(request,"DisableBlank");
	int		DisableEdit			= getIntParameter(request,"DisableEdit");
	String  Other				= getParameter(request,"Other");
	String  DefaultValue		= getParameter(request,"DefaultValue");
	String  Style				= getParameter(request,"Style");
	String  RecommendChannel	= getParameter(request,"RecommendChannel");
	String  RecommendValue		= getParameter(request,"RecommendValue");
	String  GroupChannel		= getParameter(request,"GroupChannel");
	int		Size				= getIntParameter(request,"Size");
	int		GroupID				= getIntParameter(request,"GroupID");
	String  HtmlTemplate		= getParameter(request,"HtmlTemplate");
	String  DictCode			= getParameter(request,"DictCode");
	String	Caption				= getParameter(request,"Caption");
	String	JS					= getParameter(request,"JS");
	int		Watermark	= getIntParameter(request,"Watermark");//是否水印
	int		IsCompress	= getIntParameter(request,"IsCompress");//是否压缩
	String  Width				= getParameter(request,"Width");//压缩宽度
	String  Height				= getParameter(request,"Height");//压缩高度

		//field = new Field(FieldName,ChannelID);
		field.setIsHide(IsHide);
		field.setDisableBlank(DisableBlank);
		field.setDisableEdit(DisableEdit);
		field.setDescription(Description);
		field.setOptions(Options);
		field.setDefaultValue(DefaultValue);
		field.setOther(Other);
		if("image".equals(fieldType)){
			JSONObject json = new JSONObject();
			json.put("Watermark", Watermark);
			json.put("IsCompress", IsCompress);
			if(IsCompress==1){
				json.put("Width", Width);
				json.put("Height", Height);
			}
			field.setOther(json.toString());
		}
		field.setHtmlTemplate(HtmlTemplate);
		field.setDictCode(DictCode);
		field.setSize(Size);
		field.setStyle(Style);
		field.setRecommendChannel(RecommendChannel);
		field.setRecommendValue(RecommendValue);
		field.setGroupChannel(GroupChannel);
		field.setGroupID(GroupID);
		field.setJS(JS);
		field.setCaption(Caption);

		field.Update();
		out.println("<script>top.TideDialogClose({suffix:'_3',recall:true,returnValue:{refresh:true,field:"+field.getId()+"}});</script>");
		return;
}
Channel channel = CmsCache.getChannel(field.getChannelID());
ArrayList fieldGroupArray = channel.getFieldGroupInfo();
%>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
                    <link rel="Shortcut Icon" href="../favicon.ico">
                    <title>编辑字段</title>
                    <!-- vendor css -->
                    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
                    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
                    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
                    <!-- Bracket CSS -->
                    <link rel="stylesheet" href="../style/2018/bracket.css">
                    <link rel="stylesheet" href="../style/2018/common.css">
                    <script language="javascript">
                        function checkit() {
                            /*
  if (document.form.FieldName.value==""){
  	alert("字段名不能为空！")
  	document.form.FieldName.focus();
  	return false;
  	}
	*/
							if($("#IsCompress").prop("checked")){
								if($("#Width").val()==""&&$("#Height").val()==""){
									alert("请填写宽高尺寸.");
									return false;
								}
								
							}
                            return true;
                        }

                        function InsertItem() {
                            if (document.all.Item.value != "") {
                                var myNewRow = document.all.myTable.insertRow();
                                var myNewCell = myNewRow.insertCell();
                                myNewCell.innerHTML = document.all.Item.value;
                                myNewCell = myNewRow.insertCell();
                                myNewCell.innerHTML = "<input type='radio' name='IsDefault' value='" + document.all.Item.value + "'>";
                                document.all.Item.value = "";
                            }
                        }

                        function isselect() {
                            var fieldtype = document.form.FieldType.options[document.form.FieldType.options.selectedIndex].value;
                            if (fieldtype == "select") {
                                document.all.Items.style.display = "";
                                /*
                                	var myNewRow = document.all.myTable.insertRow();
                                	var myNewCell  = myNewRow.insertCell();
                                	myNewCell.innerHTML = "<input type='text' value='' id='Item'>";
                                	myNewCell = myNewRow.insertCell();
                                	myNewCell.innerHTML = "<input type='button' value='添加选项' onClick='InsertItem();'>";
                                	myNewRow = document.all.myTable.insertRow();
                                	myNewCell  = myNewRow.insertCell();
                                	myNewCell.innerHTML = "选项名";
                                	myNewCell = myNewRow.insertCell();
                                	myNewCell.innerHTML = "是否为缺省";
                                */
                            } else if (fieldtype == "LABEL") {
                                document.form.Data.className = "";
                                document.form.Data.disabled = false;
                                prompt1.innerText = "文字：";
                                prompt2.innerText = "请输入标签的说明文字.";
                            } else {
                                document.all.Items.style.display = "none";
                            }
                        }

                        function init() {
                            var Obj = top.Obj;
                            if (Obj) {
                                //alert(Obj.ChannelID);
                                //document.all("ChannelName").innerText = Obj.ChannelName;
                                //document.form.ChannelID.value = Obj.ChannelID;
                            }
                            //document.form.Template.focus();
                        }

                        function show_item() {
                            jQuery("#Description_id").show();
                            jQuery("#textsize").show();
                            jQuery("#Style_id").show();
                            jQuery("#DefaultValue_id").show();
                            jQuery("#Other_text").html("其它:");
                        }

                        function hide_item() {
                            jQuery("#Description_id").hide();
                            jQuery("#textsize").hide();
                            jQuery("#Style_id").hide();
                            jQuery("#DefaultValue_id").hide();
                            jQuery("#Other_text").html("字段描述:");
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
                        function showTab(form, form_td) {
                            var num = 2;
                            for (i = 1; i <= num; i++) {
                                jQuery("#form" + i).hide();
                                jQuery("#form" + i + "_td").removeClass("cur");
                            }

                            jQuery("#" + form).show();
                            jQuery("#" + form_td).addClass("cur");
                        }
                    </script>
                    <style>
                        html,
                        body {
                            width: 100%;
                            height: 100%;
                        }
                        
                        .modal-body .config-box .row {
                            margin-bottom: 10px;
                        }
                        
                        .modal-body .config-box label.ckbox {
                            width: auto;
                            margin-right: 10px;
                        }
                        
                        .modal-body .config-box label.ckbox input {
                            margin-right: 2px;
                        }
                    </style>
                </head>

                <body class="" onload="init();">
                    <div class="bg-white modal-box">
                        <form name="form" method="POST" action="field_edit2018.jsp" onsubmit="return checkit();">
                            <div class="ht-60 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
                                <ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
                                    <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#" role="tab" id="form1_td">基本属性</a></li>
                                    <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab" id="form2_td">扩展属性</a></li>

                                </ul>
                            </div>
                            <div class="modal-body pd-20 overflow-y-auto">
                                <div class="config-box">
                                    <ul>
                                        <!--基本信息-->
                                        <li class="block">
                                            <div class="row">
                                                <label class="left-fn-title">类型：</label>
                                                <label class="wd-230"><%=field.getFieldTypeDesc()%></label>
                                            </div>
                                            <div class="row">
                                                <label class="left-fn-title">名称：</label>
                                                <label class="wd-230"><%=field.getName()%></label>
                                            </div>

                                            <div class="row" id="Description_id">
                                                <label class="left-fn-title">描述：</label>
                                                <label class="wd-230">
			                <input class="form-control" placeholder="" name="Description" size="20" value="<%=field.getDescription()%>" type="text">
			              </label>
                                                <label class="mg-l-5">（用于表单中的左侧显示）</label>
                                            </div>

                                            <div class="row" id="Caption_id">
                                                <label class="left-fn-title">说明：</label>
                                                <label class="wd-230">
			                <input class="form-control" placeholder="" name="Caption" size="20" value="<%=field.getCaption()%>" type="text">
			              </label>
                                            </div>

                                            <div class="row" id="textsize" >
                                                <label class="left-fn-title">长度：</label>
                                                <label class="wd-230">
			                <input class="form-control" placeholder="" name="Size" size="20" value="<%=field.getSize()%>" type="text">
			              </label>
                                            </div>
                                            <div class="row" id="DefaultValue_id">
                                                <label class="left-fn-title">默认值：</label>
                                                <label class="wd-230">
			                <input class="form-control" placeholder="" name="DefaultValue" size="20" value="<%=field.getDefaultValue()%>" type="text">
			              </label>
                                            </div>
                                            <%if(fieldType.equals("select_dict")||fieldType.equals("checkbox_dict")||fieldType.equals("radio_dict")){%>
                                                <div class="row" id="dict_code">
                                                    <label class="left-fn-title">默认值：</label>
                                                    <label class="wd-230">
			                <input class="form-control" placeholder="" name="DictCode" size="20" value="<%=field.getDictCode()%>" type="text">
			              </label>
                                                </div>
                                                <%}%>
                                                    <!--图片目录规则-->
                                                    <%if(fieldGroupArray.size()>0){%>
                                                        <div class="row">
                                                            <label class="left-fn-title">分组：</label>
                                                            <select class="form-control wd-230 ht-40 select2" data-placeholder="基本信息" name="GroupID">
				             <%
                              for(int i = 0; i < fieldGroupArray.size(); i++)
                              {
                              FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
                              if(field.getGroupID()!=fieldGroup.getId()){
                              out.println("<option value=\""+fieldGroup.getId()+"\">"+fieldGroup.getName()+"</option>");
                              }else{
                              out.println("<option value=\""+fieldGroup.getId()+"\"  selected>"+fieldGroup.getName()+"</option>");
                              }
                              }%> 
						    </select>
                                                        </div>
                                                        <%}%>
                                                            <div class="row ckbox-row flex-lg-nowrap">
                                                                <label class="left-fn-title"> </label>
                                                                <label class="ckbox">
			                <input type="checkbox" name="IsHide" value="1" id="s1" <%=field.getIsHide()==1?"checked":""%>><span class="d-inline-block">隐藏</span>
			              </label>
                                                                <label class="ckbox">
			              	<input type="checkbox" ch name="DisableBlank" value="1" id="s2" <%=field.getDisableBlank()==1?"checked":""%>><span class="d-inline-block">不允许为空</span>
			              </label>
                                                                <label class="ckbox">
			                <input type="checkbox" name="DisableEdit" value="1" id="s3" <%=field.getDisableEdit()==1?"checked":""%>><span class="d-inline-block">禁止编辑</span>
			              </label>
                                                            </div>
                                                            <%if(fieldType.equals("select")||fieldType.equals("checkbox")||fieldType.equals("radio")){
			ArrayList fieldoptions = new ArrayList();
			fieldoptions = field.getFieldOptions();
			String OptionsValue = "";
			for (int j = 0; j < fieldoptions.size(); j++) 
			{
				String[] ss = (String[])fieldoptions.get(j);
				if(field.getDataType()==0)
					OptionsValue += ss[0] + "\r\n";
				else if(field.getDataType()==1)
					OptionsValue += ss[0]+"("+ss[1]+")"+"\r\n";
			}
%>
                                                                <div class="row">
                                                                    <label class="left-fn-title">数据类型：</label>
                                                                    <label class="rdiobox">
			                <input type="radio" name="DataType" id="DataType1" value="0" <%=field.getDataType()==0?"checked":""%>><span>字符</span>
			              </label>
                                                                    <label class="rdiobox">
			                <input type="radio" name="DataType" id="DataType2" value="1" <%=field.getDataType()==1?"checked":""%>><span>数字</span>
			              </label>

                                                                </div>
                                                                <div class="row" id="Items">
                                                                    <label class="left-fn-title">选项：</label>
                                                                    <label class="wd-230">
			                <textarea class="form-control"  placeholder="" name="Options" cols=40 rows=6><%=OptionsValue%></textarea>
							<br>每行一个选项，例如：足球或足球(1)
			              </label>
                                                                </div>
                                                                <%}%>
															
															<%if("image".equals(fieldType)){%>
																<div class="row" id="f_7" >                   		  	  	
																  <label class="left-fn-title">启用水印：</label>
																  <label class="ckbox">
																	<input type="checkbox" name="Watermark" id="Watermark" value="1" <%=oo!=null&&oo.getInt("Watermark")==1?"checked":""%>><span class="d-inline-block"></span>
																  </label>		            
															  </div>
															  <div class="row" id="f_8" >                   		  	  	
																  <label class="left-fn-title">是否压缩：</label>
																  <label class="ckbox">
																	<input type="checkbox" name="IsCompress" id="IsCompress" value="1" <%=oo!=null&&oo.getInt("IsCompress")==1?"checked":"" %> onclick="checkIsCompress();"><span class="d-inline-block"></span>
																  </label>		            
															  </div>
																	
																		<div class="row" id="f_9" style="display:none">                   		  	  	
																		  <label class="left-fn-title">压缩尺寸：</label>
																		  <label class="mg-r-10">宽度：</label>
																		  <label class="wd-100">
																				<input class="form-control" name="Width" id="Width" value='<%=oo!=null&&oo.getInt("IsCompress")==1?(oo.getString("Width")!=null?oo.getString("Width"):""):""%>' size="4" placeholder="" type="text">
																		  </label><label class="mg-r-30"></label>
																			<label class="mg-r-10">高度：</label>
																			<label class="wd-100">
																				<input class="form-control" name="Height" id="Height" value='<%=oo!=null&&oo.getInt("IsCompress")==1?(oo.getString("Height")!=null?oo.getString("Height"):""):""%>' size="4" placeholder="" type="text">
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
																				
															<%}%>

                                                                    <%if(fieldType.equals("recommend")){%>
                                                                        <div class="row">
                                                                            <label class="left-fn-title">推荐栏目：</label>
                                                                            <label class="col-lg pd-l-0 pd-r-0 wd-350">
			                <textarea class="form-control"  placeholder="" name="RecommendChannel" rows="3"><%=field.getRecommendChannel()%></textarea>
							<br>每行一个栏目
			              </label>
                                                                            <label class="left-fn-title">对应关系：</label>
                                                                            <label class="col-lg pd-l-0 pd-r-0 wd-350">
			                <textarea class="form-control"  placeholder="" name="RecommendValue" rows="3"><%=field.getRecommendValue()%></textarea>
							<br>每行一个对应条件
			              </label>
                                                                        </div>
                                                                        <%}%>

                                                                            <%if(fieldType.equals("recommendout")){%>
                                                                                <div class="row">
                                                                                    <label class="left-fn-title">对应关系：</label>
                                                                                    <div class="col-lg pd-l-0 pd-r-0 wd-350">
                                                                                        <textarea rows="3" class="form-control" placeholder="" name="RecommendValue"><%=field.getRecommendValue()%></textarea>
                                                                                    </div>
                                                                                </div>
                                                                                <%}%>
                                                                                    <%if(fieldType.equals("group_parent") || fieldType.equals("group_child")){%>
                                                                                        <div class="row">
                                                                                            <label class="left-fn-title">集合栏目：</label>
                                                                                            <div class="col-lg pd-l-0 pd-r-0 wd-350">
                                                                                                <textarea rows="3" class="form-control" placeholder="" name="GroupChannel"><%=field.getGroupChannel()%></textarea>
                                                                                                <br>每行一个栏目
                                                                                            </div>
                                                                                        </div>
                                                                                        <%}%>
                                        </li>
                                        <!--拓展信息-->
                                        <li>
                                            <div class="row">
                                                <label class="left-fn-title">其他：</label>
                                                <div class="col-lg pd-l-0 pd-r-0 wd-350">
                                                    <textarea rows="3" class="form-control" placeholder="" name="Other"><%=field.getOther()%></textarea>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <label class="left-fn-title">显示模板：</label>
                                                <div class="col-lg pd-l-0 pd-r-0 wd-350">
                                                    <textarea rows="3" class="form-control" placeholder="" name="HtmlTemplate"><%=Util.HTMLEncode(field.getHtmlTemplate())%></textarea>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <label class="left-fn-title" >
                                                    <label class="d-flex align-items-center ">
                                                        脚本：
                                                        <a href="../tcenter/media_help.html" target="_blank">
                                                            <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                                                        </a>
                                                    </label>
                                                 </label>   
                                              
                                                <div class="col-lg pd-l-0 pd-r-0 wd-350">
                                                    <textarea rows="3" name="JS" class="form-control" placeholder=""><%=Util.HTMLEncode(field.getJS())%></textarea>
                                                </div>
                                            </div>
                                        </li>
                                        <!--推荐设置-->
                                    </ul>
                                </div>

                            </div>
                            <!-- modal-body -->
                            <%if(fieldType.equals("label")){%>
                                <script>
                                    hide_item();
                                </script>
                                <%}%>
                                    <div class="btn-box">
                                        <div class="modal-footer">
                                            <input type="hidden" name="FieldID" value="<%=FieldID%>">
                                            <input type="hidden" name="Submit" value="Submit">
                                            <button type="submit" class="btn btn-primary tx-size-xs" name="startButton" id="startButton">确认</button>
                                            <button type="button" onclick="top.TideDialogClose({suffix:'_3'});" name="btnCancel1" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
                                        </div>
                                    </div>
                                    <div id="ajax_script" style="display:none;"></div>
                        </form>
                    </div>
                    <!-- br-mainpanel -->
                    <!-- ########## END: MAIN PANEL ########## -->

                    <script src="../lib/2018/jquery/jquery.js"></script>
                    <script src="../lib/2018/popper.js/popper.js"></script>
                    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
                    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
                    <!--<script src="../../lib/2018/moment/moment.js"></script>-->
                    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
                    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
                    <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
                    <script src="../lib/2018/select2/js/select2.min.js"></script>
                    <script src="../common/2018/bracket.js"></script>

                    <script>
                        $(function() {
							$("#f_9").hide();
							$("#f_10").hide();
							var fieldtype1 = '<%=fieldType%>';
							if (fieldtype1=="image"){
								if($("#IsCompress").prop("checked")){
									$("#f_9").show();
									$("#f_10").show();
								}
						  }
                            $("#form_nav li").click(function() {
                                var _index = $(this).index();
                                console.log(_index)
                                $(".config-box ul li").removeClass("block").eq(_index).addClass("block");
								var fieldtype1 = '<%=fieldType%>';
								if(fieldtype1=="image"){
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
                            $(".lock-unlock").click(function() {
                                var textBox = $(this).parent(".row").find(".textBox");
                                if ($(this).find("i").hasClass("fa-lock")) {
                                    $(this).find("i").removeClass("fa-lock").addClass("fa-unlock");
                                    textBox.removeAttr("disabled", "").removeClass("disabled")
                                } else {
                                    $(this).find("i").removeClass("fa-unlock").addClass("fa-lock");
                                    textBox.attr("disabled", true).addClass("disabled")
                                }
                            })

                        });
                    </script>
                </body>

                </html>
