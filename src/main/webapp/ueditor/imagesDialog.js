
UE.registerUI('button1',function(editor,uiName1){
    var btn = new UE.ui.Button({
        name:'tcenter_video',
        title:'视频上传',
        //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
        cssRules :'background-position: -320px -20px;background-image: url("../ueditor/themes/default/images/icons.png");',
        onclick:function () {
            var content = getContent() ;
            var url = '../ueditor/dialogs/video/video.jsp' ;       
		  	var	dialog = new top.TideDialog();
				dialog.setWidth(900);
				dialog.setHeight(650);
				dialog.setUrl(url);
				dialog.setTitle('视频上传');				
				dialog.show();            
        }
    });
    return btn;
},[54]);
//图片上传
UE.registerUI('button2',function(editor,uiName1){
    var btn = new UE.ui.Button({
        name:'tcenter_images',
        title:'图片上传',
        //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
        cssRules :'background-position: -726px -77px;background-image: url("../ueditor/themes/default/images/icons.png");',
        onclick:function () {
            var content = getContent() ;
            var url = '../ueditor/dialogs/image/image.jsp?ChannelID='+parent.ChannelID ;       
		  	var	dialog = new top.TideDialog();
				dialog.setWidth(900);
				dialog.setHeight(650);
				dialog.setUrl(url);
				dialog.setTitle('图片上传');				
				dialog.show();            
        }
    });
    return btn;
},[55]);

var excludeSpecial = function(s) {  
    S
    s = s.replace(/\\/g, "");  
    return s;  
 }; 
;$(function(){
	try{
		if(ue){
			ue.addListener('afterpaste', ue_afterpaste);
			ue.addListener('beforepaste', ue_beforepaste);
		}
	}catch(err){
		console.log(err)
	}
	 
})
function ue_beforepaste(o, _html) {
	var _str = "crossorigin=\"anonymous\"" ;
	if(_html.html.indexOf(_str)!= -1 ){
		_html.html = _html.html.replace(_str,"") ;
	}
}
function ue_afterpaste(o, _html) {
	//console.log(_html.html)
	try{
		if( eci == 1 &&  _html.html.indexOf('<img') !=-1 ){
			autoLocalImg();
		}
	}catch(e){
		console.log(e)
	}
	function autoLocalImg(){
		var url = "../ueditor/dialogs/image/imglocal.html?autolocal=1";
		var	dialog = new top.TideDialog();
			dialog.setWidth(900);
			dialog.setHeight(620);
			dialog.setUrl(url);
			dialog.setTitle('图片本地化');				
			dialog.show();    
	}
	
	//html.html = "" ;
}
//图片本地化按钮
UE.registerUI('button3',function(editor,uiName1){
    //参考addCustomizeButton.js
    var btn = new UE.ui.Button({
        name:'imglocal',
        title:'图片本地化',
        //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
        cssRules :'background-position: -680px -40px;background-image: url("../ueditor/themes/default/images/icons.png");',
        onclick:function () {
			
			var url = "../ueditor/dialogs/image/imglocal.html?autolocal=0";
			var	dialog = new top.TideDialog();
				dialog.setWidth(900);
				dialog.setHeight(620);
				dialog.setUrl(url);
				dialog.setTitle('图片本地化');				
				dialog.show();    
        }
    });

    return btn;
},[56]);


//图片编辑按钮
UE.registerUI('button5',function(editor,uiName1){
    //参考addCustomizeButton.js
    var btn = new UE.ui.Button({
        name:'imgedit',
        title:'图片编辑',
        //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
        cssRules :'background-position: -582px -40px;background-image: url("../ueditor/themes/default/images/icons.png");',
        onclick:function () {
            var range = editor.selection.getRange();
            var	dialog = new top.TideDialog();
	    	
            if (!range.collapsed) {
				var img = range.getClosedNode();
				if (img && img.tagName == 'IMG') {
					var url = "../photo/image_deal_online_editor.jsp?ChannelID=" + parent.ChannelID +"&img=" + img.src;
				  	var	dialog = new top.TideDialog();
						dialog.setWidth(1000);
						dialog.setHeight(620);
						dialog.setUrl(url);
						dialog.setTitle('图片编辑');				
						dialog.show();            
					
				}else{
					dialog.showAlert( "请选择图片进行编辑！","danger");
				}
			}else{
				dialog.showAlert( "请选择图片！","danger");
			}
           	
        }
    });

    return btn;
},[57]);


//清除格式按钮
/*
*
UE.registerUI('button2',function(editor,uiName1){

    //参考addCustomizeButton.js
    var btn = new UE.ui.Button({
        name:'removestyle',
        title:'清除格式',
        //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
        cssRules :'background-position: -580px 0px;background-image: url("../ueditor/themes/default/images/icons.png");',
        onclick:function () {
            var content = getContent().toString() ;
            var reg = /style\s*?=\s*?(['"])[\s\S]*?\1/g;
            content = content.replace( reg , "").replace(/<strong.*?>|<\/strong>/ig,"");  //去除行内样式，去除strong标签
			setContent(content, false);
			
        }
    });

    return btn;
},[13]);

*
*/


//智能校对按钮
UE.registerUI('button4',function(editor,uiName1){
    var btn = new UE.ui.Button({
        name:'aiCorrect',
        title:'智能校对',
        //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
        cssRules :'background-position: -422px -20px;background-image: url("../ueditor/themes/default/images/icons.png");',
        onclick:function () {
            var content = getContent() ;
            var url = "../ueditor/aiCorrect.html";          
		  	var	dialog = new top.TideDialog();
				dialog.setWidth(430);
				dialog.setHeight(330);
				dialog.setUrl(url);
				dialog.setTitle('校对结果');				
				dialog.show();            
        }
    });
    return btn;
},[185]);




/**
 * 秀米编辑器
 */
UE.registerUI('dialog', function (editor, uiName) {
    var btn = new UE.ui.Button({
        name   : 'xiumi-connect',
        title  : '秀米',
        onclick: function () {
            var dialog = new UE.ui.Dialog({
                iframeUrl: '../ueditor/xiumi/xiumi-ue-dialog-v5.html',
                editor   : editor,
                name     : 'xiumi-connect',
                title    : "秀米图文消息助手",
                cssRules : "width: " + (window.innerWidth - 100) + "px;" + "height: " + (window.innerHeight - 100) + "px;",
            });
            dialog.render();
            dialog.open();
        }
    });
    return btn;
});
