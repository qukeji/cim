 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
    //提交问政接口
%>
<%!
    public static HashMap<String ,Object> addPolitics( int channelid,int type,int ispublic
    ,int userid,String title,String summary,String username,String phone){
        HashMap<String ,Object> map= new HashMap<String,Object>();
        try{
            if(type==0||userid==0||title.equals("")||summary.equals("")||username.equals("")||phone.equals("")){
                map.put("status",501);
                map.put("message","缺少参数");
            }else {
                TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
        		int wenzhengchannelid = politics.getInt("politicsid");//问政编号信息
        		int replysid = politics.getInt("replysid");//回复记录频道
		        //问政提交到问政表
                HashMap politicsmap=new HashMap();
                politicsmap.put("Category",String.valueOf(channelid));
                politicsmap.put("type",String.valueOf(type));
                politicsmap.put("ispublic",String.valueOf(ispublic));
                politicsmap.put("UserId",String.valueOf(userid));
                politicsmap.put("Title",title);
                politicsmap.put("Summary",summary);
                politicsmap.put("UserName",username);
                politicsmap.put("Status",0+"");
                politicsmap.put("phone",phone);
	            int gid = ItemUtil.addItemGetGlobalID(wenzhengchannelid, politicsmap);
	            
	            //获取文章对象
    			Document doc = new Document(gid);
    			//发布
    		
    			
	            //插入问政回复内容表
	            HashMap politicsmapreason=new HashMap();
                politicsmapreason.put("Title",title);
                politicsmapreason.put("Summary",summary);
                politicsmapreason.put("handler",username);
                politicsmapreason.put("parent",String.valueOf(gid));
                int gid2 = ItemUtil.addItemGetGlobalID(replysid, politicsmapreason);
                
                if(gid!=0){
                    map.put("id",gid);
                    map.put("message","成功");
                    map.put("status",200);
                   
                }else {
                    map.put("id",0);
                    map.put("status","500");
                    map.put("message","程序异常");
                }
            }
        }catch (Exception e){
                    map.put("status","500");
                    map.put("message","程序异常");
                    e.printStackTrace();
        }
        return map;
    }
%>
<%
	String callback=getParameter(request,"callback");
    JSONObject json = new JSONObject();
    int channelid		= getIntParameter(request,"channelid");
    int type			= getIntParameter(request,"type");
    int ispublic		= getIntParameter(request,"ispublic");
    int userid	        = getIntParameter(request,"userid");
    String title		= getParameter(request,"title");
    String summary		= getParameter(request,"summary");
    String username		= getParameter(request,"username");
    String phone		= getParameter(request,"phone");

    HashMap<String, Object> map = addPolitics(channelid,type,ispublic,userid,title,summary,username,phone);
    json = new JSONObject(map);
    out.println(callback+"("+json.toString()+")");

%>
