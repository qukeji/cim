
//设置导航高亮
$(function(){

	if(dir=="template"||dir=="user"||dir=="public"){
		
		$(".menu-system").addClass("active");
	}else{

		$(".menu-"+dir).addClass("active");

	}
});

$.sidebarMenu = function(menu) {
  var animationSpeed = 300;
  
  $(menu).on('click', 'li a', function(e) {
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
			$this.attr("load",0);//加载完毕改变load属性
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


function sidebarMenu_show(checkElement,animationSpeed,$this)
{

    if (checkElement.is('.treeview-menu') && checkElement.is(':visible')) {
      checkElement.slideUp(animationSpeed, function() {
        checkElement.removeClass('menu-open');
      });
      checkElement.parent("li").removeClass("active");
    }

    //If the menu is not visible
    else if ((checkElement.is('.treeview-menu')) && (!checkElement.is(':visible'))) {
      //Get the parent menu
      var parent = $this.parents('ul').first();
      //Close all open menus within the parent
      var ul = parent.find('ul:visible').slideUp(animationSpeed);
      //Remove the menu-open class from the parent
      ul.removeClass('menu-open');
      //Get the parent li
      var parent_li = $this.parent("li");

      //Open the target menu and add the menu-open class
      checkElement.slideDown(animationSpeed, function() {
        //Add the class active to the parent li
        checkElement.addClass('menu-open');
        parent.find('li.active').removeClass('active');
        parent_li.addClass('active');
      });
    }
}