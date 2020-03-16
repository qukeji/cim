<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				 java.text.DecimalFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../common/2018/common2018.js"></script>
<script src="../common/document.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
<script src="../common/tag-it.js"></script>
<%
    //问政处理插入接口
    
%>
<%

    
    int		GlobalID		=	getIntParameter(request,"GlobalID");
    int		ChannelID	=	getIntParameter(request,"ChannelID");
    int     ItemID      =   getIntParameter(request,"ItemID");

    int     probstatus     =   0;//问题状态
    /*未审核(1)审核未通过(2)未受理(3)已受理(4)平台回复(5)已回复(6)已完结(7)*/
    int     Status2     =   0;//处理状态，0为不处理，接收后需要减1
    /*待办理(0)办理中(1)已办理(2) */
    int		ispublic	=	getIntParameter(request,"ispublic");//是否公开，0为不处理，接收后需要减1
     /*公开(0)保密(1) */
    int		belong	=	getIntParameter(request,"belong");//转交所属部门

    String  reason	= getParameter(request,"reason");//处理原因
    
    TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
    int replysid = politics.getInt("replysid");//回复记录频道
    
    if(reason==null){
        reason="";
    }

    int  operation	= getIntParameter(request,"operation");//操作
    
    Document doc = null;
    if(ItemID!=0){
        doc = CmsCache.getDocument(ItemID,ChannelID);
    }
    if(doc!=null)
	{
		GlobalID = doc.getGlobalID();
	}
    Status2 = doc.getIntValue("Status2");
    
    String operationDesc = "";
    if(operation==2){
        operationDesc = "审核未通过";//状态处理中，问题未审核，提交处理操作，不通过原因。更新状态已办理、问题审核不通过
        Status2 = 2;
        probstatus = 2;
    }
    if(operation==3){
        operationDesc = "转交";//状态待处理，问题未审核。转交流程；改变是否公开、转交部门。内容插入部门。改变状态处理中，问题待处理。提交处理操作，
        Status2 = 0;
        probstatus = 3;
    }
    if(operation==4){
        operationDesc = "平台回复";//有内容//状态处理中，问题未审核。转交流程：改变是否公开、转交部门。内容插入部门。改变问题待处理。提交处理操作、处理原因。
        Status2 = 1;
        probstatus = 5;
    }
    if(operation==5){
        operationDesc = "退回";//状态处理中，问题未受理。删除部门，更新父问题状态为未审核。删除数据。提交处理操作，退回内容
        Status2 = 0;
        probstatus = 1;
    }
    if(operation==6){
        operationDesc = "开始办理";//部门结束状态处理中，问题已受理、已回复。不提交处理。同步更新状态已办理、问题已完结
        Status2 = 0;
        probstatus = 4;
    }

    if(operation==7){
        operationDesc = "回复";//部门回复//状态待处理，问题未审核、平台回复。状态处理中，问题已受理、已回复。同步更新改变问题已回复。根据父id提交处理操作、回复内容。
        Status2 = 1;
        probstatus = 6;
    }
    if(operation==8){
        operationDesc = "结束";//平台结束状态处理中，问题已受理、已回复。不提交处理。同步更新状态已办理、问题已完结
        Status2 = 2;
        probstatus = 7;
    }
    
    
    //更新处理状态、问题状态

    if(probstatus==0){
        probstatus = doc.getIntValue("probstatus");
    }

    if(ispublic==0){
        ispublic = doc.getIntValue("ispublic");
    }else{
        ispublic=ispublic-1;
    }

    if((operation!=5&&belong==0)||operation==8){
        belong = doc.getCategoryID();
    }

    if(ChannelID!=0&&ItemID!=0&&operation!=1&&operation!=0){
        
        HashMap<String, String> map = new HashMap<String, String>();
        map.put("Status2",Status2+"");
        map.put("probstatus",probstatus+"");
        map.put("ispublic",ispublic+"");
        map.put("Category",belong+"");
    
        ItemUtil.updateItemById( ChannelID,map, ItemID,1);
		doc.setUser(userinfo_session.getId());
        doc.Approve(ItemID+"",ChannelID);
    }   

    //提交回复
    if(operation==2||operation==3||operation==4||operation==5||operation==6||operation==7||operation==8){
        
        String Title=doc.getTitle();
        String name = new UserInfo(userinfo_session.getId()).getName();
        Channel channel = CmsCache.getChannel(ChannelID);
        String ChannelName = channel.getName();
    
        HashMap<String, String> replaymap = new HashMap<String, String>();
        replaymap.put("Title",Title+"");
        replaymap.put("reason",reason+"");
        replaymap.put("parent",GlobalID+"");
        replaymap.put("operation",operation+"");
        replaymap.put("handler",name+"");
        
        ItemUtil.addItemGetGlobalID(replysid, replaymap);
        System.out.println("======================================================hahaha:"+GlobalID);
    }

%>
