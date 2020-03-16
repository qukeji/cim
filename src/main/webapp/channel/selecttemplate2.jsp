<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int GroupID = getIntParameter(request,"GroupID");

TemplateGroup tg = new TemplateGroup(GroupID);
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<title>选择文件</title>

<script language="javascript">
function OpenFolder(Path){
  document.all.imagelist.src="filelist.jsp?Path=" + Path;
  
  var folders =document.folderselect.folderList.options;
  folders.length=1;
  if(Path!="/")
	  Path = Path + "/";
  var p=0;
  p = Path.indexOf("/",p+1);
  while(p>0){
    folders[folders.length]=new Option(Path.substr(0,p) + "/");
    folders[folders.length-1].value=Path.substr(0,p)+"/";
    p = Path.indexOf("/",p+1);
  }
  
  folders.selectedIndex = folders.length-1;
}

function ChangeFolder(){
  var Path = document.folderselect.folderList.options[document.folderselect.folderList.selectedIndex].value;
  OpenFolder(Path);
}
function closeWindow(){
	if (document.all.url.value!=""){window.returnValue=document.all.url.value;}
	window.close();
}

var myObject = new Object();
myObject.title = "新建文件";

function newFile()
{
    myObject.title = "新建文件";
	var Feature = "dialogWidth:32em; dialogHeight:24em;center:yes;status:no;help:no";	
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=template/newfile.jsp",myObject,Feature);
	if(retu!=null)
	{
		window.returnValue = myObject.FolderName + "/" + retu;
		window.close();
		//this.location = "selecttemplate.jsp?FolderName=/" + myObject.FolderName;
	}
}

function viewInfo(name)
{
  		var width  = Math.floor( screen.width  * .5 );
  		var height = Math.floor( screen.height * .5 );
  		var leftm  = Math.floor( screen.width  * .1)+60;
 		var topm   = Math.floor( screen.height * .05)+60;
 		var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=1, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;
  		var url="../template/viewinfo.jsp?FolderName="+encodeURI(myObject.FolderName)+"&FileName=" + encodeURI(name);
  		window.open(url,"",Feature);
}

function showText(obj)
{
	self.status=obj.innerText
}

function contextForSpan(obj)
{
   var eobj,popupoptions
   popupoptions = [
   						new ContextItem("Show Text",function(){showText(obj);})
   				  ]
   ContextMenu.display(popupoptions)
}
function hideIt(obj)
{
	obj.style.display='none'
} 

function contextForButton(obj)
{
   var eobj,popupoptions
   popupoptions = [
   						new ContextItem("<b>Hide</b>",function(){hideIt(obj);}),
   						new ContextItem("Show Text",function(){showText(obj);})
   				  ]
   ContextMenu.display(popupoptions)
}

function selectItem(obj)
{
	//alert(obj.className);
	if(obj.className!="rows3")
	{
		var curr_row;

		if(window.event.ctrlKey!=true)
		{
			for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
			{
			  if(oTable.rows[curr_row].className=="rows3")
				  oTable.rows[curr_row].className = oTable.rows[curr_row].oldclass;
			}
		}
		obj.className = "rows3";
	}
	else
		obj.className = obj.oldclass;
}

function selectItem_key(flag)
{

	var curr_row;
	var hasSelectedItem = 0;

	if(flag==1)
	{

		for (curr_row = 0; curr_row < oTable.rows.length; curr_row++)
		{
		  if(oTable.rows[curr_row].className=="rows3")
			{
			  if(flag==1)
				{
				  if(curr_row>1)
					{
					  if(window.event.shiftKey!=true)
						  oTable.rows[curr_row].className = oTable.rows[curr_row].oldclass;
					  oTable.rows[curr_row-1].className = "rows3";
					}
				}
				break;
			}
		}

	}
	else if(flag==2)
	{
		for (curr_row = oTable.rows.length-1; curr_row > 0; curr_row--)
		{
		  if(oTable.rows[curr_row].className=="rows3")
			{
			  if((curr_row+1)<oTable.rows.length)
				{
				  if(window.event.shiftKey!=true)
					  oTable.rows[curr_row].className = oTable.rows[curr_row].oldclass;
				  oTable.rows[curr_row+1].className = "rows3";
				}
			    hasSelectedItem = 1;
				break;
			}
		}
		if(hasSelectedItem==0)
		{
			oTable.rows[1].className = "rows3";
		}
	}
}

function double_click(obj)
{
	//alert(obj);
	if(obj.Type=="File")
	{
		window.returnValue = obj.ItemID;
		window.close();
	}
	else if(obj.Type=="Directory" || obj.Type=="Up")
	{//alert(myObject.FolderName + obj.Name);
		this.location = "selecttemplate.jsp?GroupID=" + obj.GroupID;
	}
}

function onkeyboard()
{
	key = event.keyCode
	if(key == 'd'.charCodeAt() || key == 'D'.charCodeAt())
		deleteFile();
	else if(key == 13)
		notepad();
	//alert(key);
}

function onkeyboard1()
{
	key = event.keyCode
	if(key==38)
	{
		selectItem_key(1);
	}
	else if(key==40)
		selectItem_key(2);
	else if(key==46)
		deleteFile();

	//alert(key);
}

function SelectStart()
{
	if(event.srcElement.tagName.toLowerCase()=="body" && event.ctrlKey && event.button==0)
	{
		//全选,第1行是Table Title
		for (curr_row = 1; curr_row < oTable.rows.length; curr_row++)
		{
			  oTable.rows[curr_row].className = "rows3";
		}
	}

	return false;
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onkeypress="onkeyboard()" onkeydown="onkeyboard1()" onselectstart="return SelectStart();">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top"> 
      <table width="100%" border="0" cellspacing="8" cellpadding="0">
        <tr>
          <td><a href="javascript:newFile();"><span class="font">新建模板文件</span></a>
            <table width="100%" border="0" cellspacing="0" cellpadding="5" id="oTable">
              <tr align="center"> 
                <td width="95" class="box-blue"><span class="font-white">编号</span></td>
                <td width="423" class="box-blue"><span class="font-white">名称</span></td>
                <td width="333" class="box-blue"><span class="font-white">文件名</span></td>
                <td width="102" class="box-blue"><span class="font-white">大小</span></td>
              </tr>
<%int j = 0;

if(tg.getParent()>0){j++;%>
              <tr class="<%=(j%2==0)?"rows2":"rows1"%>" oldclass="<%=(j%2==0)?"rows2":"rows1"%>" onClick="selectItem(this);" onDblClick ="double_click(this);" GroupID="<%=tg.getParent()%>" Type="Up" No="<%=j%>"> 
                <td width="95" ><%=j%></td>
                <td width="423"><span>..</span></td>
                <td width="333">&nbsp;</td>
                <td width="102" ></td>
              </tr>
<%}
	TableUtil tu = new TableUtil();

	String Sql = "select id from template_group where Parent="+tg.getId();
	ResultSet Rs = tu.executeQuery(Sql);
	while(Rs.next())
	{
			j++;
			int gid = Rs.getInt("id");
			TemplateGroup tGroup = CmsCache.getTemplateGroup(gid);
	%>
              <tr class="<%=(j%2==0)?"rows2":"rows1"%>" oldclass="<%=(j%2==0)?"rows2":"rows1"%>" onClick="selectItem(this);" onDblClick ="double_click(this);" GroupID="<%=tGroup.getId()%>" Type="Directory" No="<%=j%>"> 
                <td width="95" ><%=j%></td>
                <td width="423"><b><span id="FileName<%=j%>"><%=tGroup.getName()%></span></b></td>
                <td width="333">&nbsp;</td>
                <td width="102" ></td>
              </tr>
<%
	}

	tu.closeRs(Rs);

String ListSql = "select * from template_files";
if(GroupID==0)
{
	ListSql += " where GroupID=0 or GroupID is null order by id";
}
else if(GroupID==-1)
{
	ListSql += " order by id";
}
else
{
	ListSql += " where GroupID=" + GroupID + " order by id";
}

ResultSet rs = tu.executeQuery(ListSql);
while(rs.next())
{

			j++;
			int tid = rs.getInt("id");
			TemplateFile tf = CmsCache.getTemplate(tid);
			
	%>
              <tr class="<%=(j%2==0)?"rows2":"rows1"%>" oldclass="<%=(j%2==0)?"rows2":"rows1"%>" onClick="selectItem(this);" onDblClick ="double_click(this);" ItemID="<%=tid%>" Type="File" No="<%=j%>"> 
                <td width="95" ><%=j%></td>
                <td width="423"><a href="javascript:viewInfo('')"><span id="FileName<%=j%>"><%=tf.getName()%></span></a></td>
                <td width="333">&nbsp;<%=tf.getFileName()%></td>
                <td width="102" ><%//=FileSize%></td>
              </tr>
<%
}
tu.closeRs(rs);
%>
            </table>
		  </td>
        </tr>
      </table></td>
  </tr>
</table>
</body>
</html>
