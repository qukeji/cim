if (typeof new_editor == "undefined"){window.new_editor=0;}else{window.new_editor=1} ;

var	dialog = new top.TideDialog();

$(function() {
	window.onbeforeunload=function(e){
		if(unload){
			return "直接离开页面将丢失没有保存的修改！";
		}
    }
	
	try{
		init();
	}catch(e){
		console.log("init()报错",e)
	}

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
function showTab(n,refresh){
	if(document.body.disabled) return;
	adjustStyle(n) ;
	var num = groupnum;
	for(i=1;i<=num;i++){
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
	//内容编辑页自适应iframe高度
	if($("#form"+n).find("iframe").length>0){
		var ifram = $("#form"+n).find("iframe") ;
		//$("#form"+n).find(".br-content-box").css("background-color","#e9ecef")
		//console.log( ifram.get(0).id )
		if( ifram.get(0).id=="oneDocManySend" ){
			var h = $(window).height();
			ifram.get(0).style.height = h - 70 +"px" ;
		}else{
			if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
				ifram.get(0).style.height = ifram.get(0).contentWindow.document.body.scrollHeight+5+"px";
			}else{
				ifram.get(0).style.height = ifram.get(0).contentWindow.document.documentElement.scrollHeight+5+"px";
			}
		}
		
	}
	
}

function childAdjustFrameH(eleId){
	if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
		$(eleId).get(0).style.height = $(eleId).get(0).contentWindow.document.body.scrollHeight+5+"px";
	}else{
		$(eleId).get(0).style.height = $(eleId).get(0).contentWindow.document.documentElement.scrollHeight+5+"px";
	}
}

function adjustStyle(num){
	if(num!=1){
		$("#form").addClass("others")
	}else{
		$("#form").removeClass("others")
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
		dialog.showAlert( "请输入标题!" ,"danger" );
		//ddalert("请输入标题!","(function dd(){getDialog().Close({suffix:'html'});})()");
		document.form.Title.focus();
		return false;
	}
	
	if(n>100)
	{
		//alert("标题太长!");
		dialog.showAlert( "标题太长!" ,"danger" );
		//ddalert("请输入标题!","(function dd(){getDialog().Close({suffix:'html'});})()");
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
			dialog.showAlert( "请输入正确日期! 例如:2046-12-25 10:04:07" ,"danger" );
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
		dialog.showAlert( Description+"字段内容不允许为空" ,"danger" );
		//ddalert(Description+"字段内容不允许为空","(function dd(){getDialog().Close({suffix:'html'});})()");
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
				if(data.length==0){
					var keyword = $("#Keyword").val();
					 $("#field_Photo span").remove();
					 $("#field_Photo input:last").after("<span style='margin:10px;'>正文中没有可用图片，请使用<a href='http://image.baidu.com/search/index?tn=baiduimage&word="+keyword+" ' target='_blank'><font style='text-decoration:underline'>百度</font></a>搜索<span>");
				}else if(data.length==1){
					$("#Photo").val(data[0].img);
				}else{
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

//上传视频
function selectVideo(fieldname)
{
	var	dialog = new TideDialog();
	dialog.setWidth(900);
	dialog.setHeight(650);
	dialog.setLayer(2);
	dialog.setUrl("../video/field_video.jsp?userid="+userId+"&fieldname="+fieldname);
	dialog.setTitle("上传视频");
	dialog.show();

}

//预览视频
function previewVideo(fieldname)
{
	var name = document.getElementById(fieldname).value;
	//图片库采用本地预览
	if(name=="") {
		dialog.showAlert("请先上传视频","danger");
	   return;
	}

	 window.open(name);
	
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

//图片字段编辑
function editImage(fieldname)
{
	var name = document.getElementById(fieldname).value;
	var reg = new RegExp(outer_url,"g");
	if(name=="") {
	    dialog.showAlert("请先上传图片!","danger");
	   return; 
	}
	if(name.indexOf("http://")!=-1 || name.indexOf("https://")!=-1)  var url=name.replace(reg,inner_url);
	else	var url=SiteAddress+"/" + name;
	var	dialog = new TideDialog();
	dialog.setWidth(1000);
	dialog.setHeight(620);
	dialog.setLayer(2);
	dialog.setUrl("../photo/photo_editor2019.jsp?ChannelID="+channelid+"&img="+url+"&fieldname="+fieldname) ;
	dialog.setTitle("编辑图片");
	dialog.show();
}
//预览图片
function previewFile(fieldname)
{
	var name = document.getElementById(fieldname).value;
	//图片库采用本地预览
	var reg = new RegExp(outer_url,"g");
	if(name==""){
		dialog.showAlert("请先上传图片!");
		return;
	} 
		

	if(name.indexOf("http://")!=-1 || name.indexOf("https://")!=-1)  window.open(name.replace(reg,inner_url));
	else	window.open(SiteAddress + "/" + name);
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
		dialog.showAlert("该页面无图片","danger");
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
//稿件审核
function SaveApprove(action){
	var user = $("#approve").attr("user");
	var approveId = $("#approve").attr("approveId");
	var endApprove = $("#approve").attr("end");
	var actionMessage = $("#approve").val();
	if(action==1&&actionMessage==""){
		dialog.showAlert( "请输入驳回理由!" ,"danger" );
		if( !$(".r-nav-approve a").hasClass("ac") ){
			$(".r-nav-approve")[0].click() ;
		}
		$("#approve").focus() ;
		return false ;
	}
	var title = $("#Title").val();
	var enTitle= encodeURI(title);
	var url= "../approve/approve_sumbit.jsp?globalid="+GlobalID+"&title="+enTitle+"&action="+action+"&user="+user+"&approveId="+approveId+"&endApprove="+endApprove+"&actionMessage="+actionMessage;
	$.ajax({
		 type: "GET",
		 url: url,
		 success: function(msg){
			 if(msg.trim()!=""){
				dialog.showAlert(msg.trim() ,"danger");
			 }else{
				if(action==0){
			         if(endApprove==1){//终审
						Save_Publish();
					}else{
						Save();	
					}
			    }else{
			        window.onbeforeunload =function() {
                        return null;
                    }
		            document.location.reload();
			    }
			 }
		 }   
	}); 
}
//刷新相关文章的iframe页面
function intervalGgheight(index){
    var t1 = window.setTimeout(function() {
        showTab(index,true);
        window.clearTimeout(t1);
    },1000);
}


//调整编辑器内容输入区定位
function adjustInputArea(){
	var edui1_toolbarbox  = $("#edui1_toolbarbox"),
	toolbarH  = edui1_toolbarbox.height() ? edui1_toolbarbox.height() : 98 ;
	$("#edui1_iframeholder").css({
		"top" : toolbarH+"px"
	})
}

function afterEditorInit(){
	 adjustInputArea() ;
}

$(window).on("resize",function(){
	adjustInputArea();
})
  
//新版编辑器部分
 
var loadingHtml = '<div class="loading"><div class="imgbox"><img src="../static/img/video_loading.gif"></div></div>';  //loading html
var htmlHasContent = true ;
$(function () {
	
	//添加页面布局按钮
	var edHtml = "" ;
	edHtml += '<div class="left_btn_change" >'+ 
			'<div class="editor_logo">' +
				'<span class="bigger_tle">T</span>editor'+
			'</div>'+
			'<div class="layout_change">'+
				'<span id="l-editor-r" data-index="1" class="active btn_change_item"><img src="../static/img/layout-l-editor-r-active.png"/></span>'+
				'<span id="editor-r" data-index="2" class="btn_change_item"><img src="../static/img/layout-editor-r.png"></span>'+
				'<span id="l-editor" data-index="3" class="btn_change_item"><img src="../static/img/layout-l-editor.png"></span>'+
				'<span id="only-editor" data-index="4" class="btn_change_item"><img src="../static/img/layout-only-editor.png"/></span>'+
			'</div>'+
			'<div class="col-change"></div>'+
			'<div class="equipment_change">'+
				'<span id="layout_phone" data-index="1" class="btn_change_item "><i class="fa fa-tablet"></i></span>'+
				'<span id="layout_pc" data-index="2" class="btn_change_item active"><i class="fa fa-television"></i></span>'+
			'</div>'+
		'</div>' ;
	$(".br-header").append(edHtml) 
    
	if( $("body").hasClass("no-content-body") ){   
		htmlHasContent = false ; 
		$(".layout_change").find(".btn_change_item").removeClass("active");
		$("#only-editor").addClass("active").find("img").attr("src","../static/img/layout-only-editor-active.png");
		$(".main_right .r-c-others").css({
			"transition":"all 0.3s","flex":"0 0 0px","height":"0%","width":"0px"
		})
		$(".main_right .article-title").css({
			"border-right":"none","flex":"0 0 100%",
		})
	}
	//资源区域
	var h5Html = ""
	h5Html += `<div class="left_h5edit" id="h5edit">
				<ol class="tab-nav">
					<li data-index="0" class="ac" id="plate">模板</li>
					<li data-index="1">图片</li>
					<li data-index="2">视频</li>
					<li data-index="3">图文</li>
					<li data-index="4">线索</li>
				</ol>
		    <div class="left-box">
			    <div class="left-item left-item1">
				  <div class="h5_template" id="h5_template">     
						<div id='template_nav'></div>
						<div id='template_content'><div class='content_child'></div></div>
				  </div>
			    </div>
			    <div class="left-item photo-item" id="photo-item">
				    <div class="search-box">
						<select id="photoSelect" class="select">
							<option value="0" selected>全部图片</option>
							<option value="2">我的图片</option>
							<option value="1">回传图片</option>
						</select>
						<input type="text" class="form-control key-words" placeholder="关键词">
						<div class="search-btn-group">
							<a href="javascript:;" class="" id="photoSearch"><i class="fa fa-search"></i></a>
							<a href="javascript:;" class="" style="display:none;"><i class="fa fa-refresh"></i></a>
							<a href="javascript:;" data-type="photo" class="mediaupload" ><i class="fa fa-arrow-circle-up"></i></a>
						</div>
					</div>
					<div class="photo-box">
						<div class="photo-box-content">
							
						</div>
					</div>
				</div>
				<div class="left-item video-item" id="video-item">
					<div class="search-box">
						<select id="videoSelect" class="select">
							<option value="1" selected>全部视频</option>
							<option value="0">我的视频</option>
							<option value="2">PGC视频</option>
						</select>
						<input type="text" class="form-control key-words" placeholder="关键词">
						<div class="search-btn-group">
							<a href="javascript:;" class="" id="videoSearch"><i class="fa fa-search"></i></a>
							<a href="javascript:;" class="" style="display:none;"><i class="fa fa-refresh"></i></a>
							<a href="javascript:;" data-type="video" class="mediaupload"><i class="fa fa-arrow-circle-up"></i></a>
						</div>
					</div>
					<div class="video-box">
						<div class="video-box-content">
							
					    </div>
					</div>
				</div>
				<div class="left-item left-item4">
					<div class="search-box">
						<div>
							<select class="downd">
								<option value="volvo">其他..</option>
							</select>
						</div>
						<div>
							<input type="text" class="form-control" placeholder="关键词">
						</div>
						<div>
							<span class="iconfont icon-sousuo2"></span>
							<span class="iconfont icon-shuaxin1"></span>
							<span class="iconfont icon-icon_huidingbu"></span>
						</div>
					</div>
					<div class="">
						
					</div>
				</div>
				<div class="left-item left-item5">
					<div class="search-box">
						<div>
							<select class="downd">
								<option value="volvo">其他..</option>
							</select>
						</div>
						<div>
							<input type="text" class="form-control" placeholder="关键词">
						</div>
						<div>
							<span class="iconfont icon-sousuo2"></span>
							<span class="iconfont icon-shuaxin1"></span>
							<span class="iconfont icon-icon_huidingbu"></span>
						</div>
					</div>
					<div class="">
						
					</div>
		 </div>`
	$("#main_left").append(h5Html)
	
	//页面布局切换
	$(".br-header").on("click", ".layout_change .btn_change_item", function () {
		var _index = $(this).attr("data-index") ;
		
		if(htmlHasContent){  //如果有内容字段,即存在编辑器
			if( isEditInterface() != 0){
				dialog.showAlert( "请在内容编辑下调整布局!" ,"danger" );
				return false;
			}
			changeLayoutBgImg(_index) ;  //更换按钮背景图
			adjustLayout(_index) ;       //调整页面布局
		}else{
			styleWithNoContent(_index) ;  //无内容字段 
		}
		
		$(this).parent().find(".btn_change_item").removeClass("active");
		$(this).addClass("active") ;
	})
	
	function styleWithNoContent(i){
		if(i==2){
			$(".main_right .r-c-others").css({
				"transition":"all 0.3s","flex":"0 0 450px","height":"100%","width":"450px"
			})
			$(".main_right .article-title").css({
				"border-right":"2px solid #e9eff3","flex":"1"
			})
			$("#editor-r img").attr("src","../static/img/layout-editor-r-active.png")
			$("#only-editor img").attr("src","../static/img/layout-only-editor.png")
		}else if(i==4){
			$(".main_right .r-c-others").css({
				"transition":"all 0.3s","flex":"0 0 0px","height":"0%","width":"0px"
			})
			$(".main_right .article-title").css({
				"border-right":"none","flex":"0 0 100%",
			})
			$("#editor-r img").attr("src","../static/img/layout-editor-r.png")
			$("#only-editor img").attr("src","../static/img/layout-only-editor-active.png")
		}
	}
	//是否是编辑界面
	function isEditInterface(){
		var activeNav =  $("#header_nav .br-menu-link") ;
		var index = 0 ;
		$.each(activeNav,function (i,el) {
			if($(el).hasClass("active")){
				index = i ;
			}
		})
		return index ;
	}
	//更换按钮背景图
	function changeLayoutBgImg(num){
		var index = Number(num) ;
		switch (index){
			case 1:
				$("#l-editor-r img").attr("src","../static/img/layout-l-editor-r-active.png")
				$("#editor-r img").attr("src","../static/img/layout-editor-r.png")
				$("#l-editor img").attr("src","../static/img/layout-l-editor.png")
				$("#only-editor img").attr("src","../static/img/layout-only-editor.png")
				break;
			case 2:
				$("#l-editor-r img").attr("src","../static/img/layout-l-editor-r.png")
				$("#editor-r img").attr("src","../static/img/layout-editor-r-active.png")
				$("#l-editor img").attr("src","../static/img/layout-l-editor.png")
				$("#only-editor img").attr("src","../static/img/layout-only-editor.png")
				break;
			case 3:
				$("#l-editor-r img").attr("src","../static/img/layout-l-editor-r.png")
				$("#editor-r img").attr("src","../static/img/layout-editor-r.png")
				$("#l-editor img").attr("src","../static/img/layout-l-editor-active.png")
				$("#only-editor img").attr("src","../static/img/layout-only-editor.png")
				break;
			case 4:
				$("#l-editor-r img").attr("src","../static/img/layout-l-editor-r.png")
				$("#editor-r img").attr("src","../static/img/layout-editor-r.png")
				$("#l-editor img").attr("src","../static/img/layout-l-editor.png")
				$("#only-editor img").attr("src","../static/img/layout-only-editor-active.png")
				break;
			default:
				break;
		}
	}
	//调整页面布局
	function adjustLayout(index){
		var doc_main = $("#doc_main") , 
		    form1 =  $("#form1") ,   
			main_left =  $("#main_left") ,         //左边模板
			main_content =  $("#main_content") ,   //中间编辑器
			main_right =  $("#main_right") ,       //右边表单
			edui1_message_holder = $("#edui1_message_holder") ;   //编辑器内容输入区
		
		if( index == 1){         //左边模板,中间编辑器,右边表单
			main_left.css({
				"transition":"all 0.3s","flex":"0 0 450px","height":"100%","width":"450px"
			});
			main_right.css({
				"transition":"all 0.3s","flex":"0 0 450px","height":"100%","width":"450px"
			});
		}else if(index == 2){    //左边编辑器,右边表单
			main_left.css({
				"transition":"flex 0.3s","flex":"0 0 0px","height":"0%","width":"0px"
			});
			main_right.css({
				"transition":"all 0.3s","flex":"0 0 450px","height":"100%","width":"450px"
			});
			
		}else if( index == 3){    //左边模板,右边编辑器
			main_left.css({
				"transition":"all 0.3s","flex":"0 0 450px","height":"100%","width":"450px"
			});
			main_right.css({
				"transition":"flex 0.3s","flex":"0 0 0px","height":"0%","width":"0px"
			});
		}else if( index == 4){    //仅编辑器(全屏)
			main_left.css({
				"transition":"flex 0.3s","flex":"0 0 0px","height":"0%","width":"0px"
			});
			main_right.css({
				"transition":"flex 0.3s","flex":"0 0 0px","height":"0%","width":"0px"
			});
		}
		setTimeout(function(){
			adjustInputArea();
		},300)
	}
	
	//编辑器展示设备类型切换
	$(".br-header").on("click", ".equipment_change .btn_change_item", function () {
		if(isEditInterface()!=0){
			dialog.showAlert( "请在内容编辑下调整布局!" ,"danger" );
			return false;
		}
		var _index = Number( $(this).attr("data-index") )  ;

		$(this).siblings().removeClass("active").end().addClass("active") ;
		var EwapW = $(window).width() > 1440  ? "510px" : "420px" ;
		switch (_index){
			case 1:
			console.log(_index)
				$("#edui1_iframeholder").css({ 
					"transition":"width 0.3s","width": EwapW ,"margin": "0 auto",
				})
				break;
			case 2:
				$("#edui1_iframeholder").css({ 
					"transition":"width 0.3s","width": "100%","margin": "0 auto"
				})
				break;
			default:
				break;
		}
		adjustInputArea();
	})

  
	//左侧模板选项卡切换逻辑：
	var havaload = {
		imamge : false ,
		video : false 
	}
	$("body").on("click","#h5edit .tab-nav li",function() {
		var index = $(this).index();
		if(index == 0){
			
		}else if(index == 1){
			if(!havaload.imamge){
				loadImage();
			}
			havaload.imamge = true ;
		}
		else if(index == 2){
			if(!havaload.video){
				loadVedio();
			}
			havaload.video = true ;
		}
		$("#h5edit .left-box .left-item").eq(index).addClass('e').fadeIn().siblings().fadeOut().removeClass('e');
		$(this).addClass("ac").siblings().removeClass('ac') ;
		return false ;
	})
  
    var isDisplayApprove = false ;  //是否有审核
	if( $("div[data-approve='1']").length > 0 ){
		isDisplayApprove = true ;
	}
    var mainRNavHtml = 	'<div class="main_right_nav">' +
			'<ul>'+
				'<li><a href="javascript:;" class="ac">编辑</a></li>' ;
			mainRNavHtml+=	isDisplayApprove ? '<li class="r-nav-approve" data-item="approve"><a href="javascript:;">审核</a></li>' : '' ; 
				//'<li class="r-nav-version"><a href="javascript:;">版本</a></li>'+
			mainRNavHtml+=	'<li class="r-nav-annotate" data-item="annotate"><a href="javascript:;">批注</a></li>'+
			'</ul>'+
		'</div>';
	var othersContent = '<div class="approve-box others-item"><div class="approve-content"></div></div>' +
						'<div class="annotate-box others-item"><div class="annotate-content"></div></div>' ;
    $("#main_right").prepend(mainRNavHtml);
	$(".main_right_box .r-c-others").append(othersContent);
	if(isDisplayApprove){
		getApproveList() ; //如果开启了审核,进页面就请求审核信息
	}
	//点击插入模板内容
	$("#main_left").delegate(".t_m_c","click",function(){
		 ue.execCommand("inserthtml",'<section class="_wxbEditor">'+$(this).html()+'</section>');
		 return false ;
	}); 
	//左侧模板部分的滚动刷新
	$("#template_content").scroll(function(){
		if($("#template_content").scrollTop() >= $(".content_child").height()-$("#template_content").height() -5 ) {
			if(loadmore.temp._switch){
				loadTemplateContent();	        	
				return false;
			}								
		}
	});
	//左侧图片部分的滚动刷新
	$(".photo-box").scroll(function(){
		if($(".photo-box").scrollTop() >= $(".photo-box-content").height()-$(".photo-box").height() -5 ) {
			if(loadmore.photo._switch){
				loadImage();	        	
				return false;
			}								
		}
	});
	
	//左侧图片的类型切换
	$("#photoSelect").change(function(){
		var type = $(this).find("option:selected").val() ;
		loadmore.photo.type = type ;
		loadmore.photo.page = 1 ;
		loadmore.photo.havaNextPage = true ; 
		loadmore.photo._switch = true ;
		loadmore.photo.keyword = "" ;
		//$(".photo-item").find(".key-words").val("")
		$(".photo-box").scrollTop(0)
		loadImage() ;
    });
	//图片的搜索  photoSearch
	$("body").delegate("#photoSearch","click",function(){
		var _val = $(this).parents(".search-box").find(".key-words").val() ;
		if( $.trim(_val) !=""){
			loadmore.photo.keyword  = _val ;
			loadmore.photo.page = 1 ;
			loadmore.photo.havaNextPage = true ; 
			loadmore.photo._switch = true ; 
			loadImage() ;
		}else{
			dialog.showAlert( "请输入搜索关键词！" ,"danger" );
		}
		
	})
	//图片插入编辑器
	$("body").delegate(".photo-i","click",function(){
		var imgSrc = $(this).find("img").attr("src") ;
		ue.execCommand("inserthtml",'<p style="text-align:center;"><img src="'+imgSrc+'" ></p>');
	})
	
	//图片,视频上传按钮
	$("body").delegate(".mediaupload","click",function(){
		var type = $(this).attr("data-type") ;
		console.log(type)
		if(type=="photo"){
			$(".edui-for-tcenter_images .edui-button-body").trigger("click") ;
		}else if(type=="video"){
			$(".edui-for-tcenter_video .edui-button-body").trigger("click") ;
		}
		return false ;
	})
	
	
	//左侧视频部分的滚动刷新
	$(".video-box").scroll(function(){
		if($(".video-box").scrollTop() >= $(".video-box-content").height()-$(".video-box").height() -5 ) {
			if(loadmore.video._switch){
				loadVedio();	        	
				return false;
			}								
		}
	});
	//左侧视频的类型切换
	$("#videoSelect").change(function(){
		var type = $(this).find("option:selected").val() ;
		loadmore.video.type = type ;
		loadmore.video.page = 1 ;
		loadmore.video.havaNextPage = true ; 
		loadmore.video._switch = true ;
		loadmore.video.keyword = "" ;
		//$(".video-item").find(".key-words").val("")
		$(".video-box").scrollTop(0)
		loadVedio() ;
	});
	//左侧视频的码率切换
	$("body").delegate(".rate-li-a","click",function(){
		var _that = $(this) ;
		var flv = _that.attr("data-flv") ;
		var text = _that.text() ;
		var rateA  = _that.parents(".video-i").find(".rateA") ;
		rateA.text(text).attr("data-flv",flv);
	});
	//视频的搜索  photoSearch
	$("body").delegate("#videoSearch","click",function(){
		var _val = $(this).parents(".search-box").find(".key-words").val() ;
		if( $.trim(_val) !=""){
			loadmore.video.keyword  = _val ;
			loadmore.video.page = 1 ;
			loadmore.video.havaNextPage = true ; 
			loadmore.video._switch = true ; 
			loadVedio() ;
		}else{
			dialog.showAlert( "请输入搜索关键词！" ,"danger" );
		}
		
	})
	//视频插入编辑器
	$("body").delegate(".add-to-editor","click",function(){
		//var flv = $(this).parents(".video-i").find("option:selected").attr("data-flv") ;
		var flv = $(this).parents(".video-i").find(".rateA").attr("data-flv") ;
		console.log(flv);
		if(flv){
			ue.execCommand("inserthtml",'<p style="text-align:center;"><video controls="controls" src="'+flv+'" ></video>');
		}
	})
	//视频预览
	$("body").delegate(".video-box .play-btn","click",function(){
		var flv = $(this).parents(".video-i").find(".rateA").attr("data-flv") ;
		if( ! $.trim(flv) ){
			dialog.showAlert("无有效视频地址！","danger")
			return false ;
		}
		var	dialog = new top.TideDialog();
		dialog.setWidth(1000);
		dialog.setHeight(650);
		dialog.setUrl("../ueditor/dialogs/video/videopreview.html?videoUrl="+flv);
		dialog.setTitle('视频预览');
		dialog.show(); 
		return false ;
	})
	
	
	//右侧编辑部分选项卡切换
	$("#main_right").delegate(".main_right_nav li","click",function(){
		var _index = $(this).index();
		var _item = $(this).attr("data-item") ;
		if( _index == 0){  //是为编辑
			$(".main_right_box .article-title").show();
			$(".main_right_box .r-c-others").hide();
		}else{
			$(".main_right_box .article-title").hide();
			$(".main_right_box .r-c-others").show();
			$(".others-item").hide() ;
			$("."+_item+"-box").show();
			if(_item == "approve"){
				//getApproveList();
			}
		}
		$(this).siblings("li").find("a").removeClass("ac") ; 
		$(this).find("a").addClass("ac") ;
	})
  
});

//获取审核列表
function getApproveList(){
	$.ajax({
		url:"/tcenter/approve/approve_info.jsp",
		data:{globalid:GlobalID,channelid:channelid},
		type:"get",
		success :function(data){
			$(".approve-content").html(data.trim());
			$(".approve-content").find(".card-body").removeClass("hide");
		},
		error:function(e){
			console.log(e)						
		}
	});
}

//左侧加载更多相关默认参数 
var loadmore =  {
	// page页码    pagenum每页数据量  everRequest是否请求过   havaNextPage是否有下一页   _switch开关,防止请求多次
	temp : {
		page:1 ,pagenum:20 ,everRequest:false ,havaNextPage:true ,_switch:true ,id:0 
	},
	photo : {
		page:1 ,pagenum:20 ,everRequest:false ,havaNextPage:true ,_switch:true , type:0 ,  //type 2代表我的脱氨  0图片库 1回传图片
		keyword:"" 
	},
	video : {
		page:1 ,pagenum:20 ,everRequest:false ,havaNextPage:true ,_switch:true, type:1 ,  //type 0代表我的  1全部 2pgc
		keyword:"" 
	},
}


//加载左栏图片
function loadImage() {
	if(!loadmore.photo.havaNextPage){
		dialog.showAlert( "已经加载完毕！" ,"danger" );
		return false;
	}	
	$.ajax({
		url:"../photo/list",
		type:"GET",
		dataType:"json",
		data : { page : loadmore.photo.page , type : loadmore.photo.type , keyword :loadmore.photo.keyword , pagenum:loadmore.photo.pagenum},
		beforeSend:function(XMLHttpRequest){
			if(loadmore.photo.page >= 1){
				$(".photo-item").append(loadingHtml);
				$(".photo-item .loading").show();
			}
			loadmore.photo._switch = false ;
		}, 
		success:function (res) {
			console.log(res);
			
			loadmore.photo.page ++ ;
			loadmore.photo._switch = true ;
			
			$(".photo-item .loading").remove();
			
			var list = res.data.list;
			var html = '';
			if(list.length > 0){
				for (var i = 0; i < list.length; i++) {
					html+='<div class="photo-i">'+
								'<div class="img-box">'+
									'<img src="'+list[i].photoAddr+'">'+
								'</div>'+
							'<p class="i-tl" title="'+list[i].title+'">'+list[i].title+'</p>'+
						'</div>';
				}
			}else{
				if(loadmore.photo.page<=2){
					dialog.showAlert( "该分类下暂无数据！" ,"" );
				}
			}
			if(loadmore.photo.page <= 2){
				$("#photo-item .photo-box-content").html(html);
			}else{
				$("#photo-item .photo-box-content").append(html);
			}	 
		},
		error:function(){
			loadmore.photo.havaNextPage = false ;
			$(".photo-item .loading").fadeOut("slow").remove();
			loadmore.photo._switch = false ;
			dialog.showAlert( "已经加载完毕！" ,"" );
		}
	})
}
//秒转化为时分秒
function secondsToTime(seconds){
 	var hh = parseInt(seconds/3600);  
 	if(hh<10) hh = "0" + hh;  
 	var mm = parseInt((seconds-hh*3600)/60);  
 	if(mm<10) mm = "0" + mm;  
 	var ss = parseInt((seconds-hh*3600)%60);  
 	if(ss<10) ss = "0" + ss;  
 	if(hh>=1){
 		var length = hh + ":" + mm + ":" + ss; 
 	} else{
 		var length = mm + ":" + ss; 
 	}
 	if(seconds > 0){  
 		return length;  
 	}else{  
 		return "00:00";  
 	}  
}
//获取当前时间  形如2017-11-17  或者 10:00:00 
;function getFormatDate1(str,type) {
	var date = str ? new Date(str) : new Date() ;   
    var seperator1 = "-";
    var seperator2 = ":";
    function addZero(m){
    	return m<10 ? '0'+m : m  ;
    }
    if(type==1){
    	var currentdate = date.getFullYear()+ seperator1 +addZero( date.getMonth()+1 ) + seperator1 + addZero( date.getDate() ) ;           
    }
    return currentdate;
}; 
//加载左栏视频
function loadVedio() {
	if(!loadmore.video.havaNextPage){
		dialog.showAlert( "已经加载完毕！" ,"danger" );
		return false;
	}	
	$.ajax({
		url:"../video/list",
		type:"GET",
		dataType:"json",
		data : {page:loadmore.video.page , type : loadmore.video.type , keyword : loadmore.video.keyword , pagenum:loadmore.video.pagenum },
		beforeSend:function(XMLHttpRequest){
			if(loadmore.video.page >= 1){
				$(".video-item").append(loadingHtml);
				$(".video-item .loading").show();
			}
			loadmore.video._switch = false ;
		}, 
		success:function (res) {
			console.log(res);
			loadmore.video.page ++ ;
			loadmore.video._switch = true ;
			
			$(".video-item .loading").remove();
			
			var list = res.data.list;
			var html = '';
			if(list.length > 0){
				for (var i = 0; i < list.length; i++) {
					if( list[i].videolist.length > 0 ){
						html+='<div class="video-i">'+
									'<div class="img-box">'+
										'<img src="'+list[i].coverhref+'">'+
										'<div class="video-duration">'+secondsToTime(list[i].duration)+'</div>'+
										'<div class="play-btn-box"><div class="play-btn"></div></div>'+
									'</div>'+
									'<div class="video-type">'+
										'<div class="creatTime">'+ getFormatDate1( list[i].createDate , 1) +'</div>';
										if(list[i].videolist.length > 0){
											
											// html += '<select class="select">';
											// for(var j=0 ; j < list[i].videolist.length ; j++){
											// 	html += '<option data-flv="'+list[i].videolist[j].flvurl+'" data-cover="'+list[i].videolist[j].coverhref+'" value="0">'+list[i].videolist[j].desc+'</option>' ;
											// }
											// html += "</select>"
											html += '<div class="ratebox">'+
												'<a class="rateA" href="" class="" data-flv="'+list[i].videolist[0].flvurl+'" data-cover="'+list[i].videolist[0].coverhref+'" data-toggle="dropdown">'+list[i].videolist[0].desc+'</a>'+
												'<div class="dropdown-menu wd-60">'+
												  '<ul class="">' ;
												  for(var j=0 ; j < list[i].videolist.length ; j++){
													html += '<li><a class="rate-li-a" data-flv="'+list[i].videolist[j].flvurl+'" data-cover="'+list[i].videolist[j].coverhref+'" href="javascript:;">'+list[i].videolist[j].desc+'</a></li>' ;
												  }
												html +=  '</ul>'+
												'</div>'+
											'</div>' ;
										}
										html += '<span class="add-to-editor" title="添加到编辑器"><i class="fa fa-plus-square-o"></i></span>'+
									'</div>'+
									'<p class="i-tl" title="'+list[i].title+'">'+list[i].title+'</p>'+
							'</div>';
					}
					
				}
			}else{
				if(loadmore.video.page<=2){
					dialog.showAlert( "该分类下暂无数据！" ,"" );
				}
			}
			if(loadmore.video.page <= 2){
				$("#video-item .video-box-content").html(html);
			}else{
				$("#video-item .video-box-content").append(html);
			}	 
		},
		error:function(){
			loadmore.video.havaNextPage = false ;
			$(".video-item .loading").fadeOut("slow").remove();
			loadmore.video._switch = false ;
			dialog.showAlert( "已经加载完毕！" ,"" );
		}
	})
}

//绑定导航事件
$.editorLeftTempNav = function(menu) {
	var _Speed = 300;
	var firstGroup = $(menu).find(".template_group:first") ;
	if( firstGroup && firstGroup.find(".t_g_detail li").length > 0 ){ //判断是否有第一组子项
		firstGroup.find(".t_g_title").addClass("active")
			.find(".fa-angle-down").removeClass("fa-angle-down").addClass("fa-angle-up");;
		firstGroup.find(".t_g_detail").slideDown(_Speed).find("li:first a").addClass("active"); //默认展开与高亮第一个子项
	}
	$(menu).on('click', 'a', function(e) {
		var $this = $(this);
		var nextEle = $this.next();
		if (nextEle.is('.t_g_detail') && nextEle.is(':visible')) {  //如果点击的是当前展开的标题
			nextEle.slideUp(_Speed); 
			$this.find(".fa-angle-up").removeClass("fa-angle-up").addClass("fa-angle-down") ;
		}else if ((nextEle.is('.t_g_detail')) && (!nextEle.is(':visible'))) {  //如果点击的是当前未展开的标题
			$('.t_g_detail').each(function(){
				if($(this).is(':visible')) {
					$(this).slideUp(_Speed).siblings(".t_g_title").find(".fa-angle-up").removeClass("fa-angle-up").addClass("fa-angle-down");
				} 
			});
			nextEle.slideDown(_Speed); 			
			$this.find(".fa-angle-down").removeClass("fa-angle-down").addClass("fa-angle-up") ;
		}else if( nextEle.length == 0 ){   //如果点击的是当前展开的标题里面的子项
		    if( $this.hasClass("active") ){  //点击当前项
				return ;
			}else{
				$("#template_content").scrollTop(0) ;  //模板区域滚动条归0
			}
			var parentGrpup = $this.parents(".template_group") ;
			parentGrpup.siblings().find(".active").removeClass("active");
			parentGrpup.find(".t_g_title").addClass("active");
			$this.parent("li").siblings().find("a.active").removeClass("active");
			$this.addClass("active");
			
			loadmore.temp.page = 1 ; 
			loadmore.temp.havaNextPage = true ; 
			loadmore.temp._switch = true ; 
			
			loadmore.temp.id  = $this.attr("id_") ;
			loadTemplateContent( loadmore.temp.id  );
		}
		return false;
	});
}
  
//加载左栏模板导航
function loadTemplateMenu(){
  	$.ajax({
  		url:"../h5/data/nav.txt",
  		dataType:"json",
  		success:function(data){
  			var html = "";
  			var menu_id = 0;
  			for (i = 0; i < data.data.length; i++) { 
  				var sub = data.data[i].sub_tags;
  				html += "<div class='template_group'>"
  					   +"<a herf='javascript:;' class='t_g_title'>"
  						   +"<span>"+data.data[i].name+"</span>"
  						   +"<i class='fa fa-angle-down icofonts'></i>"
  					   +"</a>"
  				html += "<ul class='t_g_detail'>";
  				for(j =0;j<sub.length;j++){
  					if(menu_id==0) menu_id = sub[j].id;
  					html += "<li><a href='javascript:;' id_='"+sub[j].id+"'>"+sub[j].name+"</a></li>";
  				}
  				html += "</ul></div>";
  			}
  			$("#h5_template #template_nav").append(html);
  			$.editorLeftTempNav( $("#template_nav") );  //绑定点击效果事件
  			loadTemplateContent(menu_id);
  		}
  	});
}
  
function loadTemplateContent(id){
	if(id){
		loadmore.temp.id  = id ;
	}
	if(!loadmore.temp.havaNextPage){
		dialog.showAlert( "已经加载完毕！" ,"" );
		return false;
	}	
	$.ajax({
		url:"../h5/data/tagList.jsp",
		dataType:"json",
		data:{ id:loadmore.temp.id , page:loadmore.temp.page },
		beforeSend:function(XMLHttpRequest){ 
			if(loadmore.temp.page > 1){
				$("#h5_template").append(loadingHtml);
				$("#h5_template .loading").show();
			}
			loadmore.temp._switch = false ;
		}, 
		success:function(data){
			console.info(data.data);
			loadmore.temp.page ++ ;
			loadmore.temp._switch = true ;
			$("#h5_template .loading").remove();
			
			if(data.data.length > 0){
				var html = "";
				for (i = 0; i < data.data.length; i++) { 
					html += "<div class='t_m_c'>";
					html += data.data[i].style;
					html += "</div>";
				}
			}else{
				loadmore.temp._switch = false ;
				dialog.showAlert( "已经加载完毕！" ,"" );
			}
			
			if(loadmore.temp.page <= 2){
				$("#template_content .content_child").html(html);
			}else{
				$("#template_content .content_child").append(html);	
			}	 
		},
		error:function(){
			loadmore.temp.havaNextPage = false ;
			$("#h5_template .loading").fadeOut("slow").remove();
			loadmore.temp._switch = false ;
			dialog.showAlert( "已经加载完毕！" ,"" );
		}
	});
}



  
