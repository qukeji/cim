<%@ page contentType="text/html;charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8">
<title>主页_帮助中心_tidemedia center</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
</head>

<body>
<div class="content_t1">
	<div class="content_t1_nav">当前位置：拆条配置规范</div>
</div>
<div class="content_2012">
<table width="100%" border="0" class="view_table">
	<tr>
    		<th class="v1" colspan="2">视频部分</th>
  	</tr>
        <tr> 
                <td width="100">视频编码</td>
                <td>H264/AVC</td>
        </tr>
        <tr> 
                <td>编码级别</td>
                <td>High/Main, level3.0-level5.0，推荐High/level3.1</td>
        </tr>
        <tr> 
                <td>关键帧间隔</td>
                <td>不大于2秒，建议设置为1秒，即GOP=25</td>
        </tr>
        <tr> 
                <td>帧率</td>
                <td>25帧，恒定帧率</td>
        </tr>
        <tr> 
                <td>分辨率</td>
                <td>640px * 480px或更高</td>
        </tr>
        <tr> 
                <td>码率</td>
                <td>1-2Mbps，推荐码率1Mbps</td>
        </tr>
        <tr> 
                <td>码率控制</td>
                <td>VBR</td>
        </tr>
        <tr> 
                <td>B帧</td>
                <td>关闭</td>
        </tr>
        <tr> 
                <td>参考帧</td>
                <td>关闭</td>
        </tr>
        <tr> 
                <td>画面像素比</td>
                <td>1:1</td>
        </tr>
        <tr> 
                <td>颜色制式</td>
                <td>YUV420P</td>
        </tr>
        <tr> 
                <td>画面交错</td>
                <td>建议去交错</td>
        </tr>

</table>
<br>
<table width="100%" border="0" class="view_table">
	<tr>
    		<th class="v1" colspan="2">音频部分</th>
  	</tr>
        <tr> 
                <td width="100">音频编码</td>
                <td>AAC/LC-AAC，不推荐使用HE-AAC，推荐使用AAC</td>
        </tr>
        <tr> 
                <td>采样率</td>
                <td>44.1khz/32khz，不推荐使用22khz</td>
        </tr>
        <tr> 
                <td>音频码率</td>
                <td>32-64Kbps，建议使用48Kbps</td>
        </tr>
        <tr> 
                <td>音频声道</td>
                <td>双声道立体声</td>
        </tr>
</table>
</div>
</body>
</html>
