//UE.registerUI('dialog2',function(editor,uiName1){
//	
//	var url = '';
//	
//	//参考addCustomizeButton.js
//  var btn = new UE.ui.Button({
//      name:'imgeditor',
//      title:'图片编辑',
//      //需要添加的额外样式，指定icon图标，这里默认使用一个重复的icon
//		
//		//cssRules :'background-position: 2px 2px;background-image: url("../ueditor/themes/default/images/imgeditor.gif")!important;background-repeat: no-repeat;',
//      cssRules :'background-size: 1000px 120px;background-position: -582px -40px;background-image: url("../ueditor/themes/default/images/icons.svg")!important;background-repeat: no-repeat;',
//      onclick:function () {
//			var range = editor.selection.getRange();
//			if (!range.collapsed) {
//				var img = range.getClosedNode();
//				if (img && img.tagName == 'IMG') {
//					url = '../ueditor/imgeditor.html?img='+img.src+'&ChannelID='+parent.ChannelID;
//					//渲染dialog
//					dialog.iframeUrl=url;
//					dialog.render();
//					dialog.open();
//				}else{
//					alert("请选择图片");
//				}
//			}else{
//				alert("请选择图片");
//			}
//      }
//  });
//  
//  //创建dialog
//  var dialog = new UE.ui.Dialog({
//      //指定弹出层中页面的路径，这里只能支持页面
//      iframeUrl:url,
//      //需要指定当前的编辑器实例
//      editor:editor,
//      //指定dialog的名字
//      name:uiName1,
//		id:"tide_imgeditor",
//      //dialog的标题
//      title:"图片编辑",
//
//      //指定dialog的外围样式
//      cssRules:"width:970px;height:600px;",
//
//      //如果给出了buttons就代表dialog有确定和取消
//      buttons:[
//          {
//              className:'edui-okbutton',
//              label:'确定',
//              onclick:function () {
//					var img = editor.selection.getRange().getClosedNode();
//					//var obj=window.frames["tide_imgeditor_iframe"].contentWindow.frames["imgeditor"];
//					if(window.frames["tide_imgeditor_iframe"].contentWindow){
//					   var obj= window.frames["tide_imgeditor_iframe"].contentWindow.frames["imgeditor"];
//					}else{
//					   var obj= window.frames["tide_imgeditor_iframe"].window.frames["imgeditor"];
//					}
//					obj.save();
//					img.src=$("#image_src", obj.document).val()+"?"+Math.random();
//					img.setAttribute("_src",$("#image_src", obj.document).val());
//					dialog.close(true);
//              }
//          },
//          {
//              className:'edui-cancelbutton',
//              label:'取消',
//              onclick:function () {
//                  dialog.close(false);
//              }
//          }
//      ]
//	});   
//	return btn;
//},[54]/*index 指定添加到工具栏上的那个位置，默认时追加到最后,editorId 指定这个UI是那个编辑器实例上的，默认是页面上所有的编辑器都会添加这个按钮*/);
