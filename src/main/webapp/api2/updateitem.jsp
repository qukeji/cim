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

	  public static boolean existchannel(int channelid) throws MessageException, SQLException{
             Channel channel =CmsCache.getChannel(channelid);
             if(channel==null){
                   return false;
             }else{
                   return true;
             }
        }
		
	  public static boolean existglobalid(int globalid) throws MessageException, SQLException{
             Document doc=new Document(globalid);
             if(doc.getGlobalID()==0){
                   return false;
             }else{
                   return true;
             }
        }
%>
<%
String Title = "";
int channelid = 0;
int GlobalID = 0;


String channelid_str="";
String GlobalID_str="";
JSONObject o = new JSONObject();
try{
//Pattern pattern = Pattern.compile("[0-9]{6}"); 
//boolean channelid_valid_flag=false;//频道参数是否合法
//boolean globalid_valid_flag=false;//全局变量参数是否合法
boolean b_title = false;
boolean b_channelid = false;
boolean e_channelid=true;//频道编号是否存在
boolean e_globalid=true;//globalid是否存在
boolean b_globalid = false;
boolean field_error=true;
String Token = "";

HashMap map = new HashMap();
ArrayList<String> fields_name=new ArrayList<String>();
Enumeration paramNames = request.getParameterNames();
while (paramNames.hasMoreElements()) {  
      String p = (String) paramNames.nextElement(); 
	  String v = getParameter(request,p);
	  if(p.equals("Title") && v.length()>0) b_title = true;
	  if(p.equals("Token") && v.length()>0) Token = v;
	  if(p.equals("ChannelID") && v.length()>0){
		  channelid=getIntParameter(request,p);
		  //channelid = getIntParameter(request,p);
		 // channelid_valid_flag=pattern.matches("^[1-9]\\d{1,9}$", channelid_str);
		 
		   //channelid=Util.parseInt(channelid_str);
		  //channelid = getIntParameter(request,p);
		   b_channelid = true;
		   
		   e_channelid=existchannel(channelid);
		   
	  }
	  if(p.equals("GlobalID") && v.length()>0){
		  GlobalID=getIntParameter(request,p);
		  // globalid_valid_flag=pattern.matches("^[1-9]\\d{1,9}$", GlobalID_str);
		 
		   //GlobalID=Util.parseInt(GlobalID_str);
		   b_globalid = true;
			//if(globalid_valid_flag){
				e_globalid=existglobalid(GlobalID);
			//}
	  }
	  //out.println(p);

	  map.put(p,v);
	  fields_name.add(p);
}



if(e_channelid&&e_globalid){
			
			for(String fieldname:fields_name){
			
				if(!fieldname.equals("Token")&&!fieldname.equals("ChannelID")&&!fieldname.equals("GlobalID")){	
		
					boolean field_exist=false;
					ArrayList<Field> channel_field=new Channel(channelid).getFieldInfo();
					for(Field field:channel_field){
						String field_name=field.getName();
						if(field_name.equals(fieldname)){
							field_exist=true;
						}
					}
					if(!field_exist){
						field_error=false;
					}
				}
			}
		}
		
		
		
int login = 0;
if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token);



//if(Token.length()==0)
//{
//	o.put("status",0);
//	o.put("message","缺少登录令牌");
//}
//else if(login!=1)
//{
//	o.put("status",0);
//	o.put("message","登录失败");
//}
//else
/* if(!b_title)
{
	o.put("status",0);
	o.put("message","缺少标题");
}
else*/ 

if(!b_channelid)
{
	o.put("status",0);
	o.put("message","缺少频道编号");
}else if(channelid==0){
	o.put("status",0);
	o.put("message","频道编号不符合标准");
}else if(!field_error){
	o.put("status",0);
	o.put("message","更新字段不存在");
}else if(!b_globalid){

	o.put("status",0);
	o.put("message","缺少全局编号");
}else if(!e_globalid){
	o.put("status",0);
	o.put("message","该全局编号不存在");
}else if(!e_channelid){
	o.put("status",0);
	o.put("message","该频道编号不存在");
}
else
{
	ItemUtil util = new ItemUtil();
	util.updateItem(channelid,map,GlobalID,0);
	Document doc = new Document(GlobalID);
	o.put("itemid",doc.getId());
	o.put("channelid",doc.getChannelID());
	o.put("status",1);
	o.put("message","成功");
}
}catch(Exception e){
	o.put("status",0);
	o.put("message","调用接口失败！");
}
out.println(o.toString());
%>
