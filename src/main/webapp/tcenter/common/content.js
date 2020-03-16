$(document).ready(function() {
	document.onclick=closeDiv;
	//jQuery('#otherOperation').bind("click",showDiv);
	otherOperation({id:'#otherOperation',showid:'#otherOperation ul'});//显示其它操作
	otherOperation({id:'#otherOperation2',showid:'#otherOperation2 ul'});//显示其它操作
	otherOperation({id:'#otherOperation3',showid:'#otherOperation3 ul'});//显示其它操作
	//otherOperation({id:'#displayOperation',showid:'#displayOperation ul'});//显示其它操作
	
	if(typeof(page)=="object")
	{
		$("#rowsPerPage").val(page.rowsPerPage);
	}


	/**给行加当前样式***/
	UpdateWeight();//修改权重

	//单击，单选
	$("#oTable .tide_item").click(function(e){
		var o = $(this);
		var oo = $(e.target);
		if(o.hasClass("cur"))
			unselectOne(o);
		else
		{
			if(e.target.nodeName!="INPUT" && !oo.hasClass("checkbox")) $("#selectNo").trigger("click");
			selectOne(o);
		}
	});

	if(listType==1)
	{
		//文字列表
		//jQuery("#oTable").tablesorter({headers: { 0: { sorter: false}}});
	}

	$("#selectAll").click(function(){
		$("#oTable .tide_item").addClass("cur");
		$(":checkbox",$("#oTable")).attr("checked",true);
	});

	$("#selectNo").click(function(){
		var o = $("#oTable .tide_item.cur");
		o.removeClass("cur");
		$(":checkbox",o).attr("checked",false);
	});

	double_click();

	tidecms.setDatePicker("#CreateDate");

	jQuery("#goToId").click(function(){
	var num=jQuery("#jumpNum").val();
	if(num==""){
		alert("请输入数字!");
		jQuery("#jumpNum").focus();
		return;}
		var reg=/^[0-9]+$/;
		if(!reg.test(num)){
		alert("请输入数字!");
		jQuery("#jumpNum").focus();
		return;
	}

	if(num>page.TotalPageNumber)
		num=page.TotalPageNumber;
	if(num<1)
		num=1;

	gopage(num);
	});
});

function Drag(){
	window.event.dataTransfer.setData("Text","");
	if (window.event.shiftKey==true){
		event.dataTransfer.effectAllowed="move";
		}
	else{
		event.dataTransfer.effectAllowed="copy";
		}
}

function OnDragStart (event) {
	/*
      if (event.dataTransfer) {
                        // "text/plain" in Firefox from version 3.5
       var format = event.dataTransfer.types ? "text/plain" : "Text";
                var textData = event.dataTransfer.getData (format);
                if (textData) {
                    if (textData.length > 20) {
                        event.dataTransfer.clearData (format);
                    }
                    else {
                        var reverseText = "";
                        for (var i = 0; i < textData.length; i++) {
                            reverseText += textData.charAt (textData.length - i - 1);
                        }
                        event.dataTransfer.setData (format, reverseText);
                    }
                }
            }
	*/
}

function selectdate(fieldname){
	var args="font-size:10px;dialogWidth:286px;dialogHeight:290px;center:yes;status:no;help:no";
	var Feature=new Array();
	var selectdate=window.showModalDialog("selectdate.htm",Feature,args);
	//alert(document.all(fieldname));
	if (selectdate!=null)
	{
		if(document.all(fieldname).value!="")
		{
			arrayOfStrings = document.all(fieldname).value.split(" ");
			if(arrayOfStrings.length==1)
				document.all(fieldname).value = selectdate;
			else
				document.all(fieldname).value = selectdate + " " + arrayOfStrings[1];
		}
		else
			document.all(fieldname).value=selectdate;
	}
}


function openSearch()
{
	jQuery("#SearchArea").toggle();
	if($("#SearchArea").css("display")!="none")
		document.search_form.Title.focus();
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

function getGlobalID(){
	var id="";
	jQuery("#oTable input:checked").each(function(i){
		var obj=jQuery(this).parent().parent();
		if(i==0)
			id+=jQuery(obj).attr("GlobalID");
		else
			id+=","+jQuery(obj).attr("GlobalID");
	});
	var obj={length:jQuery("#oTable input:checked").length,id:id};
	return obj;
}

function  RefreshItem(){
	var obj=getGlobalID();
	if(obj.length==0){
		alert("请先选择要刷新的文件！");
		return;
	}
	
	if(obj.length>1){
		alert("请先选择一个刷新的文件！");
		return;
	}

	jQuery.ajax({
	 type: "POST",
	 url: "refresh_item.jsp",
	 data: "GlobalID="+obj.id,
	 error:function(){alert("刷新失败!");},
	 success: function(msg){
		alert("刷新成功!");
	 } 
	});
	
}

function Preview()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要预览的文件！");
	}else if(obj.length>1){
		alert("请先选择一个预览的文件！");
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

function Preview4(id)
{
		 window.open("../content/document_preview4.jsp?ItemID=" + id + Parameter);
}

function Preview5(id)
{
		 window.open("../content/document_preview5.jsp?ItemID=" + id + Parameter);
}

function deleteFile(){
	var obj=getCheckbox();
	var message = "确实要删除这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要删除的文件！");
	}else{
		 if(confirm(message)){
			 var url="../content/document_delete.jsp?check=1&ItemID=" + obj.id + Parameter;
			  $.ajax({
				 type: "GET",
				 url: url,
				 dataType:"json",
				 success: function(msg){
					 if(msg.status==0)
					 {
						 var msg2 = "文章已被推荐，是否删除？";
						 if(obj.length>1) msg2 = "选中的文章有被推荐，是否删除？";
						 if(confirm(msg2))
						 {
							 deleteFile_(obj.id);
						 }
					 }
					 else
					 {
						document.location.href=document.location.href;
					 }
				 }   
			});  
		}
	}
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


function deleteFile2(){
	var obj=getCheckbox();
	var message = "确实要撤稿这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要撤稿的文档！");
	}else{
		 if(confirm(message)){
			 var url="../content/document_delete2.jsp?check=1&ItemID=" + obj.id + Parameter;
			  $.ajax({
				 type: "GET",
				 url: url,
				 dataType:"json",
				 success: function(msg){
					 if(msg.status==0)
					 {
						 var msg2 = "文章已被推荐，是否撤稿？";
						 if(obj.length>1) msg2 = "选中的文章有被推荐，是否撤稿？";
						 if(confirm(msg2))
						 {
							 deleteFile2_(obj.id);
						 }
					 }
					 else
					 {
						document.location.href=document.location.href;
					 }
				 }   
			}); 
		}
	}
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

function approve(){
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要发布的文档！");
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

function Publish(){
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要发布的文档！");
		return;
	}

	var message = "确实要发布这"+obj.length+"项吗？";
	if(!confirm(message))
	{
				return;
	}

	 var url="../content/document_publish.jsp?ItemID=" + obj.id + Parameter;
		$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){document.location.href=document.location.href;}   
		}); 
}



function addDocument()
{
	var url="../content/document.jsp?ItemID=0&ChannelID=" + ChannelID;
	window.open(url);
}


function sortable(){
	var start_sort = false;
	jQuery("#oTable").sortable({items:"tr:gt(0)",axis:"y",cursor:"move",
		start:function(e,ui){
			var $p=jQuery(ui.placeholder);
			$p.css({visibility:'visible',height:'20px'});
			$p.html('<td colspan="7">&nbsp;&nbsp;&nbsp;</td>');
				if(!start_sort)
				{
					$("#selectNo").trigger("click");
					ui.helper.find(":checkbox").trigger("click");
					var th = $("#oTable_th").children();//alert(th[1].clientWidth);
					var child = ui.helper.children();
					for(var j = 0;j<child.size();j++)
						{(child[j].width=(th[j].clientWidth)+"px");
						}
					start_sort = true;
				}
			},
		stop:function(e,ui){
				start_sort = false;
			},
		update:function(e,ui){
			start_sort = false;
			var child = ui.item.children();
			for(var j = 0;j<child.size();j++)
			{
				if(window.ActiveXObject)
					child[j].width="";
				else
					child[j].width=("px");
			}
			var ItemID=ui.item.attr("ItemID");
			var OrderNumber=parseInt(ui.item.attr("OrderNumber"));
			var OrderNumber_next=parseInt(ui.item.next().attr("OrderNumber"));
			if(isNaN(OrderNumber_next)) OrderNumber_next = 0;
			var OrderNumber_prev=parseInt(ui.item.prev().attr("OrderNumber"));
			var Direction=0;
			var Number=0;
			//alert(OrderNumber+":"+OrderNumber_next+":"+OrderNumber_prev);
			if(OrderNumber!=OrderNumber_next){
				if((OrderNumber-OrderNumber_next)>0){
					Direction=0;
					Number=OrderNumber-OrderNumber_next;
					Number=Number-1;
				}else{
					Direction=1;
					Number=OrderNumber_next-OrderNumber;					
				}
			}else{
				if((OrderNumber-OrderNumber_prev)>0){
					Direction=0;
					Number=OrderNumber-OrderNumber_prev;
				}else{
					Direction=1;
					Number=OrderNumber_prev-OrderNumber;
				}
			}
			
			var url="../content/document_operation.jsp";
			var url_Refresh="content.jsp?currPage="+page.currPage+"&id="+page.id+"&rowsPerPage="+page.rowsPerPage+page.querystring+"&sortable=enable";	
			var data="Action=Order&ChannelID="+ChannelID+"&ItemID="+ItemID;
				data+="&Direction="+Direction+"&Number="+Number;		
			jQuery.ajax({
				type: "GET",
				url: url,
				async:false,
				data: data,
				success: function(msg){
					jQuery("#loadding").html("");
					if(jQuery.trim(msg)=="Refresh"){
						document.location.href=document.location.href + "&sortable=1";;
					}
				}
	 		});
	}});
	
}

function sortableEnable(){
	jQuery("#oTable").sortable("enable");
}

function sortableDisable(){
	jQuery("#oTable").sortable("disable");
}
/**改变每页显示*/
function change(s,id)
{
	var value=jQuery(s).val();
	var exp  = new Date();
	exp.setTime(exp.getTime() + 300*24*60*60*1000);
	document.cookie = "rowsPerPage="+value;
	document.location.href = pageName+"?id="+id+"&rowsPerPage="+value;
}

function changeRowsCols()
{
	var rows = $("#rows").val();
	var cols = $("#cols").val();
	var expires = new Date();
	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
	document.cookie = "rows=" + rows + ";path=/;expires=" + expires.toGMTString();
	document.cookie = "cols=" + cols + ";path=/;expires=" + expires.toGMTString();
	document.location.href = pageName + "?id="+ChannelID+"&rows="+rows+"&cols="+cols;
}

//改变列表形式
function changeList(i)
{
	var expires = new Date();
	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
	document.cookie = ChannelID+"_list=" + i + ";path=/;expires=" + expires.toGMTString();
	document.location.href = pageName + '?listtype=' + i + '&cookie=1&id='+ChannelID+Parameter;
}

function editDocument(itemid)
{
  	var url="../content/document.jsp?ItemID="+itemid+"&ChannelID=" + ChannelID;
  	window.open(url);
}

function editDocument1()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要编辑的文件！");
	}else if(obj.length>1){
		alert("请先选择一个要编辑的文件！");
	}else{
		  editDocument(obj.id);
	}
}


function double_click()
{
	jQuery("#oTable .tide_item").dblclick(function(){
		var obj=jQuery(":checkbox",jQuery(this));
		obj.trigger("click");
		editDocument(obj.val());
	});
	
}


/**操作**/
function operation(page,obj){
	
}
/***/
function otherOperation(o){
	jQuery(o.id).click(function(evt){
		jQuery(o.showid).toggle();
		//window.event.cancelBubble = true;
		if (!evt)
			window.event.cancelBubble = true;
		else
			evt.stopPropagation();
	});
}


function closeDiv()
{
	jQuery('#otherOperation ul').hide();
	jQuery('#otherOperation2 ul').hide();
	jQuery('#otherOperation3 ul').hide();
	jQuery('#displayOperation ul').hide();
}

function getAbsoluteTop(objectId) {
	o = document.getElementById(objectId)
	oTop = o.offsetTop;
	var i=0;
	while(o.offsetParent!=null) { 
		if(i<1){
		oParent = o.offsetParent;
		oTop += oParent.offsetTop;
		o = oParent;
		i++;
		}else{
		break;
		}
	}
	return oTop+3;
}
/******修改权重******/
function UpdateWeight(){
	 jQuery(".weightClass").each(function(){
		 var selfObj=this;
		 var url="update_weight.jsp?Action=setWeight&ChannelID="+page.id+"&ItemID="+jQuery(selfObj).attr("ItemID");
		 jQuery(selfObj).editable(url, {
		  name:'weight', 	
		  style:'inherit',
		 width:'22px',
		 refresh:true,
		 onblur:'submit',	  
		  data: function(value, settings) {
		  var retval = value.replace(/<br[\s\/]?>/gi, '\n');
		  return retval;
		  },
		  onsubmit:function(settings,self){
			var obj=jQuery('input',self);
			var value=jQuery(obj).val();
			var reg=/^[0-9]+$/;
			var revert=jQuery.trim(self.revert);
			if(revert==value){
				jQuery(self).html(revert);
				self.editing   = false;
				return false;
			}else if(reg.test(value)){
				return true;
			}else{
				jQuery(self).html(revert);
				self.editing   = false;
				alert("权重必须是数字!");
				return false;
			}
		 }
	  });
	 
	 });
	
}

function Lfill0(num){
	return (num>9?num:"0"+num);
}

/******权重加颜色******/
function WeightAddColor(){
	var date = new Date();
	var day = Lfill0(date.getDate());
	var month =Lfill0(date.getMonth()+1);
	var year = date.getFullYear();
	var text=month+"-"+day;
	jQuery("#oTable tr:contains('"+text+"')").each(function(){
		var cur=jQuery(this);
		jQuery(".weightClass",cur).css("color","blue");
	});
}

function selectOne(o)
{
	o.addClass("cur");
	o.find("input[name='id']").attr("checked",true);
}

function unselectOne(o)
{
	o.removeClass("cur");
	o.find("input[name='id']").attr("checked",false);
}

function recommendOut()
{
	var id="";
	var approved = true;
	$("#oTable input:checked").each(function(i){
		if(i==0)
			id+=$(this).val();
		else
			id+=","+$(this).val();
		var status=$("#item_"+$(this).val()).attr("status");
		if(status!="1") approved = false;
	});

	var obj=getCheckbox();
	if(id==""){
		alert("请选择要推荐出去的文档！");
		return;
	}

	if(!approved){
		alert("请选择发布后的文档!");
		return;
	}

	var	dialog = new top.TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(450);
	dialog.setUrl("content/recommend_out_index.jsp?ChannelID="+ChannelID+"&ItemID="+id);
	dialog.setTitle("推荐");
	dialog.show();	
}

function recommendIn()
{
	//引用
	var myObject = new Object();
	myObject.title = "选择引用条目";
	myObject.ChannelID =page.id;

	var url="../content/recommend_item.jsp?ChannelID=" + myObject.ChannelID;
	window.open(url);
}

function showCommentCount(ids){
		var url ="../comment/comment_count.jsp?ids="+ids+"&random="+Math.random();
		$.ajax({
				  type:"GET",
				  url:url,
				  dataType:"json",
				  global:false, 
				  success: function(json){
					for(var i=0;i<json.length;i++){
						var id= "comment_" +json[i].id;
						var count=json[i].count;
						$("#"+id).html("<a href='../comment/comment.jsp?ItemID="+json[i].id+"' target='_blank'>"+count+"</a>");
					}
				  } 
		});
}

//取消选择
function selectNo(){
		jQuery("#oTable td").removeClass("cur");
		var obj=jQuery(":checkbox",jQuery("#oTable"));
		obj.removeAttr("checked","checked");
}

//发布附加页面
function publishFile()
{
		var url ="../content/publish_extra_file.jsp?id="+ChannelID+"&random="+Math.random();
		$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){alert("发布成功");}   
		}); 
}