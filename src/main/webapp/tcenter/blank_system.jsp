<%@ page import="java.sql.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>主页_系统管理_tidemedia center</title>
<link href="style/tidemedia_center.css" rel="stylesheet">
</head>

<body>
<div class="product_info">
	<div class="p_i_icon" id="p_i_icon_system"></div>
    <div class="p_i_txt">
    	<h1>系统管理<span>tidemedia center system management</span></h1>
        <div class="p_i_ver">版本号：1.034  </div>
    </div>
</div>
<div class="product_features">
	<div class="p_f_txt">
    	<ul>
        	<li>
            	<div class="p_f_t_icon"><img src="img/p_f_t_icon_1.png"></div>
                <div class="p_f_t_summary"><h3>用户权限管理</h3><p>支持用户的创建及权限的配置等管理。</p></div>
            </li>
            <li>
            	<div class="p_f_t_icon"><img src="img/p_f_t_icon_2.png"></div>
                <div class="p_f_t_summary"><h3>产品应用状态</h3><p>设置统一平台应用产品状态。</p></div>
            </li>
            <li>
            	<div class="p_f_t_icon"><img src="img/p_f_t_icon_3.png"></div>
                <div class="p_f_t_summary"><h3>日志管理</h3><p>查看操作日志，登录日志等。</p></div>
            </li>
        </ul>
    </div>
    <div class="p_f_video"><img src="img/p_f_video.jpg"></div>
</div>
</body>
</html>
