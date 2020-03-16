 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%
//线索汇聚接口
%>
<%!
 public HashMap<String, Object> getItems(int type,int pages,int pagesize){
	HashMap<String, Object> map = new HashMap<String, Object>() ;

	try{		

		TideJson jurong = CmsCache.getParameter("jurong").getJson();//聚融接口信息
		int channelId = jurong.getInt("collect");//线索汇聚全部16189;

		String type_desc = "";
		if(type==1){
			channelId = jurong.getInt("webCollect");//16194;
			type_desc = "网站";
		}else if(type==2){
			channelId = jurong.getInt("weixinCollect");//16192;
			type_desc = "微信";
		}else if(type==3){
			channelId = jurong.getInt("weiboCollect");//16193;
			type_desc = "微博";
		}

		Channel channel = CmsCache.getChannel(channelId);
		TableUtil tu1 = new TableUtil();
		String listSql = "select Title,SpiderUrl,Photo,Content,Summary,id,DocFrom,PublishDate,Category from "+channel.getTableName() + " where Active=1";
		if(type!=0){
			listSql += " and ChannelCode like '"+channel.getChannelCode()+"%'";
		}
		listSql += " order by id desc limit "+(pages*pagesize)+","+pagesize;
		//System.out.println("listSql:"+listSql);
		ResultSet rs1 = tu1.executeQuery(listSql);

		JSONArray jsonArray = new JSONArray();
		while(rs1.next()){
			int id_ = rs1.getInt("id");
			String Title = convertNull(rs1.getString("Title"));
			String SpiderUrl = convertNull(rs1.getString("SpiderUrl"));
			String Photo = convertNull(rs1.getString("Photo"));
			String content = convertNull(rs1.getString("Content"));
			String Summary = convertNull(rs1.getString("Summary"));
			String DocFrom = convertNull(rs1.getString("DocFrom"));
			String PublishDate = Util.FormatTimeStamp("", rs1.getLong("PublishDate"));
			int Category = rs1.getInt("Category");
			if(Category!=0){
				type_desc = CmsCache.getChannel(Category).getName();
			}

			Document doc = new Document(id_,channelId);
			SpiderUrl = doc.getHttpHref();

			JSONObject o = new JSONObject();
			o.put("id",id_);
			o.put("title",Title);
			o.put("url",SpiderUrl);
//			o.put("content",content);
			o.put("summary",Summary);
			o.put("photo",Photo);
			o.put("from",DocFrom);
			o.put("date",PublishDate);
			o.put("type",type);
			o.put("type_desc",type_desc);
			jsonArray.put(o);
		}
		tu1.closeRs(rs1);
		
		map.put("data",jsonArray);
		map.put("status",200);
		map.put("message","成功");
		
	}catch(Exception e){
		map.put("status",500);
		map.put("message","程序异常");
		e.toString();
	} 
	return map ;
}
%>
<%
int type = getIntParameter(request,"type");
int pages = getIntParameter(request,"page");
int pagesize = getIntParameter(request,"pagesize");
if(pages>0) pages = pages-1;
if(pagesize<=0) pagesize = 20;

HashMap<String, Object> map = getItems(type,pages,pagesize);
JSONObject json = new JSONObject(map);

out.println(json);
%>
