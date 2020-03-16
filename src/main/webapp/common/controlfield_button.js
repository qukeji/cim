
var field_all = new Array("tr_juxian_liveid","tr_frame","tr_secondcategory","tr_jumptype","tr_href_app","tr_pdf");
	
var field_1 = new Array("tr_juxian_liveid","tr_frame","tr_secondcategory","tr_pdf","tr_jumptype");//1.2.3.4
var field_2 = new Array("tr_href_app","tr_frame","tr_secondcategory","tr_pdf","tr_jumptype");//5
var field_3 = new Array("tr_href_app","tr_frame","tr_secondcategory","tr_juxian_liveid","tr_jumptype");//6
var field_4 = new Array("tr_juxian_liveid","tr_href_app","tr_pdf","tr_jumptype");//7

$(document).ready(function() {
	
	$("input[name='doc_type']").bind("click",function(){ 
		
		controlField();
	}); 
});
$(function(){
    controlField();
});
function controlField(){
	
	var doc_type = $("input[name='doc_type']:checked").val();
	
	for(var i= 0;i<field_all.length;i++){  
	
		var field = field_all[i];
		
		if(doc_type==0||doc_type==1||doc_type==2||doc_type==3){//图文，视频/直播，图集，专题
			
			isView(field_1,field);
			
		}else if(doc_type==4){//聚现直播
			
			isView(field_2,field);
			
		}else if(doc_type==5){//pdf文档
			
			isView(field_3,field);
			
		}else if(doc_type==6){//App内部跳转
			
			isView(field_4,field);
		}
	}
}
//字段隐藏或显示
function isView(fields,field){
	
	if(contains(fields,field)){
		$("#"+field).css("display","none");
		if(field=="edit"){
			$("."+field).css("display","none");
		}
	}else{
		$("#"+field).css("display","");
		if(field=="edit"){
			$("."+field).css("display","");
		}
	}
	
}
//是否包含
function contains(fields,field){
	var flag = false ;
	
	for(var i= 0;i<fields.length;i++){
		
		if(field==fields[i]){
						
			flag = true;
		}
	}
	return flag ;
}