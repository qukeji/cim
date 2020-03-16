;$(function(){
	try{
		if(baoliao_userid){
			getBaoliaoInfo();
		}
	}catch (e){}
	
	function getBaoliaoInfo(){
		$.ajax({
            url:"/apiv3.6.0/topic_other_info.php",
            type:"get",
            data:{
        	session : getUserQuery()['session'],
        	userid : baoliao_userid ,
        	site : siteId
             },
            dataType:"jsonp",
            success:function(data){
                var baoliaoHtml ="" ;
                baoliaoHtml += '<div class="baoliao_info">\
							    <div class="baoliao_left">\
							        <div class="baoliao-img-box">\
							            <img src="'+data.result.avatar+'">\
							        </div>\
							        <div class="baoliao_name">\
							            <p class="b_name">'+data.result.name+'</p>\
							            <p class="b_area"><span class="area-icon"></span>'+baoliao_localtion+'</p>\
							        </div>\
							    </div>\
							    <div class="baoliao_right">' ;
							    
			    if(baoliaostatus==0){
			    	baoliaoHtml += '<p  class="sh_status shz"><span>•</span>审核中</p>'
			    }else if(baoliaostatus==1){
			    	baoliaoHtml += '<p  class="sh_status ysh"><span>•</span>已通过</p>'
			    }else if(baoliaostatus==2){
			    	baoliaoHtml += '<p  class="sh_status wtg"><span>•</span>未通过</p>'
			    }
				baoliaoHtml +='</div></div>'			        
				$(".data").after(baoliaoHtml)			    
							
            }
         });
	}
})
