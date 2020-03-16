	var field_all = new Array("MoreWindow","list_num","IsAddMoreButton","list_type","ShowType","OrderType","IsTitleHide","Title","PublishDate","onlinetime","Revoketime","position","listposition","item_type","Photo","Photo1","Photo2","href","dropchannel_id","dropchannel_name","sourcechannel_name","form2_td");

	var field_jpwh = new Array("MoreWindow","list_num","IsAddMoreButton","list_type","ShowType","OrderType","IsTitleHide","position","item_type","Photo","Photo1","Photo2");
	
	var field_ztwh = new Array("MoreWindow","list_num","IsAddMoreButton","list_type","ShowType","OrderType","IsTitleHide","position","item_type","Photo1","Photo2");
	
	var field_ggtf = new Array("MoreWindow","list_num","IsAddMoreButton","list_type","ShowType","OrderType","IsTitleHide","sourcechannel_name");

	var field_notice = new Array("MoreWindow","list_num","IsAddMoreButton","list_type","ShowType","OrderType","IsTitleHide","position","item_type","Photo","Photo1","Photo2","href","sourcechannel_name");

	var field_button = new Array("MoreWindow","list_num","IsAddMoreButton","list_type","Photo","onlinetime","Revoketime","position","Photo","Photo1","Photo2","href","sourcechannel_name","item_type");
	
	var field_recommend = new Array("ShowType","OrderType","Photo","onlinetime","Revoketime","position","Photo","Photo1","Photo2","sourcechannel_name","item_type");

	$(function(){
	    controlField();
		if ((serialNo.indexOf("module_recommen") != -1)||(serialNo.indexOf("module_special") != -1)||(serialNo.indexOf("module_auto_recommend") != -1)) {//精品推荐或专题或自动推荐
			SelectChannel("sourcechannel","href","list_1_0.shtml",15894,0);
		}
		var  MoreWindow_= $("#IsAddMoreButton").val();
		var  ShowType_= $("input[type=radio][name=ShowType]:checked").val();
		if(ShowType_=="2"||ShowType_=="3"){
			$("input[type=radio][name=OrderType][value=1]").parent().css("display","");
			$("#Caption_OrderType").css("display","");
		}else{
			$("input[type=radio][name=OrderType][value=1]").parent().css("display","none");
			$("#Caption_OrderType").css("display","none");
		}
		if(MoreWindow_=="1"){
			$("#tr_href").css("display","");
			$("#Caption_href").css("display","");
		}else if(MoreWindow_=="0"&&serialNo=="s53_module_auto_recommend"){
			$("#tr_href").css("display","none");
			$("#Caption_href").css("display","none");
			$("#desc_href").text("‘更多’跳转页面");
			$('#Caption_href').children().eq(1).html("<i class=\"icon ion-information-circled tx-16 tx-gray-900 mg-r-5\"></i>请选择已有频道.");
			//$("#Caption_href").text("填写网页地址或是列表页栏目地址，例如: https://baidu.com或是 /a/a/j/list_1_0.shtml或是直接选择已有频道.");
		}
		$("input[type=radio][name=ShowType]").change(function(){
			
			if(this.value == '2'||this.value == '3'){
				$("input[type=radio][name=OrderType][value=1]").parent().css("display","");
				$("#Caption_OrderType").css("display","");
			}else{
				$("input[type=radio][name=OrderType][value=1]").parent().css("display","none");
				$("#Caption_OrderType").css("display","none");
			}
		});
		//获取是否开或关
		$(".toggle").click(function () {
			var field = $(this).attr('field');
			var myToggle = $(this).data('toggle-active');
			if(field=="IsAddMoreButton"){
				if (myToggle) {
					$("#tr_href").css("display","");
					$("#Caption_href").css("display","");
				}else if((myToggle==false)&&serialNo=="s53_module_auto_recommend"){
					$("#tr_href").css("display","none");
					$("#Caption_href").css("display","none");
					$("#desc_href").text("‘更多’跳转页面");
					$('#Caption_href').children().eq(1).html("<i class=\"icon ion-information-circled tx-16 tx-gray-900 mg-r-5\"></i>请选择已有频道.");
					//$("#Caption_href").text("填写网页地址或是列表页栏目地址，例如: https://baidu.com或是 /a/a/j/list_1_0.shtml或是直接选择已有频道.");
				}
			}
		})
		/*$("input[type=radio][name=IsAddMoreButton]").change(function(){
			if(this.value == '1'){

			}else if(this.value == '0'&&serialNo=="s53_module_auto_recommend"){

			}
		});*/
	});
	


	function controlField(){
		for(var i= 0;i<field_all.length;i++){  
		
			var field = field_all[i];
			if (serialNo.indexOf("module_recommen") != -1) {//精品推荐
				isView(field_jpwh, field);
				$("#Caption_href").css("display","none");
                $("#form2_td").css("display","none");
                $("#form3_td").css("display","none");
			}else if(serialNo.indexOf("module_special") != -1){//专题
				isView(field_ztwh, field);
				$("#desc_Photo").text("封面图");
				$("#Caption_href").css("display","none");
                $("#form2_td").css("display","none");
                $("#form3_td").css("display","none");
			}else if(serialNo.indexOf("advert") != -1){//广告
				isView(field_ggtf, field);
				$("#Caption_Photo").css("display","none");
                $("#form2_td").css("display","none");
                $("#form3_td").css("display","none");
			}else if(serialNo.indexOf("module_notice") != -1){//公告
                isView(field_notice, field);
                $("#Caption_Photo").css("display","none");
                $("#Caption_href").css("display","none");
                $("#form2_td").css("display","");
                $("#form3_td").css("display","none");
            }else if(serialNo.indexOf("module_button") != -1) {//按钮组
				isView(field_button, field);
				$("#tr_ypj").css("display","none");
				$("#Caption_ypj").css("display","none");
				$("#form2_td").css("display","none");
				$("#form3_td").css("display","");
			}else if(serialNo.indexOf("module_auto_recommend") != -1){//自动化推荐
				isView(field_recommend, field);
				$("#desc_href").text("‘更多’跳转页面");
				$('#Caption_href').children().eq(1).html("<i class=\"icon ion-information-circled tx-16 tx-gray-900 mg-r-5\"></i>请选择已有频道.");
				$("#form2_td").css("display","none");
                $("#form3_td").css("display","none");
			}
			
			
		}
	}
	//字段隐藏或显示
	function isView(fields,field){
		
		if(contains(fields,field)){
			$("#tr_"+field).css("display","none");
			$("#Caption_"+field).css("display","none");
		}else{
			$("#"+field).css("display","");
			$("#Caption_"+field).css("display","");
		}
		
	}
	//是否包含
	function contains(fields,field){
		var flag = false ;
		
		for(var i= 0;i<fields.length;i++){
			
			if(field==fields[i]){
							
				flag = true;
			}
		}
		return flag ;
	}