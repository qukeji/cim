/**
 * Created by JetBrains PhpStorm.
 * User: taoqili
 * Date: 12-2-20
 * Time: 上午11:19
 * To change this template use File | Settings | File Templates
 */

(function(){
    var parent1 = window.parent.document;
    var video = {},
        uploadVideoList = [],
        isModifyUploadVideo = false,
        okClicked = false ,
        uploadFile;
    
    $(function(){
        initTabs();
         
	     //监听确认和取消两个按钮事件，用户执行插入或者清空正在播放的视频实例操作	       
        dialog.onok = function(){
		    if(okClicked){
		       return false ;
		    }
            Ok();
            return false ;
        };
        dialog.oncancel = function(){
            $G("videoUrl").value = "";
            $G("photoUrl").value = "";
            $G("videoWidth").value = "";
            $G("videoHeight").value = "";
        };
    })

    /* 初始化tab标签 */
    function initTabs(){
        var tabs = $G('tabHeads').children;
        for (var i = 0; i < tabs.length; i++) {
            domUtils.on(tabs[i], "click", function (e) {
                var j, bodyId, target = e.target || e.srcElement;
                for (j = 0; j < tabs.length; j++) {
                    bodyId = tabs[j].getAttribute('data-content-id');
                    if(tabs[j] == target){
                        domUtils.addClass(tabs[j], 'focus');
                        domUtils.addClass($G(bodyId), 'focus');
                    }else {
                        domUtils.removeClasses(tabs[j], 'focus');
                        domUtils.removeClasses($G(bodyId), 'focus');
                    }
                }
                okClicked = false ;
            });
        }
    }
   
	
	function Ok(){   
	    okClicked = true ;
	    var _span = $('#tabHeads span.focus') ;
	    var dataid = _span.attr("data-content-id") ;
    	var html="";
        var img = "<img class=\"tide_video_fake\" src=\"../editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";
        if(dataid=="local"){
            $(window.self.document).find("#localvideo")[0].contentWindow.Ok(); 
			return false
        }else if(dataid=="video"){
    		var isCode = false ;
    		var codeValue=  document.getElementById("videoUrl").value;
    		if(!codeValue){
    		   $(parent1).find('.edui-dialog-closebutton div[title="关闭对话框"]').trigger('click')
    		   return false 
    		}
    		var videoUrlValue = document.getElementById("videoUrl").value;
    		var photoUrlValue = document.getElementById("photoUrl").value;
    		var videoWidthValue = document.getElementById("videoWidth").value;
    		var videoHeightValue = document.getElementById("videoHeight").value;
    		videoWidthValue==""?videoWidthValue="100%":videoWidthValue=videoWidthValue+"px";
    		videoHeightValue==""?videoHeightValue="100%":videoHeightValue=videoHeightValue+"px";

			html+= '<div style="width:100%; height:auto;margin:15px auto;" align="center">';
			if(video_type==1){
				html+= '<div id="tide_video"><span hidden="hidden">video</span>';
				html+= '<video src="'+videoUrlValue+'" controls="controls" poster="'+photoUrlValue+'" width="'+videoWidthValue+'" height="'+videoHeightValue+'"></video>';
				html+= '</div>';
			}else{
				html+= '<span id="tide_video">';
				html+= '<script>tide_player.showPlayer({video:"'+videoUrlValue+'",width:"'+videoWidthValue+'",height:"'+videoHeightValue+'",cover:"'+photoUrlValue+'"});<\/script>';
				html+= '</span>';
				html+='<img class="tide_video_fake" src="../editor/images/spacer.gif"  _fckfakelement="true" _fckrealelement="1">';
			}
			html+="</div>"
        }else if(dataid=="upload"){
            /*var obj=window.frames["video"].getRadio();
			if(obj){
			    var  html2 = obj.html;
		    	html = "<div style=\"width:100%; height:auto;margin:15px auto;\" align=\"center\"><span id=\"tide_video\">";
		        html += html2+'<\/span>'+img+'<\/div>'; 
			} */
        }	 

		if(html!=""&&html!== undefined)
		{
			editor.focus();
			editor.execCommand('inserthtml',html);
			//editor.setContent(html,true); 	
		}
		
		$(parent1).find('.edui-dialog-closebutton div[title="关闭对话框"]').trigger('click')
		return true ;
	}

	function unicodeToByte(str)  //将Unicode字符串转换为UCS-16编码的字节数组 
	{  
		var result=[];  
		for(var i=0;i<str.length;i++)  
			result.push(str.charCodeAt(i)>>8,str.charCodeAt(i)&0xff);  
		return result;  
	} 
	//base64编码
	function encodeBase64(str)  
	{  
		var map="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"; //Base64从0到63的对应编码字符集   
		var buffer=0,result="";  
		var arr=unicodeToByte(str);  
		for(var i=0;i<arr.length;i++)  
		{  
			buffer=(buffer<<8)+arr[i];  
			if(i%3==2) //每3个字节处理1次  
			{  
				result+=map.charAt(buffer>>18)+map.charAt(buffer>>12&0x3f)+map.charAt(buffer>>6&0x3f)+map.charAt(buffer&0x3f);  
				buffer=0;  
			}  
		} 
		//3的整数倍的字节已处理完成，剩余的字节仍存放于buffer中  
		if(arr.length%3==1) //剩余1个字节  
			result+=map.charAt(buffer>>2)+map.charAt(buffer<<4&0x3f)+"==";  
		else if(arr.length%3==2) //剩余2个字节  
			result+=map.charAt(buffer>>10)+map.charAt(buffer>>4&0x3f)+map.charAt(buffer<<2&0x3f)+"=";  
		return result;  
	}
})();
