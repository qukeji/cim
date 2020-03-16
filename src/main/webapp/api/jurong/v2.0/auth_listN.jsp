<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%@ include file="include/config.jsp"%>
<%
    //审核列表

    String pageName = request.getServletPath();
    int pindex = pageName.lastIndexOf("/");
    if(pindex!=-1){
        pageName = pageName.substring(pindex+1);
    }

    JSONObject json = new JSONObject();

    int type = getIntParameter(request,"type");//状态 1待我审核的，2我审核通过的
    if(type==0){
        type=1 ;
    }
    int column_id = getIntParameter(request,"column_id");//栏目编号
    int status = getIntParameter(request,"status");//状态 1审核通过
    int pages= getIntParameter(request,"page");//页码
    int pagesize = getIntParameter(request,"pagesize");
    if(pages<1) pages = 1;
    if(pagesize<=0) pagesize = 10;

    String style2="";
    String style1="";
    if(type==1){
        style1="active";
    }
    if(type==2){
        style2="active";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <title>审核</title>
    <style>
        body,h1,h2,h3,h4,h5,h6,p,form,ul,ol,li,input,select,label,dl,dt,dd{margin:0;padding:0;font-family:"微软雅黑";font-size:12px;color:#333333;-webkit-text-size-adjust:none}
        input,select,label{vertical-align:middle;font-size:12px}
        ul,ol,li{list-style:none}
        img{border:0}
        .clear{clear:both;height:0;overflow:hidden}
        a{color:#666;text-decoration:none;outline:none}
        .clearfix:after{content:'\0020';display:block;height:0;clear:both;font-size:0;visibility:hidden}
        .dpnone{display:none!important}
        .img-box img{width:100%;height:100%}
        body{font-size:0.24rem;color:#666}
        .contanier{max-width:750px;margin:0 auto}
        .nav{display:flex;justify-content:flex-start;padding-left:0.45rem;border-bottom:1px solid #e4e4e4}
        .nav a{color:#666;font-size:0.28rem;line-height:0.66rem}
        .nav a.active{color:#1a9bd2}
        .nav a:first-of-type{margin-right:0.9rem}
        .condition{display:flex;align-items:center;padding:0 0.22rem;height:0.75rem;font-size:0.28rem;border-bottom:1px solid #e4e4e4}
        .condition ul{display:flex}
        .condition ul li{display:flex;font-size:0.28rem}
        .condition ul li.active a{color:#1a9bd2}
        .condition ul li:first-of-type{margin-right:0.75rem;margin-left:0.45rem}
        .xt-list{font-size:0.24rem;color:#8a8a8a}
        .xt-list .xt-item{padding:0 0.3rem;border-bottom:0.1rem solid #eee}
        .xt-list .xt-title{color:#1e1e1e;font-size:0.3rem;overflow:hidden;text-overflow:ellipsis;display:-webkit-box;-webkit-line-clamp:1;-webkit-box-orient:vertical;line-height:0.50rem;margin-top:0.22rem;height:0.50rem}
        .xt-list .xt-author-date,.xt-list .belong-column,.xt-list .someelse{height:0.4rem;line-height:0.4rem}
        .xt-list .state{height:0.66rem;line-height:0.66rem}
        .xt-list .col{margin:0 2px}
        .xt-list .row{width:100%;height:1px;background:#eee;margin-top:2px}
        .xt-list .someelse{color:#000}
        .xt-list .state.ywc{color:#3dd854}
        .xt-list .state.wwc{color:#dc2e51}
        .xt-list .person{margin-right:0.3rem}
        .no-more-info {
        font-size: .24rem;
        line-height: .5rem;
        color: #999;
        padding: 0.1rem 0;
        text-align: center;
        }
    </style>
    <script type="text/javascript" src="../../../lib/2018/jquery/jquery.js"></script>

    <script>
        var pageName = "<%=pageName%>";
        var pages = "<%=pages%>";
        var pagesize = "<%=pagesize%>";
        var type = "<%=type%>";
        var Parameter = "?pagesize=" + pagesize + "&pages=" + pages;
    </script>

</head>
<body>
<div class="container">
    <div class="nav">
        <a class="<%=style1%>" href="javascript:list('type=1');">待我审核的</a>
        <a class="<%=style2%>" href="javascript:list('type=2');">我审核过的</a>
    </div>
    <div class="xt-list">


    </div>
</div>
<script>

    var Global={
        init:function() {
            this.htmlFontSize();
        },
        //设置根元素的font-size
        htmlFontSize:function(){
            var doc = document;
            var win = window;
            function initFontSize(){
                var docEl = doc.documentElement,
                    resizeEvt = 'orientationchange' in window ? 'orientationchange' : 'resize',
                    recalc = function(){
                        var clientWidth = docEl.clientWidth;
                        if(!clientWidth) return;
                        if(clientWidth>750){
                            clientWidth=750;
                        }
                        fontSizeRate = (clientWidth / 375);
                        var baseFontSize = 50*fontSizeRate;
                        docEl.style.fontSize =  baseFontSize + 'px';
                    }
                recalc();
                if(!doc.addEventListener) return;
                win.addEventListener(resizeEvt, recalc, false);
                doc.addEventListener('DOMContentLoaded', recalc,false);
            }
            initFontSize();
        }

    };
    Global.init();

    function list(str) {
        var url = pageName + Parameter;
        if (typeof(str) != 'undefined')
            url += "&" + str;
        this.location = url;
    }
    function goto(gid){
        var url = "wengao_info.jsp?id="+gid;
       
        window.open(url);
        
    }

    //滚动的时候上拉刷新
    $(window).scroll(function(){
        if($(document).scrollTop() >= $(document).height()-$(window).height()) {
            if(_switch){
                getCoinsList();
                return false;
            }
        }
    });

    //鍒楄〃

    var havaNextPage = true ;  //是否有下一页
    var _switch  = true ;   //开关，防止下拉多次触发接口请求
    getCoinsList() ;
    function getCoinsList(){
        var url2="wegao_list.jsp?page="+pages+"&pagesize="+pagesize+"&type="+type;
        $.ajax({
            type:"get",
            url:url2,
            dataType :"json",
            beforeSend:function(XMLHttpRequest){
                if(pages>1){
                    $(".loading").show();
                }
                _switch = false ;
            },
            success:function(data){
                console.log(data);
                console.log(data.result)
                if(data.result.length>0){
                    _switch = true ;
                    pages ++ ;
                }else{
                    havaNextPage = false ;
                    $(".loading").fadeOut("slow");
                    _switch = false ;
                    $(".xt-list").append('<div class="no-more-info">没有更多内容了</div>');
                }
                $(".loading").fadeOut("slow");
                var listHtml = "<div class=\"xt-item\">" ;
                for(var i=0;i<data.result.length;i++){
                    var list=data.result[i];
                    listHtml+="<div onclick=\"goto('"+list.GlobalID+"')\">";
                    listHtml+="<div class=\"xt-title\"><a href=\"javascript:;\">"+list.title+"</a></div>\n";
                    listHtml+="<div class=\"xt-author-date\">";
                    listHtml+="<span class=\"author\">作者 :"+list.publisher+"</span>";
                    listHtml+="<span class=\"col\">|</span>";
                    listHtml+="<span class=\"date\">"+list.publish_date+"</span>";
                    listHtml+=" </div>"+
                        "<div class=\"belong-column\"><a href=\"javascript:;\">所属栏目："+list.childPath+"</a>"+
                        " </div>";
                    listHtml+="  <div class=\"row\"></div>";
                   
                      listHtml+="<div class=\"xt-state\">"+
                        "  <span class=\"person\">"+list.approve_status+"</span>"+
                        " <span class=\"state ywc\">"+list.review_date+"</span>"+
                        "  </div>"    
                    listHtml+="</div>"
                }
                listHtml+="</div>";
               
                $(".xt-list").append(listHtml);

                $('.lazy').each(function() {
                    var $object = $(this);
                    $object.on('load', function() {
                        $object.addClass('loaded');
                    });
                });
            },
            error:function(data){
                console.log(data);
            }
        });
    }

</script>
</body>

</html>
