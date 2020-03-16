/*列表页table插件
*用法：
*
*/

var tide_table={
    thead:{},
    leftButton:{},
    rightButton:{},
    listButtonStr:"",//存放列表功能组模块html字符串
    parameter:"",

    showTable:function(){
        var table=$('<table class="table mg-b-0 " id="content-table"></table>');

        $("#div_table1").append(table);
        table.append(this.getThead());
        this.getLeftButton();
        this.getRightButton();
        this.getListButton();
        this.loadData();
        //alert(this.getThead());
    },
    setThead:function(a)
    {
        this.thead = a;
    },

    setParameter:function(a)
    {
        this.parameter = a;
    },

    getThead:function()
    {
        var str = "<thead><tr>";
        /*str +='<th class="wd-5p wd-50">选择</th>';
        str +='<th class="tx-12-force tx-mont tx-medium">标题</th>';
        str +='<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-60">状态</th>';
        str +='<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">日期</th>';
        str +='<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120 wd-author">作者</th>';
        str +='<th class="tx-12-force wd-100 tx-mont tx-medium hidden-xs-down wd-160">操作</th>';*/
        for(i = 0;i < this.thead.length;i++)
        {
            //window.console.info(this.thead[i]);
            if(this.thead[i].orderNumber == 1){
                str +='<th class="wd-5p wd-'+this.thead[i].width+'">'+this.thead[i].title+'</th>';
            }else if (this.thead[i].orderNumber == 2){
                str +='<th class="tx-12-force tx-mont tx-medium">'+this.thead[i].title+'</th>';
            }else if(this.thead[i].orderNumber == 5){
                str +='<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-author wd-'+this.thead[i].width+'">'+this.thead[i].title+'</th>';
            }else{
                str +='<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-'+this.thead[i].width+'">'+this.thead[i].title+'</th>';

            }

        }
        str += "</tr></thead>";
        return str;
    },

    loadData:function()
    {
        var url="../content/list_info/json?" + this.parameter;
        var listStr = this.listButtonStr;
        $.ajax({
            type: "GET",
            dataType:"json",
            url: url,
            beforeSend:function(){$('.loadpagediv').show()},
            success: function(json){
                var str = "<tbody>";
                for(i = 0;i < json.list.length;i++)
                {
                    if (json.list[i].active == 1){
                        str +='<tr No='+json.list[i].j+' ItemID="'+json.list[i].id_+'" OrderNumber="'+json.list[i].OrderNumber+'" status="'+json.list[i].Status+'" GlobalID="'+json.list[i].GlobalID+'" id="item_'+json.list[i].id_+'" class="tide_item">'+
                            '<td class="valign-middle"><label class="ckbox mg-b-0"><input type="checkbox" name="id" value="'+json.list[i].id_+'"><span></span></label></td>';
                        str += '<td ondragstart="OnDragStart(event)">';
                        if (json.list[i].IsPhotoNews == 1)
                            str += '<i class="fa fa-picture-o drag-list tx-18 tx-primary lh-0 valign-middle mg-r-5" id="img_'+json.list[i].j+'"></i>';
                        else
                            str += '<i class="icon drag-list ion-clipboard tx-22 tx-warning lh-0 valign-middle mg-r-5" id="img_'+json.list[i].j+'"></i>';

                        if (json.list[i].TopStatus != 0)
                            str += '<i class="fa fa-upload tx-20 tx-warning lh-0 valign-middle" id="imgtop_'+json.list[i].j+'" title="置顶"></i>';

                        str += '<span class="pd-l-5 tx-black">'+json.list[i].Title+'</span></td>';
                        str += '</td>';
                        if (IsWeight == 1)
                            str += '<td class="hidden-xs-down"><span ItemID="'+json.list[i].id_+'">'+json.list[i].Weight+'</span>';
                        str += '<td class="hidden-xs-down">'+json.list[i].StatusDesc+'</td>';
                        // str += '<td class="hidden-xs-down">'+json.list[i].ModifiedDate+'</td>';
                        var ModifiedDate = json.list[i].ModifiedDate;
                        str += '<td class="hidden-xs-down" ' +
                               '<div class="content-time" title="'+ModifiedDate+'">' +
                               '<span class="article-md">'+ModifiedDate.substr(5,6)+'</span>' +
                               '<span class="article-md">'+ModifiedDate.substr(11,15)+'</span>' +
                               '</div></td>';
                        str += '<td class="hidden-xs-down">'+json.list[i].UserName+'</td>';
                        str += '<td class="dropdown hidden-xs-down">';
                        if (json.list[i].active ==1){
                            str += '<a href="javascript:approve2('+json.list[i].id_+');" class="btn pd-0 mg-r-5" title="发布"><i class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>';
                            str += '<a href="javascript:Preview2('+json.list[i].id_+');" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>';
                            str += '<a href="javascript:Preview3('+json.list[i].id_+');" class="btn pd-0 mg-r-5" title="正式地址预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>';
                        }
                        str += '<a href="#" data-toggle="dropdown" class="btn pd-y-3 tx-gray-500 hover-info"><i class="icon ion-more"></i></a><div class="dropdown-menu dropdown-menu-right pd-10">';
                        str += '<nav class="nav nav-style-1 flex-column listButtton">';
                        str += listStr;
                        str += '</nav></div></td></tr>';
                    }
                }
                str += "</tbody>";


                var str1 = '<span class="mg-r-20 ">共'+json.TotalNumber+'条</span><span class="mg-r-20 ">'+json.currPage+'/'+json.TotalPageNumber+'页</span>';
                $('#num-page').append(str1);
                $('#content-table').append(str);
                $('.loadpagediv').hide();

            }
        });
    },
    getLeftButton:function()//左边按钮模块
    {
        var str1 = "";
        var str2 = "";
        for(i = 0;i < this.leftButton.length;i++)
        {
            if (this.leftButton[i].status == 1){
                str1 +='<a href="javascript:'+this.leftButton[i].script+'" class="nav-link list_draft">'+this.leftButton[i].title+'</a>';
                str2 +='<a href="javascript:'+this.leftButton[i].script+'" class="btn btn-outline-info list_all">'+this.leftButton[i].title+'</a>';
            }
        }
        $(".btn_left").append(str1);
        $(".operation_btn_left").append(str2);
    },

    setLeftButton:function(a)
    {
        this.leftButton = a;
    },

    getRightButton:function()//右边按钮模块
    {
        var str1 = "";
        var str2 = "";
        for(i = 0;i < this.rightButton.length;i++)
        {
            if (this.rightButton[i].status == 1 && this.rightButton[i].isview ==1 ){
                str1 +='<a href="javascript:'+this.rightButton[i].script+'" class="btn btn-outline-info">'+this.rightButton[i].title+'</a>';
            }else if (this.rightButton[i].status == 1 && this.rightButton[i].isview ==0 ) {
                str2 +='<a href="javascript:'+this.rightButton[i].script+'" class="nav-link">'+this.rightButton[i].title+'</a>';
            }
        }
        $(".btn_right").append(str1);
        $(".operation_btn_right").append(str2);
    },
    getListButton:function()//列表页功能模块
    {
        var str = "";
        for(i = 0;i < this.rightButton.length;i++)
        {
            if (this.rightButton[i].status == 1){
                str +='<a href="javascript:'+this.rightButton[i].script+'" class="nav-link">'+this.rightButton[i].title+'</a>';
            }
        }
        this.listButtonStr = str;
    },

    setRightButton:function(a)
    {
        this.rightButton = a;
    },


};


