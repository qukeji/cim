<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
                org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%  int GlobalID = getIntParameter(request,"globalid");
	HashMap map = new HashMap();
	String t = CmsCache.getParameterValue("sys_video");
	JSONObject ooo = new JSONObject(t);
	JSONArray o = ooo.getJSONArray("birate");
	for(int i =0;i<o.length();i++)
    {
	  JSONObject oo = o.getJSONObject(i);
	  map.put(oo.getString("value"),oo.getString("name"));
    }
	int transcode_channelid = CmsCache.getParameter("sys_channelid_transcode").getIntValue();//获取系统参数转码频道编号
	if(transcode_channelid==0||GlobalID==0){
		out.println("[{'status2':'error'}]");
	}else{
	Channel channel= new Channel(transcode_channelid);
	TableUtil tu = new TableUtil();
	//int Status2 = 0;
	String Status2 = "";
	String sql = "select * from "+channel.getTableName()+" where Parent="+GlobalID;//+" where channel_code = "+Code;
	//System.out.println("sql3="+sql);
	ResultSet rs = tu.executeQuery(sql);		
	String res = "[";
	while(rs.next()){			
			//reason = tu3.convertNull(rs3.getString("reason"));
			int id_ = rs.getInt("id");
			int video_type = rs.getInt("video_type");
			int progress = rs.getInt("progress");
			Status2 = tu.convertNull(rs.getString("Status2"));
			//System.out.println("Status2="+Status2);
			if(Status2.equals("2")){
			Status2 = "<font color=blue>转码完成</font>";
			}else if(Status2.equals("3")){
			Status2 = "<font color=red>转码失败</font>";
			}else if(Status2.equals("0")){
			Status2 = "<font color=red>等待分发</font>";
			}else if(Status2.equals("1")){
			Status2 = "<font color=red>正在转码</font>";
			}
            String type = (String)map.get(video_type+"");
			res +="{'status2':'"+Status2+"','itemid':'"+id_+"','progress':'"+progress+"','type':'"+type+"'},";
			
		}

		int len = res.length();
		if(res.endsWith(",")){
		    res = res.substring(0,len-1);
		}
            res +="]";
			tu.closeRs(rs); 
		    out.println(res);
			
		}
		
			%>
 
