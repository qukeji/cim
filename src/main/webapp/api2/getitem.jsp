 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
				tidemedia.cms.util.*,
				java.util.regex.Pattern"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!

 //判断频道ID是否存在


	public boolean Judge_Channelid(int channelid)throws Exception{
		boolean result=false;
		TableUtil tu=new TableUtil();
		String sql="select * from channel where id="+channelid+"";
		ResultSet rs=tu.executeQuery(sql);
		while(rs.next()){
			result=true;
		}
		tu.closeRs(rs);
		return result;
	}

// 判断文章ID是否存在


	public boolean Judge_Itemid(int itemid,int channelid)throws Exception{
		boolean result=false;
		TableUtil tu=new TableUtil();
		String sql="select * from "+CmsCache.getChannel(channelid).getTableName()+" where id="+itemid+" and active=1 and status=1";
		ResultSet rs=tu.executeQuery(sql);
		while(rs.next()){
			result=true;
		}
		tu.closeRs(rs);
		return result;
	}

%>
<%
JSONObject o = new JSONObject();
try{
//Pattern pattern = Pattern.compile("[0-9]{6}"); 
int itemid =getIntParameter(request,"itemid");
int channelid=getIntParameter(request,"channelid");
/*int itemid = 0;
int channelid = 0;
boolean itemid_valid_flag=false;//ItemID是否符合标准
boolean channelid_valid_flag=false;//频道ID是否符合标准
itemid_valid_flag=pattern.matches("^[1-9]\\d{1,9}$", itemids);
channelid_valid_flag=pattern.matches("^[1-9]\\d{1,9}$", channelids);
*/
//判断完毕

/*if(itemid_valid_flag){
	itemid=Util.parseInt(itemids);
}
if(channelid_valid_flag){
	channelid=Util.parseInt(channelids);
}*/

Document doc_=new Document(itemid,channelid);




String Token=getParameter(request,"Token");//获取token

 


		int login = 0;
		if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token);
		if(Token.length()==0)
		{
			o.put("status",0);
			o.put("message","缺少登录令牌");
		}
		else if(login!=1)
		{
			o.put("status",0);
			o.put("message","登录失败");
		}else if(channelid==0){
			
				o.put("status",0);
				o.put("message","所传频道ID不符合要求");
			
			
		}else if(itemid==0){
			
				o.put("status",0);
				o.put("message","所传文章ID不符合要求");
			
			
		}else if(doc_.getId()==0){
				o.put("status",0);
				o.put("message","所查询记录不存在");
		}else{
			
			Channel channel = CmsCache.getChannel(channelid);
			Document item = new Document(itemid,channelid);
			o.put("id",item.getId());
			o.put("Title",item.getTitle());
			o.put("message","OK");
			o.put("status","1");
			JSONArray o2 = new JSONArray();  
			for(int i = 1;i<=item.getTotalPage();i++)
			{
				item.setCurrentPage(i);
				JSONObject o3 = new JSONObject();
				o3.put("Content",item.getContent());
				o2.put(o3);
			}
			o.put("Photo",item.getValue("Photo"));
			o.put("Summary",item.getSummary());
			o.put("Url",item.getHttpHref());
			o.put("PublishDate",item.getPublishDate());
			o.put("IsPhotoNews",item.getIsPhotoNews());
			o.put("DocFrom",item.getDocFrom());
			o.put("Contents",o2);
		}
	}catch(Exception e){
		o.put("message","接口调用失败");
		o.put("status","0");
	}
	out.println(o.toString());
%>
