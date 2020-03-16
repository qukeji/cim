<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="org.json.*,tidemedia.cms.util.*,tidemedia.cms.system.*"%>
<%@ include file="../config.jsp" %>
<%
	 
	String content = getParameter(request,"imgs");
	int channelid = getIntParameter(request,"channelid");
	JSONArray array = new JSONArray(content);
	 //ͼƬ��
	 TideJson tj = CmsCache.getParameter("sys_config_photo").getJson();
	 //{"channelid":"14296","force_httpurl":"1"}
	 int channelid_ = tj.getInt("channelid");
 	Channel channel = CmsCache.getChannel(channelid_);
	String inner_url = channel.getSite().getUrl();
	String url = channel.getSite().getExternalUrl2();
 %>
<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="Shortcut Icon" href="../favicon.ico">
	<title>图片列表</title>
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
		#content-table .row{margin-left: 0;margin-right: 0;}
		table{border-collapse: collapse !important;border:1px solid #dee2e6;border-bottom: 0;border-right: 0;}
		.table th, .table td{border-top:none ;border-spacing:initial;}
		table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word;}
		table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;border-top: 0;
			border-left: 0;}
		table.table-fixed tr{display: flex;}
		.list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;}
		.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}
	</style>

	<script src="../lib/2018/jquery/jquery.js"></script>
	<script type="text/javascript" src="../common/2018/common2018.js"></script>
	<script type="text/javascript" src="../common/2018/content.js"></script>
	<script>
var listType = 3;
var rows = 10;
var cols = 3;
var currRowsPerPage = 20;
var currPage = 1;
var inner_url ='<%=inner_url%>';
var url = '<%=url%>';
var Parameter = "";//"&ChannelID="+ChannelID+"&rowsPerPage="+currRowsPerPage+"&currPage="+currPage;
var pageName = "editor_photo_select_right.jsp";
if(pageName=="") pageName = "content.jsp";
var channelid = <%=channelid%>;
function gopage(currpage)
{
	var url = pageName + "?currPage="+currpage+"&id=14296&rowsPerPage=20&Title=&CreateDate=&CreateDate1=&User=&Status=0&IsPhotoNews=0&OpenSearch=0&IsDelete=0&Status1=0";
	this.location = url;
}

function list(str)
{
	var url = pageName + "?id=14296&rowsPerPage=20";
	if(typeof(str)!='undefined')
		url += "&" + str;
	this.location = url;
}

//�Ҽ�����
function SortDoc(){
	var myObject = new Object();
	var size = $(".cur").length;
	if(size>1||size<=0){
		alert("��ѡ��һ���������ѡ��");
	}else{
    myObject.title="����";
	myObject.ChannelID =ChannelID;
	myObject.ItemId =$(".cur").attr("ItemID");
	myObject.OrderNumber = $(".cur").attr("OrderNumber");		
 
	var url= "content/document_sort.jsp?ChannelID="+ChannelID+"&ItemID="+myObject.ItemId+"&OrderNumber="+myObject.OrderNumber;
	var	dialog = new top.TideDialog();
		dialog.setWidth(250);
		dialog.setHeight(162);
		dialog.setUrl(url);
		dialog.setTitle(myObject.title);
		dialog.show();
	}
}
function getCheckbox(){
	var id="";
	jQuery("#oTable input:checked").each(function(i){
		if(i==0)
			id+=jQuery(this).val();
		else
			id+=","+jQuery(this).val();
	});
	var obj={length:jQuery("#oTable input:checked").length,id:id};
	return obj;
}

function Preview2(img)
{
	window.open(img);
}

function editDocument(img)
{
	var  js = "setValue('Photo','"+img+"');";
	//alert(globalid);
         
	 	$.ajax({
		url:"../content/editor_photo_compress.jsp",
		type:"POST",
		dataType:"JSON",
		data:{img:img,channelid:channelid},              
		success:function(obj)
		{
		     if(obj.img)
		          js = "setValue('Photo','"+obj.img+"');";
                     
                    
		}
	});
	js = js.replace(inner_url,url)
  	  top.TideDialogClose({refresh:js});
}
</script>
</head>
<body onLoad="init();" class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">

	<div class="br-pageheader pd-y-15 pd-md-l-20">
		<nav class="breadcrumb pd-0 mg-0 tx-12">
			<span class="breadcrumb-item active"><%=channel.getParentChannelPath().replace(">"," / ")%></span>
		</nav>
        	
		</div>
	</div>
	
	

	<!--操作-->
	<div class="d-flex align-items-center justify-content-start pd-t-25 mg-b-20 mg-sm-b-30">

		
		<!-- btn-group -->

		
	
		<div class="btn-group mg-l-10 hidden-sm-down">
			
		</div>
		<!-- btn-group -->

	</div>
	<!--操作-->

	<!--列表-->
	<div class="br-pagebody pd-lg-x-0-force">
		<div class="card bd-0 shadow-base">
			
			<table class="table mg-b-0 table-fixed" id="content-table">
				<tbody>
		 <% 
		  int m = 0;
		  for(int i=0;i<array.length();i++){ 
		 	JSONObject obj = array.getJSONObject(i);
		 	String img = obj.getString("img");
		 	String file = img.substring(img.lastIndexOf("/")+1);
		 	if(m==0)out.println("<tr>");
		 	m++ ;
		 %>
				<td id_="<%=i%>" class="tide_item"  >
					<div class="row">
						<div class="col-md">
							<div class="card bd-0">
								<div class="list-pic-box">
									<img class="card-img-top" src="<%=img%>" data-src="<%=img%>" alt="Image" onerror="checkLoad(this);" type="tide">
								</div>
								<div class="row mg-l-0 mg-r-0 mg-t-15">
									<label class="ckbox mg-b-0 d-inline-block mg-r-5">
										<input name="id" value="<%=img%>" type="checkbox"><span></span>
									</label>
									<label>
										<p class="card-text" title="<%=file%>"><%=file%></p>
									</label>
								</div>
							</div>
						</div>
					</div>
				</td>
				<%
						if(m==4){ out.println("</tr>");m=0;}
					}
					if(m<4) out.println("</tr>");
					
				%>

				</tbody>
			</table>
			

			
		</div>
	</div>
	<!--列表-->

	<!--操作-->
	<div class="d-flex align-items-center justify-content-start pd-t-25 mg-b-20 mg-sm-b-30">

		
		

	</div>
	<!--操作-->

		
	
		

	<script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
	<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

	<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
	<script src="../lib/2018/select2/js/select2.min.js"></script>
	<script src="../common/2018/bracket.js"></script>
	<script type="text/javascript" src="../common/2018/jquery.contextmenu.js"></script>
	<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>

	<script>
        $(function() {
            'use strict';

            $("#content-table tr td").click(function() {
                var _tr = $(this).parent("tr")
                if(!$("#content-table").hasClass("table-fixed")){
                    if( _tr.find(":checkbox").prop("checked") ){
                        _tr.find(":checkbox").removeAttr("checked");
                        $(this).parent("tr").removeClass("bg-gray-100");
                    }else{
                        _tr.find(":checkbox").prop("checked", true);
                        $(this).parent("tr").addClass("bg-gray-100");
                    }
                }else{
                    if( $(this).find(":checkbox").prop("checked") ){
                        $(this).find(":checkbox").removeAttr("checked");
                        //$(this).removeClass("bg-gray-100");
                    }else{
                        $(this).find(":checkbox").prop("checked", true);
                        //$(this).addClass("bg-gray-100");
                    }
                }
            });

            $("#checkAll,#checkAll_1").click(function() {
                if($("#content-table").hasClass("table-fixed")){
                    var checkboxAll = $("#content-table tr").find("td").find(":checkbox") ;
                }else{
                    var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
                }
                var existChecked = false;
                for (var i = 0; i < checkboxAll.length; i++) {
                    if (!checkboxAll.eq(i).prop("checked")) {
                        existChecked = true;
                    }
                }
                if (existChecked) {
                    checkboxAll.prop("checked", true);
                    checkboxAll.parents("tr").addClass("bg-gray-100");
                    $(this).prop("checked", true);
                } else {
                    checkboxAll.removeAttr("checked");
                    checkboxAll.parents("tr").removeClass("bg-gray-100");
                    $(this).prop("checked", false);
                }
                return;
            })
        });

       
	</script>




</body>
</html>
