package tidemedia.cms.system;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.publish.Publish;
import tidemedia.cms.publish.PublishManager;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.service.channel.ChannelListFastSearchService;
import tidemedia.tcenter.service.channel.ChannelListHeaderService;
import tidemedia.tcenter.service.channel.ChannelListMenuService;
import tidemedia.tcenter.service.channel.ChannelListSearchService;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;

/**Channel类的辅助类*/
public class ChannelUtil {

	public ChannelUtil()
	{
		
	}
	
	//创建频道表
	public static void createChannelTable(String SerialNo, int id, TableUtil tu2) throws SQLException, MessageException {
		TableUtil tu = new TableUtil();
		String Sql = "";
		Sql += "CREATE TABLE channel_" + SerialNo + " (";
		Sql += "  id int(11) NOT NULL auto_increment,";
		Sql += "  GlobalID int(11),";
		Sql += "  Title	varchar(255) not null,";
		Sql += "  SubTitle	varchar(255),";
		Sql += "  PublishDate INTEGER(11) UNSIGNED default 0,";
		Sql += "  DocFrom varchar(255),";
		Sql += "  Content	mediumtext character set utf8mb4 collate utf8mb4_unicode_ci,";
		Sql += "  Summary	text,";
		Sql += "  Keyword	varchar(255),";
		Sql += "  Tag	varchar(255),";
		Sql += "  SetPublishDate varchar(255),";//定时发布字段
		Sql += "  Category int,";
		Sql += "  ChannelCode varchar(255),";
		Sql += "  User int,";
		Sql += "  TotalPage int default 1,";
		Sql += "  OrderNumber bigint unsigned default 0,";//无符号的范围是0到18446744073709551615
		Sql += "  Status int,";
		Sql += "  Active tinyint,";
		Sql += "  IsPhotoNews tinyint,";
		Sql += "  DocTop int default 0,";
		Sql += "  DocTopTime int default 0,";//whl 置顶时间
		Sql += "  Random int,";
		Sql += "  Weight int,";
		Sql += "  CreateDate INTEGER(11) UNSIGNED default 0,";
		Sql += "  ModifiedDate INTEGER(11) UNSIGNED default 0,";
		Sql += "  GenerateFileDate INTEGER(11) UNSIGNED default 0,";
		Sql += "  Photo varchar(250),";
		Sql += "  ModifiedUser int,";//whl 最后修改人
		Sql += "  ApproveStatus int default 0,";//审核环节 ，0 为待审核 1，2，3等为当前审核步骤 100为审核完成

		Sql += "  UNIQUE KEY id (id),KEY Category (Category)";
		Sql += ",KEY Index_5 USING BTREE (Category,Active,OrderNumber)";
		Sql += ",KEY Index_6 USING BTREE (Active,OrderNumber)";
		Sql += ") ENGINE=InnoDB DEFAULT CHARSET=utf8;";

		tu2.executeUpdate(Sql);

		FieldGroup fg = new FieldGroup();
		fg.setChannel(id);
		fg.setName("内容编辑");
		fg.Add();
		int editGroupID = fg.getId();
		fg.setName("基本属性");
		fg.Add();
		int baseGroupID = fg.getId();
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'Title','" + tu.SQLQuote("标题") + "','text',1,0)";
		int fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + editGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'SubTitle','" + tu.SQLQuote("副标题") + "','text',1,1)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + editGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'PublishDate','" + tu.SQLQuote("发布日期") + "','datetime',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'Weight','" + tu.SQLQuote("权重") + "','text',1,1)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'DocFrom','" + tu.SQLQuote("文章来源") + "','text',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'IsPhotoNews','" + tu.SQLQuote("图片新闻") + "','checkbox',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'Summary','" + tu.SQLQuote("摘要") + "','textarea',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'Content','" + tu.SQLQuote("内容") + "','textarea',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + editGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";	
		Sql += id + ",'Photo','" + tu.SQLQuote("图片") + "','image',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);

		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'Keyword','" + tu.SQLQuote("关键词") + "','text',1,1)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'Tag','" + tu.SQLQuote("标签") + "','text',1,1)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);

		String SetPublishDateCaption = "编辑好发布时间,当时间到达后所编辑的稿件就会自动发布.";
		Sql = "insert into field_desc(ChannelID,FieldName,Description,Caption,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'SetPublishDate','" + tu.SQLQuote("定时发布")+"','"+ SetPublishDateCaption+ "','text',1,1)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);

		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'ApproveStatus','" + tu.SQLQuote("审核状态") + "','number',1,1)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + editGroupID + " where id=" + fieldid);
		
		Sql = "update field_desc set OrderNumber=id*100 where OrderNumber=0";
		tu.executeUpdate(Sql);
	}
	
	//创建视频库表
	public static void createVideoTable(String SerialNo, int channelid, TableUtil tu2) throws SQLException, MessageException
	{
		TableUtil tu = new TableUtil();
		String Sql = "";

		Sql += "CREATE TABLE channel_" + SerialNo + " (";
		Sql += "  id int(11) NOT NULL auto_increment,";
		Sql += "  GlobalID int(10),";
		Sql += "  Title	varchar(255) not null,";
		Sql += "  SubTitle	varchar(255) not null,";
		Sql += "  PublishDate datetime,";
		Sql += "  DocFrom varchar(255),";
		Sql += "  Content	mediumtext character set utf8mb4 collate utf8mb4_unicode_ci,";
		Sql += "  Summary	text,";
		Sql += "  Category int,";
		Sql += "  User int,";
		Sql += "  TotalPage int default 1,";
		Sql += "  OrderNumber int default 0,";
		Sql += "  Status int,";
		Sql += "  Active tinyint,";
		Sql += "  IsPhotoNews tinyint,";
		Sql += "  Random int,";
		Sql += "  CreateDate datetime,";
		Sql += "  ModifiedDate datetime,";
		Sql += "  GenerateFileDate datetime,";
		Sql += " Keyword varchar(250),";//文章关键词
		Sql += " Keyword2 varchar(250),";//视频关键词
		Sql += " Photo varchar(250),";
		Sql += "  mediatype int,";
		Sql += " author varchar(250),";
		Sql += " coverhref varchar(250),";
		Sql += " coverhref_small varchar(250),";
		Sql += " authmode int,";
		Sql += " language varchar(250),";
		Sql += " archivedate datetime,";
		Sql += " issuer varchar(250),";
		Sql += " Tag varchar(255),";
		Sql += "  Video1	text,";
		Sql += "  Video2	text,";
		Sql += "  Video3	text,";
		Sql += "  Video4	text,";
		Sql += "  Video5	text,";
		Sql += "  Video6	text,";
		Sql += " copyright varchar(250),";
		Sql += " version varchar(250),";
		Sql += " style int,";
		Sql += " ModifiedUser int,";//2016.5.6 whl最后修改人

		/*
		 * if(ChannelType_ForAdd==1) Sql += " Href varchar(250),"; else
		 * if(ChannelType_ForAdd==2) { Sql += " Href varchar(250),"; }
		 */

		Sql += "  UNIQUE KEY id (id)";
		Sql += ")";

		tu2.executeUpdate(Sql);

		FieldGroup fg = new FieldGroup();
		fg.setChannel(channelid);
		fg.setName("内容编辑");
		fg.Add();
		int editGroupID = fg.getId();
		fg.setName("基本属性");
		fg.Add();
		int baseGroupID = fg.getId();
		fg.setName("相关视频");
		fg.Add();
		int videoGroupID = fg.getId();
		fg.setName("相关文章");
		fg.Add();
		int docGroupID = fg.getId();
		
		int id = channelid;
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'Title','" + tu.SQLQuote("标题") + "','text',1,0)";
		int fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + editGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'SubTitle','" + tu.SQLQuote("副标题") + "','text',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + editGroupID + " where id=" + fieldid);
	
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'PublishDate','" + tu.SQLQuote("发布日期") + "','datetime',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'DocFrom','" + tu.SQLQuote("文章来源") + "','text',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'Summary','" + tu.SQLQuote("摘要") + "','textarea',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'Content','" + tu.SQLQuote("内容") + "','textarea',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + editGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'Photo','" + tu.SQLQuote("图片") + "','image',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'mediatype','" + tu.SQLQuote("类型") + "','select',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'author','" + tu.SQLQuote("作者") + "','text',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'coverhref','" + tu.SQLQuote("封面图片") + "','image',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'coverhref_small','" + tu.SQLQuote("封面图片2") + "','image',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'language','" + tu.SQLQuote("语言") + "','select',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'archivedate','" + tu.SQLQuote("归档日期") + "','datetime',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'Keyword','" + tu.SQLQuote("关键字") + "','text',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + docGroupID + " where id=" + fieldid);

		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'Keyword2','" + tu.SQLQuote("关键字") + "','text',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + videoGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'copyright','" + tu.SQLQuote("版权") + "','text',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);
		
		Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		Sql += id + ",'version','" + tu.SQLQuote("版本") + "','text',1,0)";
		fieldid = tu.executeUpdate_InsertID(Sql);
		tu.executeUpdate("update field_desc set GroupID=" + baseGroupID + " where id=" + fieldid);	
		
		Sql = "update field_desc set OrderNumber=id where OrderNumber=0";
		tu.executeUpdate(Sql);
	}
	
	//分页列出某一频道下通过审核的文档
	public static ArrayList<Document> listItems(String fields, String ListSql, Channel channel) throws MessageException, SQLException
	{
		//print(ListSql);
		String[] fields_list = Util.StringToArray(fields, ",");
		ArrayList<Document> arraylist = new ArrayList<Document>();
		TableUtil tu = channel.getTableUtil();
		String fullPath = "";
		Calendar publishdate = new java.util.GregorianCalendar();
		ResultSet Rs = null;
		try {
			Rs = tu.executeQuery(ListSql);
		} catch (SQLException e) {
			throw new MessageException("SQL语句错误："+ListSql);
		}
		
		while (Rs.next()) {
			int i = Rs.getInt("id");
			int categoryid = Rs.getInt("Category");
			
			Document item = new Document();
			
			if(fields.equals("*"))
			{				
				item = CmsCache.getDocument(i, categoryid>0?categoryid:channel.getId());//new Document(i,categoryid>0?categoryid:channel.getId());
			}
			else
			{
				if(categoryid==0)
					fullPath = channel.getFullPath();
				else
					fullPath = CmsCache.getChannel(categoryid).getFullPath();
				
				if(categoryid==0)
					item.setChannelID(channel.getId());
				else
					item.setChannelID(categoryid);
				
				item.setId(i);
				item.setGlobalID(Rs.getInt("GlobalID"));
				item.setTitle(tu.convertNull(Rs.getString("Title")));
				item.setCreateDate(Util.FormatTimeStamp("",Rs.getLong("CreateDate")));
				item.setCreateDateL(Rs.getLong("CreateDate"));
				item.setPublishDate(Util.FormatTimeStamp("",Rs.getLong("PublishDate")));
				item.setSummary(tu.convertNull(Rs.getString("Summary")));
				item.setRandom(Rs.getInt("Random"));
				item.setIsPhotoNews(Rs.getInt("IsPhotoNews"));
				item.setFullPath(fullPath);
				
				//publishdate.setTime(Rs.getDate("PublishDate"));
				publishdate.setTimeInMillis(Rs.getLong("PublishDate")*1000);
				
				item.setPublishDate_Year(publishdate.get(Calendar.YEAR));
				item.setPublishDate_Month(publishdate.get(Calendar.MONTH) + 1);
				item.setPublishDate_Day(publishdate.get(Calendar.DATE));
	
				if (fields_list != null && fields_list.length > 0) {
					for (int j = 0; j < fields_list.length; j++) {
						Field fd = new Field();
						fd.setName(fields_list[j]);
						fd.setValue(tu.convertNull(Rs.getString(fields_list[j])));
						item.getFieldDescArray().put(fd.getName(),fd);
					}
				}
			}

			arraylist.add(item);
		}
		
		tu.closeRs(Rs);

		return arraylist;
	}
	
	
	public static void CopyFormToSubChannel(String SerialNo,int id) throws SQLException, MessageException {
		TableUtil tu = new TableUtil();
		TableUtil tu2 = new TableUtil();
		ArrayList<Field> arraylist = new ArrayList<Field>();
		String Sql = "";

		Sql = "select * from field_desc where Channel='" + SerialNo + "'";

		ResultSet Rs = tu.executeQuery(Sql);

		while (Rs.next()) {
			String fieldname = tu.convertNull(Rs.getString("FieldName"));
			String desc = tu.convertNull(Rs.getString("Description"));
			String fieldtype = tu.convertNull(Rs.getString("FieldType"));
			int fieldlevel = Rs.getInt("FieldLevel");
			int IsHide = Rs.getInt("IsHide");
			int DisableBlank = Rs.getInt("DisableBlank");

			Field fv = new Field();

			fv.setName(fieldname);
			fv.setDescription(desc);
			fv.setFieldType(fieldtype);
			fv.setFieldLevel(fieldlevel);
			fv.setIsHide(IsHide);
			fv.setDisableBlank(DisableBlank);

			if (fieldtype.equalsIgnoreCase("select")) {
				ArrayList<String> fieldoptions = new ArrayList<String>();
				Sql = "select * from field_options where Channel='" + SerialNo
						+ "' and FieldName='" + fieldname + "'";

				ResultSet rs = tu2.executeQuery(Sql);
				while (rs.next()) {
					String s = tu2.convertNull(rs.getString("OptionValue"));
					fieldoptions.add(s);
				}
				tu2.closeRs(rs);
				fv.setFieldOptions(fieldoptions);
			}

			arraylist.add(fv);
		}
		tu.closeRs(Rs);

		Sql = "select * from channel where Parent=" + id;

		Rs = tu.executeQuery(Sql);

		while (Rs.next()) {
			int channelid = Rs.getInt("id");
			String serialno = tu.convertNull(Rs.getString("SerialNo"));

			Sql = "select * from channel_" + serialno + "";

			ResultSet rs = tu2.executeQuery(Sql);

			ResultSetMetaData rsmd = rs.getMetaData();

			for (int i = 0; i < arraylist.size(); i++) {
				boolean isexist = false;

				Field fv = (Field) arraylist.get(i);

				String options = "";
				ArrayList<String[]> optionslist = fv.getFieldOptions();

				if (optionslist != null) {
					for (int j = 0; j < optionslist.size(); j++) {
						String[] ss = (String[]) optionslist.get(j);
						String sss = "";
						if(fv.getDataType()==0) sss = ss[0];
						else if(fv.getDataType()==1) sss = ss[0] + "(" + ss[1] + ")";
						if (j == 0)
							options += ss;
						else
							options += "\n" + ss;
					}
				}
				// System.out.print("count:"+rsmd.getColumnCount());
				for (int j = 1; j <= rsmd.getColumnCount(); j++) {
					// System.out.println("fieldname:"+fv.getFieldName()+",columnname:"+rsmd.getColumnName(j));
					if (fv.getName().equals(rsmd.getColumnName(j)))
						isexist = true;
				}

				if (isexist) {
					// 字段存在
					Sql = "update field_desc set IsHide=" + fv.getIsHide()
							+ ",Description='" + tu.SQLQuote(fv.getDescription())
							+ "' where Channel='" + serialno
							+ "' and FieldName='" + fv.getName() + "'";

					// System.out.println("update:"+Sql);
					tu.executeUpdate(Sql);
				} else {
					// 字段不存在
					Field field = new Field();

					field.setChannelID(channelid);
					field.setIsHide(fv.getIsHide());
					field.setDisableBlank(fv.getDisableBlank());
					field.setName(fv.getName());
					field.setDescription(fv.getDescription());
					field.setFieldType(fv.getFieldType());
					field.setOptions(options);

					field.Add();
				}
			}

			CmsCache.delChannel(channelid);
		}

		tu.closeRs(Rs);
	}
	
	public static ArrayList<Document> listTopItems(Channel ch, int number, boolean notincludephoto, int includesubchannel, String sql) throws SQLException, MessageException {
		// 最上面几条记录 notincludephoto==true 不包括图片新闻
		//includesubchannel=1 包括子频道
		String Sql = "select id,Category";
		
		if(ch.getIsWeight()==1)
		{
			//权重排序
			Calendar nowDate = new java.util.GregorianCalendar();
			nowDate.set(Calendar.HOUR_OF_DAY,0);
			nowDate.set(Calendar.MINUTE,0);
			nowDate.set(Calendar.SECOND,0);
			nowDate.set(Calendar.MILLISECOND,0);
			long weightTime = nowDate.getTimeInMillis()/1000;	
			Sql += ",case when CreateDate>"+weightTime+" then (Weight+"+weightTime+") else CreateDate end  as newtime";
		}
		
		Sql += " from " + ch.getTableName() + " where Status=1 and Active=1";

		if(notincludephoto)
			Sql += " and IsPhotoNews!=1 ";
		
		if (ch.getType() == Channel.Category_Type) {
			ArrayList<Channel> categorylist = ch.listAllSubChannels(1);
			if (includesubchannel != 1)
				Sql += " and Category=" + ch.getId() + "";
			else {
				String ids = ch.getId() + "";
				for (int i = 0; i < categorylist.size(); i++) {
					ids += (ids.equals("") ? "" : ",") + ((Channel) categorylist.get(i)).getId();
				}

				Sql += " and Category in (" + ids + ")";
			}
		}
		else if(ch.getType() == Channel.Channel_Type)
		{
			if (includesubchannel != 1) {Sql += " and Category=0";}
		}
		else if(ch.getType() == Channel.MirrorChannel_Type)
		{
			Channel linkChannel = ch.getLinkChannel();
			if(linkChannel.getType()== Channel.Channel_Type)
			{
				if (includesubchannel != 1) {Sql += " and Category=0";}					
			}
			else if(linkChannel.getType()== Channel.Category_Type)
			{
				ArrayList<Channel> categorylist = linkChannel.listAllSubChannels(1);
				if (includesubchannel != 1)
					Sql += " and Category=" + linkChannel.getId() + "";
				else {
					String ids = linkChannel.getId() + "";
					for (int i = 0; i < categorylist.size(); i++) {
						ids += (ids.equals("") ? "" : ",")
								+ ((Channel) categorylist.get(i)).getId();
					}

					Sql += " and Category in (" + ids + ")";
				}
			}
		}

		if(!sql.equals(""))
			Sql += " and " + sql;
		
		if(ch.getIsWeight()==1)
			Sql += " order by newtime Desc,id desc limit " + number;
		else
			Sql += " order by OrderNumber Desc,id desc limit " + number;
		//System.out.println(Sql);
		
		
		return ch.generatorArrayList(Sql);
	}
	
	//从lucene库中搜索
	/*
	public static ArrayList<Document> listTopItems(int number,String channelids,String order) throws SQLException,MessageException {
		System.out.println("lucene:"+number+","+channelids);
		ArrayList<Document> arraylist = new ArrayList<Document>();
		LuceneUtil lu = new LuceneUtil();
		ArrayList<Integer> gids = lu.search(number,channelids,order);
		for(int i = 0;i<gids.size();i++)
		{
			int gid = (Integer)gids.get(i);
			System.out.println("gid:"+gid);
			if(gid>0)
			{
				Document item = CmsCache.getDocument(gid);//new Document(gid);
				arraylist.add(item);
			}
		}
		return arraylist;
	}*/
	
	public static ArrayList<Document> listTopPhotoItems(Channel ch, int number) throws SQLException, MessageException {
		// 本频道最上面几条图片新闻
		
		String Sql = "select id,Category";
		if(ch.getIsWeight()==1)
		{
			//权重排序
			Calendar nowDate = new java.util.GregorianCalendar();
			nowDate.set(Calendar.HOUR_OF_DAY,0);
			nowDate.set(Calendar.MINUTE,0);
			nowDate.set(Calendar.SECOND,0);
			nowDate.set(Calendar.MILLISECOND,0);
			long weightTime = nowDate.getTimeInMillis()/1000;	
			Sql += ",case when CreateDate>"+weightTime+" then (Weight+"+weightTime+") else CreateDate end  as newtime";
		}		
		Sql += " from " + ch.getTableName() + " where Status=1 and Active=1 and IsPhotoNews=1 ";

		if (ch.getType() == Channel.Category_Type) {
			ArrayList<Channel> categorylist = ch.listAllSubChannels(1);
			if (categorylist.size() == 0)
				Sql += " and Category=" + ch.getId();
			else {
				String ids = ch.getId() + "";
				for (int i = 0; i < categorylist.size(); i++) {
					ids += (ids.equals("") ? "" : ",") + ((Channel) categorylist.get(i)).getId();
				}

				Sql += " and Category in (" + ids + ")";
			}
		}else if(ch.getType() == Channel.MirrorChannel_Type)
		{
			Channel linkChannel = ch.getLinkChannel();
			if(linkChannel.getType()== Channel.Category_Type)
			{
				ArrayList<Channel> categorylist = linkChannel.listAllSubChannels(1);
					{
					String ids = linkChannel.getId() + "";
					for (int i = 0; i < categorylist.size(); i++) {
						ids += (ids.equals("") ? "" : ",")
								+ ((Channel) categorylist.get(i)).getId();
					}

					Sql += " and Category in (" + ids + ")";
				}
			}
		}

		if(ch.getIsWeight()==1)
			Sql += " order by newtime Desc,id desc limit " + number + " ";
		else
			Sql += " order by OrderNumber Desc,id desc limit " + number + " ";
		//System.out.println(Sql);

		return ch.generatorArrayList(Sql);
	}
	
	public static ArrayList<Document> listTopGlobalItems(int number, boolean includesubchannel, String channelcode) throws MessageException, SQLException
	{
		ArrayList<Document> arraylist = new ArrayList<Document>();
		String Sql = "select * from item_snap use index(index_3) where Status=1 and Active=1 ";
		if(includesubchannel)
			Sql += " and ChannelCode like '" + channelcode +"%' ";
		else
			Sql += " and ChannelCode='" + channelcode + "'";
		
		Sql += " order by CreateDate Desc limit " + number;
		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(Sql);
		//System.out.println(Sql);
		while (Rs.next()) {
			int gid = Rs.getInt("GlobalID");

			Document item = CmsCache.getDocument(gid);//new Document(gid);
			arraylist.add(item);
		}
		
		tu.closeRs(Rs);		
		return arraylist;
	}
	
	public static void Order(int action,int OrderNumber,int Parent,int id) throws SQLException, MessageException
	{
		TableUtil tu = new TableUtil();
		TableUtil tu2 = new TableUtil();
		String Sql = "";

		String Symbol1 = "";
		String Symbol2 = "";
		if (action == 1)// Up,decrease order number
		{
			Symbol1 = "<";
			Symbol2 = "desc";
		} else if (action == 0)// down,increase order number
		{
			Symbol1 = ">";
			Symbol2 = "asc";
		} else
			return;

		Sql = "select * from channel where OrderNumber" + Symbol1 + OrderNumber
				+ " and Parent=" + Parent + " order by OrderNumber " + Symbol2;

		ResultSet Rs = tu.executeQuery(Sql);
		// System.out.println(Sql);
		if (Rs.next()) {
			int i = Rs.getInt("id");
			int ordernumber = Rs.getInt("OrderNumber");

			Sql = "update channel set OrderNumber=" + OrderNumber + " where id=" + i;
			tu2.executeUpdate(Sql);
			Sql = "update channel set OrderNumber=" + ordernumber + " where id=" + id;
			tu2.executeUpdate(Sql);
		}

		tu.closeRs(Rs);
		
		CmsCache.delChannel(Parent);
	}	
	
	public static String getAutoSerialNo(String s) throws MessageException, SQLException
	{
		//自动生成serialno
		String serialno = s + "_";
		String sql = "";
		
		TableUtil tu = new TableUtil();
		int begin = 97;
		int i = 0;
		while(begin<=122 && i<=10)
		{
			sql = "select * from channel where SerialNo='" + tu.SQLQuote(serialno + (char)begin)	+ "'";
			if (!tu.isExist(sql)) {
				return serialno + (char)begin;
			}
			
			begin ++;
			
			if(begin>122)
			{
				begin = 97;
				serialno = serialno + (char)(97 + i);
				i++;
			}
		}
		
		return serialno;
	}
	
	public static String getRealImageFolder(Channel ch) throws MessageException, SQLException
	{
		String folder = "";
		int foldertype = 0;
	
		Site s = ch.getSite();
		if(ch.getImageFolderName().equals(""))
		{			
			if(s.getImageFolder().equals(""))
			{
				folder = "images";
			}
			else
			{
				folder = s.getImageFolder();
			}
		}
		else
		{
			folder = ch.getImageFolderName();
		}
		
		if(ch.getImageFolderType()==0)
		{
			foldertype = s.getImageFolderType();
		}
		else
		{
			foldertype = ch.getImageFolderType();
		}
				
		if(foldertype>0)
		{
			String SubFolder = "";

			Calendar publishdate = new java.util.GregorianCalendar();
			int year = publishdate.get(Calendar.YEAR);
			int month = publishdate.get(Calendar.MONTH) + 1;
			int day = publishdate.get(Calendar.DATE);
			if (foldertype == 1)
				SubFolder = year + "/";
			else if (foldertype == 2) {
				SubFolder = year + "/" + month + "/";
			} else if (foldertype == 3) {
				SubFolder = year + "/" + month + "/" + day + "/";
			} else if (foldertype == 4) {
				SubFolder = year + "-" + month + "-" + day + "/";
			}
					
			folder = folder + (folder.endsWith("/")?"":"/") + SubFolder;
		}

		
		folder = Util.ClearPath(folder);
		
		if(!folder.startsWith("/"))
			folder = ch.getFullPath() + "/" + folder;
		
		return folder;
	}
	
	//删除频道
	public static void Delete(int id,int ActionUser) throws SQLException, MessageException {

		String Sql = "";

		TableUtil tu = new TableUtil();
		TableUtil tu2 = new TableUtil();
		
		Sql = "select id,SerialNo from channel where Parent=" + id;
		ResultSet Rs = tu.executeQuery(Sql);
		while (Rs.next()) {
			int channelid = Rs.getInt("id");

			Delete(channelid,ActionUser);
		}
		tu.closeRs(Rs);

		Sql = "select * from channel where id=" + id;

		Rs = tu.executeQuery(Sql);
		if (Rs.next()) {
			String serialno = tu.convertNull(Rs.getString("SerialNo"));
			int type = Rs.getInt("Type");
			// int parent = Rs.getInt("Parent");
			Channel ch_ = CmsCache.getChannel(id);
			if(ch_.hasMirrorChannel())
			{
				tu.closeRs(Rs);
				throw new MessageException("请先删除相关的镜像频道!", MessageException.ALERT_HISTORY_BACK);
			}
			
			if (type == Channel.Channel_Type || type == Channel.Application_Type || type == Channel.Site_Type) {
				// 删除多选字段信息
				Sql = "delete from field_options where ChannelID=" + id + "";
				tu2.executeUpdate(Sql);
				
				// 删除频道表的字段描述
				Sql = "delete from field_desc where ChannelID=" + id + "";
				tu2.executeUpdate(Sql);
				
				// 删除表单分组描述
				Sql = "delete from field_group where Channel=" + id + "";
				tu2.executeUpdate(Sql);
				
				// 删除文页文档内容
				Sql = "delete from document_content where Channel=" + id + "";
				tu2.executeUpdate(Sql);
				
				//删除generate_files表内容
				Sql = "delete from generate_files where ChannelID=" + id + "";
				tu2.executeUpdate(Sql);
				
				// 删除对应的频道表
				Sql = "DROP TABLE IF EXISTS channel_" + serialno;
				tu2.executeUpdate(Sql);
			} else if (type == 1) {
				// 如果是分类，删除对应文档

				Channel ch = CmsCache.getChannel(CmsCache.getChannel(id).getParentTableChannelID());

				// 删除文页文档内容
				Sql = "delete from document_content where Channel=" + id + "";
				tu2.executeUpdate(Sql);
				
				String channel_serialno = ch.getSerialNo();
				Sql = "delete from channel_" + channel_serialno	+ " where Category=" + id;

				try {
					tu2.executeUpdate(Sql);				
				} catch (SQLException e) {
				}
			} else if(type == Channel.Page_Type)
			{
				// 删除页面模块
				Sql = "delete from page_module where Page=" + id;
				tu2.executeUpdate(Sql);		
				
				// 删除页面模块内容
				Sql = "delete from page_module_content where Page=" + id;
				tu2.executeUpdate(Sql);	
				
				// 删除页面模块内容
				Sql = "delete from page_content where Page=" + id;
				tu2.executeUpdate(Sql);	
			}

			// 删除模板
			Sql = "delete from channel_template where Channel=" + id;
			tu2.executeUpdate(Sql);
			
			// 删除发布任务
			Sql = "delete from publish_task where ChannelID=" + id;
			tu2.executeUpdate(Sql);

			// 删除用户权限
			Sql = "delete from channel_privilege where Channel=" + id;
			tu2.executeUpdate(Sql);
			
			//删除item_snap中的记录
			Sql = "delete from item_snap where ChannelID=" + id;
			tu2.executeUpdate(Sql);
			
			//删除相关的记录
			Sql = "delete from related_doc where RelatedChannelID=" + id + " or ChannelID=" + id;
			tu2.executeUpdate(Sql);
			
			new Log().ChannelLog(LogAction.channel_delete, id, ActionUser,ch_.getSiteID());
			
			Sql = "delete from channel where id=" + id;
			tu2.executeUpdate(Sql);
			
			CmsCache.delChannel(id);
			
			if(type == Channel.MirrorChannel_Type)
				CmsCache.delChannel(ch_.getLinkChannelID());
		}

		tu.closeRs(Rs);
	}
	
	//增加一个连带发布，可以在模板中调用
	public static void PublishChannel(int channelid) throws MessageException, SQLException
	{
		PublishManager.getInstance().AddPublishTask(Publish.CHANNEL_PUBLISH,channelid,0,0,0);
	}
	
	//增加一个连带发布，可以在模板中调用
	public static void PublishDocument(int channelid,int itemid) throws MessageException, SQLException
	{
		PublishManager.getInstance().OnlyDocumentPublish(channelid,itemid,0);
	}
	
	public static String getIndexFile(int channelid) throws SQLException, MessageException {
		String IndexFileName = "";
		String IndexFileExt = "";
		TableUtil tu = new TableUtil();

		String Sql = "select * from channel_template where TemplateType=1 and Channel="
				+ channelid;

		ResultSet Rs = tu.executeQuery(Sql);

		if (Rs.next()) {
			String TargetName = tu.convertNull(Rs.getString("TargetName"));
			String TempFileName = TargetName.substring(0, TargetName
					.lastIndexOf("."));
			TempFileName = TempFileName
					.substring(TempFileName.lastIndexOf("/") + 1);
			IndexFileName = TempFileName;
			IndexFileExt = TargetName
					.substring(TargetName.lastIndexOf(".") + 1);
		}

		tu.closeRs(Rs);

		return IndexFileName + "."
				+ (IndexFileExt.equals("") ? "htm" : IndexFileExt);
	}
	
	//把当前频道的属性值复制到子频道中，包括当前频道，直接传入value（2015-09-09）
	public static void updateSubChannelsAttribute(int channelid,int type,String value) throws SQLException, MessageException
	{
		Channel channel = CmsCache.getChannel(channelid);
		ArrayList<Channel> subchannels = channel.listAllSubChannels();
		
		String f = "";
		String v = "";
		
		if(type==1)//推荐关系应用到子频道
		{
			f = "Attribute1";v = "***";
		}
		
		/*if(type==2)//引用关系应用到子频道
		{
			f = "Attribute2";v = channel.getAttribute2();
		}*/
		
		if(type==2)
		{
			f = "RecommendOut";v = "***";
		}
		
		/*if(type==4)
		{
			f = "RecommendOutRelation";v = channel.getRecommendOutRelation();
		}*/
		
		if(type==5)
		{
			f = "ListJS";v = channel.getListJS();
		}
		
		if(type==6)
		{
			f = "DocumentJS";v = channel.getDocumentJS();
		}	
		
		if(type==7)
		{
			f = "ListProgram";v = channel.getListProgram();
		}
		
		if(type==8)
		{
			f = "DocumentProgram";v = channel.getDocumentProgram();
		}
		
		v = value;
		
		if(f.length()==0) return;
		
		TableUtil tu = new TableUtil();
		
		String sql = "update channel set "+f+"='" + tu.SQLQuote(v) + "' where id="+channelid;
		tu.executeUpdate(sql);
		CmsCache.delChannel(channelid);
		
		
		for(int i = 0;i < subchannels.size();i++)
		{
			Channel subchannel=subchannels.get(i);
			sql = "update channel set "+f+"='" + tu.SQLQuote(v) + "' where id="+subchannel.getId();
			tu.executeUpdate(sql);
			CmsCache.delChannel(subchannel.getId());
		}
		
	}
	
	//初始化表单组
	public static void initFieldGroupInfo(Channel channel) throws MessageException, SQLException
	{
		int channelid = channel.getId();
		if(channel.getType()== Channel.Category_Type) channelid = channel.getParentTableChannelID();
		else if(channel.getType()== Channel.MirrorChannel_Type) //镜像频道
		{
			Channel linkChannel = channel.getLinkChannel();
			if(linkChannel.getType()== Channel.Category_Type)
				channelid = linkChannel.getParentTableChannelID();
			else if(linkChannel.getType()== Channel.Channel_Type)
				channelid = linkChannel.getId();
		}
		
		ArrayList<Integer> ids = new ArrayList<Integer>();
		TableUtil tu = new TableUtil();
		String Sql = "select * from field_group where Channel=" + channelid + " order by OrderNumber";
		ResultSet Rs = tu.executeQuery(Sql);
		ArrayList FieldGroupInfo = new ArrayList<FieldGroup>();
		while(Rs.next()) {	
			int fid = Rs.getInt("id");
			ids.add(fid);
		}
		tu.closeRs(Rs);
		
		for(int i = 0;i<ids.size();i++)
		{
			int fid = ids.get(i);
			FieldGroup f = new FieldGroup(fid);
			FieldGroupInfo.add(f);			
		}
		channel.setFieldGroupInfo(FieldGroupInfo);
	}	
	
	//设置字段信息
	public static void initFieldInfo(Channel channel) throws MessageException, SQLException
	{
		int channelid = channel.getId();
		if(channel.getType()== Channel.Category_Type) channelid = channel.getParentTableChannelID();
		else if(channel.getType()== Channel.MirrorChannel_Type) //镜像频道
		{
			Channel linkChannel = channel.getLinkChannel();
			if(linkChannel.getType()== Channel.Category_Type)
				channelid = linkChannel.getParentTableChannelID();
			else if(linkChannel.getType()== Channel.Channel_Type)
				channelid = linkChannel.getId();
		}
		
		ArrayList<Integer> ids = new ArrayList<Integer>();
		TableUtil tu = new TableUtil();
		String Sql = "select * from field_desc where ChannelID=" + channelid + " order by OrderNumber";

		ResultSet Rs = tu.executeQuery(Sql);
		ArrayList FieldInfo = new ArrayList<Field>();
		while(Rs.next()) {	
			int fieldid = Rs.getInt("id");
			ids.add(fieldid);
		}
		tu.closeRs(Rs);

		for(int i = 0;i<ids.size();i++)
		{
			int fieldid = ids.get(i);

			Field field = new Field(fieldid);

			if(field.getFieldType().equals("recommendout"))//如果有荐出字段
				channel.setHasFieldRecommend(true);
			
			FieldInfo.add(field);
		}

		channel.setFieldInfo(FieldInfo);
	}	
	
	//初始化模板
	public static void initChannelTemplates(Channel channel) throws MessageException, SQLException
	{
		int channelid = channel.getId();
		
		TableUtil tu = new TableUtil();
		ArrayList<Integer> ids = new ArrayList<Integer>();
		String Sql = "select * from channel_template where Channel=" + channelid + " order by id asc";
		ResultSet Rs = tu.executeQuery(Sql);
		ArrayList channelTemplates = new ArrayList<ChannelTemplate>();
		while (Rs.next()) {	
			int fid = Rs.getInt("id");
			ids.add(fid);
		}
		tu.closeRs(Rs);
		
		for(int i = 0;i<ids.size();i++)
		{
			int fid = ids.get(i);
			ChannelTemplate f = new ChannelTemplate(fid);
			
			if(f.getTemplateID()>0)
				channelTemplates.add(f);	
		}
		channel.setChannelTemplates(channelTemplates);
	}
	
	//从频道的ct对象列表中获取ct对象
	public static ChannelTemplate getChannelTemplate(int channelid, int ctid) throws SQLException, MessageException
	{
		Channel channel = CmsCache.getChannel(channelid);
		for(int i = 0;i<channel.getChannelTemplates().size();i++)
		{
			ChannelTemplate ct = (ChannelTemplate)channel.getChannelTemplates().get(i);
			
			if(ct.getTemplateID() ==  ctid)
				return ct;
		}
		
		//从缓存中找不到，就直接创建
		return new ChannelTemplate(ctid);
	}
	
	//频道字段内容是否继承 0 是继承  1是不继承
	public static int getFieldValueType(int channelid,String field) throws MessageException, SQLException
	{
		int type = 0;
		String sql = "select " + field + " from channel where id=" + channelid;
		TableUtil tu = new TableUtil();
		
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next())
		{
			String v = tu.convertNull(rs.getString(1));
			if(v.equals("***"))
				type = 0;
			else
				type = 1;
		}
		tu.closeRs(rs);
		
		return type;
	}
	
	//获取频道对象
	/* pgc		   		:  pgc内容库
	 * pgc_video   		:  pgc内容库-视频
	 * pgc_record  		:  pgc内容库-收录库
	 * pgc_doc     		:  pgc内容库-图文
	 * pgc_live    		:  pgc内容库-直播
	 * screen      		:  大屏
	 * screen_charts	:  大屏图表类
	 * screen_zd		:  大屏终端
	 * screen_bkjc		:  大屏播控检测
	 * screen_zhzx		:  大屏指挥中心
	 * task_doc	   		:  选题内容
	 * task_car    		:  选题车辆
	 * task_device 		:  选题设备
	 * task_score  		:  选题评分
	 * shenpian   		:  移动审片
	 * shengao     		:  文稿管理
	 * task_project     :  项目管理
	 * task_subject     :  任务管理
	 * workorder		:	工单记录
	 * */
	public static Channel getApplicationChannel(String code) throws SQLException, MessageException
	{
		Channel channel = new Channel() ;
		
		String Sql = "select id from channel where application='" + code + "'";
		
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(Sql);
		if(rs.next())
		{
			int id = rs.getInt("id") ;
			channel = CmsCache.getChannel(id);
		}
		tu.closeRs(rs);
		
		return channel ;
	}
	
	//获取APP站点下频道
	/* code==app   			app管理
	 * code==user  			用户管理
	 * code==interaction	互动管理
	 * code==web			网站管理
	 * code==app_config     app配置
	 * code==app_package    app打包
	 * SiteType==1			app站点
	 * SiteType==2			网站站点
	 * */
	public static JSONArray getApplicationChannel(String code, int company, int SiteType, UserInfo user) throws SQLException, MessageException, JSONException
	{
		JSONArray result = new JSONArray();
		
		JSONArray arr = new JSONArray();
		String sql = "select id,Name from site where SiteType="+SiteType;//APP站点
		if(company!=0){//对应租户站点
			sql += " and company="+company;
		}
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		while(rs.next())
		{
			int siteid = rs.getInt("id") ;//站点id
			String sitename = tu.convertNull(rs.getString("Name"));//站点名称
			JSONObject obj = new JSONObject();
			obj.put("siteid", siteid);
			obj.put("sitename", sitename);
			arr.put(obj);
		}
		tu.closeRs(rs);
		
		for(int i=0;i<arr.length();i++){//遍历APP站点,获取对应的频道
			JSONObject json = arr.getJSONObject(i);
			int site_id = json.getInt("siteid");
			String sitename = json.getString("sitename");
			
			sql = "select id from channel where Site="+site_id;
			if(code.equals("")){//code为空，代表是站点频道
				sql += " and parent=-1";
			}else{
				sql += " and application='" + code + "'";
			}
			TableUtil tu1 = new TableUtil();
			ResultSet rs1 = tu1.executeQuery(sql);
			if(rs1.next())
			{
				int id = rs1.getInt("id") ;
				if (!user.hasChannelShowRight(id)){//用户无此频道权限
					continue;
				}
				
				JSONObject obj1 = new JSONObject();
				obj1.put("channelid", id);
				obj1.put("siteid", site_id);
				obj1.put("sitename", sitename);
				obj1.put("load", 1);
				result.put(obj1);
			}
			tu1.closeRs(rs1);
			
		}
		return result ;
	}
	//获取频道对象
	/* 
	 * SiteType==1			app站点
	 * SiteType==2			网站站点
	 * */
	public static Channel getChannelBySearal(String Searal, int company, int SiteType) throws SQLException, MessageException
	{
		Channel channel = new Channel() ;
		
		
		int siteid = 0 ;
		String sql = "select id from site where company="+company+" and SiteType="+SiteType;
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next())
		{
			siteid = rs.getInt("id") ;
		}
		tu.closeRs(rs);
		
		if(siteid!=0){//租户有绑定站点
			
			sql = "select id from channel where SerialNo='s"+siteid+"_"+ Searal + "'";
			TableUtil tu1 = new TableUtil();
			ResultSet rs1 = tu1.executeQuery(sql);
			if(rs1.next())
			{
				int id = rs1.getInt("id") ;
				channel = CmsCache.getChannel(id);
			}
			tu1.closeRs(rs1);
			
		}
		return channel ;
	}
	
	//从租户公共频道获取对应租户的频道对象,20190505添加
	public static Channel getCompanyChannelByShare(Channel public_channel, int company) throws MessageException, SQLException
	{
		if(public_channel.isShareChannel())
		{
			//获取租户频道
			Channel company_channel = null ;
			ArrayList<Integer> childs = public_channel.getAllChildChannelIDs();
			if (childs!=null && childs.size()>0) {
				for(int i = 0;i<childs.size();i++){
					int channelid = (Integer)childs.get(i);
					Channel child = CmsCache.getChannel(channelid);
					if(company==child.getCompany()){
						company_channel = CmsCache.getChannel(channelid) ;
					}				
				}
			}			
			return company_channel;
		}
		else
		{
			return null;
		}
	}

	public static void selectCcIds(int id) throws SQLException, MessageException {
		String channelIds = id+"";
		TableUtil tu = new TableUtil();
		String Sql = "select id,SerialNo from channel where Parent=" + id;
		ResultSet Rs = tu.executeQuery(Sql);
		while (Rs.next()) {
			int channelid = Rs.getInt("id");
				channelIds += ","+channelid;
		}
		tu.closeRs(Rs);
		int[] ints = Util.StringToIntArray(channelIds,",");
		for (int i = 0; i < ints.length; i++) {
			int channelId = ints[i];
			deleteCcAndTrc(channelId);
		}
	}

	public static void deleteCcAndTrc(int channelId) throws MessageException, SQLException {
		//删除频道配置

		ChannelListHeaderService.deleteByChannel(channelId);
		ChannelListMenuService.deleteByChannel(channelId);
		ChannelListSearchService.deleteByChannel(channelId);
		ChannelListFastSearchService.deleteByChannel(channelId);

		//删除推荐配置
		Recommend.deleteByChannel(channelId);
		ChannelRecommend.deleteByChannel(channelId);
	}
}
