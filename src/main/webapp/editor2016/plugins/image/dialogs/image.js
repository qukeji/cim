/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.dialog.add( 'image', function( editor ) {
	var lang = editor.lang.about;
	var imagePath = "";

	return {
		title: '图片',
		minWidth: 650,
		minHeight: 400,
		onOk: function() {
			//alert(window.frames["iframe_image"]);
			window.frames["iframe_image"].startSWFU_(channelid);
			return true;
		},
		onShow: function() {
		},
		contents: [
            {
			id: 'tab1',
			label: '上传图片',
			title: '上传图片',
			elements: [
				{
					type: 'html',
					html: '<iframe name="iframe_image" src="../editor2016/image_upload.jsp" style="width:600px;height:300px"></iframe>'
				}
			]
			},{
			id: 'tab2',
			label: '图片库',
			title: '图片库',
			elements: [
				{
					type: 'html',
					html: 'bbb'
				}
			]
			}],
		buttons: [ CKEDITOR.dialog.okButton,CKEDITOR.dialog.cancelButton]
	};
} );

