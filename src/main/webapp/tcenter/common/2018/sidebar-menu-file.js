$(function(){

	if(dir=="template"||dir=="user"||dir=="public"){
		
		$(".menu-system").addClass("active");
	}else{

		$(".menu-"+dir).addClass("active");

	}
	
	$(".br-subleft ul").eq(0).find("li").eq(0).addClass("actve")
});

$.sidebarMenu = function(menu) {
  var animationSpeed = 300;
  
  $(menu).on('click', 'li a', function(e) {system-menu
    var $this = $(this);
	//window.console.info($this);

    var checkElement = $this.next();
	var load = $this.attr("load");
	if(load==1) 
	{
		var channelid = $this.attr("channelid");
		//alert(channelid);
		var url="channel/channel_json.jsp?id="+channelid;
		$.ajax({type:"GET",dataType:"json",url:url,success: function(json){
			//alert(json.length);
			var html = '<ul class="treeview-menu">';
			for(var i=0;i<json.length;i++){
				//window.console.info(json[i]);
				if(json[i].child && json[i].child.length>0)
				{
					html += '<li class="treeview">';
				}
				else
				{
					html += '<li>';
				}
				html += '<a href="#" load="'+json[i].load+'" channelid="'+json[i].id+'"><i class="fa fa-television"></i> <span>'+json[i].name+'</span><i class="fa fa-angle-right pull-right"></i></a>';
				if(json[i].child && json[i].child.length>0)
				{
					//alert(json[i].child.length+","+get_menu_html(json[i]));
					html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
				}
				html += '</li>';
			}
			html += '</ul>';
			//window.console.info(html);
			$this.after($(html));
			$this.attr("load",0);//������ϸı�load����
			checkElement = $this.next();
			sidebarMenu_show(checkElement,animationSpeed,$this);
		}});
		return;
	}
	else
	{
		sidebarMenu_show(checkElement,animationSpeed,$this);
	}

    //if this isn't a link, prevent the page from being redirected
    if (checkElement.is('.treeview-menu')) {
      e.preventDefault();
    }
  });
}


function sidebarMenu_show(checkElement,animationSpeed,$this){
    console.log(checkElement,animationSpeed,$this);
    
    var $i = $this.find("i.fa");
    if (checkElement.is('.treeview-menu') && checkElement.is(':visible')) {
        //自定义
      	if(!$i.is('.fisrtNav')){
      		if($i.is('.fa-folder-open')){
	      		$i.removeClass("fa-folder-open folder-open").addClass("fa-folder");
	      	}else{
	      		$i.removeClass("fa-folder-open-o folder-open").addClass("fa-folder-o");
	      	}
      	}
      	//自定义end
        checkElement.slideUp(0, function() {
        	checkElement.removeClass('menu-open');
      	});
      	//checkElement.parent("li").removeClass("active");
        var parent_li = $this.parent("li");   //当前li（父级）
        var active_li  = $(".sidebar-menu").find("li.active") ;
	    active_li.removeClass("active");
//        parent.find('li.active').removeClass('active');  //关闭顶层父级ul下面高亮的某一个
	    parent_li.addClass('active');    //给自己的当前li(父级)加上高亮
		
		//$this.removeClass("clicked"); //开启导航点击事件
      
    }

    //If the menu is not visible
    else if ((checkElement.is('.treeview-menu')) && (!checkElement.is(':visible'))) {
        //Get the parent menu
        var parent = $this.parents('ul').first();  //找到顶层父级ul
        //Close all open menus within the parent
//        var ul = parent.find('ul:visible').slideUp(animationSpeed);  //关闭顶层父级ul下面未闭合的菜单
      
        //自定义
//      var i_all = parent.find('i.folder-open');
//      if(i_all.is('.fa-folder-open')){
//	        i_all.removeClass("fa-folder-open folder-open").addClass("fa-folder");
//	    }
        //自定义end
        //Remove the menu-open class from the parent
//        ul.removeClass('menu-open');
        //Get the parent li
        var parent_li = $this.parent("li");   //当前li（父级）
     
        //自定义
      	if(!$i.is('.fisrtNav')){
		    if($i.is('.fa-folder')){
		        $i.removeClass("fa-folder").addClass("fa-folder-open folder-open");
		    }else{
		        $i.removeClass("fa-folder-o").addClass("fa-folder-open-o folder-open");
		    }
	    }
      	//自定义end
        //Open the target menu and add the menu-open class
        checkElement.slideDown(0, function() {
	        //Add the class active to the parent li
	        checkElement.addClass('menu-open');
	        var active_li  = $(".sidebar-menu").find("li.active") ;
	        active_li.removeClass("active");
//	        parent.find('li.active').removeClass('active');  //关闭顶层父级ul下面高亮的某一个
	        parent_li.addClass('active');    //给自己的当前li(父级)加上高亮
	        
	    });  
		
		//$this.removeClass("clicked"); //开启导航点击事件
		
    }else if(checkElement.length == 0){  //自定义
    	var parent = $this.parents('ul').first();  //找到顶层父级ul
        //Close all open menus within the parent
//        var ul = parent.find('ul:visible').slideUp(animationSpeed);  //关闭顶层父级ul下面未闭合的菜单
      
        //自定义
//      var i_all = parent.find('i.folder-open');
//      if(i_all.is('.fa-folder-open')){
//	        i_all.removeClass("fa-folder-open folder-open").addClass("fa-folder");
//	    }
        //自定义end
        //Remove the menu-open class from the parent
//        ul.removeClass('menu-open');
        //Get the parent li
        var parent_li = $this.parent("li");   //当前li（父级）
        var active_li  = $(".sidebar-menu").find("li.active") ;
	    active_li.removeClass("active");
//        parent.find('li.active').removeClass('active');  //关闭顶层父级ul下面高亮的某一个
	    parent_li.addClass('active');    //给自己的当前li(父级)加上高亮
		
		//$this.removeClass("clicked"); //开启导航点击事件
		
    } ////自定义end
}
