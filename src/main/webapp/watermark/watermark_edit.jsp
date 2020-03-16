<%@ page import="tidemedia.cms.util.*,
				java.io.File,
				java.sql.*,
				java.util.*,
				java.text.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.system.*
				,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    if(!userinfo_session.isAdministrator())
    { response.sendRedirect("../noperm.jsp");return;}


    int id = getIntParameter(request,"id");
    Watermark t = new Watermark(id);
    System.out.println("name==="+t.getName());
    System.out.println("name==="+t.getWaterMark());
    System.out.println("name==="+t.getCompanyid());
    System.out.println("name==="+t.getStatus());
    System.out.println("name==="+t.getName());
    String Submit = getParameter(request,"Submit");
    if(!Submit.equals(""))
    {

    	 String	Name	= getParameter(request,"Name");
         String watermark = getParameter(request,"watermark");
         int LogoTop = getIntParameter(request,"LogoTop");
         int LogoLeft = getIntParameter(request,"LogoLeft");
         int width = getIntParameter(request,"width");
         int height = getIntParameter(request,"height");
         int dissolve = getIntParameter(request,"dissolve");
         int status = getIntParameter(request,"status");
         int DataType = getIntParameter(request,"DataType");
         int company = getIntParameter(request,"company");

         t.setName(Name);
         t.setWaterMark(watermark);
         t.setLogoTop(LogoTop);
         t.setLogoLeft(LogoLeft);
         if(DataType==0){
         	t.setCompanyid(0);
         }else if(DataType==1){
         	t.setCompanyid(company);
         }
 		t.setCreateDate(Integer.parseInt((new java.util.Date().getTime())/1000+""));
 		t.setWidth(width);
 		t.setHeight(height);
 		t.setDissolve(dissolve);
 		t.setStatus(status);
        t.Update();
        new Log().WatermarkLog(LogAction.watermark_edit ,Name, id, userinfo_session.getId());
        out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
        return;
    }
  //图片及图片库配置
    Channel channel = null;
    TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();
    int sys_channelid_image = photo_config.getInt("channelid");
    channel = CmsCache.getChannel(sys_channelid_image);
    Site site = channel.getSite();//
    String Path = channel.getRealImageFolder();//图片库地址
    String SiteUrl = site.getExternalUrl();//图片库预览地址
    String SiteFolder = site.getSiteFolder();//图片库目录


%>
<!DOCTYPE HTML>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <title>水印编辑</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <script type="text/javascript" src="../common/jquery.js"></script>
    <script type="text/javascript" src="../common/common.js"></script>

    <style>
        html,
        body {
            width: 100%;
            height: 100%;
        }
    </style>
    <script >
    $(function() {
    	var companyid = '<%=t.getCompanyid()%>';
    	if(companyid!="0"){
    		$("#f_1").show();
    	}
    	
    	$("input[type=radio][name=DataType]").change(function(){
			if($("input[type=radio][name=DataType][value=0]").prop("checked")){
				$("#f_1").hide();
			}else if($("input[type=radio][name=DataType][value=1]").prop("checked")){
				$("#f_1").show();
			}
        })
    });
    
    
        function selectImage(filename)
        {
            var	dialog = new top.TideDialog();
            dialog.setWidth(680);
            dialog.setHeight(500);
            dialog.setLayer(2);
            dialog.setUrl("../watermark/insertfile.jsp");
            dialog.setTitle("上传水印");
            dialog.show();

        }
        function preview()
        {
        	var SiteUrl = '<%=SiteUrl%>';
            var SiteFolder = '<%=SiteFolder%>';
        	var watermark = $("#watermark").val();
            window.open(watermark.replace(SiteFolder,SiteUrl));
        }
        function check()
        {	
        	var reg=/^[1-9]\d*$|^0$/;
        	 var name = $("input[name='Name']").val();
             var watermark = $("input[name='watermark']").val();
             var width = $("input[name='width']").val();
             var height = $("input[name='height']").val();
             var dissolve = $("input[name='dissolve']").val();
             var LogoTop = $("input[name='LogoTop']").val();
             var LogoLeft = $("input[name='LogoLeft']").val();
             
             if(name==""){
 				alert("方案名称不能为空。");
 				return false;
             }
             if(watermark==""){
 				alert("水印文件不能为空。");
 				return false;
             }
             if(width==""){
 				alert("水印宽度不能为空。");
 				return false;
             }
             if(height==""){
 				alert("水印高度不能为空。");
 				return false;
             }
             if(dissolve==""){
 				alert("水印透明度不能为空。");
 				return false;
             }
             if(name.length>20){
 				alert("方案名称字数不能超过20字。");
 				return false;
             }
             if(!reg.test(width)||!reg.test(height)||!reg.test(dissolve)){
            	 alert("水印宽度,水印高度,水印透明度只能为数字。");
            	 return false;
            }
             if(LogoTop!=""||LogoLeft!=""){
            	 if(!reg.test(LogoTop)||!reg.test(LogoLeft)){
                	 alert("水印边距只能为数字。");
                	 return false;
                }
             }
            return true;
        }
    </script>
</head>

<body>
<div class="bg-white modal-box">
    <form name="form" action="watermark_edit.jsp" method="post" onSubmit="return check();">

        <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
            <div class="config-box">
                <ul>
                    <li class="block">
                        <div class="row">
                            <label class="left-fn-title">方案名称：</label>
                            <label class="wd-230">
                                <input class="form-control" placeholder="" type="text" name="Name" value="<%=t.getName()%>">
                            </label>
                        </div>
                        
                        <div class="row">
                            <label class="left-fn-title">水印文件：</label>
                            <label class="wd-230">
                                <input class="form-control"  id="watermark" placeholder="" type="hidden" name="watermark" value="<%=t.getWaterMark()%>">
                               <input class="form-control"  id="filename" placeholder="" type="text" name="filename" value="<%=t.getWaterMark().substring(t.getWaterMark().lastIndexOf("/")+1)%>">
                            </label>
                            <input class="btn btn-primary tx-size-xs mg-l-10" href="javascript:;" name="" type="button" value="选择" onclick="selectImage('ptoto');">
                            <input class="btn btn-primary tx-size-xs mg-l-10" href="javascript:;" name="" type="button" value="预览" onclick="preview();">
                            <input type="hidden" name="TemplateID" value="">
                        </div>
                        
                        <div class="row">
                             <div class="row mg-t--10">                   		  	  	
			   		  	  		  <label class="left-fn-title"> </label>
					              <label class="d-flex align-items-center tx-gray-800 tx-13">
					                <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>注意：水印图片仅支持PNG格式！
					              </label>									            
	       		  	  		</div>
                        </div>
						<div class="row">
                            <label class="left-fn-title">水印宽度：</label>
                            <td valign="middle">
	                 			<input   class="form-control"  type=text style="width: 70px ;height: 30px"  name="width" size="6" value="<%=t.getWidth()%>"><label class="mg-r-10"></label><span>px</span>
	                 		<label class="left-fn-title">水印高度：</label>
                            <td valign="middle">
	                 			<input   class="form-control"  type=text style="width: 70px ;height: 30px"  name="height" size="6" value="<%=t.getHeight()%>"><label class="mg-r-10"></label><span>px</span>
                        </div>
                         <div class="row">
                            <label class="left-fn-title">水平边距：</label>
                            <td valign="middle">
                                <input class="form-control" style="width: 70px ;height: 30px" type="text" name="LogoLeft" size="6" value="<%=t.getLogoLeft()%>"><label class="mg-r-10"></label><span>px</span>
                                	<label class="left-fn-title">垂直边距：</label>
                                	<td valign="middle">
                                 <input class="form-control"  style="width: 70px;height: 30px" type="text" name="LogoTop" size="6" value="<%=t.getLogoTop()%>"><label class="mg-r-10"></label><span>px</span>
                          
                            
                        </div>
                         <div class="row">
                            <label class="left-fn-title">水印透明度：</label>
                            <td valign="middle">
	                 			<input   class="form-control"  type=text style="width: 70px ;height: 30px"  name="dissolve" size="6" value="<%=t.getDissolve()%>"><label class="mg-r-10"></label><span>%</span>
                        </div>
                       <div class="row">
                            <label class="left-fn-title">是否应用：</label>
                            <label class="ckbox">
							<input type="checkbox" name="status" id="status" value="1" <%=t.getStatus()==1?"checked":"" %> ><span class="d-inline-block"></span>
						  </label>	
                        </div> 
						 <div class="row">
                        	<label class="rdiobox mg-l-50">
				                <input type="radio" name="DataType" id="isAll" value="0" <%=t.getCompanyid()==0?"checked":""%>><span>全局使用</span>
				              </label>
                          <label class="rdiobox mg-l-50">
			                <input type="radio" name="DataType" id="notIsAll" value="1" <%=t.getCompanyid()!=0?"checked":""%>><span>指定使用</span>
			              </label>
							<label id="f_1" style="display:none">
							<select id="company" name = "company" class="form-control wd-150 ht-40 select2"  >
							<%
							int companyid = userinfo_session.getCompany();
							JSONArray arr = new Company().getGroup(companyid);
								for(int i=0;i<arr.length();i++)
								{
									 JSONObject json = arr.getJSONObject(i);
									 if(json.getInt("company")==0){
										 continue;
									 }
							%>
							<option value="<%=json.getInt("company")%>" <%=t.getCompanyid()==json.getInt("company")?"selected":""%>><%=json.getString("name")%></option>
							<%} %>
						</select>
						</label>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
        <!--modal-body-->

        <div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
            <div class="modal-footer">
                <input type="hidden" name="ChannelID" value="14211">
                <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确认</button>
                <button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消
                </button>
                <input type="hidden" name="Submit" value="Submit">
                <input type="hidden" name="id" value="<%=id%>">
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
 





</script>

</html>
