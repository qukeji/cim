<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.report.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
  int	ChannelID		=	getIntParameter(request,"ChannelID");
  //out.println("ChannelID"+ChannelID);
  int	pagenum		=	getIntParameter(request,"pagenum");
  String Type			=	getParameter(request,"Type");
  String ChannelName	=	getParameter(request,"ChannelName");
  int nowpage=getIntParameter(request,"nowpage");
  if (nowpage<=0){
    nowpage=1;
  }
  String pageName = request.getServletPath();
  int pindex = pageName.lastIndexOf("/");
  if(pindex!=-1)
    pageName = pageName.substring(pindex+1);
  int pagesize=12; 
  String system_logo = CmsCache.getParameter("system_logo").getContent();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>云专题列表</title>
  <link rel="Shortcut Icon" href="../favicon.ico">
  <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
  <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
  <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
  <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
  <link href="../lib/highlightjs/github.css" rel="stylesheet">
  <!--<link href="../../lib/2018/datatables/jquery.dataTables.css" rel="stylesheet">-->
  <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
  <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
  <!-- Bracket CSS -->
  <link rel="stylesheet" href="../style/2018/bracket.css">
  <link rel="stylesheet" href="../style/2018/common.css">
  <style>
    .collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 60px;}
    #nav-header{line-height: 60px;margin-left: 20px;color: #a4aab0;font-style: normal;}
    #nav-header a{color: #a4aab0;}
    table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word}
    table.table-fixed,table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;border-collapse: collapse !important;}
    .btn-box a{color:#fff }
    .btn-box a:hover{color:#fff }
    .list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;position: relative;}
    .list-pic-box .list-img-contanier{width: 100%;position: absolute;left: 0;top: 0;height: 100%;display: flex;justify-content: center;align-items: center;}
    .list-pic-box .list-img-contanier img{width: auto;max-height: 100%;max-width: 100%;}
    .list-pic-preview{display: flex;align-items: center;justify-content: center;}
    .list-pic-preview > button[name="use"]{margin-left: .4rem;}
    .list-pic-preview button{cursor: pointer;}
    .card-body {padding: .75rem;}
    .br-pageheader-left{border-left:1px solid #868ba1;}
    .br-pageheader-text{line-height: 20px;height:20px;display: inline-block;vertical-align: top;}
    .tx-black-force{color: #000 !important;}
    .navicon-left{border-right:none;width:150px;}
    #content-table td{border-right: 15px solid #e9ecef;border-bottom: 15px solid #e9ecef;background: #fff;padding:0;}
    #content-table tr td:nth-child(4){border-right: none;}
    .card{border:none;box-shadow:none;background: none;padding-top: .75rem;}
    .pagination-basic .page-item{margin-right:2px;}
    .pagination-basic .page-item .page-link{background: #bbbbbb;cursor:pointer;} 
    .pagination-basic .active .page-link, .pagination-basic .active .page-link:focus, .pagination-basic .active .page-link:hover{background-color: #17a2b8;}
  </style>
</head>
<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
<body class="collapsed-menu">
<div class="br-header">
 
  <div class="br-header-left">
  
    <div id="nav-header" class="hidden-md-down flex-row align-items-center tx-18 tx-black-force  mg-l-20"> 云专题</div>
  </div><!-- br-header-left -->
  <div class="br-header-right">
    <!-- <div class="btn-box" >
      <a class="btn btn-info tx-size-xs mg-r-5"href="javascript:self.close();" id="Image1Href">返回</a>
    </div> -->
  </div>
</div><!-- br-header -->
<div class="br-mainpanel br-mainpanel-file pd-t-20" id="js-source">
  <div class="br-pagebody pd-x-20 pd-sm-x-30 mg-t-10">
    <div class="card bd-0 shadow-base">
      <table class="table mg-b-0 table-fixed" id="content-table">
        <thead style="display: none;">
        <tr>
          <th class="tx-12-force tx-mont tx-medium wd-20p-force">标题</th>
          <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-20p-force">点击量</th>
          <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-20p-force">状态</th>
          <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-20p-force">日期</th>
          <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-20p-force">作者</th>
        </tr>
        </thead>
        <tbody class="tide_item2">

        </tbody>
      </table>
      <div class="ht-80 d-flex align-items-center justify-content-center pd-t-20 pd-b-20">
        <nav aria-label="Page navigation">
          <ul class="pagination pagination-basic mg-b-0 pagediv ">

          </ul>
        </nav>
      </div>
    </div><!-- br-pagebody -->
  </div><!-- br-mainpanel -->
  <!-- ########## END: MAIN PANEL ########## -->

  <script src="../lib/2018/jquery/jquery.js"></script>
  <script src="../lib/2018/popper.js/popper.js"></script>
  <script src="../lib/2018/bootstrap/bootstrap.js"></script>
  <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
  <script src="../lib/2018/moment/moment.js"></script>
  <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
  <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
  <script src="../lib/2018/peity/jquery.peity.js"></script>
  <script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
  <script src="../lib/highlightjs/highlight.pack.js"></script>
  <!--<script src="../../lib/2018/datatables/jquery.dataTables.js"></script>
  <script src="../../lib/2018/datatables-responsive/dataTables.responsive.js"></script>-->
  <script src="../lib/2018/select2/js/select2.min.js"></script>
  <script src="../common/2018/bracket.js"></script>
  <script>
    var start=<%=nowpage%>;
    var ChannelID = <%=ChannelID%>;
    var ChannelName ="<%=ChannelName%>";
    var pageName = "<%=pageName%>";
    var   pagesize=<%=pagesize%>;
    $(function(){
      'use strict';

      //show only the icons and hide left menu label by default
      $('.br-mailbox-list,.br-subleft').perfectScrollbar();

      $('#showMailBoxLeft').on('click', function(e){
        e.preventDefault();
        if($('body').hasClass('show-mb-left')) {
          $('body').removeClass('show-mb-left');
          $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
        } else {
          $('body').addClass('show-mb-left');
          $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
        }
      });


      $("#checkAll,#checkAll_1").click(function(){
        if($("#content-table").hasClass("table-fixed")){
          var checkboxAll = $("#content-table tr").find("td").find(":checkbox") ;
        }else{
          var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
        }
        var existChecked = false ;
        for (var i=0;i<checkboxAll.length;i++) {
          if(!checkboxAll.eq(i).prop("checked")){
            existChecked = true ;
          }
        }
        if(existChecked){
          checkboxAll.prop("checked",true);
          $(this).prop("checked",true);
        }else{
          checkboxAll.removeAttr("checked");
          $(this).removeAttr("checked");
        }
        return;
      })
    });
  </script>

  <script type="text/javascript">
    $(function()
    {
     
      var url="http://jushi.tidemedia.com/cms//api/special_cloud_list.jsp?start="+start+"&pagesize="+pagesize;
      $.ajax({
        type:"GET",
        url: url,
        dataType:"jsonp",
        jsonpCallback:"specialJSON",
        success: function(res) {
          console.log(res);
          var html = "";
          var pagetotal="";

          //var table = document.querySelector("tbody");
          // var tr = document.createElement("tr");
          var chunk = 4; //每3个分一组
          var totalArr = [] ;
          for (var i = 0, j = res.length; i < j; i += chunk) {
            totalArr.push(res.slice(i, i + chunk));
          }
          for (var k = 0; k < totalArr.length; k++) {

            html +="<tr>" ;
            for (var m = 0; m < totalArr[k].length; m++) {
              pagetotal=totalArr[k][m].pagetotal;
              html += '<td><div class="row">' +
                      ' <div class="col-md">' +
                      '<div class="card bd-0">' +
                      ' <div class="list-pic-box">' +
                      '<div class="list-img-contanier">' +
                      '<img class="card-img-top img-fluid" src="'+totalArr[k][m].Photo+'" alt="Image">' +
                      '</div>' +
                      '</div>' +
                      '<div class="card-body bd-t-0 rounded-bottom">' +
                      '<p class="card-text tx-black">'+totalArr[k][m].name+' </p>' +
                      //' <p class="card-text pd-y-6">使用终端：电脑端、移动端</p>' +
                      ' <div class="row mg-l-0 mg-r-0 mg-t-5 list-pic-preview">' +
                      '<a href="javascript:prwviewSpecialcould('+totalArr[k][m].sourceid+','+totalArr[k][m].id+',\''+totalArr[k][m].Address+'\');" class="btn btn-outline-info active tx-size-xs pd-y-6 pd-x-15" onclick >预览</a>  ' +
                      '<a href="javascript:addSpecialcould('+totalArr[k][m].sourceid+','+totalArr[k][m].id+');" name="use" class="btn btn-outline-info active tx-size-xs pd-y-6 pd-x-15" >采用</a>' +
                      '</div>' +
                      '</div>' +
                      '</div>' +
                      '</div>' +
                      '</div></td>';
            }
            html +="</tr>"
          }
          $(".tide_item2").append(html)
          console.log("totalArr",totalArr)
          //分页显示
          var html2 = "";
          if (start>1){
          html2+='<li class="page-item">'+
                  '<a class="page-link" onClick="gopage(start-1)" aria-label="Next">'+
          ' <i class="fa fa-angle-left"></i>'+
          ' </a> </li>';
          }
          for (var i =1;i <=pagetotal;  i++) {
             if (i==start){
                html2+='<li class="page-item active"><a class="page-link active" onClick="selectpage('+i+')">'+i+'</a></li>';
                }else{
                     html2+='<li class="page-item "><a class="page-link " onClick="selectpage('+i+')">'+i+'</a></li>'; 
                }
          }
          if (pagetotal>start){
          
          html2+='<li class="page-item">'+
                  '<a class="page-link" onClick="gopage(start+1)" aria-label="Next">'+
          ' <i class="fa fa-angle-right"></i>'+
          ' </a> </li>';
          }
          $(".pagediv").append(html2)

        }
      });
    });

    function addSpecialcould(id,cloud_id)
    {
      var ChannelID=<%=ChannelID%>;
      var url='newnode.jsp?id='+id+'&cloud_id='+cloud_id+'&ChannelID='+ChannelID;
      var	dialog = new top.TideDialog();
      dialog.setWidth(600);
      dialog.setHeight(500);
      dialog.setUrl(url);
      dialog.setTitle("新建专题频道");
      dialog.show();
    }

    function prwviewSpecialcould(id,cloud_id,url)
    {
      var ChannelID=<%=ChannelID%>;
      window.open("special_preview_could.jsp?url="+url+'&id='+id+'&cloud_id='+cloud_id+'&ChannelID='+ChannelID);
    }

    function selectpage(i) {
      var url = pageName + "?nowpage="+ i + "&ChannelID="+<%=ChannelID%>;
      this.location = url;
    }
   
    function gopage(currpage) {
      var url = pageName + "?nowpage="+ currpage + "&ChannelID="+<%=ChannelID%>;
      this.location = url;
    }
  </script>
</div>
</body>
</html>
