/**
 * User: Jinqn
 * Date: 14-04-08
 * Time: 下午16:34
 * 上传图片对话框逻辑代码,包括tab: 远程图片/上传图片/在线图片/搜索图片
 */

//获取参数
function GetQueryString(name)
{
     var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
     var r = window.location.search.substr(1).match(reg);
     if(r!=null)return  unescape(r[2]); return null;
}
	
(function () {
    
       console.log(123)
       var ChannelID = GetQueryString("ChannelID");
	document.getElementById("frmMain").src="../h5/ueditor/image/ueditor_image.jsp?ChannelID="+ChannelID;
		
        initTabs();
    

    /* 初始化tab标签 */
    function initTabs() {
        var tabs = $G('tabhead').children;
        for (var i = 0; i < tabs.length; i++) {
            domUtils.on(tabs[i], "click", function (e) {
                var target = e.target || e.srcElement;
                setTabFocus(target.getAttribute('data-content-id'));
            });
        }

 //       var img = editor.selection.getRange().getClosedNode();
 //       if (img && img.tagName && img.tagName.toLowerCase() == 'img') {
 //           setTabFocus('divInternetPhoto');
 //       } else {
 //           setTabFocus('divUploadPhoto');
 //       }
    }
    /* 初始化tabbody */
    function setTabFocus(id) {
        if(!id) return;
        var i, bodyId, tabs = $G('tabhead').children;
        for (i = 0; i < tabs.length; i++) {
            bodyId = tabs[i].getAttribute('data-content-id');
            if (bodyId == id) {
                domUtils.addClass(tabs[i], 'focus');
				window.frames["frmMain"].OnDialogTabChange(bodyId);
				window.frames["frmMain"].document.getElementById(bodyId).style.display='block';
            } else {
                domUtils.removeClasses(tabs[i], 'focus');
				window.frames["frmMain"].document.getElementById(bodyId).style.display='none';
            }
        }
    }
})();
