var dialog = new top.TideDialog();  //弹窗公共变量
//列表显示
var listconfigUrl1 = "/tcenter/channel/list/header/list";	//列表项目接口1
var listconfigUrl2 = "/tcenter/channel/list/header/list2";	//列表项目接口2
var listSetUrl = "/tcenter/channel/list/header/set";		//列表项目提交接口
var menulistUrl = "/tcenter/channel/list/menu/list";		//功能菜单接口
var menuSwitch = "/tcenter/channel/list/menu/update";		//功能菜单的显示开关接口
var menuSet = "/tcenter/channel/list/menu/set";      		//功能菜单的显示开关接口
var fastSearchUrl = "/tcenter/channel/list/fastsearch/list";//快捷搜索项接口
var searchConfigUrl = "/tcenter/channel/list/search/list";	//搜索项目配置接口
var fastSearchSubmit = "/tcenter/channel/list/fastsearch/set";    //快捷搜索项提交接口
var searchconfigSubmit = "/tcenter/channel/list/search/set";    //搜索项目配置提交接口
//获取地址栏参数
function getUrl(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if (r != null)
        return unescape(r[2]);
    return null;
};
var everClickNav = [false, false, false, false]    //导航是否点击过

//导航切换显示
$("#form_nav li").click(function () {
    var _index = $(this).index();
    console.log(_index)
    $(".config-box ul li").removeClass("block").eq(_index).addClass("block");
    if (!everClickNav[_index] && _index == 1) {
        menulist();  //功能菜单
    } else if (!everClickNav[_index] && _index == 2) {
        fastSearchList();//检索项目
        searchConfigList(); //搜索项目配置
    } else if (!everClickNav[_index] && _index == 3) {

        //定制化列表
    }
    everClickNav[_index] = true;
})

/*
 列表显示部分
 * */
getlist();  //获取列表项
function getlist() {
    $.ajax({
        type: "GET",
        url: listconfigUrl1,
        data: {"channel": channelid},
        success: function (d) {
            if (d.code == 200 && d.data.length > 0) {
                var usedItem = "";  //已使用项
                var leftItem = "";  //剩余项
                for (var i = 0; i < d.data.length; i++) {
                    if (d.data[i].status == 1) {
                        usedItem += '<span class="tab-item" data-isDefault="' + d.data[i].isDefault + '" data-id="' + d.data[i].id + '" data-status="' + d.data[i].status + '">' +
                            '<i class="tab-title-i">' + d.data[i].title + '</i>' +
                            '<span class=" icon-create icon-btn edit-item" >' +
                            '<i class="icon ion-android-create tx-20 icon-color"></i>' +
                            '</span>' +
                            '<i class="icon ion-close-circled tx-16  delete-btn"></i>' +
                            '</span>';
                    } else {
                        leftItem += '<span class="tab-item" data-isDefault="' + d.data[i].isDefault + '" data-id="' + d.data[i].id + '" data-status="' + d.data[i].status + '">' +
                            '<i class="tab-title-i">' + d.data[i].title + '</i>' +
                            '<span class=" icon-create icon-btn edit-item" >' +
                            '<i class="icon ion-android-create tx-20 icon-color"></i>' +
                            '</span>' +
                            '<i class="icon ion-android-add-circle tx-16 add-btn"></i>' +
                            '</span>';
                    }
                }
                $("#currentList").html(usedItem);
                $("#residueList").html(leftItem);

//				$("#currentList").sortable({
//					//items:".tab-item",
//					//axis:"",
//					cursor:"move",
//					revert: 200 ,
//					//containment: "#currentList",
//					//helper: fixHelper,
//					handle:".tab-item"
//				})

            }
        },
        error: function (err) {
            console.log(err)
        }
    });
}

//获得列表其他配置项
getlist2();

function getlist2() {
    $.ajax({
        type: "GET",
        url: listconfigUrl2,
        data: {"channel": channelid},
        success: function (d) {
            console.log(d)
            if (d.code == 200) {
                $('#default-list input[value="' + d.data.viewType + '"]').attr("checked", 'checked');
                var other = d.data.other;
                other = other.split(",");

                $.each(other, function (i, va) {
                    if (va != 0) {
                        $('#otherFunc input[value="' + (i + 1) + '"]').prop('checked', true);
                    }
                });
            }
        },
        error: function (err) {
            console.log(err);
        }
    });
}

//修改列表项
$("#currentList , #residueList").delegate(".edit-item", "click", function () {
    var item = $(this).parent(".tab-item");
    var _id = item.attr("data-id");
    var _status = item.attr("data-status");
    var _isDefault = item.attr("data-isDefault");
    console.log(_id);
    editListItem(_id, _status, 0, _isDefault);
})
//新增列表项
$("#newListItem").click(function () {
    editListItem("", 0, 1, 0)
})

function editListItem(id, status, isadd, isDefault) {  //idadd为1是新增  为0是修改
    var url = path + "/channel/list/config/header/eoa?id=" + id + "&status=" + status + "&isadd=" + isadd + "&channelid=" + channelid + "&isDefault=" + isDefault;
    var dialog = new top.TideDialog();
    dialog.setWidth(757);
    dialog.setHeight(581);
    dialog.setUrl(url);
    if (isadd) {
        dialog.setTitle('新增列表项目');
    } else {
        dialog.setTitle('编辑列表项目');
    }
    dialog.show();
}


//剩余列表项添加为可用列表项
$('#residueList').on('click', '.add-btn', function () {
    var delBtn = '<i class="icon ion-close-circled tx-16 delete-btn"></i>';
    var nowList = $(this).parent().clone(true);
    nowList.children('.add-btn').remove();
    nowList.append(delBtn);
    $(this).parent().remove();

    if ($('#operation').parent()[0] === $('.now-tab-list')[0]) {
        $('#operation').before(nowList);
    } else {
        $('.now-tab-list').append(nowList);
    }
})

// 当前列表项目删除按钮
$('#currentList').on('click', '.delete-btn', function () {
    var addBtn = '<i class="icon ion-android-add-circle tx-16  add-btn"></i>';
    var usableList = $(this).parent().clone(true);
    usableList.children('.delete-btn').remove();
    usableList.append(addBtn);
    $(this).parent().remove();
    $('#residueList').append(usableList);
})

//列表显示确定事件
function setListItem(isconfirm) {
    var currentListItem = $("#currentList").find(".tab-item"),  //已用列表项
        id1 = "";
    if (currentListItem.length > 0) {
        $.each(currentListItem, function (i, el) {
            console.log($(el).attr("data-id"))
            if (i == 0) {
                id1 += $(el).attr("data-id");
            } else {
                id1 += "," + $(el).attr("data-id");
            }
        });
    } else {
        dialog.showAlert("当前列表项目不允许为空！", "danger");
        return false;
    }

    var _data = {}
    _data.channel = channelid;
    _data.id1 = id1;
    var viewType = $('#default-list input:radio:checked');

    _data.viewType = viewType.val();

    var otherFunc = $('#otherFunc input:checkbox');
    var _othervalue = "";
    $.each(otherFunc, function (i, el) {
        //拼接规则，选中为1，不选为0，全选"1,1,1"，不选"0,0,0"
        if ($('#otherFunc input[value="' + (i + 1) + '"]').prop("checked")) {
            if (i == 0) {
                _othervalue += 1;
            } else {
                _othervalue += "," + 1;
            }
        } else {
            if (i == 0) {
                _othervalue += 0;
            } else {
                _othervalue += "," + 0;
            }
        }
    });
    _data.other = _othervalue

    $.ajax({
        type: "post",
        url: listSetUrl,
        data: _data,
        success: function (data) {
            console.log(data)
            if (data.code == 200) {
                dialog.showAlert(data.msg);
                top.TideDialogClose();  //关闭弹窗
            } else {
                dialog.showAlert(data.msg);
            }
        },
        error: function (err) {
            console.log(err)
        }
    });
}

//弹窗确定事件
$("#listconfirm").click(function () {
    var _index = $("#form_nav li a.active").attr("data-index");
    switch (_index) {
        case "1":
            setListItem(false);  //提交列表显示
            break;
        case "2":
            submitFuncMenu(false)  //提交功能菜单
            break;
        case "3":
            //alert(1)
            submitFastSearch(false)  //提交搜索项目
            break;
        default:
            break;
    }
})

//下级弹窗回调函数
function setReturnValue(obj) {
    //status 0 是列表项的增删改成功
    if (obj.status == 0) {
        getlist();
    } else if (obj.status == 1) {
        menulist();
    } else if (obj.status == 2) {
        fastSearchList();
    } else if (obj.status == 3) {
        searchConfigList();
    }
}

/*
 功能菜单部分
 *
 * */

//请求功能菜单列表
function menulist() {
    $.ajax({
        type: "GET",
        url: menulistUrl,
        data: {"channel": channelid},
        success: function (d) {
            console.log(d)
            if (d.code == 200 && d.data.length > 0) {
                var curItem = "";  //当前功能菜单
                var restmenu = "";  //剩余
                for (var i = 0; i < d.data.length; i++) {
                    if (d.data[i].status == 1) {
                        curItem += '<div  class="left-menu-item menu-item" data-isDefault="' + d.data[i].isDefault + '" data-id="' + d.data[i].id + '" data-isview="' + d.data[i].isview + '" id="menu-item' + d.data[i].id + '">' + d.data[i].icon +
                            '<span class="menu-text menu-item-title" >' + d.data[i].title + '</span>' +
                            '<span class="list-show float-right">' +
                            '<span>列表显示</span>' +
                            '<div class="toggle-wrapper ">';
                        if (d.data[i].isview == 1) {
                            curItem += '<div class="toggle toggle-light success"  data-toggle-on="true"></div>';
                        } else {
                            curItem += '<div class="toggle toggle-light success"  data-toggle-on="false"></div>';
                        }
                        curItem += '</div>' +
                            '<i class="fa fa-sort"></i>' +
                            '</span>' +
                            '<i class="icon ion-close-circled tx-16 menu-delete"></i>' +
                            '</div>';
                    } else {
                        restmenu += '<div class="right-menu-item menu-item" data-isDefault="' + d.data[i].isDefault + '" data-id="' + d.data[i].id + '"  data-isview="' + d.data[i].isview + '" id="menu-item' + d.data[i].id + '">' +
                            d.data[i].icon +
                            '<span class="menu-text menu-item-title">' + d.data[i].title + '</span>' +
                            '<i class="icon ion-android-add-circle tx-16 menu-add"></i>' +
                            '</div>';
                    }
                }
                $(".curmenu-box").html(curItem);
                $(".restmenu").html(restmenu);

                $('.toggle').toggles({
                    height: 20
                });
            }
        },
        error: function (err) {
            console.log(err)
        }
    })
}

//当前功能菜单删除按钮
$('.left-menu').on('click', '.menu-delete', function () {

    var menuAddBtn = '<i class="icon ion-android-add-circle tx-16 menu-add"></i>';
    var nowFunction = $(this).parent().clone(true);   //克隆当前元素
    nowFunction.attr({'class': 'right-menu-item menu-item'})   //清空并赋予新的类名
    nowFunction.children().remove();                 //清空子元素
    nowFunction.append($(this).siblings('.fa,.menu-text')).append(menuAddBtn);   //补全子元素
    $(this).parent().remove();         //删除当前项
    $('.restmenu').append(nowFunction);   //插入到剩余功能菜单
})

//剩余功能菜单添加按钮
$('.right-menu').on('click', '.menu-add', function () {
    var listShow =
        '<span class="list-show float-right">' +
        '<span>列表显示</span>' +
        '<div class="toggle-wrapper ">' +
        '<div class="toggle toggle-light success" data-toggle-on="false"></div>' +
        '</div>' +
        '   <i class="fa fa-sort"></i>' +
        '</span>' +
        '<i class="icon ion-close-circled tx-16 menu-delete"></i>';
    var residual = $(this).parent().clone(true);
    residual.attr({
        'class': 'left-menu-item menu-item'
    })
    residual.children('.menu-add').remove();
    residual.append(listShow);
    residual.find('.toggle').toggles({
        on: false,
        height: 20,
        width: 60
    });
    $(this).parent().remove();
    $('.left-menu .curmenu-box').append(residual);
})

//点击编辑功能菜单项目
$("body").delegate(".menu-item-title", "click", function () {
    console.log($(this))
    var item = $(this).parents(".menu-item");
    var _itemid = item.attr("data-id");
    var _isview = item.attr("data-isview");
    var _isDefault = item.attr("data-isDefault");

    editFuncMenu(_itemid, _isview, 0, _isDefault)
})
//点击添加功能菜单项目
$("body").delegate(".add-function", "click", function () {
    editFuncMenu(0, 0, 1, 0);//
})

//功能菜单项目的新增&编辑
function editFuncMenu(id, isview, isadd, isDefault) {
    //isadd 1为新建  0为编辑
    //isview 1为显示  0为隐藏
    //isDefault 1为系统默认  0为非默认
    var url = path + "/channel/list/config/menu/eoa?channelid=" + channelid + "&itemid=" + id + "&isview=" + isview + "&isadd=" + isadd + "&isDefault=" + isDefault;
    var dialog = new top.TideDialog();
    dialog.setWidth(650);
    dialog.setHeight(506);
    dialog.setUrl(url);
    if (isadd) {
        dialog.setTitle('新增功能菜单项目');
    } else {
        dialog.setTitle('编辑功能菜单项目');
    }
    dialog.show();
}

//功能菜单项目提交
function submitFuncMenu() {
    var currentMenuItem = $(".curmenu-box").find(".left-menu-item"),  //当前功能菜单
        id1 = "";
    if (currentMenuItem.length > 0) {
        $.each(currentMenuItem, function (i, el) {
            console.log($(el).attr("data-id"))
            if (i == 0) {
                id1 += $(el).attr("data-id");
            } else {
                id1 += "," + $(el).attr("data-id");
            }
        });
    } else {
        dialog.showAlert("当前功能菜单不允许为空！", "danger");
        return false;
    }

    var _data = {}
    _data.channel = channelid;
    _data.id1 = id1;

    $.ajax({
        type: "post",
        url: menuSet,
        data: _data,
        success: function (data) {
            console.log(data)
            if (data.code == 200) {
                dialog.showAlert(data.msg);
                top.TideDialogClose();  //关闭弹窗
            } else {
                dialog.showAlert(data.msg);
            }
        },
        error: function (err) {
            console.log(err)
        }
    });
}

//菜单项显示开关
$("body").delegate(".toggle", "click", function () {
    var myToggle = $(this).data('toggle-active');
    var item = $(this).parents(".menu-item");
    var id = item.attr('data-id');
    console.log(myToggle);
    if (myToggle) {
        var isview = 1;
    } else {
        var isview = 0;
    }
    $.ajax({
        type: "post",
        url: menuSwitch + "?id=" + id + "&isview=" + isview,
        success: function (d) {
            if (d.code == 200) {
                dialog.showAlert(d.msg);
                //top.TideDialogClose();  //关闭弹窗
            } else {
                dialog.showAlert(d.msg);
            }
        }
    });
})


/*
 搜索项目
 */

//快捷搜索列表
function fastSearchList() {
    $.ajax({
        type: "GET",
        url: fastSearchUrl,
        data: {"channel": channelid},
        success: function (d) {
            console.log(d)
            if (d.code == 200 && d.data.length > 0) {
                var usedItem = "";  //当前快捷项
                var leftItem = "";  //剩余快捷项
                for (var i = 0; i < d.data.length; i++) {
                    if (d.data[i].status == 1) {
                        usedItem += '<span class="tab-item" data-isDefault="' + d.data[i].isDefault + '" data-id="' + d.data[i].id + '" data-status="' + d.data[i].status + '">' +
                            '<i class="tab-title-i">' + d.data[i].title + '</i>';
                        if (!(d.data[i].code == "allList" || d.data[i].code == "deleteList" || d.data[i].code == "search")) {
                            usedItem += '<span class="icon-create icon-btn edit-item"><i class="icon ion-android-create tx-20 icon-color"></i></span>';
                        }
                        if (d.data[i].code != "allList") {
                            usedItem += '<i class="icon ion-close-circled tx-16 menu-delete"></i>';
                        }
                        usedItem += '</span>';
                    } else {
                        leftItem += '<span class="tab-item" data-isDefault="' + d.data[i].isDefault + '" data-id="' + d.data[i].id + '" data-status="' + d.data[i].status + '">' + d.data[i].title;
                        if (!(d.data[i].code == "allList" || d.data[i].code == "deleteList" || d.data[i].code == "search")) {
                            leftItem += '<span class="icon-create icon-btn edit-item"><i class="icon ion-android-create tx-20 icon-color"></i></span>';
                        }
                        leftItem += '<i class="icon ion-android-add-circle tx-16 menu-add"></i>';
                        leftItem += '</span>';
                    }
                }
                $(".cur-search-box").html(usedItem);
                $(".rest-search-box").html(leftItem);
            }
        },
        error: function (err) {
            console.log(err)
        }
    });
}

//搜索项目配置列表
function searchConfigList() {
    $.ajax({
        type: "GET",
        url: searchConfigUrl,
        data: {"channel": channelid},
        success: function (d) {
            console.log(d)
            if (d.code == 200 && d.data.length > 0) {
                var usedItem = "";  //当前正在用的搜索项
                var leftItem = "";  //剩余搜索项
                for (var i = 0; i < d.data.length; i++) {
                    if (d.data[i].status == 1) {
                        usedItem += '<span class="tab-item" data-isDefault="' + d.data[i].isDefault + '" data-id="' + d.data[i].id + '" data-status="' + d.data[i].status + '">' +
                            '<i class="tab-title-i">' + d.data[i].title + '</i>' +
                            '<span class="icon-create icon-btn edit-item"><i class="icon ion-android-create tx-20 icon-color"></i></span>' +
                            '<i class="icon ion-close-circled tx-16 menu-delete"></i>' +
                            '</span>';
                    } else {
                        leftItem += '<span class="tab-item" data-isDefault="' + d.data[i].isDefault + '" data-id="' + d.data[i].id + '" data-status="' + d.data[i].status + '">' + d.data[i].title +
                            '<span class="icon-create icon-btn edit-item"><i class="icon ion-android-create tx-20 icon-color"></i></span>' +
                            '<i class="icon ion-android-add-circle tx-16 menu-add"></i>' +
                            '</span>';

                    }
                }
                $(".search-config-box").html(usedItem);
                $(".rest-search-config-box").html(leftItem);
            }
        },
        error: function (err) {
            console.log(err)
        }
    });
}

// 添加到当前已配置项目的方法
function transferAdd(item) {
    var addBtn = '<i class="icon ion-android-add-circle tx-16 menu-add"></i>';
    var clone = item.parent().clone(true);
    clone.children('.menu-delete').remove();
    clone.append(addBtn);
    item.parent().remove();
    return clone;
}

// 添加到可用配置的方法
function transferDel(item) {
    var delBtn = '<i class="icon ion-close-circled tx-16 menu-delete"></i>';
    var clone = item.parent().clone(true);
    clone.children('.menu-add').remove();
    clone.append(delBtn);
    item.parent().remove();
    return clone;
}

//当前快捷搜索项的删除
$('.cur-search-box').on('click', '.menu-delete', function () {
    var curFilter = transferAdd($(this));
    $('.rest-search-box').append(curFilter)
})
//剩余快捷搜索项的添加
$('.rest-search-box').on('click', '.menu-add', function () {
    var searchData = transferDel($(this));
    $('.cur-search-box').append(searchData)
})
//搜索项目配置删除
$('.search-config-box').on('click', '.menu-delete', function () {
    var residualShow = transferAdd($(this));
    $('.rest-search-config-box').append(residualShow);
})
//剩余搜索项目配置添加
$('.rest-search-config-box').on('click', '.menu-add', function () {
    var residualTab = transferDel($(this));
    $('.search-config-box').append(residualTab);
})

//快捷检索新增
$("#addFastSearch").click(function () {
    editFastSearch(0, 0, 1, 0)
})
//快捷检索编辑
$(".cur-fast-search , .rest-search-box").delegate(".edit-item", "click", function () {
    var item = $(this).parent(".tab-item");
    var _id = item.attr("data-id");
    var _status = item.attr("data-status");
    var _isDefault = item.attr("data-isDefault");
    console.log(_id);
    editFastSearch(_id, _status, 0, _isDefault);
})

function editFastSearch(id, isview, isadd, isDefault) {
    //id 项目id
    //isadd 1为新建  0为编辑
    //isview 1为显示  0为隐藏
    //isDefault 1为系统默认  0为非默认
    var url = path + "/channel/list/config/fastsearch/eoa?channelid=" + channelid + "&itemid=" + id + "&isview=" + isview + "&isadd=" + isadd + "&isDefault=" + isDefault;
    var dialog = new top.TideDialog();
    dialog.setWidth(760);
    dialog.setHeight(520);
    dialog.setUrl(url);
    if (isadd) {
        dialog.setTitle('新增快捷检索项目');
    } else {
        dialog.setTitle('编辑快捷检索项目');
    }
    dialog.show();
}


//搜索项目配置新增
$("#addSearchConfig").click(function () {
    editSearchConfig(0, 0, 1, 0)
})
//搜索项目配置编辑
$(".search-config-box , .rest-search-config-box").delegate(".edit-item", "click", function () {
    var item = $(this).parent(".tab-item");
    var _id = item.attr("data-id");
    var _status = item.attr("data-status");
    var _isDefault = item.attr("data-isDefault");
    console.log(_id);
    editSearchConfig(_id, _status, 0, _isDefault);
})

function editSearchConfig(id, isview, isadd, isDefault) {
    //id 项目id
    //isadd 1为新建  0为编辑
    //isview 1为显示  0为隐藏
    //isDefault 1为系统默认  0为非默认
    var url = path + "/channel/list/config/search/eoa?channelid=" + channelid + "&itemid=" + id + "&isview=" + isview + "&isadd=" + isadd + "&isDefault=" + isDefault;
    var dialog = new top.TideDialog();
    dialog.setWidth(760);
    dialog.setHeight(520);
    dialog.setUrl(url);
    if (isadd) {
        dialog.setTitle('新增搜索项目');
    } else {
        dialog.setTitle('编辑搜索项目');
    }
    dialog.show();
}

//快捷检索提交
function submitFastSearch() {
    var curItem = $(".cur-search-box").find(".tab-item"),
        id1 = "";
    if (curItem.length > 0) {
        $.each(curItem, function (i, el) {
            console.log($(el).attr("data-id"))
            if (i == 0) {
                id1 += $(el).attr("data-id");
            } else {
                id1 += "," + $(el).attr("data-id");
            }
        });
    } else {
        dialog.showAlert("当前快捷搜索项不允许为空！", "danger");
        return false;
    }

    var _data = {}
    _data.channel = channelid;
    _data.id1 = id1;

    $.ajax({
        type: "post",
        url: fastSearchSubmit,
        data: _data,
        success: function (data) {
            console.log(data)
            if (data.code == 200) {
                //dialog.showAlert( data.msg );
                //top.TideDialogClose();  //关闭弹窗
                submitSearchConfig()
            } else {
                dialog.showAlert(data.msg);
            }
        },
        error: function (err) {
            console.log(err)
        }
    });
}

//搜索配置项提交
function submitSearchConfig() {
    var configItem = $(".search-config-box").find(".tab-item"),
        id1 = "";
    if (configItem.length > 0) {
        $.each(configItem, function (i, el) {
            console.log($(el).attr("data-id"))
            if (i == 0) {
                id1 += $(el).attr("data-id");
            } else {
                id1 += "," + $(el).attr("data-id");
            }
        });
    } else {
        dialog.showAlert("当前搜索配置项不允许为空！", "danger");
        return false;
    }

    var _data = {}
    _data.channel = channelid;
    _data.id1 = id1;

    $.ajax({
        type: "post",
        url: searchconfigSubmit,
        data: _data,
        success: function (data) {
            console.log(data)
            if (data.code == 200) {
                dialog.showAlert(data.msg);
                top.TideDialogClose();  //关闭弹窗
            } else {
                dialog.showAlert(data.msg);
            }
        },
        error: function (err) {
            console.log(err)
        }
    });
}


/*
 拖动排序相关
 * */
$(function () {
    var currentList = $('#currentList')[0];  //当前可用列表项
    var residueList = $('#residueList')[0];  //剩余可用列表项
    var curmenu = $('.curmenu-box')[0];
    var curFastSearch = $('.cur-search-box')[0];
    var searchConfig = $('.search-config-box')[0];


    new Sortable(currentList, {
        group: {
            name: 'currentList',
        },
        dragClass: "cursor-move",
        scroll: true,
        animation: 150


    });
    new Sortable(residueList, {
        group: {
            name: 'residueList',
            //pull: 'clone'
        },
        scroll: true,
        animation: 150
    });
    new Sortable(curmenu, {
        handle: '.fa-sort', // handle's class
        scroll: true,
        animation: 150
    });
    new Sortable(curFastSearch, {
        group: {
            //name: 'shared',
            pull: 'clone'
        },
        scroll: true,
        animation: 150
    });

    new Sortable(searchConfig, {
        group: {
            //name: 'shared',
            pull: 'clone'
        },
        scroll: true,
        animation: 150
    });
})
