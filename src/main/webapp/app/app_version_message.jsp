
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    int		ChannelID				= getIntParameter(request,"id");
     Channel channel = CmsCache.getChannel(ChannelID);
    ArrayList fieldGroupArray = channel.getFieldGroupInfo();
    String SiteAddress = channel.getSite().getUrl();
    TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
	String inner_url = "";String outer_url="";
	if(photo_config != null)
	{
		int sys_channelid_image = photo_config.getInt("channelid");
		Site img_site = CmsCache.getChannel(sys_channelid_image).getSite();
		inner_url = img_site.getUrl();
		outer_url = img_site.getExternalUrl();
	}
    //获取频道路径
String parentChannelPath = channel.getParentChannelPath().replaceAll(">"," / ");
    
//获取json接口地址
String TargetName = "";
ChannelTemplate ct = null;
ArrayList cts = channel.getChannelTemplates(3);
if(cts!=null && cts.size()>0){
	for(int i = 0;i<cts.size();i++){
		ct = (ChannelTemplate)cts.get(i);
		TargetName = ct.getTargetName();
	}
}
%>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico"/>
<title>版本信息</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui.css" />
<link rel="stylesheet" href="../style/2018/bracket.css"> 
<link rel="stylesheet" href="../style/2018/common.css">
<style>
	.collapsed-menu .br-mainpanel-file{margin:0px;margin-bottom: 30px;}		
	#nav-header{line-height: 60px;margin-left: 20px;color: #a4aab0;font-style: normal;}
	#nav-header a{color: #a4aab0;}	
	.wd-content-lable.wd-sm-table{width: 700px;}
	.app-img-box{max-width: 800px;}
	.app-img-box img{max-width: 100%}
	.row{margin-left:0;margin-right: 0 }
	.wd-content-ckx label{margin-bottom: 0} 
	@media (max-width: 1200px) {
		.wd-content-lable.wd-sm-table{width: 300px;}
	}
	@media (max-width: 992px) {
		.collapsed-menu .br-mainpanel-file {margin-left: 0;}
	}	
</style>
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
<script>
function goJsonUrl(url){
	window.open(url);
}
</script>
</head>
<body class="collapsed-menu email" id="withSecondNav">
<script type="text/javascript">document.body.disabled  = true;</script>
<form name="myform" action="" method="post" id="form1">
	<div class="br-mainpanel br-mainpanel-file overflow-hidden">	
		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
             	<span class="breadcrumb-item active"><%=parentChannelPath%></span>
			</nav>
		</div>	
		 <%
           

            String sql="select * from "+channel.getTableName()+" order by CreateDate desc";
            TableUtil tu = new TableUtil();
            ResultSet rs = tu.executeQuery(sql);
            String Title="";
            int GlobalID=0;
            String version="";
            String linkurl="";
            String Summary="";
             int forceupdate=0;
             int ItemID= 1;
            while(rs.next()){
                 Title=rs.getString("Title");
                 GlobalID=rs.getInt("GlobalID");
                  ItemID=rs.getInt("id");
                 version=(rs.getString("version"));
                 linkurl=(rs.getString("linkurl"));
                 Summary=(rs.getString("Summary"));
                 forceupdate=(rs.getInt("forceupdate"));
                 }
                 tu.closeRs(rs);
        %>
		<div class="br-pagebody bd border-radius-5 bg-white mg-x-20 pd-t-20 mg-t-20">				
			<div class="br-content-box pd-20">					
				<div class="row flex-row align-items-center mg-b-15" id="tr_version">
					<label class="left-fn-title wd-150 " id="desc_version">安卓版本号：</label>
					<label class="wd-content-lable d-flex wd-sm-table" id="">
						<input class="form-control" placeholder="" type="text" id="version" name="version" size="80"value="<%=version%>">
						</label>
					<label><span id="" class="mg-l-10"></span></label>
				</div>
				<div class="row flex-row align-items-center mg-b-15" id="tr_linkurl">
					<label class="left-fn-title wd-150 " id="desc_linkurl">apk地址：</label>
					<label class="wd-content-lable d-flex wd-sm-table" id="">
						<input class="form-control" placeholder="" type="text" id="linkurl" name="linkurl" size="80" value="<%=linkurl%>">
						</label>
					<label><span id="" class="mg-l-10"></span></label>
				</div>
				 <div class="row flex-row align-items-center mg-b-15" id="tr_forceupdate">
                    <label class="left-fn-title wd-150" id='desc_forceupdate'>强制升级：</label>
                    <input type='hidden' name='forceupdate' id='forceupdate' value="<%=forceupdate%>" >
                    <div class='toggle-wrapper'>
                        <div class='toggle toggle-light success' <%if(forceupdate==0){%>data-toggle-on='false'<%}else {%> data-toggle-on='true'<%}%> field='forceupdate'></div>
                    </div>
                </div>
			
				<div class="row flex-row align-items-center mg-b-15" id="tr_Summary">
					<label class="left-fn-title wd-150 " id="desc_Summary">更新说明：</label>
					<label class="wd-content-lable d-flex wd-sm-table" id="">
						<textarea cols="81" class="textfield form-control" rows="10" name="Summary"  id="Summary"><%=Summary%></textarea>
					</label>
					<label><span id="" class="mg-l-10"></span></label>
				</div>							
			</div>						
		</div>
	
		<div class="br-pagebody mg-r-20 mg-t-40" url="" id="">		
			<div class="br-content-box pd-20">
			     <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
                <input type="hidden" name="ItemID" value="<%=ItemID%>">
				<div class="row flex-row align-items-center mg-b-15 justify-content-center" id="tr_Title">							
                    <button name="startButton" type="button" onclick="subfrom()" class="btn btn-primary tx-size-xs pd-x-30 " id="startButton">应用</button>
                    <button style="float:left;margin-left:20px;" onclick="goJsonUrl('<%=SiteAddress+(TargetName.startsWith("/")?"/":channel.getFullPath()+"/")+TargetName%>')" name="startButton" type="button" class="btn btn-primary tx-size-xs pd-x-30 " id="jkyl">预览</button>
				</div>										
			</div>						
		</div>		
	</div>

</form>
<!--6ms-->


<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>

<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script src="../common/2018/bracket.js"></script>

<script>
	
  $(function(){
		'use strict';

		//show only the icons and hide left menu label by default
		$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
		
		
		$('.br-mailbox-list,.br-subleft').perfectScrollbar();

		$('#showMailBoxLeft').on('click', function(e){
			e.preventDefault();
			if($('body').hasClass('show-mb-left')) {
			$('body').removeClass('show-mb-left');
			$(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
			} else {
			$('body').addClass('show-mb-left');
			$(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
			}
		});
		
		  $('.br-sideleft [data-toggle="tooltip"]').tooltip({
				shadowColor:"#ffffff",
				textColor:"000000",
				trigger:"hover"
			});
		
		$(".date").datetimepicker({
			   timeText: '时间',  
			   hourText: '小时',  
			   minuteText: '分钟',  
			   secondText: '秒',  
			   currentText: '现在',  
			   closeText: '完成',  
			   showSecond: true, //显示秒  
			    dateFormat:"yy-mm-dd",
			    timeFormat: 'HH:mm:ss',//格式化时间  
			    monthNames: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],  
	            dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],  
	            dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],  
	            dayNamesMin: ['日','一','二','三','四','五','六']
		});

  });
  
    function subfrom() {
        $.ajax({
            url:"app_version_message_submit.jsp",
            type: 'post',
            data:  $('#form1').serialize(),
             success:function(data){
                     window.location.reload();
                },
             error:function(){
                 alert('失败');
             },
         async:true,
        });
    }
</script>



</body>
</html>

