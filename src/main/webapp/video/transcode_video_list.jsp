<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
/*
 *  修改人		修改时间		备注
 *  
 *  whl		20140225		视频预览 可以选择不同码率预览 用来获取转码列表数据
 *	whl		20140619		doc.listChildItems(..)方法改为ItemUtil.listItem(..,..)方法，
 *								转码中只要有一种码率转码失败，所有status字段值都是0，而listChildItems方法只列出status=1的记录，这造成转码完成的也不能预览
 *								
 */
int id = getIntParameter(request,"id");
int channelid = getIntParameter(request,"channelid");
List<Map<String,String>> list = new ArrayList<Map<String,String>>();
HashMap map = new HashMap();
TideJson t = CmsCache.getParameter("sys_video").getJson();
String video_url = t.getString("video_url");
JSONArray o = t.getJSONArray("birate");
for(int i =0;i<o.length();i++)
{
	JSONObject oo = o.getJSONObject(i);
	map.put(oo.getString("value"),oo.getString("name"));
}

//out.println("id="+id+",cid="+channelid);
Channel channel = CmsCache.getChannel(channelid);

Document doc = new Document(id,channelid);
int channelid_video = CmsCache.getParameter("sys_channelid_transcode").getIntValue();
//ArrayList docs = doc.listChildItems(channelid_video);
//列出转码列表中parent字段是doc.getGloablID(),并且转码完成的记录
ArrayList docs = ItemUtil.listItems(channelid_video," where parent= "+doc.getGlobalID()+" and active=1 "); 
for(int i = docs.size()-1;i>=0;i--)
{	
	Map<String,String> map_ = new HashMap<String,String>();
	String flv = "";
	Document d = (Document)docs.get(i);
	if(d.getValue("video_dest").endsWith(".flv") || d.getValue("video_dest").endsWith(".mp4"))
	{
		 
		flv = Util.ClearPath(d.getValue("video_dest"));
		flv = Util.HTMLEncode(flv);
		int video_type = d.getIntValue("video_type");
		String title	= (String)map.get(video_type+"");
		String vtype="";
		if(video_type==1)
			vtype = "v";
		else if(video_type==2)
			vtype="v_hd";
		else if(video_type==3)
			vtype="v_sd";
		map_.put("flv",Util.base64(flv));
		map_.put("title",title);
		map_.put("vtype",vtype);
		list.add(map_);
	}
}
JSONArray array = new JSONArray(list);
out.println(array.toString());
%>
