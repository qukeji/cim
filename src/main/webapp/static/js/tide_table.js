/*列表页table插件
*用法：
*
*/

var tide_table = {
    thead: {},
    leftButton: {},//左边功能模块数据（列表页查询功能组）
    rightButton: {},//右边功能模块数据（列表页数据操作功能组）
    channel_search:{},
    listButtonStr: "",//存放列表功能组模块html字符串
    parameter: "",//接口请求参数拼接字符串
    totalPageNumber:0,
    querystring:"",
    listType: 1,
    cols: 5,
    channelid:0,
    showTable: function () {
        var table = $('<table class="table mg-b-0 " id="content-table"></table>');
        $("#div_table1").append(table);
        this.getLeftButton();
        this.getRightButton();
        this.getSearchForm();
        this.adjustScreen();
        $(window).on("resize", function () {
            tide_table.adjustScreen();
        })
        this.getListButton();
        if (this.listType == 1) {
            table.append(this.getThead());
        }
        this.loadData();
    },
    setThead: function (a) {
        this.thead = a;
    },

    setParameter: function (a) {
        this.parameter = a;
    },

    setListType: function (a) {
        this.listType = a;
    },
    setCols: function (a) {
        this.cols = a;
    },
    setChannelId: function (a) {
        this.channelid = a;
    },
    setChannel_search: function (a) {
        this.channel_search = a;
    },
    setTotalPageNumber: function (a) {
        this.totalPageNumber = a;
    },
    getTotalPageNumber: function () {
        return this.totalPageNumber;
    },
    setQuerystring: function (a) {
        this.querystring = a;
    },
    getQuerystring: function () {
        return this.querystring;
    },
    getThead: function () {
        var str = "<thead><tr>";
        /*str +='<th class="wd-5p wd-50">选择</th>';
        str +='<th class="tx-12-force tx-mont tx-medium">标题</th>';
        str +='<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-60">状态</th>';
        str +='<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">日期</th>';
        str +='<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120 wd-author">作者</th>';
        str +='<th class="tx-12-force wd-100 tx-mont tx-medium hidden-xs-down wd-160">操作</th>';*/
        console.log(this.thead);
        for (i = 0; i < this.thead.length; i++) {
            if (this.thead[i].fieldName == "") {
                str += '<th class="wd-5p wd-' + this.thead[i].width + '">' + this.thead[i].title + '</th>';
            } else if (this.thead[i].fieldName == "Title") {
                str += '<th class="tx-12-force tx-mont tx-medium">' + this.thead[i].title + '</th>';
            } else if (this.thead[i].fieldName == "UserName") {
                str += '<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-author wd-' + this.thead[i].width + '">' + this.thead[i].title + '</th>';
            } else {
                str += '<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-' + this.thead[i].width + ' ' + this.thead[i].title + '">' + this.thead[i].title + '</th>';
            }

        }
        str += "</tr></thead>";
        return str;
    },
    loadData: function (str)   //表格数据
    {
        var url = "../content/list_info/json?" + this.parameter;
        if (typeof(str) != 'undefined')
            url += "&" + str;
        var listStr = this.listButtonStr;
        var listbutton = this.rightButton;
        var listButtonStr = "";
        for (i=0;i<listbutton.length;i++){
            if (listbutton[i].status ==1 && listbutton[i].isview ==1){
                var script = listbutton[i].script;
                var scripts = script.split(';');
                listButtonStr += '<a href="javascript:'+scripts[1]+'" class="btn pd-0 mg-r-5 clickButton" isList="1" title="'+listbutton[i].title+'">'+listbutton[i].icon+'</a>';
            }
        }
        console.log(listbutton);
        var listType = this.listType;
        var cols = this.cols;
        var channelid = this.channelid;
        var id_ = 0;
        var totalPageNumber = 0;
        var querystring = "";
        $.ajax({
            type: "GET",
            dataType: "json",
            url: url,
            async: false,
            beforeSend: function () {
                $('.loadpagediv').show()
            },
            success: function (json) {
                var str = "<tbody>";
                if (listType == 2) {
                    var m = 0
                    for (i = 0; i < json.list.length; i++) {
                        console.log(json.list);
                        id_ = json.list[i].id_;
                        if (m == 0)
                            str += '<tr>';
                        m++;
                        str += '<td id="item_' + json.list[i].id_ + '" status="' + json.list[i].Status + '" class="tide_item" class="c">';
                        str += '<div class="row">';
                        str += '<div class="col-md">';
                        str += '<div class="card bd-0">';
                        str += '<div class="list-pic-box">';
                        str += '<div class="list-img-contanier">';
                        str += '<img class="card-img-top" src="' + json.list[i].photoAddr + '" alt="Image" onerror="checkLoad(this);" >';
                        str += '</div></div>';
                        str += '<div class="card-body bd-t-0 rounded-bottom">';
                        str += '<p class="card-text">';
                        if (json.list[i].TopStatus != 0)
                            str += '<i class="fa fa-upload tx-20 tx-warning lh-0 valign-middle" id="imgtop_' + json.list[i].j + '" title="置顶"></i>';
                        str += json.list[i].Title + '(' + json.list[i].StatusDesc + ')</p>';
                        str += '<div class="row mg-l-0 mg-r-0 mg-t-5">';
                        str += '<label class="ckbox mg-b-0 d-inline-block mg-r-5">';
                        str += '<input name="id" value="' + json.list[i].id_ + '" type="checkbox"><span></span>';
                        str += '</label>';
                        str += listButtonStr;
                        /*str += '<a href="javascript:approve2(' + id_ + ');" class="btn pd-0 mg-r-5" title="发布"><i class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>';
                        str += '<a href="javascript:Preview2(' + id_ + ');" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>';
                        str += '<a href="javascript:Preview3(' + id_ + ');" class="btn pd-0 mg-r-5" title="正式地址预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>';*/
                        str += '</div></div></div></div></div></td>';
                        if (m == cols) {
                            str += '</tr>';
                            m = 0;
                        }
                        str = str.replace(/\$itemid\$/ig, id_);
                        str = str.replace(/\$channelid\$/ig,channelid);
                    }
                } else {
                    for (i = 0; i < json.list.length; i++) {
                        id_ = json.list[i].id_;
                        str += '<tr No=' + json.list[i].j + ' itemid="' + json.list[i].id_ + '" OrderNumber="' + json.list[i].OrderNumber + '" status="' + json.list[i].Status + '" GlobalID="' + json.list[i].GlobalID + '" id="item_' + json.list[i].id_ + '" class="tide_item">';
                        for (var j = 0; j < tide_table.thead.length; j++) {
                            var title = tide_table.thead[j].title;
                            if (title == "选择") {
                                str += '<td class="valign-middle"><label class="ckbox mg-b-0"><input type="checkbox" name="id" value="' + json.list[i].id_ + '"><span></span></label></td>'
                            } else if (title == "标题") {
                                str += '<td ondragstart="OnDragStart(event)">';
                                if (json.list[i].IsPhotoNews == 1)
                                    str += '<i class="fa fa-picture-o drag-list tx-18 tx-primary lh-0 valign-middle mg-r-5" id="img_' + json.list[i].j + '"></i>';
                                else
                                    str += '<i class="icon drag-list ion-clipboard tx-22 tx-warning lh-0 valign-middle mg-r-5" id="img_' + json.list[i].j + '"></i>';
                                if (json.list[i].TopStatus != 0)
                                    str += '<i class="fa fa-upload tx-20 tx-warning lh-0 valign-middle" id="imgtop_' + json.list[i].j + '" title="置顶"></i>';
                                str += '<span class="pd-l-5 tx-black">' + json.list[i].Title + '</span></td>';
                            } else if (title == "操作") {
                                str += '<td class="dropdown hidden-xs-down">';
                                str += listButtonStr;
                                /*str += '<a href="javascript:approve2(' + id_ + ');" class="btn pd-0 mg-r-5" title="发布"><i class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>';
                                str += '<a href="javascript:Preview2(' + id_ + ');" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>';
                                str += '<a href="javascript:Preview3(' + id_ + ');" class="btn pd-0 mg-r-5" title="正式地址预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>';*/
                                str += '<a href="#" data-toggle="dropdown" class="btn pd-y-3 tx-gray-500 hover-info" οnclick="uncheck(item_' + id_ + ')"><i class="icon ion-more"></i></a><div class="dropdown-menu dropdown-menu-right pd-10">';
                                str += '<nav class="nav nav-style-1 flex-column listButtton">';
                                str += listStr;
                                str += '</nav></div></td>';
                            } else if (title == "状态") {
                                /*if (IsWeight == 1)
                                    str += '<td class="hidden-xs-down"><span itemid="' + json.list[i].id_ + '">' + json.list[i].Weight + '</span>';*/
                                str += '<td class="hidden-xs-down">' + json.list[i].StatusDesc + '</td>';
                            } else if (title == "创建日期") {
                                var ModifiedDate = json.list[i].ModifiedDate;
                                str += '<td class="hidden-xs-down" ' +
                                    '<div class="content-time" title="' + ModifiedDate + '">' +
                                    '<span class="article-md">' + ModifiedDate.substr(5, 6) + '</span>' +
                                    '<span class="article-md">' + ModifiedDate.substr(11, 15) + '</span>' +
                                    '</div></td>';
                            } else {
                                var key = tide_table.translate(tide_table.thead, title);
                                var sss = json.list[i][key];
                                if (typeof(sss) == 'undefined') {
                                    sss = "";
                                }
                                str += '<td class="hidden-xs-down">' + sss + '</td>';
                            }
                        }
                        str = str.replace(/\$itemid\$/ig, id_);
                        str = str.replace(/\$channelid\$/ig,channelid);
                    }

                }
                str += "</tbody>";

                var str1 = '<span class="mg-r-20 ">共' + json.TotalNumber + '条</span><span class="mg-r-20 ">' + json.currPage + '/' + json.TotalPageNumber + '页</span>';
                $('.paging').find(".btn-outline-info").remove();
                if (json.currPage >1) {
                    var right = '<a href="javascript:gopage('+(json.currPage-1)+')" class="btn btn-outline-info"><i class="fa fa-chevron-left"></i></a>'
                    $('.paging').append(right);
                }
                if (json.currPage < json.TotalPageNumber) {
                    var right = '<a href="javascript:gopage('+(json.currPage+1)+')" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>'
                    $('.paging').append(right);
                }
                $('#num-page').empty();
                $('#content-table').find(".tide_item").remove();
                $('#num-page').append(str1);
                $('#content-table').append(str);
                $('.loadpagediv').hide();
                if (json.TotalNumber > 0){
                    $('#tide_content_tfoot').show();
                }
                if (json.TotalNumber == 0){
                    $('#tide_content_tfoot').hide();
                }
                if (listType == 2){
                    $('#content-table').addClass("table-fixed");
                }
                totalPageNumber = json.TotalPageNumber;
                querystring = json.querystring;
                initCheck();
            }
        });
        this.setTotalPageNumber(totalPageNumber);
        this.setQuerystring(querystring);
    },
    getLeftButton: function ()//左边布局按钮模块
    {
        var str1 = "";
        var str2 = "";
        for (i = 0; i < this.leftButton.length; i++) {
            if (this.leftButton[i].status == 1) {
                console.log(this.leftButton[i]);
                if (this.leftButton[i].title == '全部') {
                    if (this.leftButton[i].script.length > 0) {
                        str1 += '<a href="javascript:' + this.leftButton[i].script + '" class="nav-link list_draft active">' + this.leftButton[i].title + '</a>';
                        str2 += '<a href="javascript:' + this.leftButton[i].script + '" class="btn btn-outline-info list_all active">' + this.leftButton[i].title + '</a>';
                    } else {
                        str1 += '<a href="javascript:list()" class="nav-link list_draft active">' + this.leftButton[i].title + '</a>';
                        str2 += '<a href="javascript:list()" class="btn btn-outline-info list_all active">' + this.leftButton[i].title + '</a>';
                    }
                } else if (this.leftButton[i].title == '草稿') {
                    if (this.leftButton[i].script.length > 0) {
                        str1 += '<a href="javascript:' + this.leftButton[i].script + '" class="nav-link list_draft">' + this.leftButton[i].title + '</a>';
                        str2 += '<a href="javascript:' + this.leftButton[i].script + '" class="btn btn-outline-info list_draft">' + this.leftButton[i].title + '</a>';
                    } else {
                        str1 += '<a href="javascript:list(\'fastSearchId=' + this.leftButton[i].id + '\')" class="nav-link list_draft">' + this.leftButton[i].title + '</a>';
                        str2 += '<a href="javascript:list(\'fastSearchId=' + this.leftButton[i].id + '\')" class="btn btn-outline-info list_draft">' + this.leftButton[i].title + '</a>';
                    }
                } else if (this.leftButton[i].title == '已发') {
                    if (this.leftButton[i].script.length > 0) {
                        str1 += '<a href="javascript:' + this.leftButton[i].script + '" class="nav-link list_draft">' + this.leftButton[i].title + '</a>';
                        str2 += '<a href="javascript:' + this.leftButton[i].script + '" class="btn btn-outline-info list_publish">' + this.leftButton[i].title + '</a>';
                    } else {
                        str1 += '<a href="javascript:list(\'fastSearchId=' + this.leftButton[i].id + '\')" class="nav-link list_draft">' + this.leftButton[i].title + '</a>';
                        str2 += '<a href="javascript:list(\'fastSearchId=' + this.leftButton[i].id + '\')" class="btn btn-outline-info list_publish">' + this.leftButton[i].title + '</a>';
                    }
                } else if (this.leftButton[i].title == '已删除') {
                    if (this.leftButton[i].script.length > 0) {
                        str1 += '<a href="javascript:' + this.leftButton[i].script + '" class="nav-link list_draft">' + this.leftButton[i].title + '</a>';
                        str2 += '<a href="javascript:' + this.leftButton[i].script + '" class="btn btn-outline-info list_delete">' + this.leftButton[i].title + '</a>';
                    } else {
                        str1 += '<a href="javascript:list(\'fastSearchId=-1\')" class="nav-link list_draft">' + this.leftButton[i].title + '</a>';
                        str2 += '<a href="javascript:list(\'fastSearchId=-1\')" class="btn btn-outline-info list_delete">' + this.leftButton[i].title + '</a>';
                    }
                } else if (this.leftButton[i].title == '搜索') {
                    if (this.leftButton[i].script.length > 0) {
                        str1 += '<a href="javascript:' + this.leftButton[i].script + '" class="nav-link list_draft">' + this.leftButton[i].title + '</a>';
                        str2 += '<a href="javascript:' + this.leftButton[i].script + '" class="btn btn-outline-info btn-search">' + this.leftButton[i].title + '</a>';
                    } else {
                        str1 += '<a href="javascript:" class="nav-link list_draft">' + this.leftButton[i].title + '</a>';
                        str2 += '<a href="javascript:" class="btn btn-outline-info btn-search">' + this.leftButton[i].title + '</a>';
                    }
                }else {
                    if (this.leftButton[i].script.length > 0) {
                        str1 += '<a href="javascript:' + this.leftButton[i].script + '" class="nav-link list_draft">' + this.leftButton[i].title + '</a>';
                        str2 += '<a href="javascript:' + this.leftButton[i].script + '" class="btn btn-outline-info list_draft">' + this.leftButton[i].title + '</a>';
                    } else {
                        str1 += '<a href="javascript:list(\'fastSearchId=' + this.leftButton[i].id + '\')" class="nav-link list_draft">' + this.leftButton[i].title + '</a>';
                        str2 += '<a href="javascript:list(\'fastSearchId=' + this.leftButton[i].id + '\')" class="btn btn-outline-info list_draft">' + this.leftButton[i].title + '</a>';
                    }
                }
            }
        }
        $(".btn_left").append(str1);
        $(".operation_btn_left").append(str2);
    },

    setLeftButton: function (a) {
        this.leftButton = a;
    },

    translate: function (object, value) {
        for (k = 0; k < object.length; k++) {
            for (var key in object[k]) {
                if (object[k][key] == value) {
                    return object[k]["fieldName"];
                }
            }
        }
    },

    getRightButton: function ()  //右边操作按钮模块
    {
        var str1 = "";    //操作栏按钮数据
        var str2 = "";    //下拉操作按钮数据
        var channelid = this.channelid;
        console.log(channelid);
        for (i = 0; i < this.rightButton.length; i++) {
            if (this.rightButton[i].status == 1) {

                var script = this.rightButton[i].script;
                var scripts = script.split(';');
                str1 += '<a href="javascript:' + scripts[0] + '" class="btn btn-outline-info clickButton" isList="0">' + this.rightButton[i].title + '</a>';

                str2 += '<a href="javascript:' + scripts[0] + '" class="nav-link">' + this.rightButton[i].title + '</a>';

            } else if (this.rightButton[i].status == 1 && this.rightButton[i].isview == 0) {
                //str2 +='<a href="javascript:'+this.rightButton[i].script+'" class="nav-link">'+this.rightButton[i].title+'</a>';
            }
            str1 = str1.replace(/\$channelid\$/ig,channelid);
            str2 = str2.replace(/\$channelid\$/ig,channelid);
        }

        $(".btn_right").append(str1);
        $(".operation_btn_right").append(str2);
    },
    getListButton: function ()   //列表页功能模块
    {
        var str = "";
        for (i = 0; i < this.rightButton.length; i++) {
            var script = this.rightButton[i].script;
            var scripts = script.split(';');
            if (this.rightButton[i].status == 1 && this.rightButton[i].isview != 1) {
                str += '<a href="javascript:' + scripts[1] + '" class="nav-link">' + this.rightButton[i].title + '</a>';
            }
        }
        this.listButtonStr = str;
    },

    setRightButton: function (a) {
        this.rightButton = a;
    },
    adjustScreen: function () {
        var dropdown_btn = $(".operation_btn_right"),
            dropdown_btn_a = dropdown_btn.find("a"),
            dropdown_box = $(".list-dropdown-right"),
            btn_num = $(dropdown_btn.get(0)).find("a").length;
        if (window.matchMedia('(max-width: 640px)').matches) {
            dropdown_box.show();
            dropdown_btn_a.show();
        } else if (window.matchMedia('(min-width: 641px)').matches && window.matchMedia('(max-width: 870px)').matches) {
            if (btn_num > 3) {
                dropdown_box.show();
                dropdown_btn_a.hide();
                $(".operation_btn_right a:nth-child(n+4)").show();
            }
        } else if (window.matchMedia('(min-width: 641px)').matches && window.matchMedia('(max-width: 1076px)').matches) {
            if (btn_num > 6) {
                dropdown_box.show();
                dropdown_btn_a.hide();
                $(".operation_btn_right a:nth-child(n+7)").show();
            }
        } else if (window.matchMedia('(min-width: 1077px)').matches && window.matchMedia('(max-width: 1290px)').matches) {
            if (btn_num > 9) {
                dropdown_box.show();
                dropdown_btn_a.hide();
                $(".operation_btn_right a:nth-child(n+10)").show();
            }
        } else if (window.matchMedia('(min-width: 1291px)').matches && window.matchMedia('(max-width: 1630px)').matches) {
            if (btn_num > 12) {
                dropdown_box.show();
                dropdown_btn_a.hide();
                $(".operation_btn_right a:nth-child(n+13)").show();
            }
        } else if (window.matchMedia('(min-width: 1630px)').matches) {
            $(".list-dropdown-right").hide();
        }
    },
    getSearchForm: function () {
        var str = '<form name="search_form" id="search_form" action="../content/list_info/json?'+this.parameter+'" method="POST" onsubmit="return check();"><div class="row">';
        console.log(this.channel_search);
        for (i = 0;i < this.channel_search.length;i++){
            var fieldName = this.channel_search[i].fieldName;
            if (fieldName == "Title" && this.channel_search[i].status == 1) {
                str += '<div class="mg-r-10 mg-b-30 search-item"><input class="form-control search-title" placeholder="标题" type="text" name="Title" onClick="this.select()"></div>';
            } else if (fieldName.indexOf("Date") != -1 && this.channel_search[i].status == 1) {
                str += '<div class="wd-200 mg-b-30 mg-r-10 search-item">' +
                    '<div class="input-group">' +
                    '<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>' +
                    '<input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="'+fieldName+'_start" id="'+fieldName+'_start">' +
                    '</div>' +
                    '</div>' +
                    '<div class="wd-20 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">至</div>' +
                    '<div class="wd-200 mg-b-30 mg-r-10 search-item">' +
                    '<div class="input-group">' +
                    '<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>' +
                    '<input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="'+fieldName+'_end" id="'+fieldName+'_end">' +
                    '</div>' +
                    '</div>';
            } else if (fieldName == "Author" && this.channel_search[i].status == 1) {
                str += '<div class="mg-r-10 mg-b-30 search-item">' +
                    '<div class="input-group">' +
                    '<span class="input-group-addon"><i class="icon ion-person tx-16 lh-0 op-6"></i></span>' +
                    '<input type="text" class="form-control search-author" placeholder="作者" name="User">' +
                    '</div>' +
                    '</div>';
            }else if (fieldName == "Status" && this.channel_search[i].status == 1) {
                str += '<div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">'+
                    '<select class="form-control select2" data-placeholder="状态" name="Status">'+
                    '<option label="Choose one"></option>'+
                    '<option value="0">全部</option>'+
                    '<option value="2" >已发</option>'+
                    '<option value="1" >草稿</option>'+
                    '</select>'+
                    '</div>';
                //<%=(S_Status==2?"selected":"")%>  <%=(S_Status==1?"selected":"")%>
            }else if(this.channel_search[i].status == 1) {
                str += '<div class="mg-r-10 mg-b-30 search-item"><input class="form-control search-' + this.channel_search[i].fieldName + '" placeholder="' + this.channel_search[i].title + '" type="text" name="' + this.channel_search[i].fieldName + '" onClick="this.select()"></div>';
            }
        }
        str += '<div class="search-item mg-b-30">\n' +
            '<input type="hidden" name="IsIncludeSubChannel" value="1">\n' +
            '<input type="button" name="Submit" onclick="submitForm()" value="搜索" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">\n' +
            '<input type="hidden" name="OpenSearch" id="OpenSearch" value="1">\n' +
            '</div></div></form>';
        $(".search-content").append(str);
    },
    search : function () {
        var listStr = this.listButtonStr;
        var listbutton = this.rightButton;
        var listButtonStr = "";
        for (i=0;i<listbutton.length;i++){
            if (listbutton[i].status ==1 && listbutton[i].isview ==1){
                var script = listbutton[i].script;
                var scripts = script.split(';');
                listButtonStr += '<a href="javascript:'+scripts[1]+'" class="btn pd-0 mg-r-5 clickButton" isList="1" title="'+listbutton[i].title+'">'+listbutton[i].icon+'</a>';
            }
        }
        var listType = this.listType;
        var cols = this.cols;
        var channelid = this.channelid;
        var id_ = 0;
        var totalPageNumber = 0;
        var querystring = "";
        $.ajax({
            type: "GET",
            dataType: "json",
            data:$('#search_form').serialize(),
            url: "../content/list_info/json?"+Parameter,
            async: false,
            beforeSend: function () {
                $('.loadpagediv').show()
            },
            success: function (json) {
                var str = "<tbody>";
                if (listType == 2) {
                    var m = 0
                    for (i = 0; i < json.list.length; i++) {
                        id_ = json.list[i].id_;
                        if (m == 0)
                            str += '<tr>';
                        m++;
                        str += '<td id="item_' + json.list[i].id_ + '" status="' + json.list[i].Status + '" class="tide_item" class="c">';
                        str += '<div class="row">';
                        str += '<div class="col-md">';
                        str += '<div class="card bd-0">';
                        str += '<div class="list-pic-box">';
                        str += '<div class="list-img-contanier">';
                        str += '<img class="card-img-top" src="' + json.list[i].photoAddr + '" alt="Image" onerror="checkLoad(this);" >';
                        str += '</div></div>';
                        str += '<div class="card-body bd-t-0 rounded-bottom">';
                        str += '<p class="card-text">';
                        if (json.list[i].TopStatus != 0)
                            str += '<i class="fa fa-upload tx-20 tx-warning lh-0 valign-middle" id="imgtop_' + json.list[i].j + '" title="置顶"></i>';
                        str += json.list[i].Title + '(' + json.list[i].StatusDesc + ')</p>';
                        str += '<div class="row mg-l-0 mg-r-0 mg-t-5">';
                        str += '<label class="ckbox mg-b-0 d-inline-block mg-r-5">';
                        str += '<input name="id" value="' + json.list[i].id_ + '" type="checkbox"><span></span>';
                        str += '</label>';
                        str += listButtonStr;
                        str += '</div></div></div></div></div></td>';
                        if (m == cols) {
                            str += '</tr>';
                            m = 0;
                        }
                        str = str.replace(/\$itemid\$/ig, id_);
                        str = str.replace(/\$channelid\$/ig,channelid);
                    }

                } else {
                    for (i = 0; i < json.list.length; i++) {
                        id_ = json.list[i].id_;
                        str += '<tr No=' + json.list[i].j + ' itemid="' + json.list[i].id_ + '" OrderNumber="' + json.list[i].OrderNumber + '" status="' + json.list[i].Status + '" GlobalID="' + json.list[i].GlobalID + '" id="item_' + json.list[i].id_ + '" class="tide_item">';
                        for (var j = 0; j < tide_table.thead.length; j++) {
                            var title = tide_table.thead[j].title;
                            if (title == "选择") {
                                str += '<td class="valign-middle"><label class="ckbox mg-b-0"><input type="checkbox" name="id" value="' + json.list[i].id_ + '"><span></span></label></td>'
                            } else if (title == "标题") {
                                str += '<td ondragstart="OnDragStart(event)">';
                                if (json.list[i].IsPhotoNews == 1)
                                    str += '<i class="fa fa-picture-o drag-list tx-18 tx-primary lh-0 valign-middle mg-r-5" id="img_' + json.list[i].j + '"></i>';
                                else
                                    str += '<i class="icon drag-list ion-clipboard tx-22 tx-warning lh-0 valign-middle mg-r-5" id="img_' + json.list[i].j + '"></i>';
                                if (json.list[i].TopStatus != 0)
                                    str += '<i class="fa fa-upload tx-20 tx-warning lh-0 valign-middle" id="imgtop_' + json.list[i].j + '" title="置顶"></i>';
                                str += '<span class="pd-l-5 tx-black">' + json.list[i].Title + '</span></td>';
                            } else if (title == "操作") {
                                str += '<td class="dropdown hidden-xs-down">';
                                str += listButtonStr;
                                str += '<a href="#" data-toggle="dropdown" class="btn pd-y-3 tx-gray-500 hover-info" οnclick="uncheck(item_' + id_ + ')"><i class="icon ion-more"></i></a><div class="dropdown-menu dropdown-menu-right pd-10">';
                                str += '<nav class="nav nav-style-1 flex-column listButtton">';
                                str += listStr;
                                str += '</nav></div></td>';
                            } else if (title == "状态") {
                                /*if (IsWeight == 1)
                                    str += '<td class="hidden-xs-down"><span itemid="' + json.list[i].id_ + '">' + json.list[i].Weight + '</span>';*/
                                str += '<td class="hidden-xs-down">' + json.list[i].StatusDesc + '</td>';
                            } else if (title == "创建日期") {
                                var ModifiedDate = json.list[i].ModifiedDate;
                                str += '<td class="hidden-xs-down" ' +
                                    '<div class="content-time" title="' + ModifiedDate + '">' +
                                    '<span class="article-md">' + ModifiedDate.substr(5, 6) + '</span>' +
                                    '<span class="article-md">' + ModifiedDate.substr(11, 15) + '</span>' +
                                    '</div></td>';
                            } else {
                                var key = tide_table.translate(tide_table.thead, title);
                                var sss = json.list[i][key];
                                if (typeof(sss) == 'undefined') {
                                    sss = "";
                                }
                                str += '<td class="hidden-xs-down">' + sss + '</td>';
                            }
                        }
                        str = str.replace(/\$itemid\$/ig, id_);
                        str = str.replace(/\$channelid\$/ig,channelid);
                    }
                }
                str += "</tbody>";

                var str1 = '<span class="mg-r-20 ">共' + json.TotalNumber + '条</span><span class="mg-r-20 ">' + json.currPage + '/' + json.TotalPageNumber + '页</span>';
                $('.paging').find(".btn-outline-info").remove();
                if (json.currPage >1) {
                    var right = '<a href="javascript:gopage('+(json.currPage-1)+')" class="btn btn-outline-info"><i class="fa fa-chevron-left"></i></a>'
                    $('.paging').append(right);
                }
                if (json.currPage < json.TotalPageNumber) {
                    var right = '<a href="javascript:gopage('+(json.currPage+1)+')" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>'
                    $('.paging').append(right);
                }
                $('#num-page').empty();
                $('#content-table').find(".tide_item").remove();
                $('#num-page').append(str1);
                $('#content-table').append(str);
                $('.loadpagediv').hide();
                if (json.TotalNumber > 0){
                    $('#tide_content_tfoot').show();
                }
                if (json.TotalNumber == 0){
                    $('#tide_content_tfoot').hide();
                }
                if (listType == 2){
                    $('#content-table').addClass("table-fixed");
                }
                initCheck();
                totalPageNumber = json.TotalPageNumber;
                querystring = json.querystring;
            }
        })
        this.setTotalPageNumber(totalPageNumber);
        this.setQuerystring(querystring);
    }
};
