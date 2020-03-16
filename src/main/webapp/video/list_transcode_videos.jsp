<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				 
				java.util.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
 * 用途：cms获取转码视频
 * 王海龙 20150516 创建
 * 
 *								
 */
int id = getIntParameter(request,"id");
int channelid = getIntParameter(request,"channelid");

List<Map<String,String>> list = new ArrayList<Map<String,String>>();
//int channelid_video = CmsCache.getParameter("sys_channelid_transcode").getIntValue();
int channelid_video = 4;//cms转码视频地址频道，产品默认频道
  
Channel channel = CmsCache.getChannel(channelid);

if(!channel.hasRight(userinfo_session,1))
{
	response.sendRedirect("../noperm.jsp");
	return;
}

Document doc = new Document(id,channelid);

ArrayList<Document> docs = ItemUtil.listItems(channelid_video," where Parent= "+doc.getGlobalID()+" and Active=1");
for(int i = docs.size()-1;i>=0;i--)
{	
	Map<String,String> map_ = new HashMap<String,String>();
	Document d = docs.get(i);
	if(d.getValue("Url").endsWith(".flv") || d.getValue("Url").endsWith(".mp4"))
	{
		String flv = Util.ClearPath(d.getValue("Url"));
		flv = Util.HTMLEncode(flv);
		int video_type = d.getIntValue("video_type");
		String title = d.getValue("video_desc");//TranscodeScheme.getTranscodeScheme(video_type).getName();
		 
                map_.put("flv",flv);
		map_.put("title",title);
		list.add(map_);
	}
}
JSONArray array = new JSONArray(list);
out.println(array.toString());
%>
