<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	//引用栏目               Attribute1                继承上级    cT('Attribute1')        应用到子频道   applySubChannel('Attribute1')
	//引用对应关系        Attribute2                继承上级    cT('Attribute2')        应用到子频道    applySubChannel('Attribute2')
	//推荐栏目              RecommendOut               继承上级  cT('RecommendOut')	   applySubChannel('RecommendOut')
	//推荐对应关系        RecommendOutRelation      cT('RecommendOutRelation')		applySubChannel('RecommendOut')
	//设置当前频道为独立频道     RecommendOut ='***' Attribute1 ='***'
	//设置当前频道为继承频道   RecommendOut =''     Attribute1 =''

	TableUtil  tu =  new TableUtil();
    //String delsql = "delete from channel_recommend";
    //tu.executeUpdate(delsql);
    //System.out.println("清除推荐表(channel_recommend)中数据...");
	String sql = "select * from channel";
	ResultSet rs = tu.executeQuery(sql);
	out.println("开始同步推荐和引用频道数据.....<br>");
	int recommendCount = 0;//推荐同步计数
	int referenceCount = 0;//推荐同步计数
	while(rs.next()){
		 int ChannelID = rs.getInt("id");//当前频道id
		 String RecommendOut = rs.getString("RecommendOut");//推荐栏目
		 String RecommendOutRelation = rs.getString("RecommendOutRelation");//推荐对应关系

		 //处理推荐频道
		 if(RecommendOut !=null && !RecommendOut.equals("") && RecommendOutRelation != null && !RecommendOutRelation.equals("")){

			    if (RecommendOut.equals("***")){//推荐栏目没配置，或者为***（继承上级频道）,跳过
					continue;
				}
			 	out.println(ChannelID+"："+RecommendOut+":"+RecommendOutRelation+"<br>");

			 	String[]  attrArray2 =  RecommendOut.split("\n");//获取独立推荐的频道关系
			 	for(String  attr1 : attrArray2) {
					attr1 = attr1.replace("\r","");
					Channel channel = CmsCache.getChannel(attr1);//attr 频道编号
					if (channel == null) {
						continue;
					}
					int relationID2 = channel.getId();//要推荐到的频道id
					String relationship2 = RecommendOutRelation;//对应关系

					String sql2 = "select * from channel_recommend where ChannelID=" + ChannelID
							+ " and RelationID=" + relationID2
							+ " and FieldRelation=1"
							+ " and RelationchannelType=0"
							+ " and Type=1";

					out.println(sql2 + ":" + tu.isExist(sql2) + "<br>");
					if (!tu.isExist(sql2)) {//该数据不存在 保存
						ChannelRecommend channelRecommend2 = new ChannelRecommend();
						channelRecommend2.setChannelID(ChannelID);
						channelRecommend2.setRelationID(relationID2);
						channelRecommend2.setType(1);
						channelRecommend2.setRelationship(relationship2);
						channelRecommend2.setRelationchannelType(0);
						channelRecommend2.setFieldRelation(1);
						channelRecommend2.Add();
						recommendCount++;
						out.println("同步推荐第" + recommendCount + "条数据完成" + "<br>");
					} else {
						out.println("该条记录已存在,同步推荐跳过..." + "<br>");
					}
				}
		 }

		String Attribute1 = rs.getString("Attribute1");//引用栏目
		String Attribute2 = rs.getString("Attribute2");//引用对应关系
		//处理引用频道
		if(Attribute1 !=null && !Attribute1.equals("") && Attribute2 != null && !Attribute2.equals("")){
			if (Attribute1.equals("***")){//引用栏目没配置，或者为***（继承上级频道）,跳过
				continue;
			}
			out.println(ChannelID+"："+Attribute1+":"+Attribute2+"<br>");

			String[]  attrArray =  Attribute1.split("\n");
			for(String  attr : attrArray){
				attr = attr.replace("\r","");
				Channel channel = CmsCache.getChannel(attr);//attr 频道编号
				if (channel == null) {
					continue;
				}

				int relationID1 = channel.getId();//引用频道id
				String relationship1 = Attribute2;//对应关系

				String sql1 = "select * from channel_recommend where ChannelID="+ChannelID
						+" and RelationID="+relationID1
						+" and FieldRelation=1"
						+" and RelationchannelType=0"
						+" and Type=2";

				out.println(sql1 + ":" + tu.isExist(sql1) + "<br>");
				if(!tu.isExist(sql1)){//该数据不存在 保存
					ChannelRecommend  channelRecommend1 = new ChannelRecommend();
					channelRecommend1.setChannelID(ChannelID);
					channelRecommend1.setRelationID(relationID1);
					channelRecommend1.setType(2);
					channelRecommend1.setRelationship(relationship1);
					channelRecommend1.setRelationchannelType(0);
					channelRecommend1.setFieldRelation(1);
					channelRecommend1.Add();
					referenceCount++;
					out.println("同步引用第"+referenceCount+"条数据完成<br>");
				}else{
					out.println("该条记录已存在,同步引用跳过...<br>");
				}
			}
		}
	}
	tu.closeRs(rs);
	out.println("同步完成.....");
%>