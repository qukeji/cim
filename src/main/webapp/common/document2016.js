$(function() {
	init();

	$.browser.chrome = /chrome/.test(navigator.userAgent.toLowerCase());
	if($.browser.mozilla || $.browser.chrome){
		
		$(document).bind("dragenter",function(event) {return false; }).bind("dragover", function(event) {					event.stopPropagation(); event.preventDefault();return true; }).bind("drop", function(event) { 					event.stopPropagation(); event.preventDefault();return true; })
		
		$(".upload").each(function(i){
			tidecms.uploadHtml5($(this),"insertimage_submit.jsp",{ChannelID:channelid,success:function(o,a){a=$.trim(a);var oo = eval("("+a+")");if(oo.status==0){alert(oo.message);}if(oo.status==1){o.val(oo.message);}}});
		});
	}

	//封面图字段预览
    $( ".field_image" ).tooltip({
		 content: function() {
		 var s = $(this).val();//alert(s);
		 if(s!="") return "<img width=200 src='"+s+"'>";
		 else return "";
		}
	});

	//提取缩略图
	$( "#field_Photo" ).append("\r\n<input type=\"button\" value=\"自动提取\" onclick=\"getPhotoFromContent()\" class=\"tidecms_btn3\">");
});

function checkTitle()
{
	var title = document.form.Title.value;
	var message = document.getElementById("TitleCount");//alert(title.length);
	if(title!="")
	{
		var l=title.length;
		var n=0;
		for (var i=0;i<l;i++)
		{
			if (title.charCodeAt(i)<0||title.charCodeAt(i)>255)
				n++;
			else
				n = n + 0.5;
		}
		
		if (typeof(title_length) != "undefined")
		{
			if(n>title_length) 
				$("#Title").css("background-color","yellow");//$("#Title").css("color","red");
			else
				$("#Title").css("background-color","white");
		}
		
		$("#TitleCount").html(Math.ceil(n));
	}
	else
		$("#TitleCount").html("");
}

function ControlEditor()
{
	if(document.all("Label1").innerText=="隐藏编辑器")
	{
		document.all.Editor.style.display="none";
		document.all("Label1").innerText = "显示编辑器";
	}
	else
	{
		document.all.Editor.style.display="";
		document.all("Label1").innerText = "隐藏编辑器";
	}
}

function Save_Publish()
{
	document.form.Status.value = 1;
	Save();
}

function check()
{	
	var title =  document.form.Title.value;
	var l = title.length;
	var n = 0;
	for (var i=0;i<l;i++)
	{
		if (title.charCodeAt(i)<0||title.charCodeAt(i)>255)
			n++;
		else
			n = n + 0.5;
	}
	if(title=="")
	{
		alert("请输入标题!");
		document.form.Title.focus();
		return false;
	}
	
	if(n>100)
	{
		alert("标题太长!");
		document.form.Title.focus();
		return false;
	}

	if($("#PublishDate").size()>0 && $("#PublishDate").val()!="")
	{
		//去除空格
		$("#PublishDate").val(($("#PublishDate").val()).replace(/(^[\\s]*)|([\\s]*$)/g, ""));
		if(!checkIsValidDate($("#PublishDate").val()))
		{
			alert("请输入正确日期! 例如:2046-12-25 10:04:07");
			document.form.PublishDate.focus();
			return false;
		}
	}

	
	try {document.form.RelatedItemsList.value = document.getElementById("related_doc_list").contentWindow.getCheckedItem();} catch(err) {}

	if ( typeof(check2) == 'function' ) return check2();
	// 2013/6/13 15:17 张赫东  解决表单设置中勾选不允许为空没用,点选后仍然可以为空
	/*
	var a = $(".disable_blank");
	for(var i=0;i<a.length;i++){
		if($(a[i]).val()==""){
		alert("字段内容不允许为空");
		return false;
		}		
		}
	*/
	//2014.02.24 王海龙	解决 结构管理 表单设置中勾选允许为空 无效
	$(".disable_blank > input").each(function(index)
	{
		 var val = $(this).val();
		 if(val=="")
		 {
			alert("字段内容不允许为空");
			return false;
		}
	});


	return true;
}

function checkIsValidDate(str)
{
    //如果为空，则通过校验
    if(str == "")
        return true;
//    var pattern = ((\\d{4})|(\\d{2}))-(\\d{1,2})-(\\d{1,2})$/g;
//    if(!pattern.test(str))
//        return false;
	var str1 = str.split(" ");
	if(str1.length==1)
		str1[1]="00:00:00";
	if(str1.length>2)
		return false;

    var arrDate = str1[0].split("-");
	if(arrDate.length!=3)
		return false;
	var arrDate1 = str1[1].split(":");
	if(arrDate1.length!=3)
		return false;
    if(parseInt(arrDate[0],10) < 100)
        arrDate[0] = 2000 + parseInt(arrDate[0],10) + "";

	var year = arrDate[0];
	var month = (parseInt(arrDate[1],10)-1);
	var day = parseInt(arrDate[2],10);
	var hour = parseInt(arrDate1[0],10);
	var min = parseInt(arrDate1[1],10);
	var sec = parseInt(arrDate1[2],10);
    var date =  new Date(year,month,day,hour,min,sec);
	//alert(date.getMonth()+":"+date.getDate()+":"+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds());
    if(date.getFullYear() == year
        && date.getMonth() == month
		&& date.getDate() == day 
		&& date.getHours()==hour 
		&& date.getMinutes()==min 
		&& date.getSeconds()==sec)
        return true;
    else
        return false;
}

function selectdate(fieldname){
	var args="font-size:10px;dialogWidth:286px;dialogHeight:290px;center:yes;status:no;help:no";
	var Feature=new Array();
	var selectdate=window.showModalDialog("../content/selectdate.htm",Feature,args);
	//alert(document.all(fieldname));
	if (selectdate!=null)
	{
		if(document.all(fieldname).value!="")
		{
			arrayOfStrings = document.all(fieldname).value.split(" ");
			if(arrayOfStrings.length==1)
				document.all(fieldname).value = selectdate;
			else
				document.all(fieldname).value = selectdate + " " + arrayOfStrings[1];
		}
		else
			document.all(fieldname).value=selectdate;
	}
} 

function AddPage()
{
	var tabTable = document.getElementById("tabTable");
	Pages = Pages+1;//alert(Pages);
	var row1 = tabTable.rows[0];
	var col = row1.insertCell(-1);
	col.id = "t" + Pages;
	col.setAttribute("page",Pages);
	//col.page = Pages;
	col.className = "tab";
	setInnerText(col,"第" + Pages + "页");
	//col.innerText = "第" + Pages + "页";
	//Contents[Contents.length] = "";

	saveCurrentContent();
	Contents[Contents.length] = "";
	for (var i=Pages;i>curPage+1;i--){
		Contents[i-1] = Contents[(i-2)];//alert((i-1)+":"+Contents[i-1]+","+(i-2)+":"+Contents[i-2]);
	}
	
	Contents[curPage] = "";

	SetActive(curPage+1);
	/*
	var rows = document.getElementById("tabTableRow").cells;
	for (var i=0;i<rows.length;i++)
	{
		rows[i].className = "tab";
	}

	//alert(Contents[curPage]);
	//alert("len:"+Contents.length);
	//
	curPage = curPage + 1;
	var currentTab = document.getElementById("t" + curPage);
	currentTab.className = "selTab";
	//try{
	var editor = document.getElementById("FCKeditor1___Frame").contentWindow;
	var FCK			= editor.getFCK() ;
	FCK.SetHTML(Contents[curPage-1], false );
	*/
}

function AddPageInit()
{
	var tabTable = document.getElementById("tabTable");
	Pages = Pages+1;
	var row1 = tabTable.rows[0];
	var col = row1.insertCell(-1);
	col.id = "t" + Pages;
	//col.page = Pages;
	col.setAttribute("page",Pages);
	col.className = "tab";
	setInnerText(col,"第" + Pages + "页");
	//col.innerText = "第" + Pages + "页";

	Contents[Contents.length] = "";
	//for (var i=Pages;i>curPage+1;i--){
	//	Contents["t" + i] = Contents["t" + (i -1)];
	//}

	//Contents["t" + (curPage + 1)] = "";
	//SetActive(curPage+1);
}

function DeletePage()
{
	if (curPage==1) return;					//第一页是不让删除的
	var row,cell;
	var tabTable = document.getElementById("tabTable");
	row = tabTable.rows[0];

	for(var i=0;i<row.cells.length;i++){
		cell = row.cells[i];
		if (cell.id=="t"+curPage){
			row.deleteCell(i);
			Pages = Pages-1;
			}
		}

	if(curPage>Pages)//删掉最后一页
	{
		Contents.pop();
	}
	else
	{
		for(var i=curPage-1;i<Pages;i++){
		cell = row.cells[i];
		Contents[i] = Contents[i+1];
		cell.id = "t" + (i+1);
		cell.setAttribute("page",i+1);
		setInnerText(cell,"第" + (i+1) + "页");
		//cell.innerText = "第" + (i+1) + "页";
		}
		Contents.pop();
		//Contents.splice(curPage-1,1);alert(curPage-1);
	}
	if (curPage>Pages) curPage = Pages;

	var currentTab = document.getElementById("t" + curPage);
	currentTab.className = "selTab";
	//try{
		//var editor = document.getElementById("FCKeditor1___Frame").contentWindow;
		//var FCK			= editor.getFCK() ;
		CKEDITOR.instances['FCKeditor1'].setData(Contents[curPage-1]);
		//alert(curPage+","+Pages);
	//}catch(e){}
	//SetActive(curPage);
}

function saveCurrentContent()
{
	//var editor = document.getElementById("FCKeditor1___Frame").contentWindow;
	//var FCK			= editor.getFCK() ;
	//var FCKConfig	= editor.getFCKConfig();
	var rows = document.getElementById("tabTableRow").cells;
	for (var i=0;i<rows.length;i++)
	{
		if (rows[i].className=="selTab"){
			var page = rows[i].getAttribute("page");
			//Contents[page-1] = FCK.GetXHTML( FCKConfig.FormatSource );
                        // Contents[page-1] = editor.getData();
				Contents[page-1]=CKEDITOR.instances['FCKeditor1'].getData();
                          //alert(editor.sys());
			}
	}
}

function SetActive(num){
	var currentTab;//alert("SetActive:"+num+"::"+Contents);
	//var editor = document.getElementById("FCKeditor1___Frame").contentWindow;
	//alert(editor.contentWindow.getFCK());
	//var FCK			= editor.getFCK() ;
	//var FCKConfig	= editor.getFCKConfig();
	var rows = document.getElementById("tabTableRow").cells;
	//alert("rows:"+rows.length);
	/*
	for (var i=0;i<rows.length;i++){//alert(rows[i].id + ":" + Contents[rows[i].id]);alert(rows[i].className);
	//alert(FCK.GetXHTML());
		if (rows[i].className=="selTab"){
			rows[i].className = "tab";//alert(rows[i].className);
			var page = rows[i].getAttribute("page");
			Contents[page-1] = FCK.GetXHTML( FCKConfig.FormatSource );//alert(Contents[rows[i].id]);
			//alert(Contents[page]);
			}
		}//alert("rows:"+rows.length);
		*/
	var rows = document.getElementById("tabTableRow").cells;
	for (var i=0;i<rows.length;i++)
	{
		rows[i].className = "tab";
	}
		currentTab = document.getElementById("t" + num);
		currentTab.className = "selTab";
		//editor.value = Contents[currentTab.id];
		//alert(currentTab.id+":"+Contents[currentTab.id]);
		//alert(currentTab.page-1);
		//alert(Contents[currentTab.page-1]);
		//if(currentTab.page<=Contents.length)
		try{
			var page2 = currentTab.getAttribute("page");
			CKEDITOR.instances['FCKeditor1'].setData(Contents[page2-1], false ) ;}catch(e){}
		curPage = num;//alert('end');
}

function changeTabs(){//alert(Contents["t2"]);
	var evt = getEvent();
	var src = getEventSrcElement(evt);
	if (src.className!="tab") return;
	var ns = src.id;
	ns = ns.substr(1);
	var n = parseInt(ns);
	saveCurrentContent();
	SetActive(n);
}

function SetContent(num, content){
//	var editor = document.getElementById("FCKeditor1___Frame").contentWindow;
//	var FCK			= editor.getFCK() ;
	if(num<=Contents.length)
		Contents[num-1] = content;
	else
		Contents[Contents.length] = content;

	//alert(num + ":" + Contents.length+":"+Contents);
	if (curPage == num)
	{
		CKEDITOR.instances['FCKeditor1'].setData(content); 
		//FCK.SetHTML(content,true) ;
	}
	//alert("t" + num + "::" + Contents["t" + num]);
}

 function set_checkbox(name,value){
        jQuery("input[@type=checkbox]").each(
        function(i){
          if(jQuery(this).attr("name")==name){
          if(jQuery(this).attr("value")==value){
            jQuery(this).attr("checked","checked")
          }
         }
      });
     }
     
 function set_radio(name,value){
        jQuery("input[@type=radio]").each(
        function(i){
          if(jQuery(this).attr("name")==name){
          if(jQuery(this).attr("value")==value){
            jQuery(this).attr("checked","checked")
          }
         }
      });
     } 

function recommendItem(field)
{
	var myObject = new Object();
    myObject.title = "选择推荐条目";
	curField = field;

 	var Feature = "dialogWidth:56em; dialogHeight:44em;center:yes;status:no;help:no";
	//var retu = window.showModalDialog
	("../modal_dialog.jsp?target=content/recommend_item.jsp&FieldID=" + field,myObject,Feature);

	var width  = Math.floor( screen.width  * .8 );
	var height = Math.floor( screen.height * .85 );
	var leftm  = Math.floor( screen.width  * .1);
	var topm   = Math.floor( screen.height * .05);
	var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
	var url="../content/recommend_item.jsp?FieldID=" + field;
	window.open(url,"",Feature);
}

function recommendItemJS(itemid,channelid,souceChannelID,Target)
{
	var url = "../content/recommend_in_js.jsp";
	if(Target) url = Target;
	scr = document.createElement('script')
	scr.src = url + '?FieldID=' + curField + "&ItemID=" + itemid + "&ChannelID=" + channelid + "&sourceChannelID=" + souceChannelID;
	//alert(scr.src);
	document.getElementById('ajax_script').appendChild(scr);
}

function recommendOutItemJS(itemid,channelid,souceChannelID,Target)
{
	var url = "../content/recommend_out_js.jsp";
	if(Target) url = Target;
	//alert(url);
	scr = document.createElement('script')
	scr.src = url + '?ItemID=' + itemid + "&ChannelID=" + channelid + "&sourceChannelID=" + souceChannelID;
	//document.location.href = (scr.src);
	document.getElementById('ajax_script').appendChild(scr);
}

//transfer article 2015/1/13
function transferArticleJS(article_url)
{
	var url = "../transfer/transfer_article.jsp";

	scr = document.createElement('script')
	scr.src = url + '?url=' + article_url + "&title=div.contenttitle&content=div.contentabstracttext";
	//document.location.href = (scr.src);
	document.getElementById('ajax_script').appendChild(scr);
}

function groupItem(field)
{
	var myObject = new Object();
    myObject.title = "选择集合";
	curField = field;

	var width  = Math.floor( screen.width  * .8 );
	var height = Math.floor( screen.height * .85 );
	var leftm  = Math.floor( screen.width  * .1);
	var topm   = Math.floor( screen.height * .05);
	var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
	var url="../content/group_item.jsp?FieldID=" + field;
	window.open(url,"",Feature);
}

function groupItemJS(itemid,channelid,souceChannelID)
{
	scr = document.createElement('script')
	scr.src = '../content/group_js.jsp?FieldID=' + curField + "&ItemID=" + itemid + "&ChannelID=" + channelid;
	//alert(scr.src);
	document.getElementById('ajax_script').appendChild(scr);
}

function clearGroupItem(field)
{
	setValue(field+'_Title','');setValue(field,'0');
}

function groupChildItem(field)
{
	var myObject = new Object();
    myObject.title = "选择...";
	curField = field;

	var width  = Math.floor( screen.width  * .8 );
	var height = Math.floor( screen.height * .85 );
	var leftm  = Math.floor( screen.width  * .1);
	var topm   = Math.floor( screen.height * .05);
	var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
	var url="../content/group_child_item.jsp?FieldID=" + field;
	window.open(url,"",Feature);
}

function groupChildItemJS(itemid,channelid,souceChannelID)
{
	scr = document.createElement('script')
	scr.src = '../content/group_child_js.jsp?FieldID=' + curField + "&ItemID=" + itemid + "&ChannelID=" + channelid;
	//alert(scr.src);
	document.getElementById('ajax_script').appendChild(scr);
} 

function addGroupChild(field,title,globalid)
{
	//alert(title);
	var table = document.getElementById(field+"_Table");
	var oRow = table.insertRow();
	var oCell = oRow.insertCell();
	oCell.innerHTML = title;
}

function showEditor(name)
{
	//oFCKeditor = new FCKeditor(name) ;
	//oFCKeditor.BasePath	= '../editor/' ;
	//oFCKeditor.Value	= '<p>This is some <strong>sample text<\/strong>. You are using <a href="http://www.fckeditor.net/">FCKeditor<\/a>.<\/p>' ;
	//oFCKeditor.ReplaceTextarea() ;
	CKEDITOR.replace( name,{
	language:'zh-cn',//简体中文   
    toolbarCanCollapse : true,	//高度
	toolbar ://工具栏设置               随便取舍
	[
	['Source','Maximize','-','Save','NewPage','Preview','-','Templates'],
	['Cut','Copy','Paste','PasteText','PasteFromWord'],
	['Undo','Redo','-','Find','Replace','-',,'Table','HorizontalRule','-','SelectAll','RemoveFormat'],
	'/',
	['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
	['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
	['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
	['Link','Unlink','Anchor'],
	['Image','Flash','Smiley','SpecialChar','PageBreak'],
	['Styles','Format','Font','FontSize'],
	['TextColor','BGColor']
	]
	}); 
CKEDITOR.instances['FCKeditor1'].setData(currcontent);
}

function showTab(n)
{
	if(document.body.disabled) return;

	var num = groupnum;
	for(i=1;i<=num;i++)
	{
		//var divobj = document.getElementById("form"+i);
		//if(divobj)	divobj.style.display = "none";
		$("#form"+i).hide();
		$("#form"+i+"_td").removeClass('cur');
		//document.getElementById("form"+i+"_td").className="";
	}
	$("#form"+n+"_td").addClass('cur');
	$("#form"+n).show();
	//document.getElementById("form"+n+"_td").className="cur";
	//document.getElementById("form"+n).style.display = "";
	var url = $("#form"+n).attr("url");//alert(url);
	url = url.replace("itemid=0","itemid="+$("#ItemID").val());
	url = url.replace("globalid=0","globalid="+$("#GlobalID").val());
	//if(window.console) window.console.info($("#
	if(url!="")
	{
		if($("#iframe"+n).attr("src")=="../null.jsp") $("#iframe"+n).attr("src",url);//document.getElementById("iframe"+n).src = url;
	}
}

function getAutoKeyword(name)
{

	var title = $("#Title").val();
	var Keyword = $("#Keyword").val();
	var Tag = $("#Tag").val();
	Save_Content();//先保存当前内容
	var content = "";
	for(var i=1;i<=Pages;i++)
	{
		content = content + Contents[i-1];
	}
	//title=encodeURI(title);
	//title=encodeURI(title);
	//content=content.replace(/ /g,"").replace(/>/g,"").replace(/</g,"").replace(/&/g,"");
	//content=encodeURI(content);
	//content=encodeURI(content);
	jQuery.ajax({
			type : "POST",
			url : "../content/get_auto_keyword.jsp",
			dataType : "html",
			data: {title:title,content:content},
            success : function(data){
				if(name=="Keyword"){
					data = Keyword + " " + data;
					$('#Keyword').tagit('addTags', data);
					
				}else{
					data = Tag + " " + data;
					$('#Tag').tagit('addTags', data);
				}
				
            }
    });
	//alert("title:"+title);
	//alert("content:"+content);
}

//自动提取缩略图
function getPhotoFromContent()
{
	Save_Content();//先保存当前内容
	var content = "";
	for(var i=1;i<=Pages;i++)
	{
		content = content + Contents[i-1];
	}
	jQuery.ajax({
			type : "POST",
			url : "../content/get_photo_from_content.jsp",
			dataType : "html",
			data: {content:content},
            success : function(data){
				$("#Photo").val(data);				
            }
    });
}

function showSelectButton(field,channelid,button,width,height,listnum)
{
	var html = "<input type='button' value='"+button+"' class='tidecms_btn3' id='btn_"+field+"'>";
	$("#field_"+field).append(html);
	if(!width) width = 600;
	if(!height) height = 450;
	if(!listnum) listnum = 20;
	$("#btn_"+field).click(function(){
			var	dialog = new TideDialog();
			dialog.setWidth(width);
			dialog.setHeight(height);
			dialog.setLayer(2);
			dialog.setScroll('auto');
			dialog.setUrl("../content/content_select.jsp?id="+channelid+"&field="+field+"&rowsPerPage="+listnum);
			dialog.setTitle(button);
			dialog.show();
	});
}

function Save_Content()
{
	//保存正文,内容
	//document.ContentEditor.preparesubmit();
	//var editor = document.getElementById("FCKeditor1___Frame").contentWindow;
	//var FCK			= editor.getFCK() ;
	//var FCKConfig	= editor.getFCKConfig();
	var rows = document.getElementById("tabTableRow").cells;
	for (var i=0;i<rows.length;i++){//alert(rows[i].className);
		if (rows[i].className=="selTab"){
			//rows[i].className = "tab";
			var rows_page = rows[i].getAttribute("page");
			Contents[rows_page-1] = CKEDITOR.instances['FCKeditor1'].getData()
			//处理分页符
			var symbol = '<div style="page-break-after: always;"><span style="DISPLAY:none">';
			//当前内容中含有分页符的话，在Contens[rows_page-1]元素后插入一页，把当前内容分为两部分，把最后一部分内容插入到新的内容页
			if(Contents[rows_page-1].indexOf(symbol)>-1)
			{
				var temp=Contents[rows_page-1].split(symbol);
				Pages +=(temp.length-1);
				Contents[rows_page-1] = temp[0];
				for(var j=0;j<temp.length-1;j++)
				{
					// 拼接函数(索引位置, 要删除元素的数量, 元素)  
					if(j==0)
						Contents[rows_page-1]=temp[0];//更改当前页的内容
					 Contents.splice(i+j+1, 0, temp[j+1]);  //在当前页面后面追加一页，后面的向后顺延
				} 
			}
			}
		}
	var localhost = document.location.protocol+ "//" + document.location.hostname;
	if (document.location.port!="80")
  		localhost = localhost + ":" + document.location.port;
 	if(SiteAddress!="")localhost=SiteAddress;
	var reg = new RegExp(localhost,"g");
	if(Pages<=1)
	{
		var str = Contents[0];
		str = str.replace(reg, ""); //alert(str);

		document.form.Content.value = str;
		document.form.Page.value = "1";
	}
	else
	{
		for(var i=1;i<=Pages;i++)
		{
			var str = Contents[i-1];//document.all.ContentEditor.GetContent(i);
			str = str.replace(reg, "");

			if(i==1)
				document.form.Content.value = str;
			else
			{
				var o = $("#Content"+i);
				if(o.size()>0) 
					o.val(str);
				else 
					$('<input>').attr({type: 'hidden',id:"Content"+i,name:"Content"+i,value:str}).appendTo($(form));
			}
		}
		
		document.form.Page.value = Pages + "";
	}
}

//编辑互斥
function isSaved()
{
	$.ajax({
		type : "post",
		url : "issaved.jsp",
		data: "globalid="+GlobalID,
        dataType:"text",
		success : function(mtime)
		{
			//begin_time、mtime  单位:秒
			var time = begin_time - parseInt(mtime);			 
			if(time<=0)
			{
				var message = "本文章已被他人修改，是否继续保存？";
				if(!confirm(message))return;
			}
		}
		});
	 
}
//分类功能
function category(fieldname,channelid,type)
{
	var	dialog = new TideDialog();
	dialog.setWidth(930);
	dialog.setHeight(550);
	dialog.setLayer(2);
	dialog.setUrl("../category/category.jsp?ChannelID="+channelid+"&field="+fieldname+"&type="+type);
	dialog.setTitle("分类");
	dialog.show();
}


function choose(field,channelid,type)
{
	$("#field_"+field).append("<input type=\"button\" class=\"tidecms_btn3\" onclick=\"category('"+field+"',"+channelid+",'"+type+"')\" value=\"选择\">");
	//category(field,channelid);
}

//上传文件
function selectFile(fieldname)
{
	var	dialog = new TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(400);
	dialog.setLayer(2);
	dialog.setUrl("../content/insertfile.jsp?Type=file&ChannelID="+channelid+"&fieldname="+fieldname);
	dialog.setTitle("上传文件");
	dialog.show();
}

//上传图片
function selectImage(fieldname)
{
	var	dialog = new TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(400);
	dialog.setLayer(2);
	dialog.setUrl("../content/insertfile.jsp?ChannelID="+channelid+"&Type=Image&fieldname="+fieldname);
	dialog.setTitle("上传图片");
	dialog.show();
}
