<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.Date,
				java.text.DecimalFormat,
				java.text.SimpleDateFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
    //概览页面数据统计
%>
<%
	Channel channel = ChannelUtil.getApplicationChannel("shengao");
	int channelid = channel.getId() ;
	String callback=getParameter(request,"callback");
	int company = userinfo_session.getCompany();
	int userId = userinfo_session.getId();
	int role = userinfo_session.getRole();

	String sql="select * from "+ channel.getTableName()+" where Active=1 ";
	if(role==3){
		sql+=" and User = "+userId;
	}else{
		if(company!=0){
			Channel companyChannel = ChannelUtil.getCompanyChannelByShare(channel, company);
			sql+=" and Category = "+companyChannel.getId();
		}
	}
	System.out.println("sql=="+sql);
	TableUtil tu=new TableUtil();
	ResultSet rs=tu.executeQuery(sql);
	JSONArray array = new JSONArray();
	int num1 = 0 ;//未审核
    int num2 = 0 ;//审核中
    int num3 = 0 ;//审核通过
    JSONObject o = new JSONObject();
	while(rs.next()){
	    
	    int gid=rs.getInt("GlobalID");
	    String title=rs.getString("Title");
	    //查询最后一次审核
	    ApproveAction approve = new ApproveAction(gid,0);
	    int action	= approve.getAction();//是否通过
	    int approveid = approve.getId();//审核操作id
	    int end = approve.getEndApprove();//是否终审
	    
	    if(approveid==0){
	        num1++;
	    }else if(action==0&&end==1){
	        num3++;
	    }else{
	        num2++;
	    }
	              
	}      
    o.put("num1",num1);
    o.put("num2",num2);
    o.put("num3",num3);
       
    out.println(o);
    

%>






















