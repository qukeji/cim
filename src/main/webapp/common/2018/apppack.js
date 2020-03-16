//下一步
var _step=0;
function enterNextPage(_index){
    var nextIndex = _index+1 ;
    
    if(_index==2 && $(".resolution-power .actives").length < 3){
        _step++;
        $(".resolution-power .btn").removeClass("actives");
        $(".resolution-power .btn").removeClass("progress");
        $(".step-pic").addClass("hide");
        if(_step==1){
            $(".resolution-power .btn").eq(0).addClass("actives");
            $(".resolution-power .btn").eq(1).addClass("progress");
            $(".step-pic").eq(1).removeClass("hide");
        }else if(_step==2){
            $(".resolution-power .btn").eq(0).addClass("actives");
            $(".resolution-power .btn").eq(1).addClass("actives");
            $(".resolution-power .btn").eq(2).addClass("progress");
            $(".step-pic").eq(2).removeClass("hide");
        }else if(_step==3){
            $(".resolution-power .btn").eq(0).addClass("actives");
            $(".resolution-power .btn").eq(1).addClass("actives");
            $(".resolution-power .btn").eq(2).addClass("actives");
            $(".step-pic").eq(2).removeClass("hide");
        }
    }else{
        $(".step").addClass("hide");
        $(".step-submit").addClass("hide");
        $(".step").eq(nextIndex).removeClass("hide");
        $(".step-submit").eq(nextIndex).removeClass("hide");
        $(".step-info .step-num").removeClass("active");
        $(".step-info span").removeClass("active");
        if(nextIndex>0){
            for(var i = 0;i<nextIndex;i++){
                $(".step-info .step-num").eq(i).addClass("active");
                $(".step-info span").eq(i).addClass("active");
            }
        }
        $(".step-info .step-num").eq(nextIndex).addClass("active");
    }
		
}
//上一步
function enterPrevPage(_indexs){
    var prevIndex = _indexs-1 ;
    $(".step").addClass("hide");
    $(".step-submit").addClass("hide");
    $(".step").eq(prevIndex).removeClass("hide");
    $(".step-submit").eq(prevIndex).removeClass("hide");
    $(".step-info .step-num").removeClass("active");
    $(".step-info span").removeClass("active");
    if(prevIndex>0){
        for(var i = 0;i<prevIndex;i++){
            $(".step-info .step-num").eq(i).addClass("active");
            $(".step-info span").eq(i).addClass("active");
        }
    }
    $(".step-info .step-num").eq(prevIndex).addClass("active");
}
$(function(){
'use strict';

//点击图标 下一步 上一步
$(".step-info .step-num").on("click",function(vi,va){
    var _index=$(this).index()/2;
    if(_index==0){
        $(".step").addClass("hide");
        $(".step-submit").addClass("hide");
        $(".step-info .step-num").removeClass("active");
        $(".step-info span").removeClass("active");
        $(".step").eq(0).removeClass("hide");
        $(".step-submit").eq(0).removeClass("hide");
        $(".step-info .step-num").eq(0).addClass("active");
    }else{
        $(".step").addClass("hide");
        $(".step-submit").addClass("hide");
        $(".step").eq(_index).removeClass("hide");
        $(".step-submit").eq(_index).removeClass("hide");
        $(".step-info .step-num").removeClass("active");
        $(".step-info span").removeClass("active");
        if(_index>0){
            for(var i = 0;i<_index;i++){
                $(".step-info .step-num").eq(i).addClass("active");
                $(".step-info span").eq(i).addClass("active");
            }
        }
        $(".step-info .step-num").eq(_index).addClass("active");
    }
    
})


//分辨率
// $('.resolution-power button').on('click', function(e){
//     e.preventDefault();
//     if($(this).hasClass('actives')) {
//         $(this).removeClass('actives');
//         $(this).children("img").addClass('hide');
//     } else {
//         $(this).addClass('actives');
//         $(this).children("img").removeClass('hide');
//     }
// });
//图标切换  
$('.step-pic .channel-icon-nav button').on('click', function(e){
    e.preventDefault();
    var _index=$(this).index();
    $(this).addClass('active').siblings().removeClass("active");
    $(this).parents(".channel-icon-nav").siblings(".channel-info").children(".channel-icon").eq(_index).removeClass("hide").siblings().addClass('hide');
});

//主题色
var themeColor=new showColor('#ff0000',"colorpicker","colorinput");
//手机状态栏颜色
var stateColor=new showColor('#ff0000',"colorpickertop","colorinputtop");
//创作端按钮颜色
var buttonColor=new showColor('#ff0000',"jxcolorpicker","jxcolor");

//头部样式切换
$(".header_style input[name=start_type]").change(function(){
    if($(this).prop("checked")==true){
        console.log(1)
        $(".header_style .rdiobox").removeClass("border-label");
        $(this).parent().addClass("border-label");
    }
})
//直接打包
$("#packNow").click(function(){
    $(".step").addClass("hide");
    $(".step-submit").addClass("hide");
    $("#pack_1").removeClass("hide");
    setTimeout(function(){ $("#pack_1").addClass("hide");$("#pack_2").removeClass("hide"); }, 3000);
})
});

//取色器
function showColor(defaultcolor,colorid,colorSelectId){
var _colorid=$('#'+colorid);
var _colorSelectId=$('#'+colorSelectId);
var _this=this;
this.setColor=function(){
        _colorid.spectrum({
            color: defaultcolor,
            allowEmpty:true,
    　　showInput: true,
    　　containerClassName: "full-spectrum",
    　　showInitial: true,
    　　showPalette: true,
    　　showSelectionPalette: true,
    　　showAlpha: true,
    　　maxPaletteSize: 7,
    　　preferredFormat: "hex",
    　　localStorageKey: "spectrum.demo",
    　　move: function (color) {
                _this.updateColors(color);
    　　},
    　　hide: function (color,_colorSelectId) {
                _this.updateColors(color,_colorSelectId);
    　　},
　　	palette: [
　　　　 ["#000","#444","#666","#999","#ccc","#eee","#f3f3f3","#fff"],
                ["#f00","#f90","#ff0","#0f0","#0ff","#00f","#90f","#f0f"],
                ["#f4cccc","#fce5cd","#fff2cc","#d9ead3","#d0e0e3","#cfe2f3","#d9d2e9","#ead1dc"],
                ["#ea9999","#f9cb9c","#ffe599","#b6d7a8","#a2c4c9","#9fc5e8","#b4a7d6","#d5a6bd"],
                ["#e06666","#f6b26b","#ffd966","#93c47d","#76a5af","#6fa8dc","#8e7cc3","#c27ba0"],
                ["#c00","#e69138","#f1c232","#6aa84f","#45818e","#3d85c6","#674ea7","#a64d79"],
                ["#900","#b45f06","#bf9000","#38761d","#134f5c","#0b5394","#351c75","#741b47"],
                ["#600","#783f04","#7f6000","#274e13","#0c343d","#073763","#20124d","#4c1130"]
　　　]
        });  
    },
    this.updateColors=function(color){
　　　　var hexColor = "transparent";
　　　　if(color) {
　　　　　hexColor = color.toHexString();
                _colorSelectId.val(hexColor);
　　　　}
    },
    this.setColor();
}