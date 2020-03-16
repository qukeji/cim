function openSearch()
{
	jQuery("#SearchArea").toggle();
}

function getCheckbox(){
	var id="";
	jQuery("#oTable input:checked").each(function(i){
		if(i==0)
			id+=jQuery(this).val();
		else
			id+=","+jQuery(this).val();
	});
	var obj={length:jQuery("#oTable input:checked").length,id:id};
	return obj;
}



function double_click()
{
	jQuery("#oTable tr:gt(0)").dblclick(function(){
		notepad();
	});
}

