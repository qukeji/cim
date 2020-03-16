 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
				java.util.regex.Pattern,
				tidemedia.cms.util.*"%>
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
		
		

%>
<%
String Title = "";
String Token = "";
int channelid = 0;
JSONObject o =new JSONObject();
String channelid_str="";
try{
//Pattern pattern = Pattern.compile("[0-9]{6}"); 
//boolean channelid_valid_flag=false;//频道参数是否合法
boolean b_title = false;
boolean b_channelid = false;
boolean e_channelid=true;//判断频道编号是否存在
boolean field_error=true;
HashMap map = new HashMap();
ArrayList<String> fields_name=new ArrayList<String>();
Enumeration paramNames = request.getParameterNames();
while (paramNames.hasMoreElements()) {  
      String p = (String) paramNames.nextElement(); 
	  String v = getParameter(request,p);
	  if(p.equals("Title") && v.length()>0) b_title = true;
	  if(p.equals("Token") && v.length()>0) Token = v;
	  if(p.equals("ChannelID") && v.length()>0){
		  channelid_str=getParameter(request,p);
		  channelid = getIntParameter(request,p);
		 //channelid_valid_flag=pattern.matches("^[1-9]\\d{1,9}$", channelid_str);
		 
			   //channelid=Util.parseInt(channelid_str);
		  
		 b_channelid = true;
		   
		 e_channelid=existchannel(channelid);
			
	  }
	   
			map.put(p,v);
			fields_name.add(p);
		
}
//
	
		
		if(e_channelid){
			
			for(String fieldname:fields_name){
			
				if(!fieldname.equals("Token")&&!fieldname.equals("ChannelID")){	
		
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


//JSONObject o = new JSONObject();
if(channelid==0){
	o.put("status",0);
	o.put("message","频道编号不符合标准");
}else if(!field_error){
	o.put("status",0);
	o.put("message","录入字段不存在");
}
else if(Token.length()==0)
{
	o.put("status",0);
	o.put("message","缺少登录令牌");
}
else if(login!=1)
{
	o.put("status",0);
	o.put("message","登录失败");
}
else if(!b_title)
{
	o.put("status",0);
	o.put("message","缺少标题");
}
else if(!b_channelid)
{
	o.put("status",0);
	o.put("message","缺少频道编号");
}
else if(!e_channelid){
        o.put("status",0);
		o.put("message","该频道编号不存在");
}
else
{
	ItemUtil util = new ItemUtil();
	map.put("tidecms_addGlobal","1");
	Document doc = util.addItem(channelid,map);
	int id = doc.getId();
	int gid = doc.getGlobalID();

	o.put("status",1);
	o.put("itemid",id);
	o.put("globalid",gid);
	o.put("message","success");
}
}catch(Exception e){
	o.put("status",0);
	o.put("message","接口调用出错");
}

out.println(o.toString());
%>
