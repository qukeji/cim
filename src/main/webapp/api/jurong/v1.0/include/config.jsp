<%! 
//获取用户所有权限频道（用户编号，选题编号，是否是选题）
public ArrayList getUserChannel(int userId,int channelid_,int data_type_) throws SQLException, MessageException, JSONException
{
	UserInfo info = new UserInfo(userId);

	ArrayList<Integer> channellist = new ArrayList<Integer>();

	ArrayList<ChannelPrivilegeItem> Privilegelist=info.getChannelPermArray();
	for(ChannelPrivilegeItem cl:Privilegelist){
		
		int channelId = cl.getChannel() ;
		Channel c = CmsCache.getChannel(channelId);
		int [] PerArray=cl.getPermArray();
		for(int P:PerArray){
			if(P==1){//有浏览频道权限

				if(data_type_==1){//稿件,选题频道跳过
					if(channelId==channelid_||isTopicChannel(channelId,channelid_)){
						continue;
					}
				}else{
					if(!isTopicChannel(channelId,channelid_)){//不是选题频道，跳过
						continue;
					}	
				}
				channellist.add(channelId);
			}
		}

		if(cl.getIsInherit()==1){//包含子频道

			ArrayList<Integer> arraylist = c.listAllSubChannelIDs();
			if (arraylist == null || arraylist.size() == 0){
				continue;
			}

			for (int i = 0; i < arraylist.size(); i++) {

				int childChannel = (int) arraylist.get(i);

				if(data_type_==1){//稿件,选题频道跳过
					if(childChannel==channelid_||isTopicChannel(childChannel,channelid_)){
						continue;
					}
				}else{
					if(!isTopicChannel(childChannel,channelid_)){//不是选题频道，跳过
						continue;
					}	
				}
				channellist.add(childChannel);
			}
		}
	}
	return channellist ;
}

public String getUserChannelString(int userId,int channelid_,int data_type_) throws SQLException,MessageException,JSONException {
	// 列出频道下所有子频道和子分类
	ArrayList<Integer> arraylist = getUserChannel(userId,channelid_,data_type_);

	if (arraylist == null || arraylist.size() == 0)
		return "";
	
	String ids = "";
	
	for (int i = 0; i < arraylist.size(); i++) {
		Integer integer = (Integer) arraylist.get(i);
		ids += (ids.equals("") ? "" : ",") + integer;
	}
	return ids;
}

//判断频道是否是选题的子频道
public boolean isTopicChannel(int channelid,int channelid_) throws tidemedia.cms.base.MessageException, java.sql.SQLException,org.json.JSONException{
    boolean flag = false ;

	Channel channel = CmsCache.getChannel(channelid_);
	Channel channel1 = CmsCache.getChannel(channelid);

	String code = channel.getChannelCode();
	String code1 = channel1.getChannelCode();
	if(code1.contains(code)){
		flag = true ;
	}

// 	tidemedia.cms.base.TableUtil tu = new tidemedia.cms.base.TableUtil();
//	String sql = "select * from channel where parent="+channelid_+" and id="+channelid;
//	java.sql.ResultSet rs = tu.executeQuery(sql);
//	if(rs.next()){
//		flag = true ;
//	}
//	tu.closeRs(rs);
    return flag ;
}
%>
