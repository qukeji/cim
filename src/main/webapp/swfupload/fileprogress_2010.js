/*
	A simple class for displaying file information and progress
	Note: This is a demonstration only and not part of SWFUpload.
	Note: Some have had problems adapting this class in IE7. It may not be suitable for your application.
*/

// Constructor
// file is a SWFUpload file object
// targetID is the HTML element id attribute that the FileProgress HTML structure will be added to.
// Instantiating a new FileProgress object with an existing file will reuse/update the existing DOM elements
function FileProgress(file, targetID) {
	this.fileProgressID = file.id;

	this.opacity = 100;
	this.height = 0;

	this.fileProgressWrapper = document.getElementById(this.fileProgressID);
	if (!this.fileProgressWrapper) {
		//var v = file.modificationdate;
		//var dates = v.getFullYear()+"-"+(v.getMonth() + 1)+"-"+v.getDate()+" "+v.getHours()+":"+v.getMinutes();
		var html = "<tr id='"+file.id+"'><td>"+file.name+"</td>";
		html += '<td><div style="width: 0%;" class="upload_jdt_box"></div></td>';
		html += "<td>"+Math.round(file.size/1024)+" KB</td>";
		html += "<td><a href='javascript:cancelFile(\""+file.id+"\");'><img src='../images/inner_menu_del.gif'></a></td>";
		html += "</tr>";
		$("#fsUploadProgress").append(html);
	} else {
		this.reset();
	}

	this.fileProgressWrapper = document.getElementById(this.fileProgressID);
	//alert(this.fileProgressWrapper);
	this.fileProgressElement = this.fileProgressWrapper.childNodes[1];
	//alert(this.fileProgressElement);
	//this.height = this.fileProgressWrapper.offsetHeight;
	//this.setTimer(null);
}

FileProgress.prototype.setTimer = function (timer) {
	this.fileProgressElement["FP_TIMER"] = timer;
};
FileProgress.prototype.getTimer = function (timer) {
	return this.fileProgressElement["FP_TIMER"] || null;
};

FileProgress.prototype.reset = function () {
	//jQuery(this.fileProgressWrapper).remove();	
	//this.fileProgressElement.className = "progressContainer";

	///this.fileProgressElement.childNodes[2].innerHTML = "&nbsp;";
	//this.fileProgressElement.childNodes[2].className = "progressBarStatus";
	
	//this.fileProgressElement.childNodes[3].className = "progressBarInProgress";
	//this.fileProgressElement.childNodes[3].style.width = "0%";
		
};

FileProgress.prototype.setProgress = function (percentage) {
	this.fileProgressElement.childNodes[0].style.width = percentage + "%";
	//this.appear();	
};
FileProgress.prototype.setComplete = function () {
	//this.fileProgressElement.className = "progressContainer blue";
	//this.fileProgressElement.childNodes[3].className = "progressBarComplete";
	//this.fileProgressElement.childNodes[3].style.width = "";
};
FileProgress.prototype.setError = function () {
	jQuery(this.fileProgressWrapper).remove();
	//this.fileProgressElement.childNodes[2].childNodes[0].style.width = percentage + "%";
	//this.fileProgressElement.childNodes[3].innerHTML ="上传出错";
};
FileProgress.prototype.setCancelled = function () {
	//this.fileProgressElement.className = "progressContainer";
	//this.fileProgressElement.childNodes[3].className = "progressBarError";
	///this.fileProgressElement.childNodes[3].style.width = "";
};
FileProgress.prototype.setStatus = function (status) {
	this.fileProgressElement.childNodes[2].innerHTML = status;
};

// Show/Hide the cancel button
FileProgress.prototype.toggleCancel = function (show, swfUploadInstance) {

};

FileProgress.prototype.appear = function () {
	
};

// Fades out and clips away the FileProgress box.
FileProgress.prototype.disappear = function () {

};