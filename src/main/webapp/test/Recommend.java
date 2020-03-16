package tidemedia.cms.system;

import org.apache.velocity.VelocityContext;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.publish.PublishManager;
import tidemedia.cms.publish.VelocityUtil;
import tidemedia.cms.util.RandomUtil;
import tidemedia.cms.util.Util;

import java.sql.SQLException;

public class Recommend {
	
	public Recommend()
	{
		
	}
	
	//荐入时生成的js代码 itemid 被推荐的文档编号，channelid 被推荐的文档所在的频道
	public String RecommendIn(int FieldID,int ItemID,int ChannelID,int SChannelID) throws SQLException, MessageException
	{
		if(ItemID==0||ChannelID==0) return "";
		
		Document item = new Document(ItemID,ChannelID);
		Channel ch = CmsCache.getChannel(ChannelID);
		Channel channel = null;

		String s = "";

		if(FieldID>0)
		{
			Field field = new Field(FieldID);
			s = field.getRecommendValue();
		}
		else if(SChannelID>0)
		{
			channel = CmsCache.getChannel(SChannelID);
			s = channel.getAttribute2(ChannelID);
		}
		
		return getRecommendJS(s,item,ch);
	}
	
	//荐出时生成的js代码 itemid 被推荐的文档编号，channelid 被推荐的文档所在的频道
	public String RecommendOut(int ItemID,int ChannelID,int targetChannelID) throws SQLException, MessageException
	{
		Document item = new Document(ItemID,ChannelID);
		if(item.getCategoryID()>0)
			ChannelID = item.getCategoryID();
		
		Channel channel = CmsCache.getChannel(ChannelID);
		String s = channel.getRecommendOutRelation(targetChannelID);
		
		return getRecommendJS(s,item, CmsCache.getChannel(targetChannelID));
	}
	
	//根据推荐关系，生成js代码
	public static String getRecommendJS(String s, Document item, Channel channel) throws MessageException, SQLException
	{
		String js = "";
		//System.out.println(s);
		if(!s.startsWith("#tidecms"))
		{
			String[] options = Util.StringToArray(s, "\n");
			for (int i = 0; i < options.length; i++) 
			{				
				String o = options[i].replace("\r", "");
				
				//为注释代码
				if(o.startsWith("//"))
					continue;
				
				int index = o.indexOf("=");
				if(index!=-1)
				{
					String a = o.substring(0,index);
					String b = o.substring(index+1);
				//System.out.println("a:"+a+",b:"+b);		
				if(b.startsWith("getHref()"))
				{
					int index2 = b.lastIndexOf(":");
					if(index2!=-1)
					{
						String c = b.substring(index2+1);
						item.setTemplateLabel(c);
					}
	
					js += "setValue('"+a+"','"+ Util.JSQuote(item.getFullHref())+"');";
				}
				else if(b.startsWith("getHttpHref()"))
				{
					if(item.getValue("Href").equals(""))
						js += "setValue('"+a+"','"+ Util.JSQuote(item.getHttpHref())+"');";
					else
						js += "setValue('"+a+"','"+ Util.JSQuote(item.getValue("Href"))+"');";
				}		
				else if(b.startsWith("getChannelID()"))
				{
					int cid = item.getChannelID();
					if(item.getCategoryID()>0)
						cid = item.getCategoryID();
					js += "setValue('"+a+"','"+(cid)+"');";
				}//getFullPath
				else if(b.startsWith("getChannelName()"))
				{
					js += "setValue('"+a+"','"+(item.getChannel().getName())+"');";
				}
				else if(b.startsWith("getFullPath()"))
				{
					js += "setValue('"+a+"','"+(item.getChannel().getFullPath())+"');";
				}					
				else if(b.startsWith("getHttpUrl()+"))
				{
					String bb = b.replace("getHttpUrl()+","");
					String bvalue = item.getValue(bb);
					if(bvalue.length()>0 && !bvalue.startsWith("http://"))
						bvalue = Util.ClearPath(item.getChannel().getSite().getExternalUrl()+"/"+bvalue);
					js += "setValue('"+a+"','"+(bvalue)+"');";
				}
				else if(b.startsWith("getHttpUrl()"))
				{
					js += "setValue('"+a+"','"+(item.getChannel().getSite().getExternalUrl())+"');";
				}
				else if(b.startsWith("String:"))
				{
					String value = b.substring(7);
					value = value.replace("$itemid",item.getId()+"");
					js += "setValue('"+a+"','"+ Util.JSQuote(value)+"');";
				}
				else if(b.startsWith("template:"))
				{
					String value = b.substring(9);
					VelocityContext context = new VelocityContext();
					context.put("util", new Util());
					context.put("item", item);
					context.put("channel",channel);
					VelocityUtil vu = new VelocityUtil();
					value = vu.TemplateMerge(value, context);
					js += "setValue('"+a+"','"+ Util.JSQuote(value)+"');";
				}
				else
				{
					//System.out.println(b+","+item.getValue(b));
					if(b.equals("Content"))
					{
						js += "var RecommendContent='"+ Util.JSQuote(item.getContent())+"';initRecommendContent();";
					}
					else
					{
						js += "setValue('"+a+"','"+ Util.JSQuote(getRecommendValue(b,item))+"');";
					}
				}
	
				if(a.equals("Title"))
					js += "checkTitle();";
						//System.out.println(a + "    " + b);
				}
			}
			
			js += "setValue('RecommendGlobalID','" + item.getGlobalID() + "');";
			js += "setValue('RecommendType','1');";
		}
		else
		{//System.out.println("template");
			s = s.substring(8);
			//System.out.println(s);
			VelocityContext context = new VelocityContext();
			context.put("util", new Util());
			context.put("item", item);
			VelocityUtil vu = new VelocityUtil();
			js = vu.TemplateMerge(s, context);
		}
		return js;		
	}
	
	//引用多条记录 channelid 发起引用请求的频道 recommendChannelID 被引用的频道
	public static void recommendInItems(int channelid,String recommendItemID,int recommendChannelID,int user) throws SQLException, MessageException
	{
		if(channelid==0 || recommendChannelID==0) return;
		
		Channel channel = CmsCache.getChannel(channelid);
		String channelcode = channel.getChannelCode();
		//Channel rchannel = CmsCache.getChannel(recommendChannelID);
				
		int[] ids = Util.StringToIntArray(recommendItemID, ",");
		TableUtil tu = new TableUtil();
		String s = channel.getAttribute2(recommendChannelID);
		String[] options = Util.StringToArray(s, "\n");
		
		int categoryid = 0;
		if(channel.getType()== Channel.Category_Type)
			categoryid = channel.getId();
		
		for(int i = ids.length-1;i>=0;i--)
		{
			int itemid = ids[i];
			Document item = new Document(itemid,recommendChannelID);
			String FieldList = "";
			String ValueList = "";
			
			for (int j = 0; j < options.length; j++) {
				String o = options[j].replace("\r", "");
				
				//为注释代码
				if(o.startsWith("//"))
					continue;
				
				int index = o.indexOf("=");
				if(index!=-1)
				{
					String a = o.substring(0,index);//字段名
					String b = o.substring(index+1);
					
					//验证字段名是否存在
					Field field = channel.getFieldByFieldName(a);
					if(field==null) continue;
					
					if(b.startsWith("getHref()"))
					{
						int index2 = b.lastIndexOf(":");
						if(index2!=-1)
						{
							String c = b.substring(index2+1);
							item.setTemplateLabel(c);
						}

						FieldList += (FieldList.equals("") ? "" : ",") + a;
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + item.getFullHref() + "'";
					}				
					else if(b.startsWith("getHttpHref()"))
					{
						if(item.getValue("Href").equals(""))
						{
							FieldList += (FieldList.equals("") ? "" : ",") + a;
							ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + item.getHttpHref() + "'";
						}
						else
						{
							FieldList += (FieldList.equals("") ? "" : ",") + a;
							ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + item.getValue("Href") + "'";							
						}
					}
					else if(b.startsWith("getChannelID()"))
					{
						int cid = item.getChannelID();
						if(item.getCategoryID()>0)
							cid = item.getCategoryID();
						FieldList += (FieldList.equals("") ? "" : ",") + a;
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + cid + "'";
						//js += "setValue('"+a+"','"+(item.getChannelID())+"');";
					}				
					else if(b.startsWith("getHttpUrl()+"))
					{
						String bb = b.replace("getHttpUrl()+","");
						String bvalue = item.getValue(bb);
						if(bvalue.length()>0 && !bvalue.startsWith("http://"))
							bvalue = Util.ClearPath(item.getChannel().getSite().getExternalUrl()+"/"+bvalue);
						FieldList += (FieldList.equals("") ? "" : ",") + a;
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + bvalue + "'";					
					}
					else if(b.startsWith("getHttpUrl()"))
					{
						FieldList += (FieldList.equals("") ? "" : ",") + a;
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + (item.getChannel().getSite().getExternalUrl()) + "'";
					}
					else if(b.startsWith("String:"))
					{
						FieldList += (FieldList.equals("") ? "" : ",") + a;						
						String value = b.substring(7);
						value = value.replace("$itemid",item.getId()+"");
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + (value) + "'";
					}
					else if(b.startsWith("template:"))
					{
						FieldList += (FieldList.equals("") ? "" : ",") + a;
						String value = b.substring(9);
						VelocityContext context = new VelocityContext();
						context.put("util", new Util());
						context.put("item", item);
						context.put("channel",item.getChannel());
						VelocityUtil vu = new VelocityUtil();
						value = vu.TemplateMerge(value, context);
						//js += "setValue('"+a+"','"+Util.JSQuote(value)+"');";
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + (value) + "'";
					}
					else
					{
						FieldList += (FieldList.equals("") ? "" : ",") + a;
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + getRecommendValue(b,item) + "'";
						//js += "setValue('"+a+"','"+Util.JSQuote(item.getValue(b))+"');";
					}
					//System.out.println(a + "    " + b);
				}
			}
		
			if(FieldList.indexOf("SubTitle")==-1)
			{
				FieldList += (FieldList.equals("") ? "" : ",") + "SubTitle";
				ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + "" + "'";
			}
			
			if(FieldList.indexOf("Keyword")==-1)
			{
				FieldList += (FieldList.equals("") ? "" : ",") + "Keyword";
				ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + "" + "'";
			}
			
			if(FieldList.indexOf("Tag")==-1)
			{
				FieldList += (FieldList.equals("") ? "" : ",") + "Tag";
				ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + "" + "'";
			}
			
			if(FieldList.indexOf("IsPhotoNews")==-1)
			{
				FieldList += (FieldList.equals("") ? "" : ",") + "IsPhotoNews";
				ValueList += (ValueList.equals("") ? "" : ",")	+ "0";
			}
			
			if(FieldList.indexOf("PublishDate")==-1)
			{
				FieldList += (FieldList.equals("") ? "" : ",") + "PublishDate";
				ValueList += (ValueList.equals("") ? "" : ",")	+ "UNIX_TIMESTAMP()";
			}
			
			int random = new java.util.Random().nextInt(999)+1;
			
			FieldList += (FieldList.equals("") ? "" : ",") + "TotalPage,Category,ChannelCode,User,CreateDate,ModifiedDate,Active,Weight,Status,Random,OrderNumber";
			ValueList += (ValueList.equals("") ? "" : ",") + 1 + "," + categoryid + ",'" +channelcode + "',"+ user + ",UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),1," + 0 + "," + 0 + "," + random + "," + 0;
	
	
			String sql = "insert into " + channel.getTableName() + " (" + FieldList + ") values(" + ValueList + ")";
			
			System.out.println(sql);			
			int insertid = tu.executeUpdate_InsertID(sql);
			//System.out.println("update " + channel.getTableName() + " set OrderNumber=id*100 where id="+insertid);
			tu.executeUpdate("update " + channel.getTableName() + " set OrderNumber=id*100 where id="+insertid);
			
			//审核通过
			//new Document().Approve(insertid+"", channel.getId());
			
			Document document = new Document(insertid,channel.getId());
			new ItemSnap().Add(document);//加入全局库
			
			ItemUtil2.InsertRecommendRelation(item.getGlobalID(),document.getGlobalID(),1,item.getChannelID(),item.getId(),user);
			//System.out.println("recommend in:"+item.getGlobalID()+","+item.getId()+","+document.getGlobalID()+","+document.getId());
			Log l = new Log();
			l.setTitle(document.getTitle());l.setUser(user);
			l.setItem(insertid);
			l.setLogAction(LogAction.document_recommend_in);
			//l.setLogType("添加文档_引用");
			l.setFromType("channel");l.setFromKey(channel.getId()+"");
			l.Add();			
		}
	}	
	
	//根据s，返回对应的值，用于推荐和引用
	public static String getRecommendValue(String s, Document item) throws MessageException, SQLException
	{
		String result = "";
		if(s.equals("getId()"))
			result = item.getId() + "";
		else if(s.equals("getGlobalID()"))
			result = item.getGlobalID() + "";
		else if(s.equals("getPublishDate()"))
			result = item.getPublishDate();
		else if(s.equals("PublishDate"))
			result = item.getPublishDate();
		else if(s.equals("getChannelName()"))
			result = item.getChannel().getName();
		else
			result = item.getValue(s);
		
		return result;
	}
	
	//根据s，返回对应的值，用于推荐和引用
	public static int getIntRecommendValue(String s, Document item) throws MessageException, SQLException
	{
		String result = "";
		if(s.equals("getId()"))
			result = item.getId() + "";
		else if(s.equals("getGlobalID()"))
			result = item.getGlobalID() + "";
		else if(s.equals("getPublishDate()"))
			result = item.getPublishDate();
		else if(s.equals("getChannelName()"))
			result = item.getChannel().getName();
		else
			return item.getIntValue(s);
		
		return Util.parseInt(result);
	}
	
	
	//推荐多条记录 channelid 推荐到的频道 recommendChannelID 被推荐的频道 status 是否发布
	public static void recommendOutItems(int channelid,String recommendItemID,int recommendChannelID,int status,int user) throws SQLException, MessageException
	{
		if(channelid==0 || recommendChannelID==0) return;
		
		Channel channel = CmsCache.getChannel(channelid);
		Channel recommendchannel = CmsCache.getChannel(recommendChannelID);
		String channelcode = channel.getChannelCode();
		//Channel rchannel = CmsCache.getChannel(recommendChannelID);
		
		//审核方案
		int approvescheme = channel.getApproveScheme();
		if(approvescheme!=0){//不为0，说明此频道配置了工作流，推荐出去的文章为草稿状态
			status = 0 ;
		}
		
		int[] ids = Util.StringToIntArray(recommendItemID, ",");
		TableUtil tu = new TableUtil();
		String s = recommendchannel.getRecommendOutRelation(channelid);//channelid-推荐频道id recommendItemID(等价于当前频道)
		String[] options = Util.StringToArray(s, "\n");
		
		int categoryid = 0;
		if(channel.getType()== Channel.Category_Type)
			categoryid = channel.getId();
		
		boolean publish_channel = false;
		
		for(int i = ids.length-1;i>=0;i--)
		{
			int itemid = ids[i];
			Document item = new Document(itemid,recommendChannelID);
			String FieldList = "";
			String ValueList = "";
			
			for (int j = 0; j < options.length; j++) {
				String o = options[j].replace("\r", "");
				
				//为注释代码
				if(o.startsWith("//"))
					continue;
				
				int index = o.indexOf("=");
				if(index!=-1)
				{
					String a = o.substring(0,index);//字段名
					String b = o.substring(index+1);
					
					//验证字段名是否存在
					Field field = channel.getFieldByFieldName(a);
					if(field==null) continue;
					
					if(b.startsWith("getHref()"))
					{
						int index2 = b.lastIndexOf(":");
						if(index2!=-1)
						{
							String c = b.substring(index2+1);
							item.setTemplateLabel(c);
						}

						FieldList += (FieldList.equals("") ? "" : ",") + a;
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + item.getFullHref() + "'";
					}				
					else if(b.startsWith("getHttpHref()"))
					{
						if(item.getValue("Href").equals(""))
						{
							FieldList += (FieldList.equals("") ? "" : ",") + a;
							ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + item.getHttpHref() + "'";
						}
						else
						{
							FieldList += (FieldList.equals("") ? "" : ",") + a;
							ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + item.getValue("Href") + "'";							
						}
					}
					else if(b.startsWith("getChannelID()"))
					{
						int cid = item.getChannelID();
						if(item.getCategoryID()>0)
							cid = item.getCategoryID();
						FieldList += (FieldList.equals("") ? "" : ",") + a;
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + cid + "'";
						//js += "setValue('"+a+"','"+(item.getChannelID())+"');";
					}
					else if(b.startsWith("getChannelName()"))
					{
						FieldList += (FieldList.equals("") ? "" : ",") + a;
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + item.getChannel().getName() + "'";
						//js += "setValue('"+a+"','"+(item.getChannelID())+"');";
					}					
					else if(b.startsWith("getHttpUrl()+"))
					{
						String bb = b.replace("getHttpUrl()+","");
						String bvalue = item.getValue(bb);
						if(bvalue.length()>0 && !bvalue.startsWith("http://"))
							bvalue = Util.ClearPath(item.getChannel().getSite().getExternalUrl()+"/"+bvalue);
						FieldList += (FieldList.equals("") ? "" : ",") + a;
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + bvalue + "'";					
					}
					else if(b.startsWith("getHttpUrl()"))
					{
						FieldList += (FieldList.equals("") ? "" : ",") + a;
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + (item.getChannel().getSite().getExternalUrl()) + "'";
					}
					else if(b.startsWith("String:"))
					{
						FieldList += (FieldList.equals("") ? "" : ",") + a;						
						String value = b.substring(7);
						value = value.replace("$itemid",item.getId()+"");
						ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + (value) + "'";
					}
					else if(b.startsWith("template:"))
					{
						FieldList += (FieldList.equals("") ? "" : ",") + a;
						String value = b.substring(9);
						VelocityContext context = new VelocityContext();
						context.put("util", new Util());
						context.put("item", item);
						context.put("channel",channel);//被推荐到的频道
						VelocityUtil vu = new VelocityUtil();
						value = vu.TemplateMerge(value, context);
						//js += "setValue('"+a+"','"+Util.JSQuote(value)+"');";
						
						if(a.equals("PublishDate"))
						{
							//发布日期
							ValueList += (ValueList.equals("") ? "" : ",")	+ "UNIX_TIMESTAMP('" + value + "')";
						}
						else
							ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + (value) + "'";
					}
					else if(b.startsWith("getFullPath()"))
					{
							FieldList += (FieldList.equals("") ? "" : ",") + a;
							ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + item.getFullPath() + "'";
					}
					else if(b.startsWith("PublishDate"))
					{
						FieldList += (FieldList.equals("") ? "" : ",") + a;
						ValueList += (ValueList.equals("") ? "" : ",")	+ "UNIX_TIMESTAMP('" + item.getPublishDate() + "')";
					}
					else
					{
						FieldList += (FieldList.equals("") ? "" : ",") + a;
						String ftype = field.getFieldType();
						if(ftype.equals("number") || ftype.equals("float"))
						{
							ValueList += (ValueList.equals("") ? "" : ",")	+ "" + getIntRecommendValue(b,item) + "";
						}
						else
						{
							ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + tu.SQLQuote(getRecommendValue(b,item)) + "'";
						}
						//js += "setValue('"+a+"','"+Util.JSQuote(item.getValue(b))+"');";
					}
					//System.out.println(a + "    " + b);
				}
			}
		
			if(FieldList.indexOf("SubTitle")==-1)
			{
				FieldList += (FieldList.equals("") ? "" : ",") + "SubTitle";
				ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + "" + "'";
			}
			
			if(FieldList.indexOf("Keyword")==-1)
			{
				FieldList += (FieldList.equals("") ? "" : ",") + "Keyword";
				ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + "" + "'";
			}
			
			if(FieldList.indexOf("Tag")==-1)
			{
				FieldList += (FieldList.equals("") ? "" : ",") + "Tag";
				ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + "" + "'";
			}
			
			if(FieldList.indexOf("IsPhotoNews")==-1)
			{
				FieldList += (FieldList.equals("") ? "" : ",") + "IsPhotoNews";
				ValueList += (ValueList.equals("") ? "" : ",")	+ "0";
			}
			
			if(FieldList.indexOf("PublishDate")==-1)
			{
				FieldList += (FieldList.equals("") ? "" : ",") + "PublishDate";
				ValueList += (ValueList.equals("") ? "" : ",")	+ "UNIX_TIMESTAMP()";
			}
			
			//int random = new java.util.Random().nextInt(999)+1;
			long time = System.currentTimeMillis()/1000;
			int random = RandomUtil.getRandom(time);
			
			FieldList += (FieldList.equals("") ? "" : ",") + "TotalPage,Category,ChannelCode,User,CreateDate,ModifiedDate,Active,Weight,Status,Random,OrderNumber";
			ValueList += (ValueList.equals("") ? "" : ",") + 1 + "," + categoryid + ",'" +channelcode + "',"+ user + ",UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),1," + 0 + "," + status + ","+random+","+ 0;
	
	
			String sql = "insert into " + channel.getTableName() + " (" + FieldList + ") values(" + ValueList + ")";
			
			//System.out.println(sql);
			int insertid = tu.executeUpdate_InsertID(sql);
			//System.out.println("update " + channel.getTableName() + " set OrderNumber=id*100 where id="+insertid);
			tu.executeUpdate("update " + channel.getTableName() + " set OrderNumber=id*100 where id="+insertid);
			
			//审核通过
			//new Document().Approve(insertid+"", channel.getId());
			
			Document document = new Document(insertid,channel.getId());
			new ItemSnap().Add(document);//加入全局库
			
			ItemUtil2.InsertRecommendRelation(item.getGlobalID(),document.getGlobalID(),0,item.getChannelID(),item.getId(),user);
			
			Log l = new Log();
			l.setTitle(document.getTitle());l.setUser(user);
			l.setItem(insertid);
			//l.setLogType("添加文档_推荐");
			l.setLogAction(LogAction.document_recommend_out);
			l.setFromType("channel");l.setFromKey(channel.getId()+"");
			l.Add();
			
			//发布
			if(status == 1) 
			{
				publish_channel = true;
				//PublishManager.getInstance().OnlyDocumentPublish(channel.getId(), insertid, user);
				//审核 2015-7-8
				Document d = new Document();
				d.setUser(user);
				d.Approve(insertid+"",channel.getId());
			}
		}
		
		//发布频道
		if(publish_channel)
		{
			PublishManager.getInstance().PublishChannelAndUp(channel.getId(),user);
		}
	}		
	
	public void saveWeixinRecommend(int gid,int type,int ChannelID,int SourceID,int user,String weixinItemID) throws SQLException, MessageException {
		if(weixinItemID.length()>0)
		{
			String Sql = "insert into recommend(GlobalID,Type,ChannelID,SourceID,CreateDate,User,weixinItemID,ChannelType) values(";
			Sql += gid + "," + type + ","+ChannelID+","+SourceID+",UNIX_TIMESTAMP()," + user + ",'"+weixinItemID+"',2)";
			new TableUtil().executeUpdate_InsertID(Sql);
		}
	}

	//删除频道时删除recommend表数据
	public static void deleteByChannel(int channelId) throws MessageException, SQLException {
		String sql = "delete from recommend where ChannelID = "+channelId;
		TableUtil tu = new TableUtil();
		tu.executeUpdate(sql);
	}
}
