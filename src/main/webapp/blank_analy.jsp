<%@ page import="java.sql.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%if(!CmsCache.hasValidLicense())response.sendRedirect("system/license_edit.jsp?flag=1");
String root = (request.getRequestURL()+"").replace("/blank.jsp","/google_button.jsp");%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8">
<title>主页_访问数据统计服务_tidemedia center</title>

<link href="style/tidemedia_center.css" rel="stylesheet">
</head>

<body>
	
		<div class="product_info">
	<div class="p_i_icon" id="p_i_icon_stats"></div>
    <div class="p_i_txt">
    	<h1>访问数据统计服务<span>tide LiveSphere Air</span></h1>
        <div class="p_i_ver">版本号：1.034  <a href="#">检查系统更新</a></div>
    </div>
</div>
<div class="product_features">
	<div class="p_f_txt">
    	<ul>
        	<li>
            	<div class="p_f_t_icon"><img src="img/main_icon/7.1.png"></div>
                <div class="p_f_t_summary"><h3>全媒体的用户行为统计</h3><p>系统可以对网站、视频、APP、微信、微博应用等多个信息渠道的用户访问行为进行专业化的统计分析，形成全媒体用户访问行为分析报告。</p></div>
            </li>
            <li>
            	<div class="p_f_t_icon"><img src="img/main_icon/7.2.png"></div>
                <div class="p_f_t_summary"><h3>精准化用户匹配</h3><p>基于用户数据库对IP用户、注册用户的访问行为进行数据匹配，能够清晰的描绘出用户行为蓝图。</p></div>
            </li>
            <li>
            	<div class="p_f_t_icon"><img src="img/main_icon/7.3.png"></div>
                <div class="p_f_t_summary"><h3>个性化内容匹配</h3><p>结合内容发布系统可以基于网站、APP应用、微信实现根据用户兴趣实现个性化内容推送。</p></div>
            </li>
			<li>
            	<div class="p_f_t_icon"><img src="img/main_icon/7.4.png"></div>
                <div class="p_f_t_summary"><h3>精准用户服务</h3><p>基于用户行为数据过滤筛选出精准价值用户，利用短信、邮件沟通组件实现对价值用户的进一步服务影响。</p></div>
            </li>
        </ul>
    </div>
    <div class="p_f_video"><img src="img/p_f_video.jpg"></div>
</div>	
</body>
</html>