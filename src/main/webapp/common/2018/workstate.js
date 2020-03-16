//xuanti 
function siderightNewContent2(id) {
    var url = "../lib/sidebar_new_content_bychannel.jsp?ChannelID=" + id;
    var dialog = new top.TideDialog();
    dialog.setWidth(750);
    dialog.setHeight(600);
    dialog.setUrl(url);
    dialog.setTitle('新建内容');
    dialog.show();
}

function siderightNewContent(id) {
    var url = "../lib/sidebar_new_content.jsp";
    var dialog = new top.TideDialog();
    dialog.setWidth(750);
    dialog.setHeight(600);
    dialog.setUrl(url);
    dialog.setTitle('新建内容');
    dialog.show();
}

//video
function siderightNewContent3(id, userid) {
    var url = "../../vms/video/myvideo/sidebar_new_content_bychannel.jsp?ChannelID=" + id + "&userid=" + userid;
    var dialog = new top.TideDialog();
    dialog.setWidth(750);
    dialog.setHeight(600);
    dialog.setUrl(url);
    dialog.setTitle('新建内容');
    dialog.show();
}

function editDocument(itemid, ChannelID) {
   /* $.ajax({
        url: '/tcenter/work/edit_check.jsp',
        dataType: 'json',
        data: {"itemid": itemid, "channelid": ChannelID},
        type: 'GET',
        success: function (data) {
            var code = data.result;
            if (code == 1) {
                TideAlert("提示", "该环节审核方案未开启编辑功能！");
                return;
            } else if (code == 3) {
                TideAlert("提示", "不是未提交审核或审核被驳回的稿件！");
                return;
            } else if (code == 4) {
                TideAlert("提示", "终审通过的稿件不能编辑！");
                return;
            }*/

            var url = "../subject/approve_preview.jsp?ItemID=" + itemid + "&ChannelID=" + ChannelID;
            window.open(url);
  /*      }
    })*/
}

function editDocumentsp(itemid, ChannelID) {
    var code = approve_check_2(itemid, 1);
    if (code == 1) {
        TideAlert("提示", "该环节审核方案未开启编辑功能！");
        return;
    } else if (code == 3) {
        TideAlert("提示", "不是未提交审核或审核被驳回的稿件！");
        return;
    } else if (code == 4) {
        TideAlert("提示", "终审或者已通过审核的稿件不能编辑！");
        return;
    }
    var url = "../../vms/video/document.jsp?ItemID=" + itemid + "&ChannelID=" + ChannelID;
    window.open(url);
}

//线索采用
function useToArticle(_itemid, _channleid) {
    var url = "../lib/sidebar_new_content.jsp?CloudItemID=" + _itemid + "&CloudChannelID=" + _channleid;
    var dialog = new top.TideDialog();
    dialog.setWidth(750);
    dialog.setHeight(600);
    dialog.setUrl(url);
    dialog.setTitle('新建内容');
    dialog.show();
    return false;
}

//生成选题(线索)
function newToTitle(_itemid, _channleid) {
    var url = "../lib/sidebar_new_content.jsp?CloudItemID=" + _itemid + "&CloudChannelID=" + _channleid + "&isxuanti=" + 1;
    var dialog = new top.TideDialog();
    dialog.setWidth(750);
    dialog.setHeight(600);
    dialog.setUrl(url);
    dialog.setTitle('新建内容');
    dialog.show();
    return false;
}

//管理工具+号弹窗
function tool_manage() {
    var url = "tool_manage.jsp";
    var dialog = new top.TideDialog();
    dialog.setWidth(750);
    dialog.setHeight(600);
    dialog.setUrl(url);
    dialog.setTitle('自定义工具显示');
    dialog.show();
}

//返回需要的时间格式
function returnTime(str, type) {
    var date = str ? new Date(str) : new Date();
    var seperator1 = "-";
    var seperator2 = ":";

    function addZero(m) {
        return m < 10 ? '0' + m : m;
    }

    var currentMD = addZero(date.getMonth() + 1) + seperator1 + addZero(date.getDate());
    var currentHM = addZero(date.getHours()) + seperator2 + addZero(date.getMinutes());
    if (type == 1) {
        return '<span>' + currentMD + '</span><span>' + currentHM + '</span>';
    } else {
        return currentMD + " " + currentHM;
    }

}

//pie  bg-color
var chartColors = [
    'rgb(255, 99, 132)',
    'rgb(255, 159, 64)',
    'rgb(255, 205, 86)',
    'rgb(75, 192, 192)',
    'rgb(54, 162, 235)',
    'rgb(153, 102, 255)',
    'rgb(201, 203, 207)'
];
//pie   options
var optionpie = {
    responsive: true,
    legend: {
        display: true,
        position: "right",
        labels: {
            boxWidth: 14,// 修改宽度
            fontSize: 12,
            fontColor: '#fff'
        }
    },
    animation: {
        animateScale: true,

        animateRotate: true
    }

};


//切换显示饼图
function showCharts(_this) {
    var stateItem = $(_this).parents(".stateitem");
    if ($(_this).hasClass("active-show-i")) {
        stateItem.find(".charts-section").slideUp(300);
        $(_this).removeClass("active-show-i")
    } else {
        var _id = stateItem.attr("data-id");
        workState.initPie("#pieDonut" + _id, workState.pieData[_id], _id);
        stateItem.find(".charts-section").slideDown(200);
        $(_this).addClass("active-show-i")
    }

}

function jumpTool(_this) {
    var _url = $(_this).attr("data-url");
    top.location.href = _url;
}

function jumpTool2(_this) {
    var _url = $(_this).attr("data-url");
    window.open(_url);
}

var workState = {
    everAdd: [],
    //常用工具
    usualTool: function () {
        $.ajax({
            type: "GET",
            url: usualToolUrl,
            dataType: "json",
            success: function (res) {
                var k = 0;
                var html = "";
                for (var i in res) {
                    if (res[i].flag) {
                        html += '<li class="op-9">';
                        if (res[i].Url.indexOf("http") == 0) {
                            html += '<a href="javascript:;" data-url="' + res[i].Url + '" onclick="jumpTool2(this)" >' + res[i].logo;
                        } else {
                            if (k >= res.length - 4 && k < res.length - 1) {
                                html += '<a href="javascript:;" data-url="' + baseUrl + res[i].Url + '" onclick="jumpTool2(this)" >' + res[i].logo;
                            } else {
                                html += '<a href="javascript:;" data-url="' + baseUrl + res[i].Url + '" onclick="jumpTool(this)" >' + res[i].logo;
                            }
                        }
                        html += '<span>' + res[i].prjname + '</span></a></li>';
                    }
                    k++;
                }
                html += '<li class="add-li"><a href="javascript:tool_manage();"><i class="fa fa-plus tx-30"></i></a></li>';
                var oContent = $('.tool');
                oContent.html(html);
            }
        });
    },
    //我的稿件
    creatFrame: function () {
        var rowHtml = '<h4 class="tx-gray-800 mg-b-15 tx-20">工作台</h4>\
			<div class="row row-sm workstate-row">\
				<div class="col-sm-4 col-sm-4-more" id="left-row">\
				</div>\
				<div class="col-sm-4 col-sm-4-more mg-t-20 mg-sm-t-0" id="center-row">\
				</div>\
				<div class="col-sm-4 col-sm-4-less mg-t-20 mg-sm-t-0" id="right-row">\
				</div>\
			</div>';
        $(".br-pagebody").html("").append(rowHtml);
        var _jsonarr = JSON.stringify(jsonarr);
        _jsonarr = JSON.parse(_jsonarr)
        if (_jsonarr.length > 0) {
            if (_jsonarr.length == 1) {
                $("#center-row").remove();
                $("#left-row").removeClass("col-sm-4 col-sm-4-more").addClass("col-sm-8-more")
            }
            for (var i in _jsonarr) {
                workState.creatItemOut(_jsonarr[i].url, i)
            }
        }
        ;
        workState.xiansuohtml(); //线索

    },
    creatItemOut: function (url, index) {
        var itemOuter = '<div class="bg-white card bd-0 shadow-base stateitem radius-l-t-8" data-id="' + index + '" id="stateitem' + index + '"></div>';
        if (index % 2 == 0) {
            $("#left-row").append(itemOuter);
        } else {
            $("#center-row").append(itemOuter);
        }
        workState.everAdd[index] = false;
        workState.getData(url, index);
    },
    pieArr: {},
    pieData: [],
    initPie: function (obj, piedata, _index) {
        var _label = [],
            _data = [],
            _color = [];
        for (var n = 0; n < piedata.length; n++) {
            _label.push(piedata[n].lable)
            _data.push(piedata[n].data)
            _color.push(chartColors[n])
        }
        var datapie = {
            labels: _label,
            segmentShowStroke: true,
            datasets: [{
                data: _data,
                backgroundColor: _color
            }]
        };
        workState.pieArr[_index] = new Chart($(obj).get(0), {
            type: 'pie',
            data: datapie,
            options: optionpie
        });
    },
    getData: function (_url, itemIndex, tabIndex) {
        if (tabIndex == 0 || tabIndex) {
            var url = _url + "?status=" + tabIndex;
        } else {
            if (_url.indexOf("/vms/video/myvideo/my_shipinInfo.jsp") != -1) {
                var url = _url + "?userid=" + userId;
            } else {
                var url = _url;
            }
        }
        $.ajax({
            type: "GET",
            url: url,
            dataType: "json",
            success: function (res) {
                var html = "";
                if (!workState.everAdd[itemIndex]) {    // 第一次加载
                    var outerhtml = '<div class="workstate-top radius-l-t-8">' +
                        '<div class="tx-14 pd-x-12 ht-40 d-flex justify-content-between align-items-center">' +
                        '<span class="tx-16 tx-white">' + res.moduleIcon + '' + res.name + '</span>' +
                        '<span class="tx-22">' +
                        '<i class="fa fa-pie-chart cursor-pointer mg-r-10" onclick="showCharts(this)"></i>';
                    if (url.indexOf("/tcenter/work/my_approve.jsp") != 0 && url.indexOf("/vms/video/myvideo/myshiping_info.jsp") != 0) {
                        outerhtml += '<i class="fa fa-plus-circle cursor-pointer" onclick="' + res.addJs + '"></i>';
                    }
                    outerhtml += '</span>' +
                        '</div>' +
                        '<div class="charts-section pd-5">' +
                        '<div class="d-flex justify-content-center">' +
                        '<div class="charts-box wd-100p">' +
                        '<div id="itemPie' + itemIndex + '" class="wd-100p itemPie">' +
                        '<canvas class="pieDonut" id="pieDonut' + itemIndex + '" ></canvas>' +
                        '</div>' +
                        '</div>' +
                        '<div class="data-detail" style="display:none;visibility:hidden;">' +
                        '<ul class="d-flex flex-row flex-wrap">';
                    for (var j = 0; j < res.tablist.length; j++) {
                        outerhtml += '<li class="d-flex flex-column mg-r-15">' +
                            '<span class="tx-14 mg-b-5">' + res.tablist[j].lable + '</span>' +
                            '<span>' + res.tablist[j].data + '</span>' +
                            '</li>';
                    }
                    outerhtml += '</ul>' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '<div class="change-options bg-white radius-l-t-8">' +
                        '<div class="workstate-nav mg-x-10 mg-t-5 radius-l-t-8">' +
                        '<ul>';
                    for (var m = 0; m < res.tablist.length; m++) {
                        if (m == 0) {
                            outerhtml += '<li class="ac"><a href="javascript:;">' + res.tablist[m].lable + '</a></li>';
                        } else {
                            outerhtml += '<li class=""><a href="javascript:;">' + res.tablist[m].lable + '</a></li>';
                        }
                    }
                    outerhtml += '</ul>' +
                        '</div>' +
                        '</div>' +
                        '</div>';
                    var tableheader = '<div class="table-box">' +
                        '<table class="table  table-valign-middle mg-b-0">' +
                        '<thead>' +
                        '<tr>' +
                        '<th class="wd-title pd-l-5">标题</th>' +
                        '<th class="point-th wd-55 th-point">节点</th>' +
                        '<th class="wd-50 th-state">状态</th>' +
                        '<th class="wd-50 th-time">时间</th>' +
                        '<th class="wd-50 td-handle">操作</th>' +
                        '</tr>' +
                        '</thead>' +
                        '<tbody>' +
                        '</tbody>' +
                        '</table>' +
                        '</div><div class="workstatetips"></div>';
                    outerhtml = outerhtml + tableheader;
                    $("#stateitem" + itemIndex).append(outerhtml);
                    workState.everAdd[itemIndex] = true;

                    workState.pieData[itemIndex] = res.tablist;

                    workState.bindEvent($("#stateitem" + itemIndex + " .workstate-nav li"), itemIndex, _url);  //我的稿件切换
                }

                if (res.result.length) {
                    for (var i in res.result) {
                        html += ' <tr>' +
                            '<td class="wd-title">' + res.result[i].title + '</td>' +
                            '<td class="td-point tx-12">' +
                            '<span class="tx-12">' +
                            '<a data-toggle="tooltip" data-placement="top" title="' + res.result[i].channelPath + '" href="' + res.result[i].path + '"  target="blank">' + res.result[i].channelName + '</a>' +
                            '</span>' +
                            '</td>' +
                            '<td class="td-state tx-success">' + res.result[i].StatusDesc + '</td>' +
                            '<td class="td-time">' + returnTime(res.result[i].date, 1) + '</td>' +
                            '<td class="td-handle">' +
                            '<a href="#" data-toggle="dropdown" class="btn pd-y-0 tx-gray-500 hover-info"><i class="icon ion-more"></i></a>' +
                            '<div class="dropdown-menu dropdown-menu-right pd-10">' +
                            '<nav class="nav nav-style-1 flex-column">';
                        if (res.shipinma == "en") {
                            html += '<a href="javascript:editDocumentsp(' + res.result[i].id + ' , ' + res.result[i].ChannelID + ');" class="nav-link">查看</a>';
                        } else {
                            html += '<a href="javascript:editDocument(' + res.result[i].id + ' , ' + res.result[i].ChannelID + ');" class="nav-link">查看</a>';
                        }
                        html += '</nav>' +
                            '</div>' +
                            '</td>' +
                            '</tr>';
                    }
                }
                //workState.initPie("#pieDonut"+itemIndex,res.tablist,itemIndex);  //第一次加载饼图初始化
                $("#stateitem" + itemIndex).find("tbody").html(html);
                if (!res.result.length) {
                    $("#stateitem" + itemIndex).find(".workstatetips")
                        .html('<div style="text-align: center;padding: 10px 0;font-size:12px;">暂无数据</div>');
                } else {
                    $("#stateitem" + itemIndex).find(".workstatetips").html("");
                }
                $('[data-toggle="tooltip"]').tooltip();
            }
        });
    },
    //绑定点击事件
    bindEvent: function (ele, _itemIndex, url) {
        ele.click(function () {
            var _index = $(this).index();
            $("#stateitem" + _itemIndex + " .workstate-nav li").removeClass("ac")
            $(this).addClass('ac');
            workState.getData(url, _itemIndex, _index)
        })
    },
    xiansuohtml: function () {
        var myXiansuoOuter = '<div class="bg-white card bd-0 shadow-base stateitem radius-l-t-8" data-id="99" id="xiansuo">\
			<div class="workstate-top radius-l-t-8">\
				<div class="tx-14 pd-x-12 ht-40 d-flex justify-content-between align-items-center">\
					<span class="tx-16 tx-white">\<i class="fa fa-feed mg-r-10 tx-22"></i>线索</span>\
					<span class="tx-22">\
						<i class="fa fa-pie-chart cursor-pointer mg-r-5" onclick="showCharts(this)"></i>\
					</span>\
				</div>\
				<div class="charts-section pd-5">\
					<div class="d-flex justify-content-center">\
						<div class="charts-box wd-100p">\
							<div id="itemPie99" class="wd-100p itemPie" height="">\
								<canvas class="pieDonut" id="pieDonut99" height="150"></canvas>\
							</div>\
						</div>\
						<div class="data-detail" style="display:none;visibility:hidden;">\
							<ul class="d-flex flex-row flex-wrap"></ul>\
						</div>\
					</div>\
				</div>\
				<div class="change-options bg-white radius-l-t-8">\
					<div class="workstate-nav mg-x-10 mg-t-5 radius-l-t-8">\
						<ul>\
							<li class="ac"><a href="javascript:;">网站</a></li>\
							<li><a href="javascript:;">微信</a></li>\
							<li><a href="javascript:;">微博</a></li>\
						</ul>\
					</div>\
				</div>\
			</div>\
			<div class="table-box">\
				<table class="table  table-valign-middle mg-b-0">\
					<thead style="display: none;border: none;">\
						<tr><th class="pd-l-5">标题</th><th class="wd-50">操作</th></tr>\
					</thead>\
					<tbody>\
					</tbody>\
				</table>\
			</div><div class="workstatetips"></div>\
		</div>';
        $("#right-row").append(myXiansuoOuter);
        workState.myxiansuo();
        workState.bindXiansuoEvent($("#xiansuo .workstate-nav li"));  //线索切换
    },
    bindXiansuoEvent: function (ele) {
        ele.click(function () {
            var _index = $(this).index();
            $("#xiansuo .workstate-nav li").removeClass("ac")
            $(this).addClass('ac');
            workState.myxiansuo(_index);
        })
    },
    myxiansuo: function (index) {
        if (index == 0 || index) {
            xiansuoUrl = "../collect/getitems.jsp?type=" + index + "&pagesize=15"; //线索接口
        }
        $.ajax({
            type: "GET",
            url: xiansuoUrl,
            dataType: "json",
            success: function (d) {
                var html = "";
                var res = d;
                for (var i in res.result) {
                    html += '<tr>' +
                        '<td class="pd-l-5 xs-title-td ">' +
                        '<div class="xs-title"><a href="' + res.result[i].url + '" target="_blank" class="xiansuo-title-a">' + res.result[i].title + '</a></div>' +
                        '<div class="xs-detail">';
                    if (res.result[i].type == 1) {
                        html += '<span class="xs-type mg-r-5">类型：网站</span>'
                    } else if (res.result[i].type == 2) {
                        html += '<span class="xs-type mg-r-5">类型：微信</span>'
                    } else if (res.result[i].type == 3) {
                        html += '<span class="xs-type mg-r-5">类型：微博</span>'
                    }
                    html += '<span class="xs-from mg-r-10-force">来源：' + res.result[i].type_desc + '</span>' +
                        '<span class="xs-time">' + returnTime(res.result[i].date, 2) + '</span>' +
                        '</div>' +
                        '</td>' +
                        '<td class="td-handle wd-50">' +
                        '<a href="#" data-toggle="dropdown" class="btn pd-y-0 tx-gray-500 hover-info"><i class="icon ion-more"></i></a>' +
                        '<div class="dropdown-menu dropdown-menu-right pd-10">' +
                        '<nav class="nav nav-style-1 flex-column">' +
                        '<a href="javascript:useToArticle(' + res.result[i].id + ' , ' + res.result[i].ChannelId + ');" class="nav-link">采用</a>' +
                        '<a href="javascript:newToTitle(' + res.result[i].id + ' , ' + res.result[i].ChannelId + ');" class="nav-link">生成选题</a>' +
                        '</nav>' +
                        '</div>' +
                        '</td>' +
                        '</tr>';
                }

                var detailHtml = "";
                for (var j = 0; j < res.tablist.length; j++) {
                    detailHtml += '<li class="d-flex flex-column mg-r-15">' +
                        '<span class="tx-14 mg-b-5">' + res.tablist[j].lable + '</span>' +
                        '<span>' + res.tablist[j].data + '</span>' +
                        '</li>';
                }
                $('#xiansuo .data-detail ul').html(detailHtml);
                $('#xiansuo tbody').html(html);
                if (!res.result.length) {
                    $("#xiansuo").find(".workstatetips")
                        .html('<div style="text-align: center;padding: 10px 0;font-size:12px;">暂无数据</div>');
                } else {
                    $("#xiansuo").find(".workstatetips").html("");
                }
                $('[data-toggle="tooltip"]').tooltip();
                workState.pieData[99] = res.tablist;
                //workState.initPie("#pieDonut99",res.tablist,99);  //第一次加载饼图初始化
            }
        });
    }
}

workState.usualTool(); //常用工具
workState.creatFrame(); //增加外层HTML
