<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	String globalids=getParameter(request,"globalids");
	//out.println("globalid="+globalids);
	//System.out.println("globalids="+globalids);
	String[] gid_s=globalids.split(",");
	
	int[] gids= new int[gid_s.length];

	HashMap gmap = new HashMap();
	HashMap gmap2 = new HashMap();
	for(int j=0;j<gids.length;j++){
		gids[j]=Integer.parseInt(gid_s[j])+10000;
		gmap.put(gids[j],0);
		gmap2.put(gids[j],0);
	}
	String gids_="";
	for(int k=0;k<gids.length;k++){
		if(k!=0){
			gids_+=",";
		}
		gids_+=gids[k];
	}
	
	
	//out.println("gids="+gids_);
	String res="[";
	String sql="select click_num,gid from tidecms_visit where gid in("+gids_+")";
	TableUtil tu = new TableUtil();
	int click_num=0;
	ResultSet rs = tu.executeQuery(sql);
	while(rs.next()){
		//out.println("click_num="+rs.getInt("click_num")+",gid="+rs.getInt("gid"));
		gmap.put(rs.getInt("gid"),rs.getInt("click_num"));

	}
	tu.closeRs(rs);
	//out.println(gmap);

//alter table tidecms_visit alter column click_num set default 0;
	//[{"id":1054057,"clicknum":1},{}]

//	HashMap gmap2 = gmap;
	TableUtil tu2 = new TableUtil();
	sql="select num,gid from tidecms_visit_date where gid in("+gids_+")";
	ResultSet rs2 = tu2.executeQuery(sql);
	while(rs2.next()){
		//out.println("click_num="+rs.getInt("click_num")+",gid="+rs.getInt("gid"));
		gmap2.put(rs2.getInt("gid"),rs2.getInt("num"));

	}
	tu2.closeRs(rs2);
	int temp=0;
	for(int i=0;i<gids.length;i++){
		if(temp!=0){
			res+=",";
		}
		res+="{\"id\":"+gid_s[i]+",\"clicknum\":"+gmap.get(gids[i])+",\"num\":"+gmap2.get(gids[i])+"}";
		temp++;
	}
	res+="]";
	//out.println(res);
	try {
		JSONArray ja = new JSONArray(res);
		out.println(ja);
		//System.out.println("res="+res);
	} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
	}

%>