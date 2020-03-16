<%@ page import="java.sql.*,
				tidemedia.cms.publish.PublishScheme,
				tidemedia.cms.base.TableUtil,
				org.json.JSONArray,
				tidemedia.cms.system.*,
                org.json.JSONObject,
				tidemedia.cms.util.Util,
				tidemedia.cms.system.LogAction"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
	{
		"errlog": {
			"num": 30,
			"switch": false
		},
		"syslog": {
			"num": 30,
			"switch": false
		},
		"templetenum": {
			"num": 200000,
			"switch": false
		},
		"filepubnum": {
			"num": 200000,
			"switch": false
		}
	}
*/
	int id=getIntParameter(request,"id");
	Parameter  p = new Parameter(id);
	String code = p.getCode();
	
	boolean errorswitch=false;
	boolean systemswitch=false;
	boolean templeteswitch=false;
	boolean fileswitch=false;
	
	
	if(p.getCode().equals("log_cleaning")){
		JSONObject json=new JSONObject(p.getContent().trim());
		JSONObject errjson=json.getJSONObject("errlog");
		errorswitch=errjson.getBoolean("switch");
		JSONObject sysjson=json.getJSONObject("syslog");
		systemswitch=sysjson.getBoolean("switch");
		JSONObject templetejson=json.getJSONObject("templetenum");
		templeteswitch=templetejson.getBoolean("switch");
		JSONObject filejson=json.getJSONObject("filepubnum");
		fileswitch=filejson.getBoolean("switch");
		
		
		
	}
	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title></title>
	</head>
	<style>
		*{
			margin: 0;
			padding: 0;			
		}
		html,body{
			font-family: "宋体";
		}
		ul,li{
			list-style: none;
		}
		.cl_content{
			border: 1px solid #e0e0e0;
		    padding: 0 14px 14px 14px;
		    border-radius: 5px;
		    background: #fff;
		    margin: 10px 5px 0 0;
		}
		.cl_title p{
			color: #101010;
			font-size: 14px;
			line-height: 45px;			
		}
		.cl_title  p span{
			color: #a8a4a6;
			margin-left: 16px;
			font-size: 12px;
		}
		.cl_item{
			background: #f2f2f2;
			border: 1px solid #e0e0e0;
			padding: 10px;
			border-radius: 3px;
		}
		.cl_item ul li{
			line-height: 30px;
			font-size: 12px;
			margin: 3px 0;
		}		
		.cl_item .cl_fn{
			color: #101010;
			min-width: 130px;
			display: inline-block;
		}
		.cl_item ul li i{
			font-style: normal;
			color: #6e6d6e;
		}
		#switch-bg {
			width: 40px;
			height: 17px;
			border-radius: 11px;
			position: relative;
	        display: inline-block;
	        margin: 0 10px 0 2px;
	        cursor: pointer;
	        vertical-align:middle;
		}		
		#switch-circle {
			width: 21px;
			height: 21px;
			border-radius: 50%;
			position: absolute;
			background: #ffffff;
			border: 1px solid #c6c6c6;
			box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.4);
		}		
		.switch-close {
			background: #a7a5a6;
		}
		.switch-close .switch-circle {
			left: -2px;
			top: -3px;
			transition: all 1s ;
		}
		.switch-open{
			background: #199bd1;
		}
		.switch-open .switch-circle{
			right: -2px;
			top: -3px;
			transition: all 1s ;
		}
		
	</style>
	<script type="text/javascript" src="../common/jquery.min.js"></script>
	<body>
		<div class="cl_content">
			<div class="cl_title">
				<p>日志自动清理<span class="title-explain">系统的相关日志和记录当达到一定数量之后，如果没有有效清理，会对系统整体造成影响，建议用户根据情况选择开启</span></p>
			</>
			<div class="cl_item">
				<ul>
					<li>
						<span class="cl_fn">错误日志自动清理</span>
						<div id="switch-bg"  flag="errlog"  <%if(!errorswitch){%>class="switch-close"<%}else{%>class="switch-open"<%}%> >
							<div id="switch-circle" class="switch-circle"></div>
						</div>
						<i>开启后，系统会自动清理30天前的错误日志</i>	
					</li>
					<li>
						<span class="cl_fn">系统日志自动清理</span>
						<div id="switch-bg" flag="syslog" <%if(!systemswitch){%>class="switch-close"<%}else{%>class="switch-open"<%}%> >
							<div id="switch-circle" class="switch-circle"></div>
						</div>
						<i>开启后，系统会自动清理30天前的系统日志</i>	
					</li>
					<li>
						<span class="cl_fn">模板发布记录自动清理</span>
						<div id="switch-bg" flag="templetelog"  <%if(!templeteswitch){%>class="switch-close"<%}else{%>class="switch-open"<%}%> >
							<div id="switch-circle" class="switch-circle"></div>
						</div>
						<i>开启后，已发布模板任务达到10W条记录会自动清理</i>	
					</li>
					<li>
						<span class="cl_fn">文件发布记录自动清理</span>
						<div id="switch-bg" flag="filepublog" <%if(!fileswitch){%>class="switch-close"<%}else{%>class="switch-open"<%}%> >
							<div id="switch-circle" class="switch-circle"></div>
						</div>
						<i>开启后，已分发文件记录达到20W条后会自动清理</i>	
					</li>
				</ul>
			</div>
		</div>
		<script>
			$(function(){
				$(".cl_item").delegate("#switch-bg","click",function(){
					if($(this).hasClass("switch-close")){
					    $(this).removeClass("switch-close").addClass("switch-open");
						/*{
							"errlog": {
								"num": 30,
								"switch": false
							},
							"syslog": {
								"num": 30,
								"switch": false
							},
							"templetenum": {
								"num": 200000,
								"switch": false
							},
							"filepubnum": {
								"num": 200000,
								"switch": false
							}
						}
						*/
						// alert($(this).attr('flag'));
                        var json={};
						var errlog={"switch":$('[flag=\"errlog\"]').attr('class')=='switch-open'};
						var systlog={"switch":$('[flag=\"syslog\"]').attr('class')=='switch-open'};
						var templete={"switch":$('[flag=\"templetelog\"]').attr('class')=='switch-open'};
						var filepub={"switch":$('[flag=\"filepublog\"]').attr('class')=='switch-open'};
						json={"errlog":errlog,"syslog":systlog,"templetenum":templete,"filepubnum":filepub};
						//alert(JSON.stringify(json));
						jQuery.ajax({
							 type: "POST",
							 url: "updateparameter.jsp",
							 data: "id=<%=id%>&configjson="+JSON.stringify(json)+"&code=<%=code%>",
							 error:function(){alert("更新失败!");},
							 success: function(msg){
								alert("更新成功");
							 } 
						});
					    //这里写开启开关的代码、
						//alert($(this).attr('flag'));
                                               
					    //
					}else{
						 $(this).removeClass("switch-open").addClass("switch-close");
						 //这里写关闭开关的代码、
						// alert($(this).attr('flag'));
                        var json={};
						var errlog={"switch":$('[flag=\"errlog\"]').attr('class')=='switch-open'};
						var systlog={"switch":$('[flag=\"syslog\"]').attr('class')=='switch-open'};
						var templete={"switch":$('[flag=\"templetelog\"]').attr('class')=='switch-open'};
						var filepub={"switch":$('[flag=\"filepublog\"]').attr('class')=='switch-open'};
						json={"errlog":errlog,"syslog":systlog,"templetenum":templete,"filepubnum":filepub};
						//alert(JSON.stringify(json));
						jQuery.ajax({
							 type: "POST",
							 url: "updateparameter.jsp",
							 data: "id=<%=id%>&configjson="+JSON.stringify(json)+"&code=<%=code%>",
							 error:function(){alert("更新失败!");},
							 success: function(msg){
								alert("更新成功");
							 } 
						});
					    //
					}
				})
			})
		</script>
	</body>
</html>
