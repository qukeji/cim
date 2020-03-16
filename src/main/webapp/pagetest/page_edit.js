function add_model(id){
	alert(id);
}

function get_frame_tools(id,tool_up){
	var t='';
	if(tool_up==0){
		t='<img title="向下移动" alt="向下移动" src="../images/edit_page_icon_1.gif"/>';
	}else if(tool_up==1){
		t='<img title="向下移动" alt="向下移动" src="../images/edit_page_icon_1.gif"/>';
		t+='<img title="向上移动" alt="向上移动" src="../images/edit_page_icon_4.gif"/>';
	}else if(tool_up==2){
			t='<img title="向上移动" alt="向上移动" src="../images/edit_page_icon_4.gif"/>';
	}
	var tool=' <div class="frame_tools">\
				<span class="title">通栏</span>\
				<div class="frame_tools_button">'+t+'<img src="../images/edit_page_icon_2.gif" alt="添加框架" title="添加框架"  onclick="add_model(\''+id+'\');"><img src="../images/edit_page_icon_3.gif" alt="删除框架" title="删除框架"></div>\
			</div>';
	return tool;
}

function get_block_tools(id){
	var tool=' <div class="block_tools">\
					<div class="block_tools_left"><img src="../images/edit_page_icon_2.gif" alt="添加模块" title="添加模块" onclick="add_model(\''+id+'\');"><img src="../images/edit_page_icon_3.gif" alt="删除模块" title="删除模块"></div>\
					<div class="block_tools_right"><img src="../images/edit_page_icon_7.gif" alt="模块属性" title="模块属性"><img src="../images/edit_page_icon_8.gif" alt="编辑模块" title="编辑模块"><img src="../images/edit_page_icon_9.gif" alt="复制模块" title="复制模块"></div>\
				</div>';
	return tool;
}

function start(){
	var len=jQuery('div[type="1"]').length-1;
	jQuery('div[type="1"]').each(function(i){
		var id=jQuery(this).attr("id");
		var tool_up=1;//0向下 1上下 2向上
		if(i==0){
			tool_up=0;
		}else if(len==i){
			tool_up=2;
		}
		jQuery(this).before(get_frame_tools(id,tool_up));
	});

	jQuery('div[type="2"]').each(function(){
		var id=jQuery(this).attr("id");
		jQuery(this).before(get_block_tools(id));
	});
}

start();