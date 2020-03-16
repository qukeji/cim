<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%

    int	GlobalID			= getIntParameter(request,"GlobalID");
	int	type				= getIntParameter(request,"type");//type=1说明是审核预览入口，隐藏版本恢复按钮
    //String	SiteAddress		= getParameter(request,"SiteAddress");
    //String	Parameter		= getParameter(request,"Parameter");
    //int	ItemID			    = getIntParameter(request,"ItemID");
    //int GlobalID = 1404731;
    
    
   
%>

<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>历史版本</title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/common.css">


<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/content.js"></script>
<style>
	#content-table tr th:nth-child(2) {
	    min-width: 50px;
	}
</style>
</head>
<body>
	<div class="article-title mg-l-20 mg-b-15 pd-r-20" >
	    <div class="br-pagebody pd-x-0-force pd-sm-x-30">
	        <div class="d-flex align-items-center justify-content-start mg-b-20 mg-sm-b-30">
		        <div class="btn-group">
                    <a href="javascript:contrast();" class="btn btn-outline-info analy">对比</a>
                </div>
	        </div>
			<div class="card bd-0 shadow-base">
				<table class="table mg-b-0" id="content-table">
					<thead>
						<tr>
						    <th class="tx-12-force tx-mont tx-medium wd-50">选择</th>
							<th class="tx-12-force tx-mont tx-medium wd-50-force bh">编号</th>
							<th class="tx-12-force tx-mont tx-medium">标题</th>
							<th class="tx-12-force tx-mont tx-medium wd-150">作者</th>
							<th class="tx-12-force tx-mont tx-medium wd-150">修改人</th>
							<th class="tx-12-force tx-mont tx-medium wd-80">状态</th>
							<th class="tx-12-force tx-mont tx-medium wd-160">日期</th>
							<th class="tx-12-force tx-mont tx-medium wd-120">操作</th>
						</tr>
					</thead>
					<tbody>               
                        <% 
                            String versionSql = "select * from article_replica where globailid="+GlobalID+" order by id desc";
                            TableUtil verTu = new TableUtil();
                            ResultSet verRs = verTu.executeQuery(versionSql);
                            int countNumber =0 ;
                            while(verRs.next()){
        						int Status = verRs.getInt("Status");
        						String StatusDesc = "";
        						if(Status==0)
        							StatusDesc = "<font color=red>草稿</font>";
        						else if(Status==1)
        							StatusDesc = "<font color=blue>已发</font>";

								String CreateDate = convertNull(verRs.getString("CreateDate"));
								CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm:ss",CreateDate);
        						countNumber++;
                        %>                
                        <tr>
                            <td class="valign-middle">
                                <label class="ckbox mg-b-0">
                					<input type="checkbox" name="version_selection" value="<%=verRs.getString("id")%>"><span for="version_selection"></span>
                				</label>
                            </td>
        					<td class="hidden-xs-down"><%=countNumber%></td>
        					<td class="hidden-xs-down"><%=verRs.getString("Title")%></td>
        					<td class="hidden-xs-down"><%=CmsCache.getUser(verRs.getInt("uid")).getName()%></td>
        					<td class="hidden-xs-down"><%=CmsCache.getUser(verRs.getInt("ModifiedUser")).getName()%></td>
        					<td class="hidden-xs-down"><%=StatusDesc%></td>
        					<td class="hidden-xs-down"><%=CreateDate%></td>
        				<!--	<td class="hidden-xs-down"><a href="parameter2018.jsp?Action=Del&id=130" class="btn btn-danger btn-sm tx-13" onclick=" if(confirm('你确认要删除吗?')) return true; else return false;">删除</a></td> -->
        					<td class="hidden-xs-down wd-50">
								<a href="javascript:parent.approve_preview(<%=verRs.getString("id")%>);" class="btn btn-primary btn-sm tx-13">预览</a>
								<%if(type==0){%>
								<a href="javascript:parent.returnVersion(<%=verRs.getString("id")%>);" class="btn btn-primary btn-sm tx-13">恢复</a>
								<%}%>
							</td>
        				
        					
        					<%}	verTu.closeRs(verRs);%>
        				</tr>                
					<tbody>
                </table>
			</div>
		</div>
	</div>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>

<script>
    var listType = 1;
    
    //对比
    function contrast(){
        var checked = [];
        var id1 = "";
        var id2 = "";
        $('input:checkbox:checked').each(function(){
            checked.push($(this).val());
        })
        var lengths = checked.length;
        if(lengths == 0){
            tips("请选择要对比的内容。");
            return false;
        }else if(lengths > 2){
            tips("最多可选择两个版本进行比对，请修改。");
            return false;
        }else if(lengths == 1){
            id1 = checked[0];
        }else if(lengths == 2){
            id1 = checked[0];
            id2 = checked[1];
        }
       
		
		changeFrameSrc( top.frames["content_historical_version"] , "../content/history.html?id1="+id1+"&id2="+id2+"&globalid="+<%=GlobalID%> )
		
    }
    $("#content-table tr:gt(0) td").click(function() {
		var _tr = $(this).parent("tr")
		if(!$("#content-table").hasClass("table-fixed")){
			if( _tr.find(":checkbox").prop("checked") ){
				_tr.find(":checkbox").removeAttr("checked");
				$(this).parent("tr").removeClass("bg-gray-100");
			}else{
				_tr.find(":checkbox").prop("checked", true);
				$(this).parent("tr").addClass("bg-gray-100");
			}
		}
	});
    
     //提示信息
    function tips(obj){
        var dialog = new top.TideDialog();	   
    		dialog.setWidth(320);
    		dialog.setHeight(280);		
    		dialog.setTitle("提示");
    		dialog.setMsg(obj);
    		dialog.ShowMsg(); 
    }
</script>
	
</body>
</html>



