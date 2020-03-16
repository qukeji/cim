var curFileID=-1;
var curFileName = "";
var selectedElements = new Array();
var curActiveElement;

function selectFile(fileid){

	if (curActiveElement!=null){			//先将当前反色元素的显示规为正常
		curActiveElement.style.color="black";
		curActiveElement.style.background="white";
	 	}

	if (window.event.ctrlKey!=true){	//如果没有按下CTRL键的话，先把所有已选元素的选中状态清除
	 	 for (var i=0;i<selectedElements.length;i++){
		    	document.all[selectedElements[i]].checked=false;
		    }
	}
		
	var cuEl=eval("item"+fileid);		//将新的节点选中，并反色
	cuEl.style.color="white";
	cuEl.style.background="blue";
	curActiveElement = cuEl;
	var sitem = document.all["select" + fileid];
	sitem.checked = true;
	
	var alsoChecked = -1;
	for (var i=0;i<selectedElements.length;i++){
		if (selectedElements[i] == sitem.id)
			alsoChecked = i;
		}
	
	if (alsoChecked==-1){
		selectedElements[selectedElements.length]=sitem.id;
		}
	
	curFileID = fileid;
//	var currentPath = top.ReadValue("currentPath");
//	var FileName = cuEl.filename;
//	curFileName = unescape(currentPath) + FileName;
//	top.WriteValue("curFileName",curFileName);
}

function OpenFile(){
	window.open(curFileName);
}

var el;

function showMenu() {
var isLocked=false;

//目录操作
/*
if (parent.frames["FolderList"].currentPath==""){
   newFolder.className="menuItemDisable";
   newFile.className="menuItemDisable";
   uptarget.className="menuItemDisable";
   }
else
	{
   newFolder.className="menuItem";
   newFile.className="menuItem";
   uptarget.className="menuItem";
   }
*/   
//文件操作
if (curFileID==-1){
	Lock.className="menuItemDisable";
	unLock.className="menuItemDisable";
	fileEdit.className="menuItemDisable";
	notepad.className ="menuitemDisable";
	applyTemplate.className = "menuitemDisable";
	renameFile.className="menuItemDisable";
	downloadFile.className="menuItemDisable";
	preview.className = "menuItemDisable";
	delFile.className = "menuItemDisable";
	}
else
	{
	renameFile.className="menuItem";
	downloadFile.className="menuItem";
	preview.className="menuItem";

/*
	//应用模板，如果在模板目录，则不许应用其他模板
	if (parent.frames["FolderList"].currentPath.toLowerCase()=="/templates/"){
   	applyTemplate.className="menuItemDisable";
   	}
	else
   	{
   	applyTemplate.className="menuItem";
   	}
*/
/*
	//锁定操作
	var statusEl = eval("document.all.status" + curFileID);
	if (statusEl.src.indexOf("ic_lock.gif")!=-1){	//别人锁定的
		isLocked = true;
		Lock.className="menuItemDisable";
		unLock.className="menuItemDisable";
		fileEdit.className="menuItemDisable";
		notepad.className = "menuItemDisable";
		applyTemplate.className = "menuItemDisable";
		delFile.className = "menuItemDisable";
		renameFile.className = "menuItemDisable";
	}
	else{	//可以对其操作，再看有无必要解锁
		notepad.className = "menuItem";
		applyTemplate.className = "menuItem";
		delFile.className = "menuItem";
		renameFile.className = "menuItem";

		if (statusEl.src.indexOf("ic_lockuser.gif")!=-1)
			Lock.className="menuItemDisable";
		else
			Lock.className="menuItem";
			
		if (statusEl.src.indexOf("white.gif")!=-1)
			unLock.className="menuItemDisable";
		else
			unLock.className="menuItem";
		
		//文件编辑
		var typeEl = eval("type" + curFileID);
		if (typeEl.innerText!="asp" && typeEl.innerText!="htm" && typeEl.innerText!="html")
			fileEdit.className="menuItemDisable";
		else
			fileEdit.className="menuItem";
	}
*/
}


	
//CLIPBOARD
if (curFileID==-1){
	cutFile.className = "menuItemDisable";
	copyFile.className = "menuItemDisable";
	}
else{
	if (isLocked)
		cutFile.className = "menuItemDisable";
	else
		cutFile.className = "menuItem";

	copyFile.className = "menuItem";
	}

	/*
if (top.ReadValue("ClipBoard_Data")==null || top.ReadValue("ClipBoard_Data")==""){
	pasteFile.className = "menuItemDisable";
	}
else{
	pasteFile.className = "menuItem";
	}
	*/
   
   ContextElement=event.srcElement;

   var rightedge=document.body.clientWidth-event.clientX;
   var bottomedge=document.body.clientHeight-event.clientY;

   if (rightedge<menu1.offsetWidth)
     menu1.style.posLeft = document.body.scrollLeft + event.clientX - menu1.offsetWidth;
   else
     menu1.style.posLeft = document.body.scrollLeft + event.clientX;
   if (bottomedge<menu1.offsetHeight)
     menu1.style.posTop = event.clientY+document.body.scrollTop-menu1.offsetHeight;
   else
     menu1.style.posTop = event.clientY+document.body.scrollTop;

   menu1.className = "menushow";
   menu1.setCapture();
}
function toggleMenu() {   
   el=event.srcElement;
   if (el.className=="menuItem") {
      el.className="highlightItem";
   } else if (el.className=="highlightItem") {
      el.className="menuItem";
   }
}
function clickMenu() {
   menu1.releaseCapture();
   menu1.className = "menu";
   //menu1.style.display="none";
   el=event.srcElement;
   if (el.doFunction != null) {
     eval(el.doFunction);
   }
}

function doLock(){
	if (Lock.className!="menuItemDisable"){
		try{
			var statusEl = eval("document.all.status" + curFileID);
	  		var f = window.frames["postFrame"].document.postForm;
  			f.action="lock.jsp";
			f.submit();
			statusEl.src="images/ic_lockuser.gif";
		}catch(exception){}
	}
}


function doUnLock(){
	if (unLock.className!="menuItemDisable"){
		try{
			var statusEl = eval("document.all.status" + curFileID);
	  		var f = window.frames["postFrame"].document.postForm;
  			f.action="unlock.jsp";
			f.submit();
			statusEl.src="images/white.gif";
		}catch(exception){}
	}
}

function doFileEdit(){
	if(fileEdit.className!="menuItemDisable"){
  		var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		var parameter = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
  		var url="editer/edit.jsp?" + curFileName;
  		window.open(url,"",parameter);
  	}
}

function doNotepad(){
	if(notepad.className!="menuItemDisable"){
  		var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		var parameter = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
  		var url="editer/textedit.jsp?" + curFileName;
  		window.open(url,"",parameter);
  	}
}

function doApplyTemplate(){
	if(applyTemplate.className!="menuItemDisable"){
 		var parameter = "dialogWidth:32em; dialogHeight:16em;center:yes;status:no;help:no";
		window.showModalDialog("modal_dialog.jsp?target=preapplytemplate.jsp","应用模板",parameter);
		parent.frames["File"].location.reload();
	}
}

function doNewFolder(){
	if (newFolder.className!="menuItemDisable"){
 		var parameter = "dialogWidth:32em; dialogHeight:16em;center:yes;status:no;help:no";
		window.showModalDialog("modal_dialog.jsp?target=prenewfolder.jsp","新建目录",parameter);
		parent.frames["Folder"].location.reload();
		parent.frames["File"].location.reload();
	}
}

function NewFile(){
	if (newFile.className!="menuItemDisable"){
 		var parameter = "dialogHeight:16em;dialogWidth:32em;center:yes;status:no;help:no";
		window.showModalDialog("modal_dialog.jsp?target=newfile.jsp",myObject,parameter);
		parent.frames["File"].location.reload();
	}
}

function doUpload(){
	if (uptarget.className!="menuItemDisable"){
	 	var parameter = "dialogWidth:32em; dialogHeight:18em;center:yes;status:no;help:no";
		window.showModalDialog("modal_dialog.jsp?target=preupload.jsp","上传文件",parameter);
		parent.frames["File"].location.reload();
	}
}

function doCutFile(){
	if (cutFile.className!="menuItemDisable"){
		top.WriteValue("ClipBoard_Data",curFileName);
		top.WriteValue("ClipBoard_Command","Cut");
	}
}

function doCopyFile(){
	if (copyFile.className!="menuItemDisable"){
		top.WriteValue("ClipBoard_Data",curFileName);
		top.WriteValue("ClipBoard_Command","Copy");
	}
}

function doPasteFile(){
	if (pasteFile.className!="menuItemDisable"){
		var src = top.ReadValue("ClipBoard_Data");
		var command = top.ReadValue("ClipBoard_Command");
		if (src=="" || command==""){return;}
  		
  		var f = window.frames["postFrame"].document.postForm;
		f.submit();
		
		window.setTimeout("windowRefresh();",2000);
	}
}

function doDownload(){
	window.frames["Download"].location="/tcenter/download.jsp?" + curFileName;
}

function windowRefresh(){
		var command = top.ReadValue("ClipBoard_Command");
		
		parent.frames["Folder"].location.reload();
		parent.frames["File"].location.reload();
		
		if (command=="Cut"){	//如果先前是剪切，则清空，如是拷贝，可以进行多次
			top.WriteValue("ClipBoard_Data","");
			top.WriteValue("ClipBoard_Type","");
			top.WriteValue("ClipBoard_Command","");
		}

}

function doRenameFile(){
	if (renameFile.className!="menuItemDisable"){
 		var parameter = "dialogWidth:32em; dialogHeight:16em;center:yes;status:no;help:no";
		window.showModalDialog("modal_dialog.jsp?target=prerenamefile.jsp","重新命名文件",parameter);
		parent.frames["File"].location.reload();
	}
}

function doDelFile(){
if (confirm("真的要删除吗?\r\n删除所有选中的文件，删除后无法恢复。\r\n请按确认前仔细检查是否有不应删除的文件。")){
	document.fileform.submit();
	}
return;
}

function doReFresh(){
	parent.frames["File"].location.reload();
}

function viewSource()
{
	location.replace("view-source:"+location);
}