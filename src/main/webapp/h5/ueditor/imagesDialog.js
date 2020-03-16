UE.registerUI('dialog3',function(editor,uiName1){

    //创建dialog
    var dialog = new UE.ui.Dialog({
        //指定弹出层中页面的路径，这里只能支持页面,因为跟addCustomizeDialog.js相同目录，所以无需加路径
        iframeUrl:'ueditor/image/image.html?ChannelID='+parent.ChannelID,
        //需要指定当前的编辑器实例
        editor:editor,
        //指定dialog的名字
        name:uiName1,
		id:"tide_images",
        //dialog的标题
        title:"图片上传",

        //指定dialog的外围样式
        cssRules:"width:820px;height:460px;",

        //如果给出了buttons就代表dialog有确定和取消
        buttons:[
            {
                className:'edui-okbutton',
                label:'确定',
                onclick:function () {
					if(window.frames["tide_images_iframe"].contentWindow){
                       var frmMain = window.frames["tide_images_iframe"].contentWindow.frames["frmMain"];
                    }else{
                       var frmMain = window.frames["tide_images_iframe"].window.frames["frmMain"];
                    }
					if ( frmMain.Ok && frmMain.Ok() ){
						dialog.close(true);
					}else{
						frmMain.focus();
					}
					
                }
            },
            {
                className:'edui-cancelbutton',
                label:'取消',
                onclick:function () {
                    dialog.close(false);
                }
            }
        ]});

    //参考addCustomizeButton.js
    var btn = new UE.ui.Button({
        name:'insert-images',
        title:'图片上传',
        //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon       
        cssRules :'background-position: 0 -450px;background-image: url(ueditor/utf8-php/themes-custom/default/icon/tool-0201.png) !important;',
        //cssRules :'background-position: -726px -77px;',
        onclick:function () {
            //渲染dialog
            dialog.render();
            dialog.open();
        }
    });
   

    return btn;
},[20]/*index 指定添加到工具栏上的那个位置，默认时追加到最后,editorId 指定这个UI是那个编辑器实例上的，默认是页面上所有的编辑器都会添加这个按钮*/);


