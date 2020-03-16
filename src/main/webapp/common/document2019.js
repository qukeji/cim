if (typeof new_editor == "undefined"){window.new_editor=0;}else{window.new_editor=1}

$(function(){
	window.onbeforeunload=function(e){
//		if(document.getElementById("Image1Href").href == "javascript:Save();"){
		if(unload){
			return "直接离开页面将丢失没有保存的修改！";
		}
	}
});

$(function() {
	init();

//	$.browser.chrome = /chrome/.test(navigator.userAgent.toLowerCase());
/*	if($.browser.mozilla || $.browser.chrome){
		
		$(document).bind("dragenter",function(event) {return false; }).bind("dragover", function(event) {					event.stopPropagation(); event.preventDefault();return true; }).bind("drop", function(event) { 					event.stopPropagation(); event.preventDefault();return true; })
		
		$(".upload").each(function(i){
			tidecms.uploadHtml5($(this),"insertimage_submit.jsp",{ChannelID:channelid,success:function(o,a){a=$.trim(a);var oo = eval("("+a+")");if(oo.status==0){alert(oo.message);}if(oo.status==1){o.val(oo.message);}}});
		});
	}
*/
	//封面图字段预览
	$( ".field_image" ).tooltip({
		title : function() {
			var s = $(this).val();
			if(s!=""){
				if(s.indexOf("http://")<0){
					s = SiteAddress + s ;
				}
				return "<img width=150 src='"+s+"'>";
			}else{
				return "";
			} 
		},
		placement : "bottom",
		toggle : "tooltip",
		animation : false,
		html : true,
		delay : {
			show : 500,
			hide : 100,
		},
		container : 'body'
	});

	//提取缩略图
	$( "#tr_Photo .row" ).append("\r\n<label><input type=\"button\" value=\"自动提取\" onclick=\"getPhotoFromContent()\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>");
	
	//初始化编辑器
	initContent();
});

//refresh为true，刷新url
function showTab(n,refresh)
{
	if(document.body.disabled) return;

	var num = groupnum;
	for(i=1;i<=num;i++)
	{
		$("#form"+i).hide();
		$("#form"+i+"_td").removeClass('active');
	}
	$("#form"+n+"_td").addClass('active');
	$("#form"+n).show();
	var url = $("#form"+n).attr("url")+"";//alert(url);
	url = url.replace("itemid=0","itemid="+$("#ItemID").val());
	url = url.replace("globalid=0","globalid="+$("#GlobalID").val());
	if(url!="")
	{
		if($("#iframe"+n).attr("src")=="../null.jsp" || refresh) $("#iframe"+n).attr("src",url);//document.getElementById("iframe"+n).src = url;
	}
}



//关键词热键 ctrl+shift+k
document.onkeyup=function(event){
  var e=e||window.event;
  var keyCode=e.keyCode||e.which;
   if (e.ctrlKey&&e.shiftKey&& e.keyCode == 75){  　
 　　　getAutoKeyword('Keyword');
   }
}

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
		//alert("请输入标题!");
		ddalert("请输入标题!","(function dd(){getDialog().Close({suffix:'html'});})()");
		document.form.Title.focus();
		return false;
	}
	
	if(n>100)
	{
		//alert("标题太长!");
		ddalert("请输入标题!","(function dd(){getDialog().Close({suffix:'html'});})()");
		document.form.Title.focus();
		return false;
	}

	if($("#PublishDate").size()>0 && $("#PublishDate").val()!="")
	{
		//去除空格
		$("#PublishDate").val(($("#PublishDate").val()).replace(/(^[\\s]*)|([\\s]*$)/g, ""));
		if(!checkIsValidDate($("#PublishDate").val()))
		{
			//alert("请输入正确日期! 例如:2046-12-25 10:04:07");
			ddalert("请输入正确日期! 例如:2046-12-25 10:04:07","(function dd(){getDialog().Close({suffix:'html'});})()");
			document.form.PublishDate.focus();
			return false;
		}
	}

	
	try {document.form.RelatedItemsList.value = document.getElementById("related_doc_list").contentWindow.getCheckedItem();} catch(err) {}

	if ( typeof(check2) == 'function' ) return check2();
	
	var Description = ""; 
	var inputs = $(".disable_blank > input[type='text']");
	for(var i =0;i<inputs.length;i++)
	{
		var value = inputs[i].value;
		if(value=="")
		{
			var id = inputs[i].id ;
			if(Description!=""){
				Description += ",";
			}
			Description += $("#desc_"+id).text().replace("：","");
		}
	}
	if(Description!=""){
		//alert(Description+"字段内容不允许为空");
		ddalert(Description+"字段内容不允许为空","(function dd(){getDialog().Close({suffix:'html'});})()");
		return false;
	}
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

	saveCurrentContent();
	Contents[Contents.length] = "";
	for (var i=Pages;i>curPage+1;i--){
		Contents[i-1] = Contents[(i-2)];//alert((i-1)+":"+Contents[i-1]+","+(i-2)+":"+Contents[i-2]);
	}
	
	Contents[curPage] = "";

	SetActive(curPage+1);
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
		if(window.new_editor==0)
		{
			setContent(Contents[curPage-1],false);
		}
		else
		{
			setContent(Contents[curPage-1],false);
		}
}
function saveCurrentContent(){
	var rows = document.getElementById("tabTableRow").cells;
	for (var i=0;i<rows.length;i++){
		if (rows[i].className=="selTab"){
			var page = rows[i].getAttribute("page");
			if(window.new_editor==0){
				Contents[page-1] = getContent();
			}else{
				Contents[page-1] = getContentTxt;//CKEDITOR.instances.editor1.getData();
			}
		}
	}
}

function SetActive(num){
	var currentTab;//alert("SetActive:"+num+"::"+Contents);
	var rows = document.getElementById("tabTableRow").cells;
	for (var i=0;i<rows.length;i++)
	{
		rows[i].className = "tab";
	}
	currentTab = document.getElementById("t" + num);
	currentTab.className = "selTab";
	try{
		var page2 = currentTab.getAttribute("page");

		if(window.new_editor==0)
		{
			setContent(Contents[page2-1],false);
		}
		else
		{
			setContent(Contents[page2-1],false);
		}
		}catch(e){}
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
	("../modal_dialog.jsp?target=recommend/recommend_item.jsp&FieldID=" + field,myObject,Feature);

	var width  = Math.floor( screen.width  * .8 );
	var height = Math.floor( screen.height * .85 );
	var leftm  = Math.floor( screen.width  * .1);
	var topm   = Math.floor( screen.height * .05);
	var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
	var url="../recommend/recommend_item.jsp?FieldID=" + field;
	window.open(url,"",Feature);
}

function recommendItemJS(itemid,channelid,souceChannelID,Target)
{
	var url = "../recommend/recommend_in_js.jsp";
	if(Target) url = Target;
	scr = document.createElement('script')
	scr.src = url + '?FieldID=' + curField + "&ItemID=" + itemid + "&ChannelID=" + channelid + "&sourceChannelID=" + souceChannelID;
	//alert(scr.src);
	document.getElementById('ajax_script').appendChild(scr);
}

function recommendOutItemJS(itemid,channelid,souceChannelID,Target)
{
	var url = "../recommend/recommend_out_js.jsp";
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
	oFCKeditor = new FCKeditor(name) ;
	oFCKeditor.BasePath	= '../editor/' ;
	oFCKeditor.Value	= '<p>This is some <strong>sample text<\/strong>. You are using <a href="http://www.fckeditor.net/">FCKeditor<\/a>.<\/p>' ;
	oFCKeditor.ReplaceTextarea() ;
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
			dataType : "JSON",
			data: {content:content,channelid:channelid},
            success : function(data)
			{
				if(data.length==0)
				{
					var keyword = $("#Keyword").val();
					 $("#field_Photo span").remove();
					 $("#field_Photo input:last").after("<span style='margin:10px;'>正文中没有可用图片，请使用<a href='http://image.baidu.com/search/index?tn=baiduimage&word="+keyword+" ' target='_blank'><font style='text-decoration:underline'>百度</font></a>搜索<span>");
				}
				else if(data.length==1)
				{
					$("#Photo").val(data[0].img);
				}
				else
				{
					var img = "[";
					$.each(data,function(index,obj){
						img+="{'img':'"+obj.img+"'}";
						if(index<(data.length-1))
							img+=",";
					}); 
					img +="]"
				  	var	dialog = new TideDialog();
					dialog.setWidth(600);
					dialog.setHeight(480);
					dialog.setLayer(2);
					dialog.setScroll('auto');
					dialog.setUrl("../content/photo_list_from_content.jsp?imgs="+img.toString()+"&channelid="+channelid);
					dialog.setTitle("图片提取");
					dialog.show();
				}
            }
			
    });
	  
}


function chooseImage(img)
{
	$("#Photo").val(img);
	$("#img_list").remove();
}

function showSelectButton(field,channelid,button,width,height,listnum)
{
	var html = "<input type='button' value='"+button+"' class='btn btn-primary tx-size-xs mg-l-10' id='btn_"+field+"'>";
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
	if(window.new_editor==0)
		Save_Content_1();
	else
	{
		//alert(CKEDITOR.instances.editor1.getData());
		Save_Content_2();
	}
}
function Save_Content_1()
{
	//保存正文,内容
	var rows = document.getElementById("tabTableRow").cells;
	for (var i=0;i<rows.length;i++){//alert(rows[i].className);
		if (rows[i].className=="selTab"){
			//rows[i].className = "tab";
			var rows_page = rows[i].getAttribute("page");
			Contents[rows_page-1] = getContent();//获取编辑器内容  FCK.GetXHTML( FCKConfig.FormatSource );
			//处理分页符
			var symbol = '<div style="page-break-after: always;"><span style="DISPLAY:none"> </span></div>';
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
 	if(SiteAddress!="")localhost=SiteAddress+"/";
	var reg = new RegExp(localhost,"g");
	//保存时把内容中图片地址替换为外网地址
	var url_reg = new RegExp(inner_url+"/","g");
	if(Pages<=1)
	{
		var str = Contents[0];
		str = str.replace(reg, "/").replace(url_reg,outer_url+"/"); //alert(str);

		document.form.Content.value = str;
		document.form.Page.value = "1";
	}
	else
	{
		for(var i=1;i<=Pages;i++)
		{
			var str = Contents[i-1];//document.all.ContentEditor.GetContent(i);
			str = str.replace(reg, "/").replace(url_reg,outer_url+"/");;

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
function Save_Content_2()
{
	//保存正文,内容
	var rows = document.getElementById("tabTableRow").cells;
	for (var i=0;i<rows.length;i++){//alert(rows[i].className);
		if (rows[i].className=="selTab"){
			//rows[i].className = "tab";
			var rows_page = rows[i].getAttribute("page");
			Contents[rows_page-1] = getContent();//获取编辑器内容  CKEDITOR.instances.editor1.getData();
			//处理分页符
			var symbol = '<div style="page-break-after: always;"><span style="DISPLAY:none"> </span></div>';
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
 	if(SiteAddress!="")localhost=SiteAddress+"/";
	var reg = new RegExp(localhost,"g");
	//保存时把内容中图片地址替换为外网地址
	var url_reg = new RegExp(inner_url+"/","g");
	if(Pages<=1)
	{
		var str = Contents[0];
		str = str.replace(reg, "/").replace(url_reg,outer_url+"/"); //alert(str);

		document.form.Content.value = str;
		document.form.Page.value = "1";
	}
	else
	{
		for(var i=1;i<=Pages;i++)
		{
			var str = Contents[i-1];//document.all.ContentEditor.GetContent(i);
			str = str.replace(reg, "/").replace(url_reg,outer_url+"/");

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
		url : "../content/issaved.jsp",
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
	$("#field_"+field).append("<input type=\"button\" class=\"btn btn-primary tx-size-xs mg-l-10\" onclick=\"category('"+field+"',"+channelid+",'"+type+"')\" value=\"选择\">");
	//category(field,channelid);
}

//上传文件
function selectFile(fieldname)
{
	var	dialog = new TideDialog();
		dialog.setWidth(730);
		dialog.setHeight(550);
		dialog.setLayer(2);
		dialog.setUrl("../content/insertfile.jsp?ChannelID="+channelid+"&Type=file&fieldname="+fieldname);
		dialog.setTitle("上传文件");
		dialog.show();
}

//上传图片 
function selectImage(fieldname)
{
	var	dialog = new top.TideDialog();
		dialog.setWidth(730);
		dialog.setHeight(550);
		dialog.setLayer(2);
		dialog.setUrl("../content/insertfile.jsp?ChannelID="+channelid+"&Type=Image&fieldname="+fieldname);
		dialog.setTitle("上传图片");
		dialog.show();
}

function initEditor()
{
	if (window.new_editor==0){
		$.ajax({
				url: "../editor/fckeditor.js",
				dataType: "script",
				cache: true
		}).done(function() {
		oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
		oFCKeditor.BasePath	= '../editor/' ;
		oFCKeditor.Height	= 600 ;
		$("#FCKeditor1").val(currcontent);
		$("#FCKeditor1___Config").after("<iframe id=\"FCKeditor1___Frame\" src=\"../editor/fckeditor.html?InstanceName=FCKeditor1&Toolbar=Default\" width=\"100%\" height=\"600\" frameborder=\"0\" scrolling=\"no\"></iframe>");				
		});
	}else
	{
		//使用新版编辑器 20160609
		window.CKEDITOR_BASEPATH = '../editor2016/';
		$.ajax({
			url: "../editor2016/ckeditor.js",
			dataType: "script",
			cache: true
			}).done(function() {

				$("#FCKeditor1___Config").after("<textarea name=\"editor1\" id=\"editor1\" rows=\"10\" cols=\"80\"></textarea>");
				//CKEDITOR.skinName = 'myskin,/customstuff/myskin/';
				var editor1 = CKEDITOR.replace( 'editor1',{
				on: {
				instanceReady: function() {
						CKEDITOR.instances.editor1.setData(currcontent);
						initContent1();
					}
				}});
				
			});
	}
}

//添加图片预览所需文件
var everAddLcj = false ;
function addCssJs(everAdd){
   if(!everAdd){
     var lightboxCss= document.createElement('link');
     lightboxCss.type = 'text/css';
     lightboxCss.rel = 'stylesheet';
     lightboxCss.href = '../style/9/lightbox.css';
     document.getElementsByTagName("head")[0].appendChild(lightboxCss);
		
     var lightboxJs  = document.createElement("script") ;
     lightboxJs.type = 'text/javascript';
     lightboxJs.src = '../common/lightbox.min.js';  
     $('body').append(lightboxJs);
   }   
}
//图片预览函数
function initPicsView(frid){         	
	var picBox = $("#iframe"+frid).contents().find("#content-table");	
	var allPic = picBox.find(".list-pic-box img") ;					
	var picSrcArr = [] ;
	var srcEach = "" ;
	$.each(allPic, function(vi,va) {
		srcEach = allPic.eq(vi).attr("data-src") ;
		if( $.trim(srcEach)!="" && typeof(srcEach)!="undefined" && srcEach){
			 picSrcArr.push( srcEach )
		}
	});
	if(picSrcArr.length==0){
		//alert("该页面无图片");
		ddalert("该页面无图片","(function dd(){getDialog().Close({suffix:'html'});})()");
		return false;
	}
        addCssJs(everAddLcj)
        everAddLcj = true ;
        if( $('.preview-pic-box').length == 0 ){
		var lightHtml = '<div class="preview-pic-box" style="visibility: hidden;height:0px;width:0px;margin:0;padding:0;overflow:hidden;"><ul></ul></div>' ;
    	        $('body').append(lightHtml);
	}
	$(".preview-pic-box ul").empty()
	$.each(picSrcArr, function(vi,va) {
		$(".preview-pic-box ul").append(
			'<li>'+
				'<a href="'+va+'" data-lightbox="roadtrip">'+
					'<img class="example" src="'+va+'" />'+
				'</a>'+					
			'</li>'
		)
	}); 
        lightbox.option({
          'resizeDuration': 200,
          'wrapAround': true ,
           'positionFromTop' : 80 ,
           'albumLabel':"" 
         })               
	$(".preview-pic-box ul img").eq(0)[0].click();       
}


//alert定制
function ddalert(message,confirm_){
	var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(250);
		dialog.setTitle('提示');
		dialog.setMsg(message);
		dialog.setMsgJs(confirm_);
		dialog.ShowMsg();
}


