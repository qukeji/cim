<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				java.text.SimpleDateFormat,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//编辑日志
Log l = new Log();
tidemedia.cms.publish.PublishScheme pt = new tidemedia.cms.publish.PublishScheme();	
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
if(currPage<1)
currPage = 1;
if(rowsPerPage<=0)
rowsPerPage = 100;

Integer userId = userinfo_session.getId();	




String ListSql = " select * from( select * from tidecms_log where 1=1 and  LogAction ="+LogAction.document_edit+" and User="+userId+" ORDER BY CreateDate desc ) table1  GROUP BY Item  ORDER BY CreateDate desc";
String CountSql = "select count(*) from tidecms_log where 1=1";
TableUtil tu = new TableUtil("user");
ResultSet Rs = pt.List(ListSql,CountSql,currPage,rowsPerPage);

JSONArray array = new JSONArray();
while(Rs.next()){
    JSONObject obj = new JSONObject();
    int UserID = Rs.getInt("User");
	UserInfo user = (UserInfo)CmsCache.getUser(UserID);
	String CreateDate = convertNull(Rs.getString("CreateDate"));
	String Title = convertNull(Rs.getString("Title"));
	
	String LogType = convertNull(Rs.getString("LogType"));
	int logAction_ = Rs.getInt("LogAction");
    String action = LogAction.getActionDesc(logAction_);
    String FromType = convertNull(Rs.getString("FromType"));
    String FromTypeDesc = l.getFromDesc(FromType);
	String FromKey = convertNull(Rs.getString("FromKey"));
	int Item = Rs.getInt("Item");
	
	int gid=Rs.getInt("id");

    int cid=0;
    
	if(FromType.equals("channel"))
	{//out.println(FromType);
		 cid = Util.parseInt(FromKey);//out.println(FromKey);
		if(cid>0)
		{
			Channel c_ = CmsCache.getChannel(cid);
			if(c_!=null)
			{
				FromTypeDesc = c_.getParentChannelPath();
			}
		}
	} 
	
	String url = request.getRequestURL()+"";
    String base = url.replace(request.getRequestURI(),"");
    String ContextPath=request.getContextPath();
    
    
    String path=base+ContextPath+"/content/document.jsp?ItemID="+Item+"&ChannelID="+FromKey+"";

	obj.put("address",path);
	
	obj.put("cid",cid);
	obj.put("FromKey",FromKey);

	obj.put("name",user.getName());
	obj.put("username",user.getUsername());
	obj.put("CreateDate",CreateDate);
	obj.put("Title",Title);
	obj.put("LogType",LogType);
	obj.put("action",action);
	obj.put("FromType",FromType);
	obj.put("FromTypeDesc",FromTypeDesc);
    array.put(obj);	
   
}
  
String callback=getParameter(request,"callback");  
out.println(callback+"("+array+")");  
 
%>




