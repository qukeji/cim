function add_frame(id){
	var	dialog = new top.TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(400);
	dialog.setLayer(2);
	dialog.setUrl("page_frame_add.jsp?frameID="+id+"&pageID="+pageID);
	dialog.setTitle("添加框架");
	dialog.show();
}

function del_frame(id)
{
	if(id>0)
	{
		if(confirm('你确认要删除框架吗?')) 
		{
			var url = baseUrl + "/page/page_action.jsp?Action=DeleteFrame&frameID="+id+"&pageID="+pageID;
			$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){
					 jQuery('div[tidecms_id="'+id+'"]').remove();
				 }   
			}); 
		}
	}
}

function move_frame2(id,action)
{
	if(id>0)
	{
		var divO =jQuery('div[tidecms_id="'+id+'"]');
		var divO2;
		var id2 = 0;

		if(action==1)//move to left
		{
			divO2 = divO.prev();//alert(divO2.html());
			id2 = divO2.attr("tidecms_id");
		}
		else if(action==2)//move to right
		{
			divO2 = divO.next();//alert(divO2.html());
			id2 = divO2.attr("tidecms_id");
		}

		//alert(id+","+id2);
		//if(confirm('你确认要移动框架吗?')) 
		//{
			var url = baseUrl + "/page/page_action.jsp?Action=MoveFrame&frameID="+id+"&frameID2="+id2+"&pageID="+pageID;
			//this.location = url;
			$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){
					 if(action==2) divO2.after(divO);
					 if(action==1) divO.after(divO2);
					 show_tools();
				 }   
			}); 
		//}
	}
}

function move_frame3(id,action)
{
	if(id>0)
	{
		var divO =jQuery('div[tidecms_id="'+id+'"]');
		var id2 = 0;

		if(action==1)//up
		{
			var divO2 = divO.prev();//alert(divO2.html());
			id2 = divO2.attr("tidecms_id");
		}
		else if(action==2)//down
		{
			var divO2 = divO.next();//alert(divO2.html());
			id2 = divO2.attr("tidecms_id");
		}
		//alert(id+","+id2);
		if(confirm('你确认要移动模块吗?')) 
		{
			this.location = baseUrl + "/page/page_action.jsp?Action=MoveModule&moduleID="+id+"&moduleID2="+id2+"&pageID="+pageID;
		}
	}
}

//上下移动框架
function move_frame(id,action)
{
	if(id>0)
	{
		var divO =jQuery('div[tidecms_id="'+id+'"]');
		var id2 = 0;

		if(action==1)//up
		{
			var divO2 = divO.prev();//alert(divO2.html());
			id2 = divO2.attr("tidecms_id");
		}
		else if(action==2)//down
		{
			var divO2 = divO.next();//alert(divO2.html());
			id2 = divO2.attr("tidecms_id");
		}

		if (typeof(id2) == "undefined") { 
			alert("没有找到移动后交换的框架");
			return;
		}
		//alert(id+","+id2);
		//if(confirm('你确认要移动框架吗?')) 
		//{
			var url = baseUrl + "/page/page_action.jsp?Action=MoveFrame&frameID="+id+"&frameID2="+id2+"&pageID="+pageID;
			$.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg){
					 if(action==2) divO2.after(divO);
					 if(action==1) divO.after(divO2);
					 show_tools();
				 }   
			}); 
		//}
	}
}

function del_module(id)
{
	if(id!=0)
	{
		if(confirm('你确认要删除模块吗?')) 
		{
			this.location = baseUrl + "/page/page_action.jsp?Action=DeleteModule&moduleID="+id+"&pageID="+pageID;
		}
	}
}

function add_module(id)
{
	if(id!=0)
	{
		this.location = baseUrl + "/page/page_action.jsp?Action=AddModule&moduleID="+id+"&pageID="+pageID;
	}
}

function listDocument(id)
{
		var url = baseUrl  + "/content/module_content_list.jsp?ModuleID=" + id;
		window.open(url);
}

function addDocument(id)
{
  		var url= baseUrl  + "/content/module_content_add.jsp?ModuleID=" + id;
  		window.open(url);
}

function set_module(id)
{
	if(id!=0)
	{
		var	dialog = new top.TideDialog();
		dialog.setWidth(480);
		dialog.setHeight(290);
		dialog.setLayer(2);
		dialog.setUrl("pagemodule_add.jsp?moduleID="+id+"&pageID="+pageID);
		dialog.setTitle("模块设置");
		dialog.show();
	}
}

function update_content_module(id)
{
	if(id!=0)
	{
		var	dialog = new top.TideDialog();
		dialog.setWidth(400);
		dialog.setHeight(300);
		dialog.setLayer(2);
		dialog.setUrl("pagemodule_add_2.jsp?moduleID="+id+"&pageID="+pageID);
		dialog.setTitle("内容编辑");
		dialog.show();
	}
}

function get_frame_tools(obj,tool_up){
	var id = obj.attr("tidecms_id");
	var t='';
	if(tool_up==0){
		t='<img title="向下移动" alt="向下移动" src="'+baseUrl+'/images/edit_page_icon_1.gif" onClick="move_frame('+id+',2);"/>';
	}else if(tool_up==1){
		t='<img title="向上移动" alt="向上移动" src="'+baseUrl+'/images/edit_page_icon_4.gif" onClick="move_frame('+id+',1);"/>';
		t+='<img title="向下移动" alt="向下移动" src="'+baseUrl+'/images/edit_page_icon_1.gif" onClick="move_frame('+id+',2);"/>';
	}else if(tool_up==2){
			t='<img title="向上移动" alt="向上移动" src="'+baseUrl+'/images/edit_page_icon_4.gif" onClick="move_frame('+id+',1);"/>';
	}
	var obj2 = obj.find('div[type="2"]');
	//alert(obj2.length);
	var title = "";
	if(obj2.length==1) title = "通栏";
	else if(obj2.length==2) title = "二分栏";
	else if(obj2.length==3) title = "三分栏";
	else if(obj2.length==4) title = "四分栏";

	var tool=' <div class="tideframe_tools">\
				<span class="tideframe_title">'+title+'</span>\
				<div class="tideframe_tools_button">'+t+'<img src="'+baseUrl+'/images/edit_page_icon_2.gif" alt="添加框架" title="添加框架"  onclick="add_frame(\''+id+'\');"><img src="'+baseUrl+'/images/edit_page_icon_3.gif" alt="删除框架" title="删除框架" onclick="del_frame(\''+id+'\');"></div>\
			</div>';
	return tool;
}

function get_column_tools(obj){
	//alert(obj.attr("class"));
	var id = obj.attr("tidecms_id");
	//var c = obj.attr("class");
	//var s = c.lastIndexOf ("_");
	var title = obj.width();

	var tool='            <div class="tideframe_column_tools">\
                <span class="tideframe_title">'+title+'px</span>';
	var tool2 = "";
	var o = obj.prev();//window.console.info(o);
	if(o!=null && o.attr("type")==2)
			tool2 = tool2 + '<img style="width:14px;height:14px" src="'+baseUrl+'/images/edit_page_icon_5.gif" alt="向左移动" title="向左移动" onClick="move_frame2('+id+',1);"/>';

	var o = obj.next();//alert(o.html());
	if(o!=null && o.attr("type")==2)
			tool2 = tool2 + '<img style="width:14px;height:14px" src="'+baseUrl+'/images/edit_page_icon_6.gif" alt="向右移动" title="向右移动" onClick="move_frame2('+id+',2);"/>';


	if(tool2!="") tool = tool + '<div class="tideframe_column_tools_button">' + tool2 + '</div>';

	tool = tool + '</div>';
	//window.console.info(tool);
	return tool;
}

function get_block_tools(obj){
	var id = obj.attr("tidecms_id");//alert(id);
	var type = obj.attr("type");
	var tool='<div class="tideframe_block_tools_left">';

	/*
	var o = obj.prev();//alert(o.html());
	if(o!=null && o.attr("class")=="block_tools")
			tool +=  '<img src="'+baseUrl+'/images/edit_page_icon_4.gif" alt="向上移动" title="向上移动" onClick="move_frame3('+id+',1);"/>';

	var o = obj.next();//alert(o.html());
	if(o!=null && o.attr("class")=="block_tools")
			tool +=  '<img src="'+baseUrl+'/images/edit_page_icon_1.gif" alt="向下移动" title="向下移动" onClick="move_frame3('+id+',2);"/>';

	*/
	if(edittype>0)
	tool += '<img style="width:14px;height:14px" src="'+baseUrl+'/images/edit_page_icon_2.gif" alt="添加模块" title="添加模块" onclick="add_module(\''+id+'\');"><img style="width:14px;height:14px" src="'+baseUrl+'/images/edit_page_icon_3.gif" alt="删除模块" title="删除模块" onClick="del_module('+id+')">';
	
	tool += '</div>';
	
	tool += '<div class="tideframe_block_tools_right">';

	if(id<0 && edittype>0)
		tool += '<img style="width:14px;height:14px" src="'+baseUrl+'/images/edit_page_icon_7.gif" alt="模块属性" title="模块属性" onClick="set_module('+id+')">';

	if(id>0)
	{
		if(type==2)
			tool += '<img style="width:14px;height:14px" src="'+baseUrl+'/images/edit_page_icon_8.gif" alt="编辑模块" title="编辑模块" onClick="update_content_module('+id+')">';
		if(type==1)
		{
			if(edittype>0)
			tool += '<img style="width:14px;height:14px" src="'+baseUrl+'/images/edit_page_icon_7.gif" alt="模块属性" title="模块属性" onClick="set_module('+id+')">';
			
			tool += '<img style="width:14px;height:14px" src="'+baseUrl+'/images/edit_page_icon_9.gif" alt="列表" title="内容列表" onClick="listDocument('+id+')">';
			tool += '<img style="width:14px;height:14px" src="'+baseUrl+'/images/edit_page_icon_10.gif" alt="添加文档" title="添加文档" onClick="addDocument('+id+')">';
		}
	}
	
	tool += '</div>';//alert(tool);
	return tool;
}


function show_tools(){
	jQuery(".tideframe_column_tools").remove();
	jQuery(".tideframe_tools").remove();
	if(edittype==0)
	{
		jQuery('div[class="tideframe_block_tools"]').each(function(){
			var obj=jQuery(this);//alert(obj);
			obj.append(get_block_tools(obj));
		});
	}
	else if(edittype==1)
	{
		jQuery('div[class="tideframe_block_tools"]').each(function(){
			var obj=jQuery(this);//alert(obj);
			obj.append(get_block_tools(obj));
		});
	}
	else if(edittype==2)
	{
		var len=jQuery('div[type="1"]').length;
		if(len>0){
			len=len-1;
			jQuery('div[type="1"]').each(function(i){
				var obj=jQuery(this);
				//var id=obj.attr("tidecms_id");//alert(id);
				var tool_up=1;//0向下 1上下 2向上
				if(i==0){
					tool_up=0;
				}else if(len==i){
					tool_up=2;
				}
				obj.prepend(get_frame_tools(obj,tool_up));
			});

			
			jQuery('div[type="2"]').each(function(){
				var obj=jQuery(this);
				obj.prepend(get_column_tools(obj));
			});
			
		}else{
			var html='<div class="template_div" style="width:100%;height:100%"><img style="width:14px;height:14px" src="'+baseUrl+'/images/edit_page_icon_2.gif" alt="添加框架" title="添加框架"  onclick="add_frame(\'\');"></div>';
			jQuery("body").append(html);
		}
	}
}

show_tools();