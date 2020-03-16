<%@ page import="tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*,java.sql.*,tidemedia.cms.base.*,tidemedia.cms.scheduler.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!

// 判断表中是否存在某数据
public static int exists(String sql) {
	int id = 0;
	try {
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		if (rs.next()) {// 数据存在，返回ID
			id = rs.getInt("id");
		}
		tu.closeRs(rs);
	} catch (Exception e) {
		e.printStackTrace();
	}
	return id;
}
//创建媒体号
public static int createChannel(int parent_channelid,int itemid,String Title,String recommendOut,String recommendOutRelation,String documentProgram,String documentJS) {
	int thisChannelid = 0;
	try{
		String serialno = CmsCache.getChannel(parent_channelid).getAutoSerialNo();		
		int index = serialno.lastIndexOf("_");
		String folder = "";
		if(index!=-1){
			folder = serialno.substring(index+1);
		}else{									
			folder = serialno;
		}	         
		String Extra2="{\"company\":"+itemid+"}";
		//判断频道是否存在
		int CurrentCompanyId = exists("select id from channel where parent=" + parent_channelid + " and extra2 ='"+Extra2+"'");
		if(CurrentCompanyId==0){//说明此企业为生成对应频道

			Channel channel = new Channel();
			channel.setName(Title);
			channel.setFolderName(folder);
			channel.setTemplateInherit(1);
			channel.setIsDisplay(1);
			channel.setParent(parent_channelid);
			channel.setType(1);
			channel.setSerialNo(serialno);
			channel.setExtra2(Extra2);
			channel.setRecommendOut(recommendOut);
			channel.setRecommendOutRelation(recommendOutRelation);
			channel.setDocumentProgram(documentProgram);
			channel.setDocumentJS(documentJS);
			channel.Add();
			thisChannelid = channel.getId();
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	return thisChannelid;
}
%>
<%
/**
* 用途：内容页提交程序
* 1,李永海 20140101 创建
* 2,此文件编码必须是ANSI
* 3,
* 4,
* 5,
*/
//final int parent_channelid = CmsCache.getParameter("company_source").getIntValue();
try{
	String Action = getParameter(request,"Action");
	if(!Action.equals(""))
	{
		int		ChannelID			= getIntParameter(request,"ChannelID");
		int		close_window_type	= getIntParameter(request,"Close_Window_Type");
		String	RelatedItemsList	= getParameter(request,"RelatedItemsList");
		int ContinueNewDocument		= getIntParameter(request,"ContinueNewDocument");
		int NoCloseWindow			= getIntParameter(request,"NoCloseWindow");//不关闭窗口
		//int	AutoSave			= getIntParameter(request,"AutoSave");//自动保存         
    	int	ItemID					= getIntParameter(request,"ItemID");	 
//	    System.out.println("文章修改ItemID==="+ItemID);

		String Title = getParameter(request,"Title");

/*		int title_repeat_config=CmsCache.getParameter("sys_checktitle").getIntValue();//重复标题监测
		
		if(title_repeat_config==1){	  
			boolean chongfu = false;			
			TableUtil tu = new TableUtil();
			Channel channel = CmsCache.getChannel(ChannelID);
			String sql = "select id from " + channel.getTableName() + " where Title='" + tu.SQLQuote(Title) + "' and Active=1 and id!="+ItemID;
			ResultSet rs = tu.executeQuery(sql);
			if(rs.next())
			{
				chongfu = true;
			}
			tu.closeRs(rs);
			if(chongfu)
			{
				out.println("{\"message\":\"标题已经存在\"}");
				return;
			}
		}
*/		
		int gid=0;
		HashMap map = new HashMap();
		HashMap map_media = new HashMap();
		Enumeration enumeration = request.getParameterNames();
		while(enumeration.hasMoreElements()){
			String name=(String)enumeration.nextElement();			
			String values[] = request.getParameterValues(name);
			String values2 = "";
			if(values!=null)
			{
				if(values.length==1)
					values2 = values[0];
				else
					values2 = Util.ArrayToString(values,",");
			}
			if(name.equals("Content"))
			{
				//处理热词
				values2 = WordUtil.processHotword(values2);
			}
            map_media.put(name,values2);
			map.put(name,values2);
		}
		tidemedia.cms.system.Document document = new tidemedia.cms.system.Document();
		document.setRelatedItemsList(RelatedItemsList);
		document.setChannelID(ChannelID);
		document.setUser(userinfo_session.getId());
		document.setModifiedUser(userinfo_session.getId());
		//gid = document.getGlobalID();
		
		//根据频道ID获取频道对象
		Channel channel=CmsCache.getChannel(ChannelID);
		//获取频道所属站点ID
		int siteId = channel.getSiteID();		
		//定义频道标识名
		String channel_SerialNo = "company_s"+siteId+"_source";		
		//根据频道标识名获取频道对象
		Channel channelWl=CmsCache.getChannel(channel_SerialNo);
		//获取频道ID
		int parent_channelid = channelWl.getId();
		
		//获取频道属性
		Channel channel_parent = CmsCache.getChannel(parent_channelid);
	    String recommendOut = channel_parent.getRecommendOut();
		String recommendOutRelation = channel_parent.getRecommendOutRelation();
		String documentProgram = channel_parent.getDocumentProgram();
		String documentJS =channel_parent.getDocumentJS();
//		System.out.println("文章创建setRelatedItemsList==="+RelatedItemsList);
		int Status	=	getIntParameter(request,"Status");
		int itemid  =   0 ;
		int result = 0;
		if(Action.equals("Add"))//2013-07-15 15:41:34
		{
			result = document.AddDocument(map);
			//获取ItemID
			itemid=document.getId();//0;
			TableUtil tu_ = new TableUtil();
			Channel channel_company_id = CmsCache.getChannel(ChannelID);
			String sql_ = "update " + channel_company_id.getTableName() + " set company_id=" + itemid + " where id="+itemid;
			tu_.executeUpdate(sql_);				
		}
		if(Action.equals("Update"))
		{
			result = document.UpdateDocument(map);
			itemid=document.getId();
		}
		
		//判断操作是否成功
		if(result==0){
			out.println("{\"message\":\"无权限进行此操作\"}");
			return;
		}else if(result==2){
			out.println("{\"message\":\"保存没有成功，请重新尝试。\"}");
			return;
		}else if(result==3){
			out.println("{\"message\":\"内容存在敏感词。\"}");
			return;
		}

		if(Status==1){	//保存发布时创建频道				
			int thisChannelid = createChannel(parent_channelid, itemid, Title, recommendOut, recommendOutRelation, documentProgram, documentJS);
			if(thisChannelid!=0){
				CmsCache.delChannel(thisChannelid);//清除频道缓存
				session.removeAttribute("channel_tree_string");
				//频道列表地址
				Channel channel1 = new Channel(thisChannelid);
				String filePath = Util.ClearPath(channel1.getFullPath()+"/list_1_0.shtml") ;
				TableUtil tu = new TableUtil();
				tu.executeUpdate("update "+CmsCache.getChannel(ChannelID).getTableName()+" set listurl='"+tu.SQLQuote(filePath)+"' where id="+itemid);

				//HashMap<String, String> map1 = new HashMap<String, String>();
				//map1.put("listurl",filePath);
				//ItemUtil.updateItemById(ChannelID,map1,itemid,userinfo_session.getId());
			}
		}

		gid = document.getGlobalID();
		//SetPublishJobUtil job = new SetPublishJobUtil();
		//SetRemoveJobUtil job2 = new SetRemoveJobUtil();
		tidemedia.cms.system.Document doc = new tidemedia.cms.system.Document(gid);
		int status = doc.getStatus();
		//String spd = Util.convertNull(doc.getValue("SetPublishDate"));
		//String spd2 = Util.convertNull(doc.getValue("Revoketime"));
		String title = doc.getValue("Title");
		/*if(spd!=null){
			spd=spd.replace(".0","");
		}
		
		if(spd2!=null){
			spd2=spd2.replace(".0","");
		}
		
		if(status==0&&spd!=null&&spd.length()>0&&Util.getCalendar(spd,"yyyy-MM-dd HH:mm").getTimeInMillis()>System.currentTimeMillis()){
			//必须是草稿状态 一次判断 不为null，length，时间
			job.setPublishJob(gid);
		}
		if(spd2!=null&&spd2.length()>0&&Util.getCalendar(spd2,"yyyy-MM-dd HH:mm").getTimeInMillis()>System.currentTimeMillis()){
			//必须是已发状态 一次判断 不为null，length，时间
			job2.setPublishJob2(gid);
		}
		*/
		if(close_window_type==0) close_window_type = 1;
		String message = document.getMessage();

		//if(NoCloseWindow==1) message = "no close window";
		//if(AutoSave==1) message = "auto save";
		if(NoCloseWindow==1)
		{
				//自动保存 不关闭窗口
				//	response.sendRedirect("document.jsp?NoCloseWindow=1&ItemID=" + document.getId() + "&ChannelID="+ChannelID);
				out.println("{\"id\":\""+document.getId()+"\",\"channelid\":\""+ChannelID+"\"}");
		}
		else
		{
			if(message.length()>0)
			{
				out.println("{\"message\":\""+message+"\"}");
			}
			else
			{
				out.println("{\"message\":\"\"}");	
			}
		}
		/*
		if(ContinueNewDocument==1)
			response.sendRedirect("document.jsp?ContinueNewDocument=1&ItemID=0&ChannelID="+ChannelID);
			
		else if(NoCloseWindow==1)
			response.sendRedirect("document.jsp?NoCloseWindow=1&ItemID=" + document.getId() + "&ChannelID="+ChannelID);
		else
			response.sendRedirect("../close_pop.jsp?Type="+close_window_type);
			*/
	}
}catch(Exception e){
	e.printStackTrace();
	out.println("{\"message\":\"保存没有成功，请重新尝试。\"}");
}
%>
