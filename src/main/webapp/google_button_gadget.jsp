<?xml version="1.0" encoding="UTF-8"?>
<Module>
	<!-- vim: set filetype=google_gadgets : -->
	<ModulePrefs author="LabPixies"
	author_email="info+converter@labpixies.com"
	description="__MSG_description__"
	screenshot="http://www.labpixies.com/campaigns/calendar/images/screenshot.jpg"
	title="__MSG_title__"
	title_url="http://www.labpixies.com"
  category="tools"             
	thumbnail="http://www.labpixies.com/campaigns/calendar/images/thumbnail.jpg" height="304" render_inline="never">
		
        <Locale messages="http://www.labpixies.com/campaigns/calendar/i19/all_all.xml"/>
        <Locale lang="es" messages="http://www.labpixies.com/campaigns/calendar/i19/es_all.xml"/>
        <Locale lang="de" messages="http://www.labpixies.com/campaigns/calendar/i19/de_all.xml"/>
        <Locale lang="fr" messages="http://www.labpixies.com/campaigns/calendar/i19/fr_all.xml"/>
        <Locale lang="it" messages="http://www.labpixies.com/campaigns/calendar/i19/it_all.xml"/>
        <Locale lang="ja" messages="http://www.labpixies.com/campaigns/calendar/i19/ja_all.xml"/>
        <Locale lang="nl" messages="http://www.labpixies.com/campaigns/calendar/i19/nl_all.xml"/>
        <Locale lang="pl" messages="http://www.labpixies.com/campaigns/calendar/i19/pl_all.xml"/>
        <Locale lang="pt-PT" messages="http://www.labpixies.com/campaigns/calendar/i19/pt_all.xml"/>
        <Locale lang="pt-BR" messages="http://www.labpixies.com/campaigns/calendar/i19/pt_all.xml"/>
        <Locale lang="zh-CN" messages="http://www.labpixies.com/campaigns/calendar/i19/zh_cn_all.xml"/>
		<Require feature="analytics" />
		<Require feature="setprefs"/>
	</ModulePrefs>
	
	<UserPref name="skin" default_value="1" datatype="hidden"/>
	<UserPref name="state" default_value="date" datatype="hidden"/>
	<Content type="html">
		<![CDATA[
<!-- 
 Calendar Gadget
 Design & Code: LabPixies
 All subsequent code and resources used are proprietary of LabPixies unless directly stated otherwise.
 Copyright (C) 2008 LabPixies.    
 www.labpixies.com
 
 This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivs 2.5 License.
 To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/2.5/ or
 send a letter to Creative Commons, 543 Howard Street, 5th Floor, San Francisco, California, 94105, USA.
 -->

<title>Calendar</title>
<!-- PUT THIS TAG IN THE head SECTION -->
<script type="text/javascript" src="http://partner.googleadservices.com/gampad/google_service.js">
</script>
<script type="text/javascript">
  GS_googleAddAdSenseService("ca-pub-8123415297019784");
  GS_googleEnableAllServices();
</script>
<script type="text/javascript">
  GA_googleAddSlot("ca-pub-8123415297019784", "calendar_txt");
</script>
<script type="text/javascript">
  GA_googleFetchAds();
</script>
<!-- END OF TAG FOR head SECTION -->

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js"></script>
<script src="http://www.google-analytics.com/ga.js" type="text/javascript"></script>
<script type="text/javascript">
	/* insert cached JS files */
	var $lp = jQuery.noConflict();
  var _gadgetID=80;
  
	var IMAGES_BASE = "http://www.labpixies.com/campaigns/calendar/images/";
	
	var prefs = new _IG_Prefs();

	try {
		skin = prefs.getInt("skin");
		skin = skin ? skin : 1;
		state = prefs.getString("state");
	} catch (ee) {
		var skin = 1; //set the default skin
		var state = "date";
	}

	//define an array that maps the days of the week to there message key
	var weekday = new Array(7);
	weekday[0]="__MSG_sunday__";
	weekday[1]="__MSG_monday__";
	weekday[2]="__MSG_tuesday__";
	weekday[3]="__MSG_wednesday__";
	weekday[4]="__MSG_thursday__";
	weekday[5]="__MSG_friday__";
	weekday[6]="__MSG_saturday__";

	var month = new Array(12);
	month[0] = "__MSG_january__";
	month[1] = "__MSG_february__";
	month[2] = "__MSG_march__";
	month[3] = "__MSG_april__";
	month[4] = "__MSG_may_long__";
	month[5] = "__MSG_june__";
	month[6] = "__MSG_july__";
	month[7] = "__MSG_august__";
	month[8] = "__MSG_september__";
	month[9] = "__MSG_october__";
	month[10] = "__MSG_november__";
	month[11] = "__MSG_december__";

	//for short month names
	var mon = new Array(12);
	mon[0] = "__MSG_jan__";
	mon[1] = "__MSG_feb__";
	mon[2] = "__MSG_mar__";
	mon[3] = "__MSG_apr__";
	mon[4] = "__MSG_may__";
	mon[5] = "__MSG_jun__";
	mon[6] = "__MSG_jul__";
	mon[7] = "__MSG_aug__";
	mon[8] = "__MSG_sep__";
	mon[9] = "__MSG_oct__";
	mon[10] = "__MSG_nov__";
	mon[11] = "__MSG_dec__";

	var d = new Date();

	function getDaysInMonth(year, month) {
		return 32 - new Date(year, month,32).getDate();
	}

	// return 2-digit year
	function shortYear(year) {
		year = String(year);
		return year.substr();//TODO
	}

	_IG_RegisterOnloadHandler(function(){
		/* fix font settings - apply skin */
		$lp(".color-a1").removeClass("color-a1").addClass("color-a"+skin);		
		$lp(".color-b1").removeClass("color-b1").addClass("color-b"+skin);		
		$lp(".color-c1").removeClass("color-c1").addClass("color-c"+skin);		
		$lp(".color-d1").removeClass("color-d1").addClass("color-d"+skin);		

		$lp("#view-year .left-arrow").click(function(){
			d.setFullYear(d.getFullYear()-1);
			generateYear();
		});
		$lp("#view-year .right-arrow").click(function(){
			d.setFullYear(d.getFullYear()+1);
			generateYear();
		});
		$lp("#view-month .left-arrow").click(function(){
			if (d.getMonth()==0) {
				d.setFullYear(d.getFullYear()-1);
				d.setMonth(11);
			} else
				d.setMonth(d.getMonth()-1);
			generateMonth();
		});
		$lp("#view-month .right-arrow").click(function(){
			if (d.getMonth()==11) {
				d.setFullYear(d.getFullYear()+1);
				d.setMonth(0);
			} else
				d.setMonth(d.getMonth()+1);
			generateMonth();
		});
		$lp(".skin-button").click(function(){
			old_skin = skin;
			skin = (skin)%4+1;
	
			/* change the current elements skin */
			$lp(".color-a"+old_skin).removeClass("color-a"+old_skin).addClass("color-a"+skin);		
			$lp(".color-b"+old_skin).removeClass("color-b"+old_skin).addClass("color-b"+skin);		
			$lp(".color-c"+old_skin).removeClass("color-c"+old_skin).addClass("color-c"+skin);		
			$lp(".color-d"+old_skin).removeClass("color-d"+old_skin).addClass("color-d"+skin);		
	
			loadImages();
			generateMonth();
			generateYear();
			
			//save skin
			prefs.set("skin",skin);
		});

		loadImages();
		$lp("#view-today .month-year span, #view-month .year").mouseover(function(){
			$lp(this).css('text-decoration','underline');
		});
		$lp("#view-today .month-year span, #view-month .year").mouseout(function(){
			$lp(this).css('text-decoration','none');
		});

		switch(state) {
			case 'date':
				displayDate();
				break;
			case 'month':
				displayMonth();
				break;
			case 'year':
				displayYear();
				break;
			default:
				state='date';
				displayDate();
		}
		
	});

	function loadImages() {
		$lp('.view').css('background', "transparent url("+_IG_GetImageUrl(IMAGES_BASE+skin+'/'+'background.jpg')+") 0px 0px no-repeat");
		$lp('.back-arrow').css('background', "transparent url("+_IG_GetImageUrl(IMAGES_BASE+skin+'/'+'back_arrow.gif')+") 0px 0px no-repeat");
		$lp('#view-today .back-arrow').css('background', "transparent");
	}

	function displayDate() {
		reportInteraction("day");
		d = new Date();
		$lp("#view-month").hide();
		$lp("#view-year").hide();
		$lp("#view-today").show();
		prefs.set("state","date");
	}
	function displayMonth() {
		
		/*d.SetMonth(month);*/
		reportInteraction("month");
		$lp("#view-year").hide();
		$lp("#view-today").hide();
		$lp("#view-month").show();
		generateMonth();
		prefs.set("state","month");
	}
	function displayYear() {
		/*d.SetFullYear(year);*/
		reportInteraction("year");
		$lp("#view-month").hide();
		$lp("#view-today").hide();
		$lp("#view-year").show();
		generateYear();
		prefs.set("state","year");
	}

	//generates the month view
	function generateMonth() {

		/* update the month | year header */
		$lp("#view-month .month").html(month[d.getMonth()]+'&nbsp;');
		$lp("#view-month .year").html('&nbsp;'+d.getFullYear());

		//generate the header
		output = '<table id="month" cellspacing="0">';
		output += '\
			<tr class="header color-c'+skin+'">\
				<td>__MSG_lsunday__</td>\
				<td>__MSG_lmonday__</td>\
				<td>__MSG_ltuesday__</td>\
				<td>__MSG_lwednesday__</td>\
				<td>__MSG_lthursday__</td>\
				<td>__MSG_lfriday__</td>\
				<td>__MSG_lsaturday__</td>\
			</tr>';
		today = new Date();
		days_in_month = getDaysInMonth(d.getFullYear(),d.getMonth());
		days_in_previous_month = d.getMonth==0 ? getDaysInMonth(d.getFullYear()-1,12) : getDaysInMonth(d.getFullYear(),d.getMonth()-1);
		
		d_month = new Date(d.getFullYear(),d.getMonth(),1);
		output += '<tr>';
		for (i = 0; i<d_month.getDay(); i++) {
			output += '<td class="color-d'+skin+'">'+(days_in_previous_month-d_month.getDay()+i+1)+'</td>';
		}
		for (i=1; i<=days_in_month; i++) {
			output += (((d_month.getDay()-1+i)%7)==0) ? '<tr>' : '';
			if (d_month.getFullYear()==today.getFullYear() && d_month.getMonth()==today.getMonth() && i==today.getDate())
				output += '<td class="color-b'+skin+' today">'+i+'</td>';
			else
				output += '<td class="color-b'+skin+'">'+i+'</td>';
		}
		for (i=1; i < (7-(d_month.getDay()-1+days_in_month)%7) ; i++) {
				output += '<td class="color-d'+skin+'">'+i+'</td>';
		}
		output+='</tr> </table>';
		$lp("#div-month").html(output);
		$lp("#month td").attr("day_of_week", function(i){return i%7});
		$lp('.today').css('background', "transparent url("+_IG_GetImageUrl(IMAGES_BASE+skin+'/'+'today_circle.gif')+") 1px 0px no-repeat");
		$lp("#month tr.header td[day_of_week="+$lp('.today').attr("day_of_week")+"]").addClass("color-a"+skin);
		//remove all events
		$lp("#month td").unbind();

		$lp("#month td").mouseover(function(){
			if (!$lp(this).hasClass("today"))
				$lp(this).addClass("color-a"+skin);
			$lp("#month tr.header td[day_of_week="+$lp(this).attr("day_of_week")+"]").addClass("color-a"+skin);
		});
		$lp("#month td").mouseout(function(){
			$lp(this).removeClass("color-a"+skin);
			$lp("#month tr.header").children().eq($lp(this).attr("day_of_week")).removeClass("color-a"+skin);
			$lp("#month tr.header td[day_of_week="+$lp('.today').attr("day_of_week")+"]").addClass("color-a"+skin);
		//remove all events
		});
		$lp("#month .today").click(function(){
			displayDate();
		});
	}

	function generateYear() {
			/* update the year header */
			$lp("#view-year .month-year").html(d.getFullYear());

			output = "";
			
			today = new Date();
			year = d.getFullYear() ;
			for (i=0; i < 12; i++) {
				if ((i%4)==0)
					output+="<tr>";
				if (i==today.getMonth() && year==today.getFullYear())
					output+='<td year="'+year+'" month="'+i+'" class="this-month">'+mon[i]+'</td>';
				else
					output+='<td year="'+year+'" month="'+i+'" >'+mon[i]+'</td>';
				if ((i%4)==3)
					output+="</tr>";
			}
			$lp("#year-table").html(output);

			$lp('.this-month').css('background', "transparent url("+_IG_GetImageUrl(IMAGES_BASE+skin+'/'+'this_month_circle.gif')+") 6px 2px no-repeat");
			//remove all events
			$lp("#year-table td").unbind();

			$lp("#year-table td").mouseover(function(){
				if ($lp(this).hasClass("this-month"))
					return;
				$lp(this).addClass("color-a"+skin);
			});
			$lp("#year-table td").mouseout(function(){
				$lp(this).removeClass("color-a"+skin);
			});
			$lp("#year-table td").click(function(){
				d.setMonth($lp(this).attr("month"));
				d.setFullYear($lp(this).attr("year"));
				displayMonth();
			});
	}
	
</script>

<style>
* {
	padding: 0px;
	margin: 0px;
}
.color-a1 {
	/* the important is needed for highlighting to work */
	color: #ff6000 !important;
}
.color-b1 {
	color: #323232;
}
.color-c1 {
	color: #b5b5b5;
}
.color-d1 {
	color: #d7d7d7;
}
.color-a2 {
	/* the important is needed for highlighting to work */
	color: #0c9bd1 !important;
}
.color-b2 {
	color: #323232;
}
.color-c2 {
	color: #7ed3f6;
}
.color-d2 {
	color: #cfebf9;
}
.color-a3 {
	/* the important is needed for highlighting to work */
	color: #95aa08 !important;
}
.color-b3 {
	color: #323232;
}
.color-c3 {
	color: #d2d2d2;
}
.color-d3 {
	color: #c4cc8d;
}
.color-a4 {
	/* the important is needed for highlighting to work */
	color: #ffba00 !important;
}
.color-b4 {
	color: #ffffff;
}
.color-c4 {
	color: #8b8b8b;
}
.color-d4 {
	color: #d7d7d7;
}
.view {
	font-family: arial, sans-serif;
	width: 233px;
	height: 251px;
	text-align: center;
	margin: 0 auto;
}
#view-today div.date {
	font-size: 120px;
	line-height: 100px;
	height: 100px;
	cursor: pointer;
}
#view-today div.day-of-week {
	font-size: 18px;
	cursor: pointer;
}
.month-year {
	font-size: 16px;
	text-align: center;
}
#view-today .month-year span,
#view-month .month-year .year {
	cursor: pointer;
}
#view-month, #view-year {
	font-size: 11px;
}
#year-table {
	margin: auto;
}

#year-table {
	font-size: 12px;
	text-align: center;
}
#view-month #month {
	margin: auto;
}
#view-month #month td {
	font-size: 12px;
	text-align: right;
	width: 17px;
	height: 21px;
	padding-right: 5px;
}
#view-month #month .header {
	font-weight: bold;
	color: #808080;
	text-align: center;
}

#year-table td {
	font-size: 12px;
	width: 25px;
	height: 35px;
	padding: 12px 10px;
	cursor: pointer;
}
.right-arrow {
	width: 22px;
	height: 16px;
	cursor: pointer;
}
.left-arrow {
	width: 22px;
	height: 16px;
	cursor: pointer;
}

.today, .this-month {
	color: #ffffff;
	cursor: pointer;
}

.back-arrow {
	width: 18px;
	height: 11px;
	cursor: pointer;
	float: left;
}
.skin-button {
	width: 10px;
	height: 10px;
	cursor: pointer;
	float: left;
}
</style>
<!--[if IE 6]>
<style>
</style>
<![endif]-->

<div style="height:2px; font-size:1px"></div>
<div style="text-align: center; margin-top:10px;"> <!--this is required for centering the views as IE doesn't handle margin: auto for some reason and this fix won't work for firefox-->
<div id="view-today" class="view">
	<div style="height:6px; overflow: hidden;"></div>
	<div style="height:10px;overflow: hidden;">
		<div style="float:left; width: 12px;height: 10px;"></div>
		<div class="skin-button"></div>
	</div>
	<div style="height:12px;overflow: hidden;"></div>
	<div style="height:20px; overflow: hidden;" >
		<table cellspacing="0">
		<tr>
		<td style="width: 10px;"></td>
		<td style="background-color: #efefef; width: 22px; height: 16px"> </td>
		<td style="width:169px" class="month-year color-a1">
			<span class="month" onclick="displayMonth()">
				<script type="text/javascript">document.write(month[d.getMonth()]);</script>
			</span>&nbsp;|&nbsp;<span class="year" onclick="displayYear()">
				<script type="text/javascript">document.write(d.getFullYear());</script></span></div>
		</td>
		<td style="background-color: #efefef; width: 22px; height: 16px"> </td>
		<td style="width: 10px;"></td>
		</tr>
		</table>
	</div>
	<div style="height:30px;overflow: hidden;"></div>
	<div style="height: 145px;">
		<div class="date color-a1" onclick="displayMonth()">
			<script type="text/javascript">document.write(d.getDate());</script>
		</div>
		<div style="height:16px;"></div>
		<div class="day-of-week color-a1" onclick="displayMonth()">
			<script type="text/javascript">document.write(weekday[d.getDay()]);</script>
		</div>
	</div>
</div>

<div id="view-month" class="view" style="display:none;">
	<div style="height:6px; overflow: hidden;"></div>
	<div style="height:10px;overflow: hidden;">
		<div style="float:left; width: 12px;height: 10px;"></div>
		<div class="skin-button"></div>
	</div>
	<div style="height:12px;overflow: hidden;"></div>
	<div style="height:20px; overflow: hidden;" >
		<table cellspacing="0">
		<tr>
		<td style="width: 10px;"></td>
		<td class="left-arrow"> </td>
		<td style="width:169px" class="month-year color-a1">
			<span class="month">
				<script type="text/javascript">document.write(month[d.getMonth()]);</script>
			</span>&nbsp;|&nbsp;<span class="year" onclick="displayYear()">
				<script type="text/javascript">document.write(d.getFullYear());</script>
			</span> 
		</td>
		<td class="right-arrow"> </td>
		<td style="width: 10px;"></td>
		</tr>
		</table>
	</div>
	<div style="height:25px;overflow: hidden;"></div>
	<div id="div-month" style="height: 150px;">
	</div>
	<div style="float:left; width: 15px;height: 10px;"></div>
	<div class="back-arrow" onclick="displayDate()"></div>
</div>

<div id="view-year" class="view" style="display:none;">
	<div style="height:6px; overflow: hidden;"></div>
	<div style="height:10px;overflow: hidden;">
		<div style="float:left; width: 12px;height: 10px;"></div>
		<div class="skin-button"></div>
	</div>
	<div style="height:12px;overflow: hidden;"></div>
	<div style="height:20px; overflow: hidden;" >
		<table cellspacing="0">
		<tr>
		<td style="width: 10px;"></td>
		<td class="left-arrow"> </td>
		<td style="width:169px" class="month-year color-a1">
				<script type="text/javascript">document.write(d.getFullYear());</script>
		</td>
		<td class="right-arrow"> </td>
		<td style="width: 10px;"></td>
		</tr>
		</table>
	</div>
	<div style="height:25px;overflow: hidden;"></div>
	<div style="height: 150px;">
		<table id="year-table"> </table>
	</div>
	<div style="float:left; width: 15px;height: 10px;"></div>
	<div class="back-arrow" onclick="displayMonth()"></div>
</div>

<div style="margin-top:2px; text-align:center;" align="center">
	<!-- PUT THIS TAG IN DESIRED LOCATION OF SLOT calendar_txt -->
	<script type="text/javascript">
	  GA_googleFillSlot("calendar_txt");
	</script>
<!-- END OF TAG FOR SLOT calendar_txt -->
</div>

<!-- LP footer -->
<div>
	<script type="text/javascript">
    var mMENU = _IG_GetCachedUrl("http://cdn.labpixies.com/infra/js/lp_footer.js");
    document.write('<scr'+'ipt type="text/javascript" src="'+mMENU+'"></scr'+'ipt>');
  </script>
</div>
<iframe width="1" height="1" style="width:1px; height:1px; overflow:hidden; position:absolute; visibility:hidden;" src="http://static.labpixies.com/campaigns/calendar/analytics.html"></iframe>

	
<script type="text/javascript">
	
	var pageTracker = _gat._getTracker("UA-345375-1");
	pageTracker._initData();		
	
	var firstLoad = true;
	function reportInteraction(tp) {		
		if (firstLoad) {
      firstLoad = false;
      return;
    }
    pageTracker._trackEvent("calendar","Click",tp);
	}
	
	_IG_Analytics("UA-345375-1", "/calendar");

</script>
		]]>
	</Content>
</Module>