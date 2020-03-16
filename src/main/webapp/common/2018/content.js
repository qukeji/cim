$(document).ready(function() {

    if(typeof(page)=="object")
    {
        $("#rowsPerPage").val(page.rowsPerPage);
    }

    if(listType==2){

        $("#rows").val(rows);
        $("#cols").val(cols);
    }

    double_click();
});

function view1() {
    var obj=getCheckbox();
    if(obj.length==0){
        TideAlert("提示","请先选择要查看的文件！");
    }else if(obj.length>1){
        TideAlert("提示","请选择一个查看的文件！");
    }else{
        view(obj.id);//window.open("../content/document_preview.jsp?ItemID=" + obj.id + Parameter);
    }
}

//查看
function view(id) {
    if(typeof (id)=="undefined") {

        var obj = getCheckbox();
        id = obj.id;
        if (obj.length == 0) {
            TideAlert("提示", "请先选择要查看的文档！");
            return;
        }
    }
    window.open("../content/document_look.jsp?ItemID=" + id + Parameter);
}

//检查审核状态
function approve_check(type){
    var flag = true ;
    jQuery("#content-table input:checked").each(function(i){
        var id = jQuery(this).val();

        flag = approve_check_(id,type);
        if(!flag){
            return false ;
        }
    });
    return flag;
}
function approve_check_(id,type){
    var flag = true ;

    var approve = $("#item_"+id).attr("approve");
    if(approve!=1){	//未配置审核
        return flag ;
    }

    var action = $("#item_"+id).attr("ApproveAction");//是否通过
    var actionId = $("#item_"+id).attr("actionId");//是否提交审核
    var end = $("#item_"+id).attr("end");//是否终审

    if(type==1){//编辑操作，未提交审核或者审核被驳回可以再次编辑
        if(actionId==0||action==1){
            return true ;
        }else{
            return false ;
        }
    }if(type==2){//删除操作，未提交审核或者终审通过可以删除
        if(actionId==0||(action==0&&end==1)||userrole==1){
            return true ;
        }else{
            return false ;
        }
    }else{
        if(end!=1||action==1){//不是终审或者未通过
            return false ;
        }
    }

    return flag;
}
function approve_check_2(id,type){
    //1未开启编辑功能  4.终审或者已通过 审核  3//不是未提交审核或审核被驳回的稿件；
    var flag = 0;
    var approve = $("#item_"+id).attr("approve");
    if(approve!=1){	//未配置审核
        return 0 ;
    }

    if(type==1){//编辑操作

        var action = $("#item_"+id).attr("ApproveAction");//是否通过
        var actionId = $("#item_"+id).attr("actionId");//审核环节id
        var end = $("#item_"+id).attr("end");//是否是终审
        var editables = $("#item_"+id).attr("Editables");//当前稿件是否允许编辑

        if(actionId==0||action==1||editables==1){//未提交审核、审核被驳回、审核通过允许编辑
            return 0;
        }
        if(end==1&&action==0){//终审通过不允许再次编辑
            return 4 ;
        }
        if(editables==0){//不允许编辑
            return 1;
        }
    }
    return flag;
}
//获取选中记录
function getCheckbox(){
    var id="";
    jQuery("#content-table input:checked").each(function(i){
        if(i==0)
            id+=jQuery(this).val();
        else
            id+=","+jQuery(this).val();
    });
    var obj={length:jQuery("#content-table input:checked").length,id:id};
    return obj;
}

function getCurrentCheckbox(){
    var id="";
    $("#content-table tr.bg-gray-100").each(function(i){
        if(i==0){
            id+=$(this).val();
        }else{
            id+=","+$(this).val();
        }
    });
    var obj={length:$("#content-table tr.bg-gray-100").length,id:id};
    return obj;
}
//发布
function approve(){
    var obj=getCheckbox();
    if(obj.length==0){
        TideAlert("提示","请先选择要发布的文档！");
        return;
    }

    if(!approve_check(0)){
        TideAlert("提示","请选择审核通过的文档！");
        return;
    }

    /*var message = "确实要发布这"+obj.length+"项吗？";

    if(!confirm(message)){
            return;
    }*/

    approve_(obj.id);
}
function approve2(id){
    /*var message = "确实要发布这1项吗？";

    if(!confirm(message)){
            return;
    }*/

    approve_(id);
}
function approve_(id)
{
    var url= "../content/approvedocument.jsp?ItemID=" + id + Parameter;
    $.ajax({
        type: "GET",
        url: url,
        success: function(msg){document.location.reload();}
    });
}

//预览
function Preview()
{
    var obj=getCheckbox();
    if(obj.length==0){
        TideAlert("提示","请先选择要预览的文件！");
    }else if(obj.length>1){
        TideAlert("提示","请选择一个预览的文件！");
    }else{
        Preview2(obj.id);//window.open("../content/document_preview.jsp?ItemID=" + obj.id + Parameter);
    }
}
function Preview2(id)
{
    window.open("../content/document_preview.jsp?ItemID=" + id + Parameter);
}
function Preview3(id)
{
    window.open("../content/document_preview2.jsp?ItemID=" + id + Parameter);
}
//多端预览
function Preview_()
{
    var obj=getCheckbox();
    if(obj.length==0){
        TideAlert("提示","请先选择要预览的文件！");
    }else if(obj.length>1){
        TideAlert("提示","请选择一个预览的文件！");
    }else{
        Preview2_(obj.id);//window.open("../content/document_preview.jsp?ItemID=" + obj.id + Parameter);
    }
}
function Preview2_(id)
{
    window.open("../content/three_terminal_preview.jsp?ItemID=" + id + Parameter);
}
//列表页正式地址预览
function Preview3()
{
    var obj=getCheckbox();
    if(obj.length==0){
        TideAlert("提示","请先选择要预览的文件！");
    }else if(obj.length>1){
        TideAlert("提示","请选择一个预览的文件！");
    }else{
        Preview3_(obj.id);
    }
}
function Preview3_(id)
{
    window.open("../content/three_terminal_preview.jsp?ItemID=" + id + Parameter+"&type=1");
}

//编辑
function editDocument(itemid)
{
    var  code = approve_check_2(itemid,1);
    /*if(!approve_check_2(itemid,1)){
        TideAlert("提示","审核中的文档不能进行编辑！");
        return;
    }*/
    if(code ==1){
        TideAlert("提示","该环节审核方案未开启编辑功能！");
        return;
    }else if(code ==3){
        TideAlert("提示","不是未提交审核或审核被驳回的稿件！");
        return;
    }else if(code ==4){
        TideAlert("提示","终审通过的稿件不能编辑！");
        return;
    }

    var url="../content/document.jsp?ItemID="+itemid+"&ChannelID=" + ChannelID;
    window.open(url);
}
function editDocument1()
{
    var obj=getCheckbox();
    if(obj.length==0){
        TideAlert("提示","请先选择要编辑的文件！");
    }else if(obj.length>1){
        TideAlert("提示","请先选择一个要编辑的文件！");
    }else{
        editDocument(obj.id);
    }
}
//撤稿
function deleteFile2(){
    var obj=getCheckbox();
    //var message = "确实要撤稿这"+obj.length+"项吗？";
    if(obj.length==0){
        TideAlert("提示","请先选择要撤稿的文档！");
    }else{

        if(!approve_check(0)){
            TideAlert("提示","请选择审核通过的文档！");
            return;
        }

        //if(confirm(message)){
        deleteFile2_confirm(obj.id,obj.length);
        //}
    }
}
function deleteFile3(id){
    //var message = "确实要撤稿这1项吗？";
    //if(confirm(message)){
    deleteFile2_confirm(id,0);
    //}
}
function deleteFile2_confirm(id,length){

    var url="../content/document_delete2.jsp?check=1&ItemID=" + id + Parameter;
    $.ajax({
        type: "GET",
        url: url,
        dataType:"json",
        success: function(msg){
            if(msg.status==0)
            {
                var msg2 = "文章已被推荐，是否撤稿？";
                if(length>1) msg2 = "选中的文章有被推荐，是否撤稿？";

                if(confirm(msg2)){
                    deleteFile2_(id);
                }

            }
            else
            {
                document.location.href=document.location.href;
            }
        }
    });
}
function deleteFile2_(s)
{
    var url="../content/document_delete2.jsp?ItemID=" + s + Parameter;
    $.ajax({
        type: "GET",
        url: url,
        success: function(msg){document.location.href=document.location.href;}
    });
}
//删除
function deleteFile(){
    var obj=getCheckbox();
    var message = "确实要删除这"+obj.length+"项吗？";
    if(obj.length==0){
        TideAlert("提示","请先选择要删除的文件！");
    }else{
        if(!approve_check(2)){
            TideAlert("提示","请选择审核通过或未提交审核的文档！");
            return;
        }

        if(confirm(message)){
            deleteFile_confirm(obj.id,obj.length);
        }
    }
}
function deleteFile1(id){
    var message = "确实要删除这1项吗？";
    if(confirm(message)){
        deleteFile_confirm(id,0);
    }
}
function deleteFile_confirm(id,length){

    var url="../content/document_delete.jsp?check=1&ItemID=" + id + Parameter;
    $.ajax({
        type: "GET",
        url: url,
        dataType:"json",
        success: function(msg){
            if(msg.status==0)
            {
                var msg2 = "文章已被推荐，是否删除？";
                if(length>1) msg2 = "选中的文章有被推荐，是否删除？";

                if(confirm(msg2)){
                    deleteFile_(id);
                }
            }
            else
            {
                document.location.href=document.location.href;
            }
        }
    });
}
function deleteFile_(s)
{
    var url="../content/document_delete.jsp?ItemID=" + s + Parameter;
    $.ajax({
        type: "GET",
        url: url,
        success: function(msg){document.location.href=document.location.href;}
    });
}
//恢复
function resume(id){
    /*var message = "确实要恢复这1项吗？";

    if(!confirm(message)){
            return;
    }*/

    var url=  "../content/document_resume.jsp?ItemID=" + id + Parameter;
    $.ajax({
        type: "GET",
        url: url,
        success: function(msg){document.location.href=document.location.href;}
    });
}
//新建
function addDocument()
{
    var url="../content/document.jsp?ItemID=0&ChannelID=" + ChannelID;
    window.open(url);
}
//推荐
function recommendOut()
{
    var id="";
    var approved = true;
    $("#content-table input:checked").each(function(i){
        if(i==0)
            id+=$(this).val();
        else
            id+=","+$(this).val();
        var status=$("#item_"+$(this).val()).attr("status");
        if(status!="1") approved = false;
    });

    if(id==""){
        TideAlert("提示","请选择要推荐出去的文档！");
        return;
    }

    if(!approved){
        TideAlert("提示","请选择发布后的文档");
        return;
    }

    var	dialog = new top.TideDialog();
    dialog.setWidth(500);
    dialog.setHeight(400);
    dialog.setUrl("../recommend/out_index.jsp?ChannelID="+ChannelID+"&ItemID="+id);
    dialog.setTitle('推荐');
    dialog.show();
}
//引用
function recommendIn()
{
    //引用
    var myObject = new Object();
    myObject.title = "选择引用条目";
    myObject.ChannelID =page.id;

    var url="../recommend/recommend_item.jsp?ChannelID=" + myObject.ChannelID;
    window.open(url);
}
/**改变每页显示*/
function change(s,id)
{
    var value=jQuery(s).val();
    var exp  = new Date();
    exp.setTime(exp.getTime() + 300*24*60*60*1000);
    document.cookie = "rowsPerPage_new="+value;
    document.location.href = pageName+"?id="+id+"&rowsPerPage="+value+queryString;
}
//跳页
function jumpPage(){
    var num=jQuery("#jumpNum").val();
    if(num==""){
        TideAlert("提示","请输入数字!");
        jQuery("#jumpNum").focus();
        return;
    }
    var reg=/^[0-9]+$/;
    if(!reg.test(num)){
        TideAlert("提示","请输入数字!");
        jQuery("#jumpNum").focus();
        return;
    }

    if(num>page.TotalPageNumber)
        num=page.TotalPageNumber;
    if(num<1)
        num=1;
    gopage(num);
}
//内容中心返回上级
function jumpContent(id){

    window.parent.frames["content_frame"].src="../content/content2018.jsp?id="+id;
}
//频道管理返回上级
function jumpChannel(id){

    window.parent.frames["content_frame"].src="../channel/channel2018.jsp?id="+id;
}
//双击
function double_click()
{
    jQuery("#content-table .tide_item").dblclick(function(){
        var obj=jQuery(":checkbox",jQuery(this));
        obj.trigger("click");
        editDocument(obj.val());
    });

}
function  RefreshItem(){
    var obj=getGlobalID();
    if(obj.length==0){
        TideAlert("提示","请先选择要刷新的文件！");
        return;
    }

    if(obj.length>1){
        TideAlert("提示","请选择一个刷新的文件！");
        return;
    }

    RefreshItem1(obj.id);
}
function  RefreshItem1(id){

    jQuery.ajax({
        type: "POST",
        url: "refresh_item.jsp",
        data: "GlobalID="+id,
        error:function(){
            TideAlert("提示","刷新失败!");
        },
        success: function(msg){
            TideAlert("提示","刷新成功!");
        }
    });
}
function getGlobalID(){
    var id="";
    jQuery("#content-table input:checked").each(function(i){
        var obj=jQuery(this).parent().parent();
        if(i==0)
            id+=jQuery(obj).attr("GlobalID");
        else
            id+=","+jQuery(obj).attr("GlobalID");
    });
    var obj={length:jQuery("#content-table input:checked").length,id:id};
    return obj;
}
//排序
function SortDoc(){

    var obj=getCheckbox();
    if(obj.length!=1){
        TideAlert("提示","请选择一个待排序的选项!");
    }else{

        SortDoc1(obj.id);
    }
}
function SortDoc1(id){

    var OrderNumber = $("#item_"+id).attr("OrderNumber");
    var url= "../content/document_sort.jsp?ChannelID="+ChannelID+"&ItemID="+id+"&OrderNumber="+OrderNumber;

    var	dialog = new top.TideDialog();
    dialog.setWidth(300);
    dialog.setHeight(230);
    dialog.setUrl(url);
    dialog.setTitle("排序");
    dialog.show();
}

function createCategory(id){

    var url= "../content/document_create_category.jsp?ChannelID="+id;

    var	dialog = new top.TideDialog();
    dialog.setWidth(300);
    dialog.setHeight(230);
    dialog.setUrl(url);
    dialog.setTitle("新建分类");
    dialog.show();
}

//搜索
function check(){
    var StartDate = $("input[id='startDate']").val();//开始时间
    var EndDate = $("input[id='endDate']").val();//结束时间

    if(StartDate>EndDate){//开始时间能大于结束时间
        TideAlert("提示","开始时间不能大于结束时间!");
        return false;
    }

    return true ;
}
//alert定制
function ddalert(message,confirm_){
    var	dialog = new top.TideDialog();
    dialog.setWidth(300);
    dialog.setHeight(250);
    dialog.setTitle('提示');
    dialog.setMsg(message);
    dialog.setMsgJs(confirm_);
    dialog.ShowMsg();
}
//改变列表形式
function changeList(i)
{
    var expires = new Date();
    var Parameter = "&ChannelID=" + ChannelID + "&rowsPerPage=" + currRowsPerPage + "&currPage=1";
    expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
    document.cookie = ChannelID+"_list_new=" + i + ";path=/;expires=" + expires.toGMTString();
    document.location.href = pageName + '?listtype=' + i + '&cookie=1&id='+ChannelID+Parameter;
}
function changeRowsCols()
{
    var rows = $("#rows").val();
    var cols = $("#cols").val();
    var expires = new Date();
    expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
    document.cookie = "rows_new=" + rows + ";path=/;expires=" + expires.toGMTString();
    document.cookie = "cols_new=" + cols + ";path=/;expires=" + expires.toGMTString();
    document.location.href = pageName + "?id="+ChannelID+"&rows="+rows+"&cols="+cols;
}
function checkLoad(_this){
    $(_this).attr('src', '../images/2018/img12.jpg');
    $(_this).attr('data-src', '');
}

function ChangeTop(channelid,way){
    var msg = "置顶";
    if(way==2){
        msg = "撤销置顶";
    }
    var obj=getCheckbox();
    if(obj.length==0){
        TideAlert("提示","请先选择要"+msg+"的文档！");
        return;
    }
    /*var message = "确实要"+msg+"这"+obj.length+"项吗？";
    if(!confirm(message)){
        return;
    }*/
    $.ajax({
        type: "GET",
        url: "../content/changetop.jsp",
        data: {id:channelid,way:way,ids:obj.id},
        success: function(msg){
            location.reload();
        }
    });
}

function CancleTop(channelid,way,itemid){
    /*var message = "确实要取消这篇文章的置顶吗？";
    if(way==1){
        message = "确实要置顶这篇文章吗？";
    }
    if(!confirm(message)){
            return;
    }*/
    $.ajax({
        type: "GET",
        url: "../content/changetop.jsp",
        data: {id:channelid,way:way,ids:itemid},
        success: function(msg){
            // alert(msg);
            location.reload();
        }
    });
}

//复制移动
function copy(type){
    var msg = "复制";
    if(type==1){
        msg = "移动";
    }
    var obj=getCheckbox();
    if(obj.length<1){
        TideAlert('提示',"请选择要"+msg+"的稿件!")
        //alert("请选择要"+msg+"的稿件!");
        return;
    }
    var dialog = new top.TideDialog();
    dialog.setWidth(500);
    dialog.setHeight(400);
    dialog.setUrl("../content/document_copy_index.jsp?ChannelID="+ChannelID+"&ItemID="+obj.id+"&type="+type);
    dialog.setTitle('选择');
    dialog.show();
}

//列表操作列复制移动
function copy_(type,id){
    var msg = "复制";
    if(type==1){
        msg = "移动";
    }
    var dialog = new top.TideDialog();
    dialog.setWidth(500);
    dialog.setHeight(400);
    dialog.setUrl("../content/document_copy_index.jsp?ChannelID="+ChannelID+"&ItemID="+id+"&type="+type);
    dialog.setTitle('选择');
    dialog.show();
}

function sortable(){
    var start_sort = false;
    var fixHelper = function(e, ui) {
        //console.log(ui)
        ui.children().each(function() {
            $(this).width($(this).width());  //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理
            $(this).css({"background":"#dee2e6"})
        });
        return ui;
    };
    $("#content-table").sortable(
        {
            items:"tr:gt(0)",
            axis:"y",
            //cursor:"move",
            revert: 200 ,
            //	containment: "table",
            helper: fixHelper,
            handle:".drag-list",
            start:function(e,ui){
                var $p=jQuery(ui.placeholder);
                $p.css({visibility:'visible',height:'40px'});
                $p.html('<td colspan="7">   </td>');
                if(!start_sort){
                    $("#selectNo").trigger("click");
                    if($("#content-table").hasClass("table-fixed")){
                        var checkboxAll = $("#content-table tr").find("td").find(":checkbox") ;
                    }else{
                        var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
                    }
                    checkboxAll.removeAttr("checked").parents("tr").removeClass("bg-gray-100");;
                    $("#checkAll,#checkAll_1").prop("checked", false);
                    ui.helper.find(":checkbox").trigger("click");
                    var th = $("#content-table thead tr").children();//alert(th[1].clientWidth);
                    var child = ui.helper.children();
                    for(var j = 0;j<child.size();j++)
                    {(child[j].width=(th[j].clientWidth)+"px");
                    }
                    start_sort = true;
                }
            },
            stop:function(e,ui){
                start_sort = false;
            },
            update:function(e,ui){
                start_sort = false;
                var child = ui.item.children();
                for(var j = 0;j<child.size();j++)
                {
                    if(window.ActiveXObject)
                        child[j].width="";
                    else
                        child[j].width=("px");
                }
                var ItemID=ui.item.attr("itemid");
                var OrderNumber=parseInt(ui.item.attr("ordernumber"));
                var OrderNumber_next=parseInt(ui.item.next().attr("ordernumber"));
                if(isNaN(OrderNumber_next)) OrderNumber_next = 0;
                var OrderNumber_prev=parseInt(ui.item.prev().attr("ordernumber"));
                var Direction=0;
                var Number=0;
                //alert(OrderNumber+":"+OrderNumber_next+":"+OrderNumber_prev);
                if(OrderNumber!=OrderNumber_next){
                    if((OrderNumber-OrderNumber_next)>0){
                        Direction=0;
                        if(OrderNumber_next==0){
                            Number=OrderNumber-OrderNumber_prev;
                        }else{
                            Number=OrderNumber-OrderNumber_next;
                            Number=Number-1;
                        }
                    }else{
                        Direction=1;
                        Number=OrderNumber_next-OrderNumber;
                    }
                }else{
                    if((OrderNumber-OrderNumber_prev)>0){
                        Direction=0;
                        Number=OrderNumber-OrderNumber_prev;
                    }else{
                        Direction=1;
                        Number=OrderNumber_prev-OrderNumber;
                    }
                }
                var isOthersSort = false ;  //是否是其他排序,如轮播图和置顶
                try {
                    if(item_type_ == 5){
                        isOthersSort = true ;
                        var _itemids = "" ;
                        var url = "../content/document_sort1.jsp" ;
                        var trAll = $("#content-table tbody tr") ;
                        $.each(trAll,function (i,el) {
                            if(i==0){
                                _itemids +=  $(el).attr("itemid");
                            }else{
                                _itemids += ","+  $(el).attr("itemid");
                            }
                        })
                        $.ajax({
                            type: "GET",
                            url: url,
                            async:false,
                            data: {"itemids":_itemids,"ChannelID":ChannelID},
                            success: function(msg){
                                $("#loadding").html("");
                                if($.trim(msg)=="Refresh"){
                                    document.location.href=document.location.href + "&sortable=1";;
                                }
                            },
                            error:function(){
                                $(this).sortable( 'cancel' )
                            }
                        });
                    }
                }catch (e){
                    console.log(e)
                }

                if(!isOthersSort){
                    var url="../content/document_operation.jsp";
                    var url_Refresh="content.jsp?currPage="+page.currPage+"&id="+page.id+"&rowsPerPage="+page.rowsPerPage+page.querystring+"&sortable=enable";
                    var data="Action=Order&ChannelID="+ChannelID+"&ItemID="+ItemID;
                    data+="&Direction="+Direction+"&Number="+Number;
                    $.ajax({
                        type: "GET",
                        url: url,
                        async:false,
                        data: data,
                        success: function(msg){
                            $("#loadding").html("");
                            if($.trim(msg)=="Refresh"){
                                document.location.href=document.location.href + "&sortable=1";;
                            }
                        },
                        error:function(){
                            $(this).sortable( 'cancel' )
                        }
                    });
                }
            }
        });

}

function sortableEnable(){
    jQuery("#content-table").sortable("enable");
}

function sortableDisable(){
    jQuery("#content-table").sortable("disable");
}
