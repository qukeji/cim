var curFileID=-1;
var curFileName = "";
var selectedElements = new Array();
var curActiveElement;

function selectFile(fileid){

	if (curActiveElement!=null){			//�Ƚ���ǰ��ɫԪ�ص���ʾ��Ϊ����
		curActiveElement.style.color="black";
		curActiveElement.style.background="white";
	 	}

	if (window.event.ctrlKey!=true){	//���û�а���CTRL���Ļ����Ȱ�������ѡԪ�ص�ѡ��״̬���
	 	 for (var i=0;i<selectedElements.length;i++){
		    	document.all[selectedElements[i]].checked=false;
		    }
	}
		
	var cuEl=eval("item"+fileid);		//���µĽڵ�ѡ�У�����ɫ
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
	var FileName = cuEl.filename;
}

function OpenFile(){
	window.open(curFileName);
}

var el;

function showMenu() {
var isLocked=false;

//Ŀ¼����
if (parent.frames["Folder"].curPath==""){
   newFolder.className="menuItemDisable";
   newFile.className="menuItemDisable";
   uploadFile.className="menuItemDisable";
   }
else
	{
   newFolder.className="menuItem";
   newFile.className="menuItem";
   uploadFile.className="menuItem";
   }
   
//�ļ�����
if (curFileID==-1){
	Lock.className="menuItemDisable";
	unLock.className="menuItemDisable";
	fileEdit.className="menuItemDisable";
	notepad.className ="menuitemDisable";
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
	
	//��������
	var statusEl = eval("document.all.status" + curFileID);
	if (statusEl.src.indexOf("ic_lock.gif")!=-1){	//����������
		isLocked = true;
		Lock.className="menuItemDisable";
		unLock.className="menuItemDisable";
		fileEdit.className="menuItemDisable";
		notepad.className = "menuItemDisable";
		delFile.className = "menuItemDisable";
		renameFile.className = "menuItemDisable";
	}
	else{	//���Զ���������ٿ����ޱ�Ҫ����
		notepad.className = "menuItem";
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
		
		//�ļ��༭
		var typeEl = eval("type" + curFileID);
		if (typeEl.innerText!="asp" && typeEl.innerText!="htm" && typeEl.innerText!="html")
			fileEdit.className="menuItemDisable";
		else
			fileEdit.className="menuItem";
	}
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
	
if (top.ReadValue("ClipBoard_Data")==null || top.ReadValue("ClipBoard_Data")==""){
	pasteFile.className = "menuItemDisable";
	}
else{
	pasteFile.className = "menuItem";
	}
   
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
  			f.action="lock.asp";
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
  			f.action="unlock.asp";
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
 		var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
  		var url="editer/edit.asp?" + curFileName;
  		window.open(url,"",Feature);
  	}
}

function doNotepad(){
	if(notepad.className!="menuItemDisable"){
  		var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
  		var url="editer/textedit.asp?" + curFileName;
  		window.open(url,"",Feature);
  	}
}

function doNewFolder(){
	if (newFolder.className!="menuItemDisable"){
 		var Feature = "dialogWidth:32em; dialogHeight:16em;center:yes;status:no;help:no";
		window.showModalDialog("windowframe.asp?loadfile=prenewfolder.asp","�½�Ŀ¼",Feature);
		parent.frames["Folder"].location.reload();
		parent.frames["FileList"].location.reload();
	}
}

function doNewFile(){
	if (newFile.className!="menuItemDisable"){
 		var Feature = "dialogWidth:32em; dialogHeight:16em;center:yes;status:no;help:no";
		window.showModalDialog("windowframe.asp?loadfile=prenewfile.asp","�½��ļ�",Feature);
		parent.frames["FileList"].location.reload();
	}
}

function doUpload(){
	if (uploadFile.className!="menuItemDisable"){
	 	var Feature = "dialogWidth:32em; dialogHeight:18em;center:yes;status:no;help:no";
		window.showModalDialog("windowframe.asp?loadfile=preupload.asp","�ϴ��ļ�",Feature);
		parent.frames["FileList"].location.reload();
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
	window.frames["Download"].location="/tcenter/download.asp?" + curFileName;
}

function windowRefresh(){
		var command = top.ReadValue("ClipBoard_Command");
		
		parent.frames["Folder"].location.reload();
		parent.frames["FileList"].location.reload();
		
		if (command=="Cut"){	//�����ǰ�Ǽ��У�����գ����ǿ��������Խ��ж��
			top.WriteValue("ClipBoard_Data","");
			top.WriteValue("ClipBoard_Type","");
			top.WriteValue("ClipBoard_Command","");
		}

}

function doRenameFile(){
	if (renameFile.className!="menuItemDisable"){
 		var Feature = "dialogWidth:32em; dialogHeight:16em;center:yes;status:no;help:no";
		window.showModalDialog("windowframe.asp?loadfile=prerenamefile.asp","���������ļ�",Feature);
		parent.frames["FileList"].location.reload();
	}
}

function doDelFile(){
if (confirm("���Ҫɾ����?\r\nɾ������ѡ�е��ļ���ɾ�����޷��ָ���\r\n�밴ȷ��ǰ��ϸ����Ƿ��в�Ӧɾ�����ļ���")){
	document.fileform.submit();
	}
return;
}

function doReFresh(){
	parent.frames["FileList"].location.reload();
}
