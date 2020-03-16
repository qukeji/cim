<%@ page import="tidemedia.cms.video.*,tidemedia.cms.base.*,java.sql.*,tidemedia.cms.util.*,java.util.*,tidemedia.cms.system.*,org.json.JSONArray,org.json.JSONObject"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String Type			= getParameter(request,"Type");
String fieldname			= getParameter(request,"fieldname");
int ChannelID		= getIntParameter(request,"ChannelID");
int itemid			= getIntParameter(request,"itemid");

int transcode_channelid = CmsCache.getParameter("sys_channelid_transcode").getIntValue();
int video_channelid = ChannelID;//CmsCache.getParameter("sys_channelid_video").getIntValue();

String file_types = "*.avi;*.wmv;*.mpeg;*.mov";
String file_types_description = "视频文件";

HashMap map_ext = new HashMap();
String p_video_type = CmsCache.getParameterValue("sys_video");
JSONObject ooo = new JSONObject(p_video_type);
JSONArray o1 = ooo.getJSONArray("birate");
//JSONArray o1 = new JSONArray(p_video_type);
for(int i =0;i<o1.length();i++)
{
	JSONObject oo = o1.getJSONObject(i);
	map_ext.put(oo.getString("value"),oo.getString("ext"));
}

String submit = getParameter(request,"submit");
if(!submit.equals(""))
{
	ItemUtil util = new ItemUtil();
	Document doc = new Document(itemid,video_channelid);
	
	Channel transcode_channel = CmsCache.getChannel(transcode_channelid);

	TableUtil tu = new TableUtil();
	CmsFile cmsfile = new CmsFile();
	String[] videotype = request.getParameterValues("videotype"); 
	for(int i=0;videotype!=null && i<videotype.length;i++)
	{
		int m = Util.parseInt(videotype[i]);
		if(m>0)
		{
			int cid = 0;
			String sql = "select id from channel_transcode where Active=1 and Parent=" + doc.getGlobalID() + " and video_type=" + m;
			//out.println(sql);
			ResultSet rs = tu.executeQuery(sql);
			if(rs.next())
			{
				cid = rs.getInt("id");
			}
			tu.closeRs(rs);

			if(cid>0)
			{
				HashMap map = new HashMap();
				map.put("Status2","0");
				map.put("PublishStatus","0");
				map.put("progress","0");
				util.updateItemById(transcode_channelid,map,cid,0);
			}
			else
			{
				String video_dest = "";
				String video_source = doc.getValue("video_source");
				String video_source_folder = doc.getValue("video_source_folder");
				int mm = video_source.lastIndexOf(".");
				if(mm!=-1)
				{
					String NewFileName = cmsfile.getNewFileName("",transcode_channel.getRealImageFolder(),userinfo_session.getId());
					out.println("NewFileName:"+NewFileName);
					//int mmm = NewFileName.lastIndexOf(".");
					video_dest = Util.ClearPath(transcode_channel.getRealImageFolder() + "/" + NewFileName + "_" + m + "." + (String)map_ext.get(m+""));
				}
				HashMap map2 = new HashMap();
				map2.put("Title",doc.getTitle());
				map2.put("video_source",video_source);
				map2.put("video_source_folder",video_source_folder);
				map2.put("video_type",m+"");
				map2.put("video_dest",video_dest);
				map2.put("Parent",doc.getGlobalID()+"");
				map2.put("Status2","0");
				map2.put("Status","1");
				int id = util.addItemGetID(transcode_channelid,map2);
				//out.println("dest:"+video_dest);
			}
			//out.println("cid:"+cid);
		}
	}
	TranscodeManager.getInstance().Start();
	
	out.println("<script>top.TideDialogClose({refresh:'showTab(\"2\");'});</script>");
	return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/form-common.css" rel="stylesheet" />
<link href="../style/9/form-iframe.css" rel="stylesheet" />
<link href="../style/9/tidecms.css" rel="stylesheet" />
<style>
label{margin:0 0 0 2px;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
</head>
<body>
<form action="retranscode.jsp" method="post"  name="form" onSubmit="return check();">
<div class="iframe_form">
	<div class="form_top">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="form_main">
    	<div class="form_main_m">
<table  border="0" width="460">
   <tr>
    <td align="right" valign="middle" width="80"><label>转码格式：</label></td>
	<td valign="middle" width="380">
<%
String t = CmsCache.getParameterValue("sys_video");
JSONObject oooo = new JSONObject(t);
JSONArray o = oooo.getJSONArray("birate");
//JSONArray o = new JSONArray(t);
for(int i =0;i<o.length();i++)
{
	JSONObject oo = o.getJSONObject(i);
	if(i%3==0) out.println("");
%>
<input type="checkbox" value="<%=oo.getString("value")%>" name="videotype" id="videotype_<%=i%>"><label for="videotype_<%=i%>"><%=oo.getString("name")%></label>  
<%}%>
  </td></tr>
</table>
		</div>
    </div>
    <div class="form_bottom">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
</div>
<div class="form_button">
	<input name="startButton" type="submit" class="tidecms_btn3" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn3" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
	<input type="hidden" name="submit" value="submit">
	<input type="hidden" name="itemid" value="<%=itemid%>">
	<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
</div>
</form>
</body>
</html>
