function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]);
    return null;
}
var status = getQueryString("status");
if(status==1){
    $(".main-wrap1").show().siblings().hide();
    $(".fixed-bottom1").show().siblings().hide();
}else if(status==2){
    $(".main-wrap2").show().siblings().hide();
    $(".fixed-bottom2").show().siblings().hide();
}else if(status==3){
    $(".main-wrap3").show().siblings().hide();
    $(".fixed-bottom3").show().siblings().hide();
}else if(status==4){
    $(".main-wrap4").show().siblings().hide();
    $(".fixed-bottom4").show().siblings().hide();
}else if(status==5){
    $(".main-wrap5").show().siblings().hide();
    $(".fixed-bottom4").show().siblings().hide();
}
$(".topic-header .arrow").on("click",function(){
    if($(this).hasClass("up")){
        $(this).removeClass("up");
        $(".audit-process").hide();
    }else{
        $(this).addClass("up");
        $(".audit-process").show();
    }
});
// 椹冲洖
$(".reject-btn").on("click",function(){
    $(".reject-pop").show();
});
$(".pop-modal .cancel").on("click",function(){
    $(".pop-modal").hide();
});
$(".pop-modal .confirm").on("click",function(){
    $(".pop-modal").hide();
});
$(".grade-btn").on("click",function(){
    $(".pingfeng-pop").show();
});
// 閫氳繃
$(".pass-btn").on("click",function(){
    $(".pass-confirm").show();
});
$(".confirm-modal .confirm").on("click",function(){
    $(".confirm-modal").hide();
});
$(".confirm-modal .cancel").on("click",function(){
    $(".confirm-modal").hide();
});
