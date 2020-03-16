$(function() {
	$.browser.chrome = /chrome/.test(navigator.userAgent.toLowerCase());
	if($.browser.mozilla || $.browser.chrome){	
		tidecms.log("o");
		/*$(document).bind("dragenter",function(event) {var files=e.originalEvent.dataTransfer.files;if(files==null || files.length==0) return true;return false; }).bind("dragover", function(event) {
			var files=e.originalEvent.dataTransfer.files;if(files==null || files.length==0) return true;
			event.stopPropagation(); event.preventDefault();return true; })
		*/
		$(document).bind("drop", function(e) { 

		//try{
		var o = null;
		var data = {success:function(o,a){a=$.trim(a);if(a=="") return;var oo = eval("("+a+")");
		if(oo.status==0){alert(oo.message);}
		if(oo.status==1 && oo.message!=""){var fck = parent.getFCK();fck.Focus();fck.InsertHtml(oo.message);}
		}};
		var url = "../content/insertimage_submit.jsp";
		var files=e.originalEvent.dataTransfer.files;
		tidecms.log(files);
		if(files==null || files.length==0) return true;
		var xhr = new XMLHttpRequest();
		xhr.open("POST",url);
		var file = files.item(0);
		var fileName = file.name;  
		var fileSize = file.size;  
		var fileData = "";//file.getAsBinary();
		var boundary = "xxxxxxxxx";
		//xhr.setRequestHeader("Content-Type", "multipart/form-data, boundary="+boundary); // simulate a file MIME POST request.  
		//xhr.setRequestHeader("Content-Length", fileSize);  
		
		var p = '<div class="upload_jdt" style="z-index:999;position:absolute;width:200px"><div id="upload_progress" class="upload_jdt_box" style="width: 0%;"></div></div>';
		$(p).css({left:e.pageX+10,top:e.pageY}).appendTo($("body"));

		var fileUpload = xhr.upload;
		fileUpload.onprogress=function(e){
			var percentage = Math.round((e.loaded * 100) / e.total);
			$("#upload_progress").css("width",percentage+"%");
		};

		fileUpload.onload=function(e){
			$("#upload_progress").css("width","100%").parent().remove();
		};
		
		var f = new FormData();
		f.append("Client","2");
		f.append("ChannelID","4020");
		f.append("file1", file);
		
		var body = '';
		
		for(i in data){
			body += "--" + boundary + "\r\n";  
			body += "Content-Disposition: form-data; name=\""+i+"\"\r\n\r\n";
			body += data[i];
			body += "\r\n"; 
		}
		body += "--" + boundary + "\r\n";  
		body += "Content-Disposition: form-data; name=\"Client\"\r\n\r\n";
		body += "2";
		body += "\r\n"; 

		body += "--" + boundary + "\r\n";  
		body += "Content-Disposition: form-data; name=\""+"file"+"\"; filename=\"" + encodeURIComponent(fileName) + "\"\r\n";  
		body += "Content-Type: application/octet-stream\r\n\r\n";  
		body += fileData + "\r\n";  
		body += "--" + boundary + "--\r\n";

		xhr.onreadystatechange = function (e) {
			if (xhr.readyState == 4) {
			if(xhr.status == 200)
			{
				if(data.success) data.success(o,xhr.responseText);
			}
			}
		};
		//tidecms.log(body);
		//xhr.sendAsBinary(f);
		xhr.send(f);

		e.stopPropagation(); e.preventDefault();
		//}catch(err){e.stopPropagation(); e.preventDefault();}
		return true; 
		})
				
	}
});