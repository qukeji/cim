/**改变每页显示*/
function changeRowsPerPage(id)
{
	var value=$("#"+id).val();
	var exp  = new Date();
	exp.setTime(exp.getTime() + 300*24*60*60*1000);
	document.cookie = id+"="+value;
	jumpUrl(id,value);
}

/*******翻页使用********/
function jumpUrl(id,value){
	var pathname=location.pathname;
	var search=location.search;
	var reg_str='(('+id+'=\\d+)|(&'+id+'=\\d+))';
	var reg=new RegExp(reg_str,"gi");
	var ss=search.replace(reg,"");
	var href=pathname+ss;
	if(href.indexOf('?')!=-1){
		href+="&"+id+"="+value;
	}else{
		href+="?"+id+"="+value;
	}
	document.location.href=href;
}

function GoPage(id,totalPageNumber,currPage){
	var page=jQuery("#"+id).val();
	page=parseInt(page,10);
	if(isNaN(page)){
		alert('请输入数字!');
		return;
	}
	if(page<1 ||page>totalPageNumber){
		alert('请输入1-'+totalPageNumber+'之间的数!');
		return;
	}
	jumpUrl(currPage,page);
}

function getCommentCount(pre,ids){
		var url ="getCommentCount.jsp?ids="+ids+"&random="+Math.random();
		jQuery.ajax({
				  type:"GET",
				  url:url,
				  dataType:"json",
				  global:false, 
				  success: function(json){
					for(var i=0;i<json.length;i++){
						var id=pre+json[i].id;
						var count=json[i].count;
						jQuery("#"+id).html(count);
					}
				  } 
		});
}