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

function Preview()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择要预览的文件！");
	}else if(obj.length>1){
		alert("请先选择一个预览的文件！");
	}else{
		 window.open("document_preview.jsp?ItemID=" + obj.id + Parameter);
	}
}

function deleteFile(){
	var obj=getCheckbox();
	var message = "确实要删除这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要删除的文件！");
	}else{
		 if(confirm(message)){
		  document.location.href = "document_delete.jsp?ItemID=" + obj.id + Parameter;
		}
	}
}


function deleteFile2(){
	var obj=getCheckbox();
	var message = "确实要撤稿这"+obj.length+"项吗？";
	if(obj.length==0){
		alert("请先选择要撤稿的文档！");
	}else{
		 if(confirm(message)){
		  document.location.href = "document_delete2.jsp?ItemID=" + obj.id + Parameter;
		}
	}
}


function approve(Status){
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请先选择文档！");
		return;
	}
	var message="";
	if(Status==1){
			message = "确实要审核这"+obj.length+"项吗？";
			if(!confirm(message))
			{
				return;
			}
	}else	if(Status==2){
			message = "确实要归档这"+obj.length+"项吗？";
			if(!confirm(message))
			{
				return;
			}
	}else	if(Status==3){
			 message = "确实要预审这"+obj.length+"项吗？";
			if(!confirm(message))
			{
				return;
			}
	}
		document.location.href = "approvedocument.jsp?Status="+Status+"&ItemID=" + obj.id + Parameter;
	
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
	  document.location.href = "document_publish.jsp?ItemID=" + obj.id + Parameter;
}

function addDocument()
{
	var width  = Math.floor( screen.width  * .8 );
	var height = Math.floor( screen.height * .85 );
	var leftm  = Math.floor( screen.width  * .1);
	var topm   = Math.floor( screen.height * .05);
	var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
	var url="document.jsp?ItemID=0&ChannelID=" + ChannelID;
	window.open(url,"",Feature);
}


function sortable(){
	jQuery("#oTable").sortable({items:"tr:gt(0)",axis:"y",cursor:"move",
		start:function(e,ui){
			},
		stop:function(e,ui){
			},
		update:function(e,ui){
			var ItemID=ui.item.attr("ItemID");
			var OrderNumber=parseInt(ui.item.attr("OrderNumber"));
			var OrderNumber_next=parseInt(ui.item.next().attr("OrderNumber"));
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
			//var url="document_operation.jsp";
			var url="../content/document_operation.jsp";
			var url_Refresh="content.jsp?currPage="+page.currPage+"&id="+page.id+"&rowsPerPage="+page.rowsPerPage+page.querystring+"&sortable=enable";	
			var data="Action=Order&ChannelID="+ChannelID+"&ItemID="+ItemID;
				data+="&Direction="+Direction+"&Number="+Number;		
			jQuery.ajax({
				type: "GET",
				url: url,
				async:false,
				data: data,
				error: function(){},
				beforeSend:function(){},
				complete:function(){},
				success: function(msg){
					jQuery("#loadding").html("");
					if(jQuery.trim(msg)=="Refresh"){
						document.location=url_Refresh;
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
	document.location.href = "content.jsp?id="+id+"&rowsPerPage="+value;
}

function editDocument(itemid)
{
	var width  = Math.floor( screen.width  * .8 );
	var height = Math.floor( screen.height * .8 );
	var leftm  = Math.floor( screen.width  * .1)+30;
	var topm   = Math.floor( screen.height * .05)+30;
 	var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
  	var url="document.jsp?ItemID="+itemid+"&ChannelID=" + ChannelID;
  	window.open(url,"",Feature);
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
	jQuery("#oTable tr:gt(0)").dblclick(function(){
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
	jQuery('#displayOperation ul').hide();
}

function showDiv()
{
	jQuery('#ul1').show();
	window.event.cancelBubble = true;
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

jQuery(document).ready(function() {
	document.onclick=closeDiv;
	otherOperation({id:'#otherOperation',showid:'#otherOperation ul'});//显示其它操作
	otherOperation({id:'#otherOperation2',showid:'#otherOperation2 ul'});//显示其它操作
	jQuery("#rowsPerPage").val(page.rowsPerPage);
	/**给行加当前样式***/
jQuery(":checkbox",jQuery("#oTable")).click(function(){
		 closeDiv();
		var obj=jQuery(this).parent().parent();
		obj.toggleClass("cur");
		if(jQuery(obj).hasClass("cur")){
			var next=jQuery(obj).next();
			var id=next.attr("id");
			if(typeof(id)=='undefined'){
			var pre=jQuery(obj).prev();
				id=pre.attr("id");
			}

			if(typeof(id)=='undefined'){
					id=obj.attr("id");
			}
			var top=getAbsoluteTop(id);
			jQuery("#jTipId").css({top:top});
			jQuery("#jTipId").show();
		}
		var obj2=getCheckbox();
		if(obj2.length==0){
			jQuery("#jTipId").hide();
		}
	});

	jQuery("#oTable td:has(img)").click(function(){
		 closeDiv();
		jQuery("#selectNo").trigger("click");
		var obj=jQuery(this).parent();
		var obj2=jQuery(":checkbox",jQuery(obj));
		obj2.trigger("click");
		var next=jQuery(obj).next();
		var id=next.attr("id");
		if(typeof(id)=='undefined'){
			var pre=jQuery(obj).prev();
			id=pre.attr("id");
		}

		if(typeof(id)=='undefined'){
					id=obj.attr("id");
		}
		var top=getAbsoluteTop(id);
		jQuery("#jTipId").css({top:top});
		jQuery("#jTipId").show();
		
	});

	jQuery("#selectAll").click(function(){
		jQuery("#oTable tr").addClass("cur");
		var obj=jQuery(":checkbox",jQuery("#oTable"));
		obj.attr("checked","checked");
	});

	jQuery("#selectNo").click(function(){
		jQuery("#oTable tr").removeClass("cur");
		var obj=jQuery(":checkbox",jQuery("#oTable"));
		obj.removeAttr("checked","checked");
		jQuery("#jTipId").hide();
	});

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
		var href="content.jsp?currPage="+num+"&id="+page.id+"&rowsPerPage="+page.rowsPerPage+page.querystring;
		document.location.href=href;
	});
	double_click();
	jQuery("#oTable").tablesorter({headers: { 0: { sorter: false}}});
});


function recommendOut()
{
	var obj=getCheckbox();
	if(obj.length==0){
		alert("请选择要推荐出去的文档！");
	}else if(obj.length>1){
		alert("请选择一个要推荐出去的文档！");
	}else{
		  //alert(obj.id);
		  	var myObject = new Object();
			myObject.title = "推荐";
			var Feature = "dialogWidth:32em; dialogHeight:20em;center:yes;status:no;help:no";
			var retu = window.showModalDialog
			("../modal_dialog.jsp?target=content/recommend_out.jsp&ItemID="+obj.id + "&ChannelID="+ChannelID,myObject,Feature);
	}
}

function recommendIn()
{
		  var myObject = new Object();
			myObject.title = "选择推荐条目";
			myObject.ChannelID =page.id;

			var width  = Math.floor( screen.width  * .8 );
			var height = Math.floor( screen.height * .85 );
			var leftm  = Math.floor( screen.width  * .1);
			var topm   = Math.floor( screen.height * .05);
			var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height=" + height;
			var url="../content/recommend_item.jsp?ChannelID=" + myObject.ChannelID;
			window.open(url,"",Feature);
	
}