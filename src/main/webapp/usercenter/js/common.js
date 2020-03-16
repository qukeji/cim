//左右两侧相同高度
/*
function $(id){ 
    return document.getElementById(id) 
}
function getHeight() { 
    if ($("#u_i_left").offsetHeight>=$("#u_i_right").offsetHeight){
        $("#u_i_right").height($("#u_i_left").height());
    }
    else{
        $("#u_i_left").height($("#u_i_right").height());
    }   
}
window.onload = function() {
    getHeight();
}
 */
$(document).ready(function(){
	if ($("#u_i_left").offsetHeight>=$("#u_i_right").offsetHeight){
        $("#u_i_right").height($("#u_i_left").height());
    }
    else{
        $("#u_i_left").height($("#u_i_right").height());
    }  
});