<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int id = CmsCache.getParameter("channelid_video_url_ugc").getIntValue();
int photo_id =  CmsCache.getParameter("channelid_video_photo_ugc").getIntValue();
int globalid = getIntParameter(request,"globalid");
int max=5;
//System.out.println("geturl.jsp  globalid="+globalid);
Document doc = new Document(globalid);
String  callback = getParameter(request,"callback");
String flv = "";
int channelid_video = CmsCache.getParameter("sys_channelid_transcode").getIntValue();
ArrayList docs = doc.listChildItems(channelid_video);
for(int i = 0;i<docs.size();i++)
{
	Document d = (Document)docs.get(i);
	if(d.getValue("video_dest").endsWith(".flv") || d.getValue("video_dest").endsWith(".mp4")){

	//flv = Util.ClearPath(doc.getChannel().getSite().getUrl()+"/"+d.getValue("video_dest"));
		String sys_video = CmsCache.getParameterValue("sys_video");
		TideJson t = CmsCache.getParameter("sys_video").getJson();
		String video_url = t.getString("video_url");
		if(video_url.length()<=0){
			video_url= doc.getChannel().getSite().getUrl();
		}
		//判断程序直接导入视频地址和通过转码服务器的视频地址  李青松
		if(d.getValue("video_dest").indexOf("http://")>=0){
		    flv =Util.ClearPath(d.getValue("video_dest"));
		}else{
		    flv = Util.ClearPath(video_url+"/"+d.getValue("video_dest"));
		}
	}
}

//out.println(flv);
TableUtil tu_ = new TableUtil();
//out.println("gid="+globalid);
String sql_ = "select Photo from channel_s4_a_b where Parent="+globalid+" and Status=1 limit 0,5";
ResultSet rs_ = tu_.executeQuery(sql_);
List list =  new ArrayList();
int temp=0;
while(rs_.next()){


		String url_ = rs_.getString("Photo");
		list.add(url_);
		//out.println("url="+url_);

}
tu_.closeRs(rs_);

String str ="";
for(int i = 0; i<list.size();i++){
  if(i == list.size() -1){
   str += "{'title':''"+","+"'url'"+":"+"'"+list.get(i)+"'"+"}";
  }else{
   str += "{'title':''"+","+"'url'"+":"+"'"+list.get(i)+"'"+"}"+",";
  }
}
String json = callback+"({'video'"+":"+"'"+flv+"'"+","+"'img':["+ str +"]})";
//String json =  callback+"({'video'"+":"+"'"+str1+"'"+"})";
out.println(json);
//System.out.println(json);
%>