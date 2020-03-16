<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.*,
				tidemedia.cms.base.*,
				java.sql.*,
				java.util.concurrent.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
*		修改人			修改时间			备注
*		郭庆光			20150305			两个sql语句where中，Active=0
*
*
*/
if(!(userinfo_session.getUsername().equals("admin") || userinfo_session.getUsername().equals("lsh")))
{ response.sendRedirect("../noperm.jsp");return;}

	int channelid=0;
	
	//int parentid=0;
	channelid=getIntParameter(request,"channelid");
	//parentid=getIntParameter(request,"parentid");
//System.out.println("channelid1="+channelid);
	int tempchannelid=channelid;
	if(channelid>0){
		Channel ch = CmsCache.getChannel(channelid);

		//System.out.println("type="+ch.getType()+","+Channel.Category_Type);
		if(ch.getType()!=Channel.Category_Type){
			tempchannelid=0;
		}
		
		String sql = "delete from "+ch.getTableName()+" where Category="+tempchannelid+" and Active=0";
		//System.out.println("sql1="+sql);
		TableUtil tu = ch.getTableUtil();
		tu.executeUpdate(sql);
		sql = "delete from item_snap where ChannelID="+channelid+" and Active=0";
		//System.out.println("sql2="+sql);
		TableUtil tu2 = ch.getTableUtil();
		tu2.executeUpdate(sql);
		//System.out.println("channelid12="+channelid);
		//out.println("删除完毕");
		
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>数据清理</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script language="javascript">

function myclick()
{
	var channelid=$("#channelid").val();
	//alert("channelid="+channelid);
	$.ajax({
				 type: "post",
				 url: "clear_channel.jsp?channelid="+channelid,
				 success: function(msg){
					//alert("msg="+msg);
					alert("删除完成");
					$("#channelid").val("");
				 }   
	}); 
}
</script>
</head>
<body>
<div class="content_t1">
	<div class="content_t1_nav">频道数据</div>
</div>

<div class="content_2012">
	<div class="viewpane">
        <div class="viewpane_tbdoy">
			
				<div >
					<input type="text" name="channelid" id="channelid"></input>
				</div>
				<div class="tidecms_btn">
					<div class="t_btn_txt" onclick="myclick()" >提交</div>
				</div>
				
				<div class="tidecms_btn">
					<div class="t_btn_txt"><a href="manager.jsp">返回</a></div>
				</div>

		</div>
	</div>
</div>
</body>
</html>
