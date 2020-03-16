FCKDialogCommand.prototype.Execute=function(){/*modify by liyonghai 20080610*/
if(this.Name=="Image" || this.Name=="Flash" || this.Name=="Video" || this.Name=="TideVideo" || this.Name=="TidePhoto2")
{
	//图片，Flash，视频，图片集，都弹出窗口
	FCKDialog.OpenDialog('FCKDialog_'+this.Name,this.Title,this.Url+"?ChannelID="+parent.ChannelID,this.Width,this.Height,this.CustomValue,null,this.Resizable);
}else if(this.Name=="ImgEditor")
{

		var img = "";
		var oFakeImage=FCKSelection.GetSelectedElement();//获取选中元素
		if ( oFakeImage )
		{
			if ( oFakeImage.tagName == 'IMG'  )
			{
				/*
				var o =	FCK.GetRealElement(oFakeImage);
					if(o)
					{
						//pid=o.getAttribute("photoid");
						img = o.getAttribute("src");
					}*/
					//img = o.getAttribute("src");
					img = oFakeImage.src;
			}
			
		FCKDialog.OpenDialog('FCKDialog_'+this.Name,this.Title,this.Url+"?img="+img+"&ChannelID="+parent.ChannelID,this.Width,this.Height,this.CustomValue,null,this.Resizable);
		}
		else
		{
			alert("请选择图片");
		}


}
else if(this.Name=="TidePhoto"){var pid = 0;var oFakeImage=FCKSelection.GetSelectedElement();if ( oFakeImage ){if ( oFakeImage.tagName == 'IMG' && oFakeImage.className== 'FCK__TidePhoto' ){var o = FCK.GetRealElement(oFakeImage);if(o){pid=o.getAttribute("photoid")}}}var argu = "dialogWidth:60em; dialogHeight:30em;center:yes;status:no;help:no";var retu=window.showModalDialog("../../modal_dialog.jsp?target=editor/tidephoto_add.jsp&ItemID="+pid,null,argu);if (retu!=null){FCK.InsertHtml(retu);}}
else if(this.Name=="TidePhoto2"){var pid = 0;var oFakeImage=FCKSelection.GetSelectedElement();if ( oFakeImage ){if ( oFakeImage.tagName == 'IMG' && oFakeImage.className== 'FCK__TidePhoto' ){var o = FCK.GetRealElement(oFakeImage);if(o){pid=o.getAttribute("photoid");}}}
//window.open("../photo/document_photo.jsp?ItemID="+pid+"&ChannelID=6640");
top.insert_photos();
}
else{FCKDialog.OpenDialog('FCKDialog_'+this.Name,this.Title,this.Url,this.Width,this.Height,this.CustomValue,null,this.Resizable);}};