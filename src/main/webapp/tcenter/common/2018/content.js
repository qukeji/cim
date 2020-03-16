$(document).ready(function() {
	
	if(typeof(page)=="object")
	{
		$("#rowsPerPage").val(page.rowsPerPage);
	}
	
	if(listType==2){

		$("#rows").val(rows);
		$("#cols").val(cols);
	}

	double_click();
});
//检查审核状态
function approve_check(type){
	var flag = true ;
	jQuery("#content-table input:checked").each(function(i){
		var id = jQuery(this).val();

		flag = approve_check_(id,type);
		if(!flag){
			return false ;
		}
	});
	return flag;
}
function approve_check_(id,type){
	var flag = true ;

	var approve = $("#item_"+id).attr("approve");
	if(approve!=1){	//未配置审核	
		return flag ;			
	}
	
	var action = $("#item_"+id).attr("ApproveAction");//是否通过
	if(type==1){//编辑操作，未提交审核或者审核被驳回可以再次编辑
		var actionId = $("#item_"+id).attr("actionId");
		if(actionId==0||action==1){
			return true ;	
		}else{
			return false ;
		}
	}else{
		var end = $("#item_"+id).attr("end");
		if(end!=1||action==1){//不是终审或者未通过
			return false ;
		}
	}

	return flag;
}
//获取选中记录
function getCheckbox(){
	var id="";
	jQuery("#content-table input:checked").each(function(i){
		if(i==0)
			id+=jQuery(this).val();
		else
			id+=","+jQuery(this).val();
	});
	var obj={length:jQuery("#content-table input:checked").length,id:id};
	return obj;
}
//发布
function approve(){
	var obj=getCheckbox();
	if(obj.length==0){
		TideAlert("提示","请先选择要发布的文档！");
		return;
	}

	if(!approve_check(0)){
		TideAlert("提示","请选择审核通过的文档！");
		return;
	}

	var message = "确实要发布这"+obj.length+"项吗？";
	
	if(!confirm(message)){
			return;
	}

	approve_(obj.id);
}
function approve2(id){
	var message = "确实要发布这1项吗？";
	
	if(!confirm(message)){
			return;
	}
	
	approve_(id);	
}
function approve_(id)
{
	var url= "../content/approvedocument.jsp?ItemID=" + id + Parameter;
	$.ajax({
		 type: "GET",
		 url: url,
		 success: function(msg){document.location.reload();}   
	}); 
}

//预览
function Preview()
{
	var obj=getCheckbox();
	if(obj.length==0){
		TideAlert("提示","请先选择要预览的文件！");
	}else if(obj.length>1){
		TideAlert("提示","请选择一个预览的文件！");
	}else{
		 Preview2(obj.id);//window.open("../content/document_preview.jsp?ItemID=" + obj.id + Parameter);
	}
}
function Preview2(id)
{
		 window.open("../content/document_preview.jsp?ItemID=" + id + Parameter);
}
function Preview3(id)
{
		 window.open("../content/document_preview2.jsp?ItemID=" + id + Parameter);
}
//编辑
function editDocument(itemid)
{
	if(!approve_check_(itemid,1)){
		TideAlert("提示","审核中的文档不能进行编辑！");
		return;
	}

  	var url="../content/document.jsp?ItemID="+itemid+"&ChannelID=" + ChannelID;
  	window.open(url);
}
function editDocument1()
{
	var obj=getCheckbox();
	if(obj.length==0){
		TideAlert("提示","请先选择要编辑的文件！");
	}else if(obj.length>1){
		TideAlert("提示","请先选择一个要编辑的文件！");
	}else{
		editDocument(obj.id);
	}
}
//撤稿
function deleteFile2(){
	var obj=getCheckbox();
	var message = "确实要撤稿这"+obj.length+"项吗？";
	if(obj.length==0){
		TideAlert("提示","请先选择要撤稿的文档！");
	}else{

		if(!approve_check(0)){
			TideAlert("提示","请选择审核通过的文档！");
			return;
		}

		if(confirm(message)){
			deleteFile2_confirm(obj.id,obj.length);
		}
	}
}
function deleteFile3(id){
	var message = "确实要撤稿这1项吗？";
	if(confirm(message)){
		deleteFile2_confirm(id,0);
	}
}
function deleteFile2_confirm(id,length){
	
	var url="../content/document_delete2.jsp?check=1&ItemID=" + id + Parameter;
	$.ajax({
		type: "GET",
		url: url,
		dataType:"json",
		success: function(msg){
			if(msg.status==0)
			{
				var msg2 = "文章已被推荐，是否撤稿？";
				if(length>1) msg2 = "选中的文章有被推荐，是否撤稿？";
				
				if(confirm(msg2)){
					deleteFile2_(id);
				}
				
			}
			else
			{
				document.location.href=document.location.href;
			}
		}
	}); 
}
function deleteFile2_(s)
{
	var url="../content/document_delete2.jsp?ItemID=" + s + Parameter;
	$.ajax({
		type: "GET",
		url: url,
		success: function(msg){document.location.href=document.location.href;}   
	}); 
}
//删除
function deleteFile(){
	var obj=getCheckbox();
	var message = "确实要删除这"+obj.length+"项吗？";
	if(obj.length==0){
		TideAlert("提示","请先选择要删除的文件！");
	}else{
		if(!approve_check(1)){
			TideAlert("提示","请选择审核通过的文档！");
			return;
		}

		if(confirm(message)){
			deleteFile_confirm(obj.id,obj.length);
		}
	}
}
function deleteFile1(id){
	var message = "确实要删除这1项吗？";
	if(confirm(message)){
		deleteFile_confirm(id,0);
	}
}
function deleteFile_confirm(id,length){
	
	var url="../content/document_delete.jsp?check=1&ItemID=" + id + Parameter;
	$.ajax({
		type: "GET",
		url: url,
		dataType:"json",
		success: function(msg){
			if(msg.status==0)
			{
				var msg2 = "文章已被推荐，是否删除？";
				if(length>1) msg2 = "选中的文章有被推荐，是否删除？";
				
				if(confirm(msg2)){
					deleteFile_(id);
				}
			}
			else
			{
				document.location.href=document.location.href;
			}
		}   
	});  
}
function deleteFile_(s)
{
	var url="../content/document_delete.jsp?ItemID=" + s + Parameter;
	$.ajax({
		type: "GET",
		url: url,
		success: function(msg){document.location.href=document.location.href;}   
	});  
}
//恢复
function resume(id){
	var message = "确实要恢复这1项吗？";
	
	if(!confirm(message)){
			return;
	}
	
	var url=  "../content/document_resume.jsp?ItemID=" + id + Parameter;
	$.ajax({
		 type: "GET",
		 url: url,
		 success: function(msg){document.location.href=document.location.href;}   
	}); 	
}
//新建
function addDocument()
{
	var url="../content/document.jsp?ItemID=0&ChannelID=" + ChannelID;
	window.open(url);
}
//推荐
function recommendOut()
{				
	var id="";
	var approved = true;
	$("#content-table input:checked").each(function(i){
		if(i==0)
			id+=$(this).val();
		else
			id+=","+$(this).val();
		var status=$("#item_"+$(this).val()).attr("status");
		if(status!="1") approved = false;
	});

	if(id==""){
		TideAlert("提示","请选择要推荐出去的文档！");
		return;
	}

	if(!approved){
		TideAlert("提示","请选择发布后的文档");
		return;
	}
	
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(400);
		dialog.setUrl("../recommend/out_index.jsp?ChannelID="+ChannelID+"&ItemID="+id);
		dialog.setTitle('推荐');
		dialog.show();
}
//引用
function recommendIn()
{
	//引用
	var myObject = new Object();
	myObject.title = "选择引用条目";
	myObject.ChannelID =page.id;

	var url="../recommend/recommend_item.jsp?ChannelID=" + myObject.ChannelID;
	window.open(url);
}
/**改变每页显示*/
function change(s,id)
{
	var value=jQuery(s).val();
	var exp  = new Date();
	exp.setTime(exp.getTime() + 300*24*60*60*1000);
	document.cookie = "rowsPerPage_new="+value;
	document.location.href = pageName+"?id="+id+"&rowsPerPage="+value;
}
//跳页
function jumpPage(){
	var num=jQuery("#jumpNum").val();
	if(num==""){
		TideAlert("提示","请输入数字!");
		jQuery("#jumpNum").focus();
		return;
	}
	var reg=/^[0-9]+$/;
	if(!reg.test(num)){
		TideAlert("提示","请输入数字!");
		jQuery("#jumpNum").focus();
		return;
	}

	if(num>page.TotalPageNumber)
		num=page.TotalPageNumber;
	if(num<1)
		num=1;
	gopage(num);	
}
//内容中心返回上级
function jumpContent(id){
	
	window.parent.frames["content_frame"].src="../content/content2018.jsp?id="+id;
}
//频道管理返回上级
function jumpChannel(id){
	
	window.parent.frames["content_frame"].src="../channel/channel2018.jsp?id="+id;
}
//双击
function double_click()
{
	jQuery("#content-table .tide_item").dblclick(function(){
		var obj=jQuery(":checkbox",jQuery(this));
		obj.trigger("click");
		editDocument(obj.val());
	});
	
}
function  RefreshItem(){
	var obj=getGlobalID();
	if(obj.length==0){
		TideAlert("提示","请先选择要刷新的文件！");
		return;
	}
	
	if(obj.length>1){
		TideAlert("提示","请选择一个刷新的文件！");
		return;
	}

	RefreshItem1(obj.id);
}
function  RefreshItem1(id){
	
	jQuery.ajax({
	 type: "POST",
	 url: "refresh_item.jsp",
	 data: "GlobalID="+id,
	 error:function(){
		 TideAlert("提示","刷新失败!");
	},
	 success: function(msg){
		TideAlert("提示","刷新成功!");
	 } 
	});
}
function getGlobalID(){
	var id="";
	jQuery("#content-table input:checked").each(function(i){
		var obj=jQuery(this).parent().parent();
		if(i==0)
			id+=jQuery(obj).attr("GlobalID");
		else
			id+=","+jQuery(obj).attr("GlobalID");
	});
	var obj={length:jQuery("#content-table input:checked").length,id:id};
	return obj;
}
//排序
function SortDoc(){
	
	var obj=getCheckbox();
	if(obj.length!=1){
		TideAlert("提示","请选择一个待排序的选项!");
	}else{
		
		SortDoc1(obj.id);
	}	
}
function SortDoc1(id){
	
	var OrderNumber = $("#item_"+id).attr("OrderNumber");		
	var url= "../content/document_sort.jsp?ChannelID="+ChannelID+"&ItemID="+id+"&OrderNumber="+OrderNumber;
	
	var	dialog = new top.TideDialog();
	dialog.setWidth(300);
	dialog.setHeight(230);
	dialog.setUrl(url);
	dialog.setTitle("排序");
	dialog.show();
}

function createCategory(id){
	
	var url= "../content/document_create_category.jsp?ChannelID="+id;
	
	var	dialog = new top.TideDialog();
	dialog.setWidth(300);
	dialog.setHeight(230);
	dialog.setUrl(url);
	dialog.setTitle("新建分类");
	dialog.show();
}

//搜索
function check(){
	var StartDate = $("input[id='startDate']").val();//开始时间
	var EndDate = $("input[id='endDate']").val();//结束时间
	
	if(StartDate>EndDate){//开始时间能大于结束时间
		TideAlert("提示","开始时间不能大于结束时间!");
		return false;
	}
	
	return true ;
}
//alert定制
function ddalert(message,confirm_){
	var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(250);
		dialog.setTitle('提示');
		dialog.setMsg(message);
		dialog.setMsgJs(confirm_);
		dialog.ShowMsg();
}
//改变列表形式
function changeList(i)
{
	var expires = new Date();
	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
	document.cookie = ChannelID+"_list_new=" + i + ";path=/;expires=" + expires.toGMTString();
	document.location.href = pageName + '?listtype=' + i + '&cookie=1&id='+ChannelID+Parameter;
}
function changeRowsCols()
{
	var rows = $("#rows").val();
	var cols = $("#cols").val();
	var expires = new Date();
	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
	document.cookie = "rows_new=" + rows + ";path=/;expires=" + expires.toGMTString();
	document.cookie = "cols_new=" + cols + ";path=/;expires=" + expires.toGMTString();
	document.location.href = pageName + "?id="+ChannelID+"&rows="+rows+"&cols="+cols;
}
function checkLoad(_this){
	$(_this).attr('src', '../images/2018/img12.jpg');
	$(_this).attr('data-src', '');
}

function ChangeTop(channelid,way){
	var msg = "置顶";
	if(way==2){
		msg = "撤销置顶";
	}
	var obj=getCheckbox();
	if(obj.length==0){
		TideAlert("提示","请先选择要"+msg+"的文档！");
		return;
	}
	var message = "确实要"+msg+"这"+obj.length+"项吗？";
	if(!confirm(message)){
		return;
	}
	$.ajax({
	   type: "GET",
	   url: "../content/changetop.jsp",
	   data: {id:channelid,way:way,ids:obj.id},
	   success: function(msg){
		  location.reload();
	   }
    });
}

function CancleTop(channelid,way,itemid){
	var message = "确实要取消这篇文章的置顶吗？";
	if(way==1){
		message = "确实要置顶这篇文章吗？";
	}
	if(!confirm(message)){
			return;
	}
	$.ajax({
	   type: "GET",
	   url: "../content/changetop.jsp",
	   data: {id:channelid,way:way,ids:itemid},
	   success: function(msg){
		 // alert(msg);
		  location.reload();
	   }
    });
}

//复制移动
function copy(type){
	var msg = "复制";
	if(type==1){
		msg = "移动";
	}
	var obj=getCheckbox();
	if(obj.length<1){
		TideAlert('提示',"请选择要"+msg+"的稿件!")
		//alert("请选择要"+msg+"的稿件!");
		return;
	}
	var dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(400);
		dialog.setUrl("../content/document_copy_index.jsp?ChannelID="+ChannelID+"&ItemID="+obj.id+"&type="+type);
		dialog.setTitle('选择');
		dialog.show();
/*	
	
	var message = "确实要"+msg+"这"+obj.length+"项到。。。吗？";
	if(!confirm(message)){
			return;
	}
*/	
}