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
		this.fileProgressWrapper = document.createElement("div");
		this.fileProgressWrapper.className = "upload_line";
		this.fileProgressWrapper.id = this.fileProgressID;

		this.fileProgressElement = document.createElement("div");
		this.fileProgressElement.className = "upload_line_box";

		var progressText = document.createElement("div");
		progressText.className = "upload_filename";
		progressText.appendChild(document.createTextNode(file.name));

		var progressBar = document.createElement("div");
		progressBar.className = "upload_jdt";
		
		var progressBar2 = document.createElement("div");
		progressBar2.className = "upload_jdt_box";
		progressBar2.style.width="0%"; 
		progressBar.appendChild(progressBar2);


		var progressStatus = document.createElement("div");
		progressStatus.className = "upload_txt";
		progressStatus.style.display="";
		progressStatus.innerHTML = "&nbsp;";

		this.progressCancel = document.createElement("a");
		this.progressCancel.className = "";
		this.progressCancel.href = "#";
		this.progressCancel.style.visibility="hidden";
		this.progressCancel.innerHTML = "取消上传";
		this.progressCancel.appendChild(document.createTextNode(""));
		
		this.fileProgressElement.appendChild(progressText);
		this.fileProgressElement.appendChild(progressBar);
		this.fileProgressElement.appendChild(progressStatus);
		this.fileProgressElement.appendChild(this.progressCancel);

		this.fileProgressWrapper.appendChild(this.fileProgressElement);

		document.getElementById(targetID).appendChild(this.fileProgressWrapper);
	} else {
		this.fileProgressElement = this.fileProgressWrapper.firstChild;
		this.reset();
	}

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
	this.fileProgressElement.childNodes[1].childNodes[0].style.width = percentage + "%";
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
	this.fileProgressElement.childNodes[3].style.visibility = show ? "visible" : "hidden";
	if(!show){
		//this.fileProgressWrapper.style.visibility = show ? "visible" : "hidden";
		//jQuery(this.fileProgressWrapper).remove();	
	}
	if (swfUploadInstance) {
		var fileID = this.fileProgressID;
		this.fileProgressElement.childNodes[3].onclick = function () {
			swfUploadInstance.cancelUpload(fileID);
			return false;
		};
	}
};

FileProgress.prototype.appear = function () {
	
};

// Fades out and clips away the FileProgress box.
FileProgress.prototype.disappear = function () {

};