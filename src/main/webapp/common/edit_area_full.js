 function EAL(){var t=this;t.version="0.8.2";date=new Date();t.start_time=date.getTime();t.win="loading";t.error=false;t.baseURL="";t.template="";t.lang={};t.load_syntax={};t.syntax={};t.loadedFiles=[];t.waiting_loading={};t.scripts_to_load=[];t.sub_scripts_to_load=[];t.syntax_display_name={'basic':'Basic','brainfuck':'Brainfuck','c':'C','coldfusion':'Coldfusion','cpp':'CPP','css':'CSS','html':'HTML','java':'Java','js':'Javascript','pas':'Pascal','perl':'Perl','php':'Php','python':'Python','robotstxt':'Robots txt','ruby':'Ruby','sql':'SQL','tsql':'T-SQL','vb':'Visual Basic','xml':'XML'};t.resize=[];t.hidden={};t.default_settings={debug:false,smooth_selection:true,font_size:"10",font_family:"monospace",start_highlight:false,toolbar:"search,go_to_line,fullscreen,|,undo,redo,|,select_font,|,change_smooth_selection,highlight,reset_highlight,word_wrap,|,help",begin_toolbar:"",end_toolbar:"",is_multi_files:false,allow_resize:"both",show_line_colors:false,min_width:400,min_height:125,replace_tab_by_spaces:false,allow_toggle:true,language:"en",syntax:"",syntax_selection_allow:"basic,brainfuck,c,coldfusion,cpp,css,html,java,js,pas,perl,php,python,ruby,robotstxt,sql,tsql,vb,xml",display:"onload",max_undo:30,browsers:"known",plugins:"",gecko_spellcheck:false,fullscreen:false,is_editable:true,cursor_position:"begin",word_wrap:false,autocompletion:false,load_callback:"",save_callback:"",change_callback:"",submit_callback:"",EA_init_callback:"",EA_delete_callback:"",EA_load_callback:"",EA_unload_callback:"",EA_toggle_on_callback:"",EA_toggle_off_callback:"",EA_file_switch_on_callback:"",EA_file_switch_off_callback:"",EA_file_close_callback:""};t.advanced_buttons=[ ['new_document','newdocument.gif','new_document',false],['search','search.gif','show_search',false],['go_to_line','go_to_line.gif','go_to_line',false],['undo','undo.gif','undo',true],['redo','redo.gif','redo',true],['change_smooth_selection','smooth_selection.gif','change_smooth_selection_mode',true],['reset_highlight','reset_highlight.gif','resync_highlight',true],['highlight','highlight.gif','change_highlight',true],['help','help.gif','show_help',false],['save','save.gif','save',false],['load','load.gif','load',false],['fullscreen','fullscreen.gif','toggle_full_screen',false],['word_wrap','word_wrap.gif','toggle_word_wrap',true],['autocompletion','autocompletion.gif','toggle_autocompletion',true] ];t.set_browser_infos(t);if(t.isIE>=6||t.isGecko||(t.isWebKit&&!t.isSafari<3)||t.isOpera>=9||t.isCamino)t.isValidBrowser=true;
else t.isValidBrowser=false;t.set_base_url();for(var i=0;i<t.scripts_to_load.length;i++){
	setTimeout("eAL.load_script('"+t.baseURL+t.scripts_to_load[i]+".js');",1);t.waiting_loading[t.scripts_to_load[i]+".js"]=false;}t.add_event(window,"load",EAL.prototype.window_loaded);};
	
	
EAL.prototype={
has_error:function(){this.error=true;for(var i in EAL.prototype){EAL.prototype[i]=function(){};}},

set_browser_infos:function(o){ua=navigator.userAgent;o.isWebKit=/WebKit/.test(ua);o.isGecko=!o.isWebKit&&/Gecko/.test(ua);o.isMac=/Mac/.test(ua);o.isIE=(navigator.appName=="Microsoft Internet Explorer");if(o.isIE){o.isIE=ua.replace(/^.*?MSIE\s+([0-9\.]+).*$/,"$1");if(o.isIE<6)o.has_error();}if(o.isOpera=(ua.indexOf('Opera')!=-1)){o.isOpera=ua.replace(/^.*?Opera.*?([0-9\.]+).*$/i,"$1");if(o.isOpera<9)o.has_error();o.isIE=false;}if(o.isFirefox=(ua.indexOf('Firefox')!=-1))o.isFirefox=ua.replace(/^.*?Firefox.*?([0-9\.]+).*$/i,"$1");if(ua.indexOf('Iceweasel')!=-1)o.isFirefox=ua.replace(/^.*?Iceweasel.*?([0-9\.]+).*$/i,"$1");if(ua.indexOf('GranParadiso')!=-1)o.isFirefox=ua.replace(/^.*?GranParadiso.*?([0-9\.]+).*$/i,"$1");if(ua.indexOf('BonEcho')!=-1)o.isFirefox=ua.replace(/^.*?BonEcho.*?([0-9\.]+).*$/i,"$1");if(ua.indexOf('SeaMonkey')!=-1)o.isFirefox=(ua.replace(/^.*?SeaMonkey.*?([0-9\.]+).*$/i,"$1"))+1;if(o.isCamino=(ua.indexOf('Camino')!=-1))o.isCamino=ua.replace(/^.*?Camino.*?([0-9\.]+).*$/i,"$1");if(o.isSafari=(ua.indexOf('Safari')!=-1))o.isSafari=ua.replace(/^.*?Version\/([0-9]+\.[0-9]+).*$/i,"$1");if(o.isChrome=(ua.indexOf('Chrome')!=-1)){o.isChrome=ua.replace(/^.*?Chrome.*?([0-9\.]+).*$/i,"$1");o.isSafari=false;}},

window_loaded:function(){eAL.win="loaded";if(document.forms){for(var i=0;i<document.forms.length;i++){var form=document.forms[i];form.edit_area_replaced_submit=null;try{form.edit_area_replaced_submit=form.onsubmit;form.onsubmit="";}catch(e){}eAL.add_event(form,"submit",EAL.prototype.submit);eAL.add_event(form,"reset",EAL.prototype.reset);}}eAL.add_event(window,"unload",function(){for(var i in eAs){eAL.delete_instance(i);}});},

init_ie_textarea:function(id){var a=document.getElementById(id);try{if(a&&typeof(a.focused)=="undefined"){a.focus();a.focused=true;a.selectionStart=a.selectionEnd=0;get_IE_selection(a);eAL.add_event(a,"focus",IE_textarea_focus);eAL.add_event(a,"blur",IE_textarea_blur);}}catch(ex){}},
	
init:function(settings)
{
		var t=this,s=settings,i;
		if(!s["id"])t.has_error();
		if(t.error)return;
		if(eAs[s["id"]])t.delete_instance(s["id"]);
		for(i in t.default_settings){if(typeof(s[i])=="undefined")s[i]=t.default_settings[i];}
		if(s["browsers"]=="known"&&t.isValidBrowser==false){return;}
		if(s["begin_toolbar"].length>0)s["toolbar"]=s["begin_toolbar"]+","+s["toolbar"];
		if(s["end_toolbar"].length>0)s["toolbar"]=s["toolbar"]+","+s["end_toolbar"];
		s["tab_toolbar"]=s["toolbar"].replace(/ /g,"").split(",");
		t.get_template();t.load_script(t.baseURL+"langs/"+s["language"]+".js");
		if(s["syntax"].length>0){s["syntax"]=s["syntax"].toLowerCase();
		t.load_script(t.baseURL+"reg_syntax/"+s["syntax"]+".js");}
		eAs[s["id"]]={"settings":s};eAs[s["id"]]["displayed"]=false;eAs[s["id"]]["hidden"]=false;
		
		eAs[s["id"]]["content"] = s["content"];
		
		//alert(eAs[s["id"]]["settings"]["start_highlight"]);
		t.start(s["id"]);
},
			
delete_instance:function(id){var d=document,fs=window.frames,span,iframe;eAL.execCommand(id,"EA_delete");if(fs["frame_"+id]&&fs["frame_"+id].editArea){if(eAs[id]["displayed"])eAL.toggle(id,"off");fs["frame_"+id].editArea.execCommand("EA_unload");}span=d.getElementById("EditAreaArroundInfos_"+id);if(span)span.parentNode.removeChild(span);iframe=d.getElementById("frame_"+id);if(iframe){iframe.parentNode.removeChild(iframe);try{delete fs["frame_"+id];}catch(e){}}delete eAs[id];},
	
start:function(id)
{

	var t=this,d=document,f,span,father,next,html='',html_toolbar_content='',template,content,i;
	if(t.win!="loaded"){setTimeout("eAL.start('"+id+"');",50);return;}
	for(i in t.waiting_loading){if(t.waiting_loading[i]!="loaded"&&typeof(t.waiting_loading[i])!="function"){setTimeout("eAL.start('"+id+"');",50);return;}}


	if(!t.lang[eAs[id]["settings"]["language"]]||(eAs[id]["settings"]["syntax"].length>0&&!t.load_syntax[eAs[id]["settings"]["syntax"]])){setTimeout("eAL.start('"+id+"');",50);return;}if(eAs[id]["settings"]["syntax"].length>0)t.init_syntax_regexp();
			


if(!eAs[id]["initialized"]){t.execCommand(id,"EA_init");if(eAs[id]["settings"]["display"]=="later"){eAs[id]["initialized"]=true;return;}}if(t.isIE){t.init_ie_textarea(id);}var area=eAs[id];


//alert(template);
area.textarea=d.getElementById(area["settings"]["id"]);
eAs[area["settings"]["id"]]["textarea"]=area.textarea;
//if(typeof(window.frames["frame_"+area["settings"]["id"]])!='undefined')delete window.frames["frame_"+area["settings"]["id"]];father=area.textarea.parentNode;
/*
content=d.createElement("iframe");
content.name="frame_ok";
content.src = "../common/temp.html";
content.id="frame_ok";content.style.borderWidth="0px";
content.style.height="100px";
content.style.width="100px";
setAttribute(content,"frameBorder","0");
content.style.overflow="hidden";
content.style.display="";
*/
//next=area.textarea.nextSibling;

//if(next==null)father.appendChild(content);
//else father.insertBefore(content,next);

f=window.frames["frame_CodeArea"];

//f.document.open();
f.eAs=eAs;f.area_id=area["settings"]["id"];f.document.area_id=area["settings"]["id"];
window.editor = eAs["CodeArea"];
//top.template = template;

//f.src = "../common/temp.html";
//f.document.write(template);
//f.document.close();
},
	
toggle:function(id,toggle_to)
{if(!toggle_to)toggle_to=(eAs[id]["displayed"]==true)?"off":"on";if(eAs[id]["displayed"]==true&&toggle_to=="off"){this.toggle_off(id);}
else if(eAs[id]["displayed"]==false&&toggle_to=="on"){this.toggle_on(id);}return false;},
	
toggle_off:function(id){var fs=window.frames,f,t,parNod,nxtSib,selStart,selEnd,scrollTop,scrollLeft;if(fs["frame_"+id]){f=fs["frame_"+id];t=eAs[id]["textarea"];if(f.editArea.fullscreen['isFull'])f.editArea.toggle_full_screen(false);eAs[id]["displayed"]=false;t.wrap="off";setAttribute(t,"wrap","off");parNod=t.parentNode;nxtSib=t.nextSibling;parNod.removeChild(t);parNod.insertBefore(t,nxtSib);t.value=f.editArea.textarea.value;selStart=f.editArea.last_selection["selectionStart"];selEnd=f.editArea.last_selection["selectionEnd"];scrollTop=f.document.getElementById("result").scrollTop;scrollLeft=f.document.getElementById("result").scrollLeft;document.getElementById("frame_"+id).style.display='none';t.style.display="inline";try{t.focus();}catch(e){};if(this.isIE){t.selectionStart=selStart;t.selectionEnd=selEnd;t.focused=true;set_IE_selection(t);}
else{
	
	if(this.isOpera&&this.isOpera < 9.6){t.setSelectionRange(0,0);}
	
	try{t.setSelectionRange(selStart,selEnd);}catch(e){};}
	
	t.scrollTop=scrollTop;t.scrollLeft=scrollLeft;f.editArea.execCommand("toggle_off");}},
		
	toggle_on:function(id){
		var fs=window.frames,f,t,selStart=0,selEnd=0,scrollTop=0,scrollLeft=0,curPos,elem;
		if(fs["frame_"+id]){
		
		f=fs["frame_"+id];
		t=eAs[id]["textarea"];
		area=f.editArea;

		//alert("t.value"+t.value);
		//area.textarea.value=eAs[id]["content"];
		
		curPos=eAs[id]["settings"]["cursor_position"];
	
	if(t.use_last==true){
		selStart=t.last_selectionStart;selEnd=t.last_selectionEnd;scrollTop=t.last_scrollTop;scrollLeft=t.last_scrollLeft;
		t.use_last=false;}
else if(curPos=="auto"){try{selStart=t.selectionStart;selEnd=t.selectionEnd;scrollTop=t.scrollTop;scrollLeft=t.scrollLeft;}catch(ex){}}



t.style.display="none";document.getElementById("frame_"+id).style.display="inline";area.execCommand("focus");eAs[id]["displayed"]=true;area.execCommand("update_size");f.document.getElementById("result").scrollTop=scrollTop;f.document.getElementById("result").scrollLeft=scrollLeft;
area.area_select(selStart,selEnd-selStart);area.execCommand("toggle_on");}
else{elem=document.getElementById(id);elem.last_selectionStart=elem.selectionStart;elem.last_selectionEnd=elem.selectionEnd;elem.last_scrollTop=elem.scrollTop;elem.last_scrollLeft=elem.scrollLeft;elem.use_last=true;eAL.start(id);}},
	
set_editarea_size_from_textarea:function(id,frame){

}
,set_base_url:function(){var t=this,elems,i,docBasePath;if(!this.baseURL){elems=document.getElementsByTagName('script');for(i=0;i<elems.length;i++){if(elems[i].src&&elems[i].src.match(/edit_area_[^\\\/]*$/i)){var src=unescape(elems[i].src);src=src.substring(0,src.lastIndexOf('/'));this.baseURL=src;this.file_name=elems[i].src.substr(elems[i].src.lastIndexOf("/")+1);break;}}}docBasePath=document.location.href;if(docBasePath.indexOf('?')!=-1)docBasePath=docBasePath.substring(0,docBasePath.indexOf('?'));docBasePath=docBasePath.substring(0,docBasePath.lastIndexOf('/'));if(t.baseURL.indexOf('://')==-1&&t.baseURL.charAt(0)!='/'){t.baseURL=docBasePath+"/"+t.baseURL;}t.baseURL+="/";},get_button_html:function(id,img,exec,isFileSpecific,baseURL){var cmd,html;if(!baseURL)baseURL=this.baseURL;cmd='editArea.execCommand(\''+exec+'\')';html='<a id="a_'+id+'" href="javascript:'+cmd+'" onclick="'+cmd+';return false;" onmousedown="return false;" target="_self" fileSpecific="'+(isFileSpecific?'yes':'no')+'">';html+='<img id="'+id+'" src="'+baseURL+'images/'+img+'" title="{$'+id+'}" width="20" height="20" class="editAreaButtonNormal" onmouseover="editArea.switchClass(this,\'editAreaButtonOver\');" onmouseout="editArea.restoreClass(this);" onmousedown="editArea.restoreAndSwitchClass(this,\'editAreaButtonDown\');" /></a>';return html;},get_control_html:function(button_name,lang){var t=this,i,but,html,si;for(i=0;i<t.advanced_buttons.length;i++){but=t.advanced_buttons[i];if(but[0]==button_name){return t.get_button_html(but[0],but[1],but[2],but[3]);}}switch(button_name){case "*":case "return":return "<br />";case "|":case "separator":return '<img src="'+t.baseURL+'images/spacer.gif" width="1" height="15" class="editAreaSeparatorLine">';case "select_font":html="<select id='area_font_size' onchange='javascript:editArea.execCommand(\"change_font_size\")' fileSpecific='yes'>";html+="<option value='-1'>{$font_size}</option>";si=[8,9,10,11,12,14];for(i=0;i<si.length;i++){html+="<option value='"+si[i]+"'>"+si[i]+" pt</option>";}html+="</select>";return html;case "syntax_selection":html="<select id='syntax_selection' onchange='javascript:editArea.execCommand(\"change_syntax\",this.value)' fileSpecific='yes'>";html+="<option value='-1'>{$syntax_selection}</option>";html+="</select>";return html;}return "<span id='tmp_tool_"+button_name+"'>["+button_name+"]</span>";},
	
get_template:function(){},

translate:function(text,lang,mode){if(mode=="word")text=eAL.get_word_translation(text,lang);
else if(mode="template"){eAL.current_language=lang;text=text.replace(/\{\$([^\}]+)\}/gm,eAL.translate_template);}return text;},

translate_template:function(){return eAL.get_word_translation(EAL.prototype.translate_template.arguments[1],eAL.current_language);},
get_word_translation:function(val,lang){var i;for(i in eAL.lang[lang]){if(i==val)return eAL.lang[lang][i];}return "_"+val;},
load_script:function(url){var t=this,d=document,script,head;if(t.loadedFiles[url])return;try{script=d.createElement("script");script.type="text/javascript";script.src=url;script.charset="UTF-8";d.getElementsByTagName("head")[0].appendChild(script);}catch(e){d.write('<sc'+'ript language="javascript" type="text/javascript" src="'+url+'" charset="UTF-8"></sc'+'ript>');}t.loadedFiles[url]=true;},
add_event:function(obj,name,handler){try{if(obj.attachEvent){obj.attachEvent("on"+name,handler);}
else{obj.addEventListener(name,handler,false);}}catch(e){}},
remove_event:function(obj,name,handler){try{if(obj.detachEvent)obj.detachEvent("on"+name,handler);
else obj.removeEventListener(name,handler,false);}catch(e){}},
reset:function(e){var formObj,is_child,i,x;formObj=eAL.isIE ? window.event.srcElement:e.target;if(formObj.tagName!='FORM')formObj=formObj.form;for(i in eAs){is_child=false;for(x=0;x<formObj.elements.length;x++){if(formObj.elements[x].id==i)is_child=true;}if(window.frames["frame_"+i]&&is_child&&eAs[i]["displayed"]==true){var exec='window.frames["frame_'+i+'"].editArea.textarea.value=document.getElementById("'+i+'").value;';exec+='window.frames["frame_'+i+'"].editArea.execCommand("focus");';exec+='window.frames["frame_'+i+'"].editArea.check_line_selection();';exec+='window.frames["frame_'+i+'"].editArea.execCommand("reset");';window.setTimeout(exec,10);}}return;},
submit:function(e){var formObj,is_child,fs=window.frames,i,x;formObj=eAL.isIE ? window.event.srcElement:e.target;if(formObj.tagName!='FORM')formObj=formObj.form;for(i in eAs){is_child=false;for(x=0;x<formObj.elements.length;x++){if(formObj.elements[x].id==i)is_child=true;}if(is_child){if(fs["frame_"+i]&&eAs[i]["displayed"]==true)document.getElementById(i).value=fs["frame_"+i].editArea.textarea.value;eAL.execCommand(i,"EA_submit");}}if(typeof(formObj.edit_area_replaced_submit)=="function"){res=formObj.edit_area_replaced_submit();if(res==false){if(eAL.isIE)return false;
else e.preventDefault();}}return;},

getValue:function(id){if(window.frames["frame_"+id]&&eAs[id]["displayed"]==true){return window.frames["frame_"+id].editArea.textarea.value;}
else if(elem=document.getElementById(id)){return elem.value;}return false;},

setValue:function(id,new_val)
	{
		var fs=window.frames;
		if((f=fs["frame_"+id])&&eAs[id]["displayed"]==true){f.editArea.textarea.value=new_val;f.editArea.execCommand("focus");f.editArea.check_line_selection(false);f.editArea.execCommand("onchange");}
		else if(elem=document.getElementById(id)){elem.value=new_val;}
	},

getSelectionRange:function(id){var sel,eA,fs=window.frames;sel={"start":0,"end":0};if(fs["frame_"+id]&&eAs[id]["displayed"]==true){eA=fs["frame_"+id].editArea;sel["start"]=eA.textarea.selectionStart;sel["end"]=eA.textarea.selectionEnd;}
else if(elem=document.getElementById(id)){sel=getSelectionRange(elem);}return sel;},
setSelectionRange:function(id,new_start,new_end){var fs=window.frames;if(fs["frame_"+id]&&eAs[id]["displayed"]==true){fs["frame_"+id].editArea.area_select(new_start,new_end-new_start);if(!this.isIE){fs["frame_"+id].editArea.check_line_selection(false);fs["frame_"+id].editArea.scroll_to_view();}}
else if(elem=document.getElementById(id)){setSelectionRange(elem,new_start,new_end);}},

getSelectedText:function(id){var sel=this.getSelectionRange(id);return this.getValue(id).substring(sel["start"],sel["end"]);},

setSelectedText:function(id,new_val){var fs=window.frames,d=document,sel,text,scrollTop,scrollLeft,new_sel_end;new_val=new_val.replace(/\r/g,"");sel=this.getSelectionRange(id);text=this.getValue(id);if(fs["frame_"+id]&&eAs[id]["displayed"]==true){scrollTop=fs["frame_"+id].document.getElementById("result").scrollTop;scrollLeft=fs["frame_"+id].document.getElementById("result").scrollLeft;}
else{scrollTop=d.getElementById(id).scrollTop;scrollLeft=d.getElementById(id).scrollLeft;}text=text.substring(0,sel["start"])+new_val+text.substring(sel["end"]);this.setValue(id,text);new_sel_end=sel["start"]+new_val.length;this.setSelectionRange(id,sel["start"],new_sel_end);if(new_val !=this.getSelectedText(id).replace(/\r/g,"")){this.setSelectionRange(id,sel["start"],new_sel_end+new_val.split("\n").length-1);}if(fs["frame_"+id]&&eAs[id]["displayed"]==true){fs["frame_"+id].document.getElementById("result").scrollTop=scrollTop;fs["frame_"+id].document.getElementById("result").scrollLeft=scrollLeft;fs["frame_"+id].editArea.execCommand("onchange");}
else{d.getElementById(id).scrollTop=scrollTop;d.getElementById(id).scrollLeft=scrollLeft;}},
	
insertTags:function(id,open_tag,close_tag){var old_sel,new_sel;old_sel=this.getSelectionRange(id);text=open_tag+this.getSelectedText(id)+close_tag;eAL.setSelectedText(id,text);new_sel=this.getSelectionRange(id);if(old_sel["end"] > old_sel["start"])this.setSelectionRange(id,new_sel["end"],new_sel["end"]);
else this.setSelectionRange(id,old_sel["start"]+open_tag.length,old_sel["start"]+open_tag.length);},

hide:function(id){var fs=window.frames,d=document,t=this,scrollTop,scrollLeft,span;if(d.getElementById(id)&&!t.hidden[id]){t.hidden[id]={};t.hidden[id]["selectionRange"]=t.getSelectionRange(id);if(d.getElementById(id).style.display!="none"){t.hidden[id]["scrollTop"]=d.getElementById(id).scrollTop;t.hidden[id]["scrollLeft"]=d.getElementById(id).scrollLeft;}if(fs["frame_"+id]){t.hidden[id]["toggle"]=eAs[id]["displayed"];if(fs["frame_"+id]&&eAs[id]["displayed"]==true){scrollTop=fs["frame_"+id].document.getElementById("result").scrollTop;scrollLeft=fs["frame_"+id].document.getElementById("result").scrollLeft;}
else{scrollTop=d.getElementById(id).scrollTop;scrollLeft=d.getElementById(id).scrollLeft;}t.hidden[id]["scrollTop"]=scrollTop;t.hidden[id]["scrollLeft"]=scrollLeft;if(eAs[id]["displayed"]==true)eAL.toggle_off(id);}span=d.getElementById("EditAreaArroundInfos_"+id);if(span){span.style.display='none';}d.getElementById(id).style.display="none";}},

show:function(id){var fs=window.frames,d=document,t=this,span;if((elem=d.getElementById(id))&&t.hidden[id]){elem.style.display="inline";elem.scrollTop=t.hidden[id]["scrollTop"];elem.scrollLeft=t.hidden[id]["scrollLeft"];span=d.getElementById("EditAreaArroundInfos_"+id);if(span){span.style.display='inline';}if(fs["frame_"+id]){elem.style.display="inline";if(t.hidden[id]["toggle"]==true)eAL.toggle_on(id);scrollTop=t.hidden[id]["scrollTop"];scrollLeft=t.hidden[id]["scrollLeft"];if(fs["frame_"+id]&&eAs[id]["displayed"]==true){fs["frame_"+id].document.getElementById("result").scrollTop=scrollTop;fs["frame_"+id].document.getElementById("result").scrollLeft=scrollLeft;}
else{elem.scrollTop=scrollTop;elem.scrollLeft=scrollLeft;}}sel=t.hidden[id]["selectionRange"];t.setSelectionRange(id,sel["start"],sel["end"]);delete t.hidden[id];}},
	
getCurrentFile:function(id){return this.execCommand(id,'get_file',this.execCommand(id,'curr_file'));},
	
getFile:function(id,file_id){return this.execCommand(id,'get_file',file_id);},
	
getAllFiles:function(id){return this.execCommand(id,'get_all_files()');},
	
openFile:function(id,file_infos){return this.execCommand(id,'open_file',file_infos);},
	
closeFile:function(id,file_id){return this.execCommand(id,'close_file',file_id);},
	
setFileEditedMode:function(id,file_id,to){var reg1,reg2;reg1=new RegExp('\\\\','g');reg2=new RegExp('"','g');return this.execCommand(id,'set_file_edited_mode("'+file_id.replace(reg1,'\\\\').replace(reg2,'\\"')+'",'+to+')');},
	
execCommand:function(id,cmd,fct_param){switch(cmd){case "EA_init":if(eAs[id]['settings']["EA_init_callback"].length>0)eval(eAs[id]['settings']["EA_init_callback"]+"('"+id+"');");break;case "EA_delete":if(eAs[id]['settings']["EA_delete_callback"].length>0)eval(eAs[id]['settings']["EA_delete_callback"]+"('"+id+"');");break;case "EA_submit":if(eAs[id]['settings']["submit_callback"].length>0)eval(eAs[id]['settings']["submit_callback"]+"('"+id+"');");break;}if(window.frames["frame_"+id]&&window.frames["frame_"+id].editArea){if(fct_param!=undefined)return eval('window.frames["frame_'+id+'"].editArea.'+cmd+'(fct_param);');
else return eval('window.frames["frame_'+id+'"].editArea.'+cmd+';');}return false;}};

var eAL=new EAL();var eAs={}; 

function getAttribute(elm,aName){var aValue,taName,i;try{aValue=elm.getAttribute(aName);}catch(exept){}if(! aValue){for(i=0;i < elm.attributes.length;i++){taName=elm.attributes[i] .name.toLowerCase();if(taName==aName){aValue=elm.attributes[i] .value;return aValue;}}}return aValue;};

function setAttribute(elm,attr,val){if(attr=="class"){elm.setAttribute("className",val);elm.setAttribute("class",val);}
else{elm.setAttribute(attr,val);}};

function getChildren(elem,elem_type,elem_attribute,elem_attribute_match,option,depth){
	if(!option)var option="single";if(!depth)var depth=-1;if(elem){var children=elem.childNodes;var result=null;var results=[];for(var x=0;x<children.length;x++){
		
		strTagName="undefined";//new String(children[x].tagName);
		children_class="?";
		if(strTagName!="undefined"){child_attribute=getAttribute(children[x],elem_attribute);if((strTagName.toLowerCase()==elem_type.toLowerCase()||elem_type=="")&&(elem_attribute==""||child_attribute==elem_attribute_match)){if(option=="all"){results.push(children[x]);}
else{return children[x];}}if(depth!=0){result=getChildren(children[x],elem_type,elem_attribute,elem_attribute_match,option,depth-1);if(option=="all"){if(result.length>0){results=results.concat(result);}}
else if(result!=null){return result;}}}}if(option=="all")return results;}return null;};

function isChildOf(elem,parent){if(elem){if(elem==parent)return true;while(elem.parentNode !='undefined'){return isChildOf(elem.parentNode,parent);}}return false;};

function getMouseX(e){if(e!=null&&typeof(e.pageX)!="undefined"){return e.pageX;}
else{return(e!=null?e.x:event.x)+document.documentElement.scrollLeft;}};

function getMouseY(e){if(e!=null&&typeof(e.pageY)!="undefined"){return e.pageY;}
else{return(e!=null?e.y:event.y)+document.documentElement.scrollTop;}};

function calculeOffsetLeft(r){return calculeOffset(r,"offsetLeft")};

function calculeOffsetTop(r){return calculeOffset(r,"offsetTop")};

function calculeOffset(element,attr){var offset=0;while(element){offset+=element[attr];element=element.offsetParent}return offset;};

function get_css_property(elem,prop){if(document.defaultView){return document.defaultView.getComputedStyle(elem,null).getPropertyValue(prop);}
else if(elem.currentStyle){var prop=prop.replace(/-\D/gi,function(sMatch){return sMatch.charAt(sMatch.length-1).toUpperCase();});return elem.currentStyle[prop];}
else return null;}

var _mCE;
function start_move_element(e,id,frame){var elem_id=(e.target||e.srcElement).id;if(id)elem_id=id;if(!frame)frame=window;if(frame.event)e=frame.event;_mCE=frame.document.getElementById(elem_id);_mCE.frame=frame;frame.document.onmousemove=move_element;frame.document.onmouseup=end_move_element;mouse_x=getMouseX(e);mouse_y=getMouseY(e);_mCE.start_pos_x=mouse_x-(_mCE.style.left.replace("px","")||calculeOffsetLeft(_mCE));_mCE.start_pos_y=mouse_y-(_mCE.style.top.replace("px","")||calculeOffsetTop(_mCE));return false;};

function end_move_element(e){_mCE.frame.document.onmousemove="";_mCE.frame.document.onmouseup="";_mCE=null;};

function move_element(e){var newTop,newLeft,maxLeft;if(_mCE.frame&&_mCE.frame.event)e=_mCE.frame.event;newTop=getMouseY(e)-_mCE.start_pos_y;newLeft=getMouseX(e)-_mCE.start_pos_x;maxLeft=_mCE.frame.document.body.offsetWidth-_mCE.offsetWidth;max_top=_mCE.frame.document.body.offsetHeight-_mCE.offsetHeight;newTop=Math.min(Math.max(0,newTop),max_top);newLeft=Math.min(Math.max(0,newLeft),maxLeft);_mCE.style.top=newTop+"px";_mCE.style.left=newLeft+"px";return false;};

var nav=eAL.nav;
function getSelectionRange(textarea){return{"start":textarea.selectionStart,"end":textarea.selectionEnd};};

function setSelectionRange(t,start,end){t.focus();start=Math.max(0,Math.min(t.value.length,start));end=Math.max(start,Math.min(t.value.length,end));if(nav.isOpera&&nav.isOpera < 9.6){t.selectionEnd=1;t.selectionStart=0;t.selectionEnd=1;t.selectionStart=0;}t.selectionStart=start;t.selectionEnd=end;if(nav.isIE)set_IE_selection(t);};

function get_IE_selection(t){var d=document,div,range,stored_range,elem,scrollTop,relative_top,line_start,line_nb,range_start,range_end,tab;if(t&&t.focused){if(!t.ea_line_height){div=d.createElement("div");div.style.fontFamily=get_css_property(t,"font-family");div.style.fontSize=get_css_property(t,"font-size");div.style.visibility="hidden";div.innerHTML="0";d.body.appendChild(div);t.ea_line_height=div.offsetHeight;d.body.removeChild(div);}range=d.selection.createRange();try{stored_range=range.duplicate();stored_range.moveToElementText(t);stored_range.setEndPoint('EndToEnd',range);if(stored_range.parentElement()==t){elem=t;scrollTop=0;while(elem.parentNode){scrollTop+=elem.scrollTop;elem=elem.parentNode;}relative_top=range.offsetTop-calculeOffsetTop(t)+scrollTop;line_start=Math.round((relative_top / t.ea_line_height)+1);line_nb=Math.round(range.boundingHeight / t.ea_line_height);range_start=stored_range.text.length-range.text.length;tab=t.value.substr(0,range_start).split("\n");range_start+=(line_start-tab.length)*2;t.selectionStart=range_start;range_end=t.selectionStart+range.text.length;tab=t.value.substr(0,range_start+range.text.length).split("\n");range_end+=(line_start+line_nb-1-tab.length)*2;t.selectionEnd=range_end;}}catch(e){}}if(t&&t.id){setTimeout("get_IE_selection(document.getElementById('"+t.id+"'));",50);}};

function IE_textarea_focus(){event.srcElement.focused=true;}

function IE_textarea_blur(){event.srcElement.focused=false;}

function set_IE_selection(t){var nbLineStart,nbLineStart,nbLineEnd,range;if(!window.closed){nbLineStart=t.value.substr(0,t.selectionStart).split("\n").length-1;nbLineEnd=t.value.substr(0,t.selectionEnd).split("\n").length-1;try{range=document.selection.createRange();range.moveToElementText(t);range.setEndPoint('EndToStart',range);range.moveStart('character',t.selectionStart-nbLineStart);range.moveEnd('character',t.selectionEnd-nbLineEnd-(t.selectionStart-nbLineStart));range.select();}catch(e){}}};

eAL.waiting_loading["elements_functions.js"]="loaded";
 EAL.prototype.start_resize_area=function(){var d=document,a,div,width,height,father;d.onmouseup=eAL.end_resize_area;d.onmousemove=eAL.resize_area;eAL.toggle(eAL.resize["id"]);a=eAs[eAL.resize["id"]]["textarea"];div=d.getElementById("edit_area_resize");if(!div){div=d.createElement("div");div.id="edit_area_resize";div.style.border="dashed #888888 1px";}width=a.offsetWidth-2;height=a.offsetHeight-2;div.style.display="block";div.style.width=width+"px";div.style.height=height+"px";father=a.parentNode;father.insertBefore(div,a);a.style.display="none";eAL.resize["start_top"]=calculeOffsetTop(div);eAL.resize["start_left"]=calculeOffsetLeft(div);};
 
 EAL.prototype.end_resize_area=function(e){var d=document,div,a,width,height;d.onmouseup="";d.onmousemove="";div=d.getElementById("edit_area_resize");a=eAs[eAL.resize["id"]]["textarea"];width=Math.max(eAs[eAL.resize["id"]]["settings"]["min_width"],div.offsetWidth-4);height=Math.max(eAs[eAL.resize["id"]]["settings"]["min_height"],div.offsetHeight-4);if(eAL.isIE==6){width-=2;height-=2;}a.style.width=width+"px";a.style.height=height+"px";div.style.display="none";a.style.display="inline";a.selectionStart=eAL.resize["selectionStart"];a.selectionEnd=eAL.resize["selectionEnd"];eAL.toggle(eAL.resize["id"]);return false;};
 
 EAL.prototype.resize_area=function(e){var allow,newHeight,newWidth;allow=eAs[eAL.resize["id"]]["settings"]["allow_resize"];if(allow=="both"||allow=="y"){newHeight=Math.max(20,getMouseY(e)-eAL.resize["start_top"]);document.getElementById("edit_area_resize").style.height=newHeight+"px";}if(allow=="both"||allow=="x"){newWidth=Math.max(20,getMouseX(e)-eAL.resize["start_left"]);document.getElementById("edit_area_resize").style.width=newWidth+"px";}return false;};
 
 eAL.waiting_loading["resize_area.js"]="loaded";
	EAL.prototype.get_regexp=function(text_array){res="(\\b)(";for(i=0;i<text_array.length;i++){if(i>0)res+="|";res+=this.get_escaped_regexp(text_array[i]);}res+=")(\\b)";reg=new RegExp(res);return res;};
	
EAL.prototype.get_escaped_regexp=function(str){return str.toString().replace(/(\.|\?|\*|\+|\\|\(|\)|\[|\]|\}|\{|\$|\^|\|)/g,"\\$1");};

EAL.prototype.init_syntax_regexp=function(){var lang_style={};for(var lang in this.load_syntax){if(!this.syntax[lang]){this.syntax[lang]={};this.syntax[lang]["keywords_reg_exp"]={};this.keywords_reg_exp_nb=0;if(this.load_syntax[lang]['KEYWORDS']){param="g";if(this.load_syntax[lang]['KEYWORD_CASE_SENSITIVE']===false)param+="i";for(var i in this.load_syntax[lang]['KEYWORDS']){if(typeof(this.load_syntax[lang]['KEYWORDS'][i])=="function")continue;this.syntax[lang]["keywords_reg_exp"][i]=new RegExp(this.get_regexp(this.load_syntax[lang]['KEYWORDS'][i]),param);this.keywords_reg_exp_nb++;}}if(this.load_syntax[lang]['OPERATORS']){var str="";var nb=0;for(var i in this.load_syntax[lang]['OPERATORS']){if(typeof(this.load_syntax[lang]['OPERATORS'][i])=="function")continue;if(nb>0)str+="|";str+=this.get_escaped_regexp(this.load_syntax[lang]['OPERATORS'][i]);nb++;}if(str.length>0)this.syntax[lang]["operators_reg_exp"]=new RegExp("("+str+")","g");}if(this.load_syntax[lang]['DELIMITERS']){var str="";var nb=0;for(var i in this.load_syntax[lang]['DELIMITERS']){if(typeof(this.load_syntax[lang]['DELIMITERS'][i])=="function")continue;if(nb>0)str+="|";str+=this.get_escaped_regexp(this.load_syntax[lang]['DELIMITERS'][i]);nb++;}if(str.length>0)this.syntax[lang]["delimiters_reg_exp"]=new RegExp("("+str+")","g");}var syntax_trace=[];this.syntax[lang]["quotes"]={};var quote_tab=[];if(this.load_syntax[lang]['QUOTEMARKS']){for(var i in this.load_syntax[lang]['QUOTEMARKS']){if(typeof(this.load_syntax[lang]['QUOTEMARKS'][i])=="function")continue;var x=this.get_escaped_regexp(this.load_syntax[lang]['QUOTEMARKS'][i]);this.syntax[lang]["quotes"][x]=x;quote_tab[quote_tab.length]="("+x+"(\\\\.|[^"+x+"])*(?:"+x+"|$))";syntax_trace.push(x);}}this.syntax[lang]["comments"]={};if(this.load_syntax[lang]['COMMENT_SINGLE']){for(var i in this.load_syntax[lang]['COMMENT_SINGLE']){if(typeof(this.load_syntax[lang]['COMMENT_SINGLE'][i])=="function")continue;var x=this.get_escaped_regexp(this.load_syntax[lang]['COMMENT_SINGLE'][i]);quote_tab[quote_tab.length]="("+x+"(.|\\r|\\t)*(\\n|$))";syntax_trace.push(x);this.syntax[lang]["comments"][x]="\n";}}if(this.load_syntax[lang]['COMMENT_MULTI']){for(var i in this.load_syntax[lang]['COMMENT_MULTI']){if(typeof(this.load_syntax[lang]['COMMENT_MULTI'][i])=="function")continue;var start=this.get_escaped_regexp(i);var end=this.get_escaped_regexp(this.load_syntax[lang]['COMMENT_MULTI'][i]);quote_tab[quote_tab.length]="("+start+"(.|\\n|\\r)*?("+end+"|$))";syntax_trace.push(start);syntax_trace.push(end);this.syntax[lang]["comments"][i]=this.load_syntax[lang]['COMMENT_MULTI'][i];}}


if(quote_tab.length>0)this.syntax[lang]["comment_or_quote_reg_exp"]=new RegExp("("+quote_tab.join("|")+")","gi");

if(syntax_trace.length>0)this.syntax[lang]["syntax_trace_regexp"]=new RegExp("((.|\n)*?)(\\\\*("+syntax_trace.join("|")+"|$))","gmi");if(this.load_syntax[lang]['SCRIPT_DELIMITERS']){this.syntax[lang]["script_delimiters"]={};for(var i in this.load_syntax[lang]['SCRIPT_DELIMITERS']){if(typeof(this.load_syntax[lang]['SCRIPT_DELIMITERS'][i])=="function")continue;this.syntax[lang]["script_delimiters"][i]=this.load_syntax[lang]['SCRIPT_DELIMITERS'];}}this.syntax[lang]["custom_regexp"]={};if(this.load_syntax[lang]['REGEXPS']){for(var i in this.load_syntax[lang]['REGEXPS']){if(typeof(this.load_syntax[lang]['REGEXPS'][i])=="function")continue;var val=this.load_syntax[lang]['REGEXPS'][i];if(!this.syntax[lang]["custom_regexp"][val['execute']])this.syntax[lang]["custom_regexp"][val['execute']]={};this.syntax[lang]["custom_regexp"][val['execute']][i]={'regexp':new RegExp(val['search'],val['modifiers']),'class':val['class']};}}if(this.load_syntax[lang]['STYLES']){lang_style[lang]={};for(var i in this.load_syntax[lang]['STYLES']){if(typeof(this.load_syntax[lang]['STYLES'][i])=="function")continue;if(typeof(this.load_syntax[lang]['STYLES'][i])!="string"){for(var j in this.load_syntax[lang]['STYLES'][i]){lang_style[lang][j]=this.load_syntax[lang]['STYLES'][i][j];}}
else{lang_style[lang][i]=this.load_syntax[lang]['STYLES'][i];}}}var style="";for(var i in lang_style[lang]){if(lang_style[lang][i].length>0){style+="."+lang+" ."+i.toLowerCase()+" span{"+lang_style[lang][i]+"}\n";style+="."+lang+" ."+i.toLowerCase()+"{"+lang_style[lang][i]+"}\n";}}this.syntax[lang]["styles"]=style;}}};

eAL.waiting_loading["reg_syntax.js"]="loaded";
var editAreaLoader= eAL;var editAreas=eAs;EditAreaLoader=EAL;