<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!

public String getParentChannelPath(Channel channel) throws MessageException, SQLException{

    String path = "";
    ArrayList arraylist = channel.getParentTree();

    if ((arraylist != null) && (arraylist.size() > 0))
    {
      for (int i = 0; i < arraylist.size(); ++i)
      {
        Channel ch = (Channel)arraylist.get(i);

		if((i+1)==arraylist.size()){//当前频道名
			path = path + ch.getName() ;// + ((i < arraylist.size() - 1) ? " / " : "");
		}else{
			path = path + ch.getName() +" / ";// javascript:jumpContent("+ch.getId()+")
		}        
      }
    }

    arraylist = null;

    return path;
}
%>
<%
/**
* 用途：文档列表页
* 1,李永海 20140101 创建
* 2,王海龙 20150408  修改	 定制列表页无需再删除重定向代码
* 3,王海龙 20150609 修改     261行使用user数据源，解决按用户搜索bug
* 4,
* 5,
*/
String uri = request.getRequestURI();
long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int sortable = getIntParameter(request,"sortable");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");

String content = getParameter(request,"content");

String fieldName = getParameter(request,"fieldName");

int selecttype = getIntParameter(request,"type");
String globalids="";
if(currPage<1)
	currPage = 1;

if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new",request.getCookies()));

if(rowsPerPage<=0)
	rowsPerPage = 20;

if(rows==0)
	rows = Util.parseInt(Util.getCookieValue("rows_new",request.getCookies()));
if(cols==0)
	cols = Util.parseInt(Util.getCookieValue("cols_new",request.getCookies()));

if(rows==0)
	rows = 10;
if(cols==0)
	cols = 5;

Channel channel = CmsCache.getChannel(id);
boolean IsTopStatus=false;//是否置顶
if(channel.getIsTop()==1){
	IsTopStatus=true;
}
if(channel==null || channel.getId()==0)
{
	//response.sendRedirect("../content/content_nochannel.jsp");
	//return;
}

Channel parentchannel = null;
int ChannelID = channel.getId();
String ChannelName = channel.getName();
int IsWeight=channel.getIsWeight();
int	IsComment=channel.getIsComment();
int	IsClick=channel.getIsClick();
//String gids = "";
 

if(channel.getListProgram().length()>0 && uri.endsWith("/content/content2018.jsp"))
{response.sendRedirect(channel.getListProgram()+"?id="+id);return;}

String S_Title				=	getParameter(request,"Title");
String S_startDate			=	getParameter(request,"startDate");
String S_endDate			=	getParameter(request,"endDate");
String S_User				=	getParameter(request,"User");
int S_IsIncludeSubChannel	=	getIntParameter(request,"IsIncludeSubChannel");
int S_Status				=	getIntParameter(request,"Status");
int S_IsPhotoNews			=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch			=	getIntParameter(request,"OpenSearch");
int IsDelete				=	getIntParameter(request,"IsDelete");

int Status1			=	getIntParameter(request,"Status1");

int listType = 0;
listType = getIntParameter(request,"listtype");
if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list_new",request.getCookies()));
if(listType==0) listType = 1;

boolean listAll = false;

if(channel.getParent()==-1){//说明是站点
	S_IsIncludeSubChannel = 0;
}

if(channel.isTableChannel() && channel.getType2()==8) listAll = true;
if(channel.getIsListAll()==1) listAll = true;
if(S_IsIncludeSubChannel==1) listAll = true;

if(channel.getType()==2)
{
	response.sendRedirect("../page/content_page.jsp?id="+id);
	return;
}


//如果是“新建应用”；
if(channel.getType()==3)
{
	response.sendRedirect("app.jsp?id="+id);
	return;
}

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&startDate="+S_startDate+"&endDate="+S_endDate+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1;

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

if(!channel.hasRight(userinfo_session,1))
{
	//response.sendRedirect("../noperm.jsp");return;
}
boolean canApprove = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove);
boolean canDelete = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanDelete);
boolean canAdd = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanAdd);
int canExcel=channel.getIsExportExcel();//是否导出Excel
int canWord=channel.getIsImportWord();//是否导出world
String SiteAddress = channel.getSite().getUrl();


//获取频道路径
String parentChannelPath = getParentChannelPath(channel);
%>
<!DOCTYPE HTML>
<html>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="noindex, nofollow">
	<title>选择</title>
	<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
	<link rel="stylesheet" href="../style/2018/bracket.css">
	<link rel="stylesheet" href="../style/2018/common.css">
	<script type="text/javascript" src="../common/jquery.js"></script>
	<script type="text/javascript" src="../common/common.js"></script>

	<style>
		html,
		body {
			width: 100%;
			height: 100%;
		}
	</style>
	<script language=javascript>

        $(function(){

            $("a[tag='k']").click(function(){
                var name = $(this).attr("name");
                $.ajax({
                    type : "POST",
                    url : "getscheme_info2018.jsp",
                    dataType : "json",
                    data: {name:name},
                    success : function(data){
                        if(data!=""){
                            $.each(data,function(name,value){
                                var $inp = $("input[name='"+name+"']");
                                if($inp.length>0){
                                    if($inp.attr("type")=="text")
                                    {
                                        $inp.val(value);
                                    }
                                    else if($inp.attr("type")=="radio")
                                    {
                                        $.each($inp,function(i,item){
                                            if($(item).val()==value){
                                                $(item).prop("checked",true);
                                            }
                                        });
                                    }
                                }
                            })
                        }
                    }
                });
            });
        })
        
        

	</script>
	<script type="text/javascript">
	$(function(){
            var content_ = "<%=content%>";
            var val = content_.split(",");
            var boxes = document.getElementsByName("id");
            for(i=0;i<boxes.length;i++){
                for(j=0;j<val.length;j++){
                    if(boxes[i].value == val[j]){
                        boxes[i].checked = true;
                        break;
                    }
                }
            }
            
        })
        function selectImage()
        {
            var	dialog = new top.TideDialog();
            dialog.setWidth(500);
            dialog.setHeight(240);
            dialog.setLayer(2);
            dialog.setUrl("../watermark/upload_watermark.jsp");
            dialog.setTitle("上传水印");
            dialog.show();

        }
        function preview()
        {
            window.open("data:image/png;base64,"+$("#watermark").val());
        }

        function addioscode()
{
         var s = document.getElementsByName("id");
         var s2 = "";
         for( var i = 0; i < s.length; i++ )
         {
           if ( s[i].checked ){
             //s2 += s[i].value+",";
             s2 += s[i].value+",";
             }
					}
					if(s2!==""){
						s2 = s2.substr(0,s2.length-1)
					}
          //s2 = s2.substr(0,s2.length-1);
						alert("添加完成");
                                   
					parent.$("#<%=fieldName%>").attr("value",s2);
					top.TideDialogClose();                                      
}
	</script>
</head>

<body>
<%
int S_UserID = 0;
long weightTime = 0;
int IsActive = 1;
if(IsDelete==1) IsActive=0;

if(!S_User.equals("")){
	String sql2="select * from userinfo where Name='"+S_User+"'";
	TableUtil tu2 = new TableUtil("user");
	ResultSet Rs2 = tu2.executeQuery(sql2);
	if(Rs2.next()){
		S_UserID=Rs2.getInt("id");
	}else{
		S_UserID=0;
	}
}

if(channel.getIsWeight()==1)
{
	//权重排序
	java.util.Calendar nowDate = new java.util.GregorianCalendar();
	nowDate.set(Calendar.HOUR_OF_DAY,0);
	nowDate.set(Calendar.MINUTE,0);
	nowDate.set(Calendar.SECOND,0);
	nowDate.set(Calendar.MILLISECOND,0);
	weightTime = nowDate.getTimeInMillis()/1000;
}

//System.out.println("time:"+weightTime);
String Table = channel.getTableName();
String ListSql = "select id,Title,Weight,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews";

String FieldStr=",DocTop,DocTopTime";
if(IsTopStatus){
	ListSql+=FieldStr;
}


if(listType==2)
{
	ListSql += ",Summary,Content,Keyword";
}
if(channel.getIsWeight()==1)
	ListSql += ",case when CreateDate>"+weightTime+" then (Weight+"+weightTime+") else CreateDate end  as newtime";
ListSql += " from " + Table;
String CountSql = "select count(*) from "+Table;

//if(!S_User.equals(""))
	//CountSql = "select count(*) from "+Table+" ";

if(!listAll)
{
	if(channel.getType()==Channel.Category_Type)
	{
		ListSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
		CountSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
	}
	else if(channel.getType()==Channel.MirrorChannel_Type)
	{
		Channel linkChannel = channel.getLinkChannel();
		if(linkChannel.getType()==Channel.Category_Type)
		{
			ListSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
			CountSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
		}
		else
		{
			ListSql += " where Category=0 and Active=" + IsActive;
			CountSql += " where Category=0 and Active=" + IsActive;
		}
	}
	else
	{
		ListSql += " where "+ (!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
		CountSql += " where "+(!listAll?Table+".Category=0 and ":"")+" Active=" + IsActive;
	}
}
else
{
	ListSql += " where ChannelCode like '"+channel.getChannelCode()+"%' and Active=" + IsActive;
	CountSql += " where ChannelCode like '"+channel.getChannelCode()+"%' and Active=" + IsActive;
}

String WhereSql = "";

if(!S_Title.equals("")){
	String tempTitle=S_Title.replaceAll("%","\\\\%");
	WhereSql += " and Title like '%" + channel.SQLQuote(tempTitle) + "%'";
}
if(!S_startDate.equals("")){
	long startTime=Util.getFromTime(S_startDate,"");
	WhereSql += " and CreateDate>="+startTime ;
}
if(!S_endDate.equals("")){
	long endTime=Util.getFromTime(S_endDate,"");
	WhereSql += " and CreateDate<"+(endTime+86400);
}

/*
if(S_IsIncludeSubChannel==1)
{
	WhereSql += " and ChannelCode like '"+channel.getChannelCode() + "%'";
}*/

if(S_UserID>0)
{
	WhereSql += " and User="+S_UserID;
}

if(S_IsPhotoNews==1)
	WhereSql += " and IsPhotoNews=1";
if(S_Status!=0)
	WhereSql += " and Status=" + (S_Status-1);

if(Status1!=0)
{
	if(Status1==-1)
		WhereSql += " and Status=0";
	else
		WhereSql += " and Status=" + Status1;
}

ListSql += WhereSql;
CountSql += WhereSql;

if(channel.getIsWeight()==1)
{
	ListSql += " order by newtime desc,id desc";
}
else
{
   if(IsTopStatus){
		ListSql += " order by  DocTop desc ,DocTopTime  desc  ,OrderNumber desc ";
   }else {
	    ListSql += " order by OrderNumber desc ";
   }
}

// out.println(ListSql);

int listnum = rowsPerPage;
if(listType==2) listnum = cols*rows;

TableUtil tu = channel.getTableUtil();
ResultSet Rs = tu.List(ListSql,CountSql,currPage,0);
int TotalPageNumber = tu.pagecontrol.getMaxPages();
int TotalNumber = tu.pagecontrol.getRowsCount();

%>
<div class="bg-white modal-box">

		<div class="modal-body modal-body-btn pd-20 overflow-y-auto">

		<!--搜索-->
		<div class="search-box pd-x-20 pd-sm-x-30" >
			<div class="search-content bg-white">
				<form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onsubmit="return check();">
					<div class="row">
						<!--标题-->
						<div class="mg-r-10 mg-b-30 search-item">
							<input class="form-control search-author" placeholder="标题" type="text" name="Title" value="<%=S_Title%>" onClick="this.select()">
						</div>
						<!-- wd-200 -->
						<!--用户名-->
						<div class="mg-r-10 mg-b-30 search-item">
							<div class="input-group">
								<input type="text" class="form-control search-author" placeholder="用户名" name="Username" value="<%=S_Username%>">
							</div>
						</div>
						<!--手机号-->
						<div class="mg-r-10 mg-b-30 search-item">
							<div class="input-group">
								<input type="text" class="form-control search-title" placeholder="手机号" name="Tel" value="<%=S_Tel%>">
							</div>
						</div>
						<div class="search-item mg-b-30">
							<input type="hidden" name="IsIncludeSubChannel" value="1">
							<input type="submit" name="Submit" value="搜索" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
							<input type="hidden" name="OpenSearch" id="OpenSearch" value="1">
						</div>
					</div>
					<!-- row -->
				</form>
			</div>
		</div>
		<!--搜索-->
			<%
//if(channel.hasRight(userinfo_session,1)){
if(true){
%>
		<!--列表-->
		<div class="br-pagebody pd-x-20 pd-sm-x-30">
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0 <%=listType==2?"table-fixed":""%>" id="content-table">
				<%if(listType==1){%>
					<thead>
						<tr>
							<th class="wd-5p">
								选择
								<!--<label class="ckbox mg-b-0">
									<input type="checkbox" id="checkAll"><span></span>
								</label>-->
							</th>
							<th class="tx-12-force tx-mont tx-medium">名称</th>
							<th class="tx-12-force tx-mont tx-medium">编号</th>
							<%if(IsWeight==1){%>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">权重</th>
							<%}%>
							<!--<th class="tx-12-force tx-mont tx-medium hidden-xs-down">状态</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">日期</th>-->
							<%if(IsComment==1){%>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">评论</th>
							<%}%>
							<%if(IsClick==1){%>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down">点击量</th>
							<%}%>
							
						</tr>
					</thead>
                  <%}%>
					<tbody>
<%

int j = 0;
int m = 0;
//int temp_gid=0;
while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int Status = Rs.getInt("Status");
	int category = Rs.getInt("Category");
	int user = Rs.getInt("User");
	int active = Rs.getInt("Active");
	String Title	= convertNull(Rs.getString("Title"));
	int globalid_ =  Rs.getInt("GlobalID");
	int IsPhotoNews = Rs.getInt("IsPhotoNews");
	int TopStatus = 0;
	if(IsTopStatus){
		 TopStatus = Rs.getInt("DocTop");
	}
	if(listAll)
	{
		if(category>0)
			Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
	}
	int Weight=Rs.getInt("Weight");
	//int GlobalID=Rs.getString("Title");
	String titleName=Rs.getString("Title");


//	if(temp_gid!=0){
//		globalids+=",";
//	}
//	temp_gid++;
//	globalids+=GlobalID+"";


	String ModifiedDate	= convertNull(Rs.getString("ModifiedDate"));
	ModifiedDate=Util.FormatDate("yyyy-MM-dd HH:mm",ModifiedDate);
	String UserName	= CmsCache.getUser(user).getName();//convertNull(Rs.getString("userinfo.Name"));
	String StatusDesc = "";
	if(IsDelete!=1){
	if(Status==0)
		StatusDesc = "<span class='tx-orange'>草稿</span>";
	else if(Status==1)
		StatusDesc = "<span class='tx-success'>已发</span>";
	}else{
		StatusDesc = "<span class='tx-danger'>已删除</span>";
	}

//	if(gids.length()>0){gids+=","+GlobalID+"";}else{gids=GlobalID+"";}

	int OrderNumber = TotalNumber-j-((currPage-1)*rowsPerPage);
	j++;

	if(listType==1)
	{
%>
		<tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>" status="<%=Status%>" id="item_<%=id_%>" >
            <td class="valign-middle">
              <%if(selecttype==1){%>
              <label class="rdiobox mg-r-15">
                <input type="radio" name="id" value="<%=globalid_%>"><span></span>
              </label>
              <%}else{%>
              <label class="ckbox mg-b-0">
				<input type="checkbox" name="id" value="<%=globalid_%>"><span></span>
				<%}%>
			  </label>
            </td>
            <td ondragstart="OnDragStart (event)">
              <%if(IsPhotoNews==1){%>
			  <i class="icon ion-image tx-22 tx-warning lh-0 valign-middle" id="img_<%=j%>"></i>
              <%}else{%>
			  <i class="icon ion-clipboard tx-22 tx-warning lh-0 valign-middle" id="img_<%=j%>"></i>
              <%}%>
              <%if(TopStatus==0){%><%}else{%>
			  <i class="fa fa-upload tx-20 tx-warning lh-0 valign-middle" id="imgtop_<%=j%>" title="置顶"></i>
              <%}%>
              <span class="pd-l-5 tx-black"><%=Title%></span>
            </td>
            <td class="hidden-xs-down"><span class="pd-l-5 tx-black"><%=globalid_%></span></td>
			<%if(IsWeight==1){%>
			<td class="hidden-xs-down"><span ItemID="<%=id_%>"><%=Weight%></span></td>
			<%}%>
			<!--<td class="hidden-xs-down">
				<%=StatusDesc%>
			</td>
			<td class="hidden-xs-down">
				<%=ModifiedDate%>
			</td>-->
			
		</tr>
	<%}
	if(listType==2)
	{

		if(m==0) out.println("<tr>");
		m++;
%>

<%	
		if(m==cols){ out.println("</tr>");m=0;}
	} 
}
if(listType==2 && m<cols) out.println("</tr>");
tu.closeRs(Rs);
%>
					</tbody>
				</table>
                <script>
					var page = {
						id: '<%=id%>',
						currPage: '<%=currPage%>',
						rowsPerPage: '<%=rowsPerPage%>',
						querystring: '<%=querystring%>',
						TotalPageNumber: <%=TotalPageNumber%>
					};
				</script>
                </div>
		</div>
		</div>
        <%}else{%>
		<script>
			var page = {
				id: '<%=id%>',
				currPage: '<%=currPage%>',
				rowsPerPage: '<%=rowsPerPage%>',
				querystring: '<%=querystring%>',
				TotalPageNumber: 0
			};
		</script>
     <%}%>
		<!--modal-body-->

		<div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
			<div class="modal-footer">
				<input type="hidden" name="startButton" value="14211">
                <button name="startButton" type="button" class="btn btn-primary tx-size-xs"  id="startButton" onclick="addioscode();">确定</button>
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消
				</button>
				<input type="hidden" name="Submit" value="Submit">
			</div>
		</div>
		<div id="ajax_script" style="display:none;"></div>
</div>
<!-- modal-box -->
</body>

<script src="../common/2018/common2018.js"></script>
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>

<script language=javascript>




    function change() {
        $("#tr01").hide();
        $("#tr02").hide();
        $("#tr03").hide();

        var type = document.form.TemplateType.value; //alert(type);
        if (type == "1") {
            $("#tr01").show(); //tr01.style.display = "";
        } else if (type == "2") {
            $("#tr02").show(); //tr02.style.display = "";
        } else if (type == "3") {
            $("#tr03").show(); //tr03.style.display = "";
        }

    }

    function changeFolderType() {
        var t = "";
        if (document.form.SubFolderType.value == "0") {
            t = "没有子目录";
        } else if (document.form.SubFolderType.value == "1") {
            t = "如：/2018/";
        } else if (document.form.SubFolderType.value == "2") {
            t = "如：/2018/08/";
        } else if (document.form.SubFolderType.value == "3") {
            t = "如：/2018/08/08/";
        } else if (document.form.SubFolderType.value == "4") {
            t = "如：/2018-08-08/";
        } else if (document.form.SubFolderType.value == "5") {
            t = "目录由文档中的Path字段指定.";
        } else if (document.form.SubFolderType.value == "6") {
            t = "如：/20180808/";
        }

        $("#FolderTypeDesc").html(t);
    }

    function ViewTemplate() {
        TemplateID = document.form.TemplateID.value;

        if (TemplateID == "") return;

        var foldername = "";
        var filename = "";
        var width = Math.floor(screen.width * .8);
        var height = Math.floor(screen.height * .8);
        var leftm = Math.floor(screen.width * .1) + 30;
        var topm = Math.floor(screen.height * .05) + 30;
        var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm + ",top=" + topm + ", width=" + width + ", height=" + height;

        var url = "../template/template_edit2018.jsp?TemplateID=" + TemplateID;
        window.open(url, "", Feature);
    }
</script>

</html>
