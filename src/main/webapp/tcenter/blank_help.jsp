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
<title>主页_帮助中心_tidemedia center</title>
<link href="style/tidemedia_center.css" rel="stylesheet">
</head>

<body>
<div class="product_info">
	<div class="p_i_icon" id="p_i_icon_help"></div>
    <div class="p_i_txt">
    	<h1>帮助中心<span>tidemedia center technical support</span></h1>
    </div>
</div>
<div class="product_features">
	<div class="p_f_txt">
    	<ul>
        	<li>
            	<div class="p_f_t_icon"><img src="img/main_icon/8.1.png"></div>
                <div class="p_f_t_summary"><h3>在线帮助</h3><p>提供常用功能的在线帮助或示例.</p></div>
            </li>
            <li>
            	<div class="p_f_t_icon"><img src="img/main_icon/8.2.png"></div>
                <div class="p_f_t_summary"><h3>文档下载</h3><p>提供产品手册下载.</p></div>
            </li>

        </ul>
    </div>
    <div class="p_f_video"><img src="img/p_f_video.jpg"></div>
</div>
<div class="code_small">
	<img src="img/code_big.jpg" />
    <div class="txt"><p>第一时间了解tidemedia产品动态</p><p>请扫描二维码关注微信公众号</p></div>
</div>
</body>
</html>