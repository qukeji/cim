/*
 * Created on 2004-8-22
 *
 */
package tidemedia.cms.system;

import java.io.IOException;
import java.io.Serializable;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.plugin.CallApi;
import tidemedia.cms.plugin.DelApi;
import tidemedia.cms.publish.PublishManager;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.CallServices;
import tidemedia.cms.util.RandomUtil;
import tidemedia.cms.util.SolrUtil;
import tidemedia.cms.util.StringUtils;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.service.channel.ChannelListMenuService;


/**
 * @author 李永海(liyonghai@tom.com)
 * 
 */
public class Document extends Table implements Serializable {

	private int id;
	private int GlobalID;// 全局ID
	private String Title = ""; // 标题
	private String SubTitle = "";// 副标题
	private String Content = ""; // 内容
	private int TotalPage; // 页数
	private int ChannelID; // 频道ID
	private int CategoryID; // 分类ID
	private int User; // 用户ID
	private int Status; // 状态 0 未审核，1 审核通过
	private int Active; // 是否删除标志,0 删除
	private int Weight;// 权重
	private String UserName = ""; // 用户名
	private String DocFrom = ""; // 文章来源
	private String Summary = "";// 文章简介
	private String CreateDate = "";// 创建时间
	private long CreateDateL = 0;
	private String PublishDate = "";// 发布时间
	private String ModifiedDate = "";// 发布时间
	private long PublishDateL = 0;
	private long ModifiedDateL = 0;
	private String GeneratePageDate = "";// CMS生成页面时间
	private int IsPhotoNews; // 是否为图片新闻
	private int Random;// 随机数 用于文件名生成
	private String FullPath = "";// 文档对应的频道路径
	private String Keyword = "";// 关键词
	private String Tag = "";// Tag
	private String RelatedItemsList = "";// 相关文章

	private String IndexFileName = "";// 索引页文件名
	private String IndexFileExt = "";// 索引页面扩展名

	private int SubFolderType = 0;// 子目录命名规则
	private int PublishDate_Year = 0;// 发布日期：年
	private int PublishDate_Month = 0;// 发布日期：月
	private int PublishDate_Day = 0;// 发布日期：日
	
	private int ModifiedUser ;//文章最后修该人 5.6加
	// 上面四个变量从Controller中设置
	private int CurrentPage = 0; // 当前此文档的页数
	private HashMap<String, Field> FieldDescArray = new HashMap<String, Field>();
	private ArrayList<String> ContentArray = new ArrayList<String>();
	private long OrderNumber;// 2012-12-04修改ordernumber为long类型,int数值有点小，id不能大于2000万
	private String TemplateLabel = "";// 当前应用的模板标识

	private boolean hasRecommendOutField = false;// 是否有荐出字段
	private String	Message = "";//存放提示信息用
	private int DocTop=0;//置顶排序
	private int ApproveStatus=0;//默认值是0 为待审核 1，2，3等为当前审核步骤 100为审核完成

	public Document() throws SQLException, MessageException {
	}

	public Document(int globalID) throws SQLException, MessageException {
		ItemSnap snap = new ItemSnap(globalID);
		InitDoc(snap.getItemID(), snap.getChannelID());
	}

	public Document(int id, int channelid) throws SQLException,
			MessageException {
		InitDoc(id, channelid);
	}



	private void InitDoc(int id, int channelid) throws SQLException,
			MessageException {
		ArrayList<Field> arraylist = new ArrayList<Field>();
		Channel channel = CmsCache.getChannel(channelid);

		// 复制一份FieldInfo
		for (int i = 0; i < channel.getFieldInfo().size(); i++) {
			Field fd = (Field) channel.getFieldInfo().get(i);
			Field fd1 = new Field();
			fd1.setName(fd.getName());
			fd1.setValue(fd.getValue());
			fd1.setFieldType(fd.getFieldType());
			// fd1.setRelationChannelID(fd.getRelationChannelID());

			// System.out.println(fd.getFieldType());
			if (fd.getFieldType().equals("recommendout"))
				setHasRecommendOutField(true);

			fd1.setGroupChannel(fd.getGroupChannel());
			arraylist.add(fd1);
		}

		// arraylist = (ArrayList)channel.getFieldInfo().clone();

		String Sql = "select * from " + channel.getTableName() + " where id="
				+ id;
		// print(Sql);
		TableUtil datasource_tu = channel.getTableUtil();
		ResultSet Rs = datasource_tu.executeQuery(Sql);
		if (Rs.next()) {
			setId(Rs.getInt("id"));
			setGlobalID(Rs.getInt("GlobalID"));
			setChannelID(channelid);
			setCategoryID(Rs.getInt("Category"));
			setStatus(Rs.getInt("Status"));
			setTitle(convertNull(Rs.getString("Title")));
			setSubTitle(convertNull(Rs.getString("SubTitle")));
			setContent(convertNull(Rs.getString("Content")));
			setSummary(convertNull(Rs.getString("Summary")));
			setKeyword(convertNull(Rs.getString("Keyword")));
			setTag(convertNull(Rs.getString("Tag")));
			setUser(Rs.getInt("User"));
			setModifiedUser(Rs.getInt("ModifiedUser"));
			setTotalPage(Rs.getInt("TotalPage"));
			setIsPhotoNews(Rs.getInt("IsPhotoNews"));
			setRandom(Rs.getInt("Random"));
			// setCreateDate(Util.FormatTimeStamp("",Rs.getLong("CreateDate")));
			setCreateDateL(Rs.getLong("CreateDate"));
			setModifiedDateL(Rs.getLong("ModifiedDate"));
			setPublishDateL(Rs.getLong("PublishDate"));
			setCreateDate(Util.FormatTimeStamp("", getCreateDateL()));
			setModifiedDate(Util.FormatTimeStamp("", getModifiedDateL()));
			// setModifiedDate(Util.FormatTimeStamp("",Rs.getLong("ModifiedDate")));
			setPublishDate(Util.FormatTimeStamp("", Rs.getLong("PublishDate")));
			setDocFrom(convertNull(Rs.getString("DocFrom")));
			setActive(Rs.getInt("Active"));
			setOrderNumber(Rs.getLong("OrderNumber"));
			setWeight(Rs.getInt("Weight"));
			setDocTop(Rs.getInt("DocTop"));
			setApproveStatus(Rs.getInt("ApproveStatus"));
			Calendar publishdate = new java.util.GregorianCalendar();
			// publishdate.setTime(Rs.getDate("PublishDate"));
			publishdate.setTimeInMillis(Rs.getLong("PublishDate") * 1000);
			// System.out.println(publishdate+" " +
			// publishdate.get(Calendar.YEAR));
			setPublishDate_Year(publishdate.get(Calendar.YEAR));
			setPublishDate_Month(publishdate.get(Calendar.MONTH) + 1);
			setPublishDate_Day(publishdate.get(Calendar.DATE));

			for (int i = 0; i < arraylist.size(); i++) {
				Field fd = (Field) arraylist.get(i);
				// print(fd.getName()+","+fd.getFieldType());
				// 集合
				if (fd.getFieldType().equals("group_parent")
						|| fd.getFieldType().equals("group_child")) {
					if (!fd.getGroupChannel().equals("")) {
						if (fd.getFieldType().equals("group_parent")) {
							Channel ch = CmsCache.getChannel(fd
									.getGroupChannel());
							int parentid = 0;
							Sql = "select * from parent_child_item where Child="
									+ getGlobalID();
							Sql += " and ParentChannelCode like '"
									+ ch.getChannelCode() + "%'";
							// print(Sql);

							TableUtil tu = new TableUtil();
							ResultSet rsrs = tu.executeQuery(Sql);
							if (rsrs.next()) {
								parentid = rsrs.getInt("Parent");
							}
							tu.closeRs(rsrs);
							fd.setValue(parentid + "");
						}

						if (fd.getFieldType().equals("group_child")) {
							Channel ch = CmsCache.getChannel(fd
									.getGroupChannel());
							String ids = "";
							Sql = "select * from parent_child_item where Parent="
									+ getGlobalID();
							Sql += " and ChildChannelCode like '"
									+ ch.getChannelCode() + "%'";
							// print(Sql);

							TableUtil tu = new TableUtil();
							ResultSet rsrs = tu.executeQuery(Sql);
							while (rsrs.next()) {
								int parentid = rsrs.getInt("Child");
								ids += (ids.equals("") ? "" : ",") + parentid;
							}
							tu.closeRs(rsrs);
							fd.setValue(ids);
						}
					}
				} else if (fd.getFieldType().equals("relation"))// 关联字段
				{
					String ids = "";
					int channelid_ = channel.getId();
					if (!channel.isTableChannel())
						channelid_ = (channel.getParentTableChannelID());
					Sql = "select ChildGlobalID from relation2_" + channelid_
							+ "_" + fd.getRelationChannelID()
							+ " where GlobalID=" + getGlobalID();
					TableUtil tu = new TableUtil();
					ResultSet rsrs = tu.executeQuery(Sql);
					while (rsrs.next()) {
						int parentid = rsrs.getInt("ChildGlobalID");
						ids += (ids.equals("") ? "" : ",") + parentid;
					}
					tu.closeRs(rsrs);
					fd.setValue(ids);
				} else if (fd.getFieldType().equals("datetime")) // 日期字段
				{
					String v = "";
					Timestamp t = Rs.getTimestamp(fd.getName());
					if(t!=null){
						v = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(t);
					}
					fd.setValue(v);
				} else {
					try {
						fd.setValue(convertNull(Rs.getString(fd.getName())));
					} catch (Exception e) {
						e.printStackTrace(System.out);
						System.out.println(fd.getName() + ":" + e.getMessage());
					}
				}

				FieldDescArray.put(fd.getName(), fd);
			}

			datasource_tu.closeRs(Rs);

			// 如果此文档有多页内容
			if (getTotalPage() > 1) {
				Sql = "select * from document_content where Channel="
						+ (getCategoryID() > 0 ? getCategoryID() : channelid)
						+ " and Document=" + id + " order by Page";

				Rs = executeQuery(Sql);
				while (Rs.next()) {
					String content = convertNull(Rs.getString("Content"));
					ContentArray.add(content);
					// System.out.println("content:" + content);
				}
				closeRs(Rs);
			}

			UserInfo userinfo = CmsCache.getUser(User);
			if (userinfo != null) {
				setUserName(userinfo.getName());
			}

			if (CategoryID == 0) {
				setFullPath(channel.getFullPath());
			} else {
				setFullPath(CmsCache.getChannel(CategoryID).getFullPath());
				/*
				 * Sql = "select FullPath from channel where id=" + CategoryID;
				 * Rs = executeQuery(Sql); if (Rs.next()) {
				 * setFullPath(convertNull(Rs.getString("FullPath"))); }
				 * 
				 * closeRs(Rs);
				 */
			}

		} else {
			closeRs(Rs);
			// throw new MessageException("This item is not exist!");
		}
	}

	public void Add() throws SQLException, MessageException {

		Channel channel = CmsCache.getChannel(ChannelID);
		String Sql = "";

		Sql = "insert into " + channel.getTableName() + " (";

		Sql += "Title,Content,User";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Title) + "'";
		Sql += ",'" + SQLQuote(Content) + "'";
		Sql += "," + User + "";

		Sql += ")";

		// System.out.println("Title:"+Title+"Sql:"+Sql);
		executeUpdate(Sql);
	}

	public void Delete(int id) throws SQLException, MessageException {
	}

	/*
	 * public void Delete(int itemid, int channelid) throws
	 * SQLException,MessageException { Channel channel =
	 * CmsCache.getChannel(channelid);
	 * 
	 * String Sql = "update " + channel.getTableName() +
	 * " set Active=0 where id=" + itemid;
	 * 
	 * executeUpdate(Sql); }
	 */

	public void Delete(String itemid, int channelid) throws SQLException,
			MessageException, IOException, ParseException {
		Channel channel = CmsCache.getChannel(channelid);

		TableUtil datasource_tu = channel.getTableUtil();
		String[] ids = Util.StringToArray(itemid, ",");
		if (ids != null && ids.length > 0) {
			for (int i = 0; i < ids.length; i++) {
				int id_ = Util.parseInt(ids[i]);
				String Sql = "update " + channel.getTableName()
						+ " set Active=0,Status=0 where id=" + id_;
				datasource_tu.executeUpdate(Sql);

				Document document = CmsCache.getDocument(id_, channelid);// new
																			// Document(id_,channelid);
				new ItemSnap().Delete(document.getGlobalID()); // 不是真删除，否则用gid取不到文档
				new RelatedItem().Delete(document.getGlobalID());

				CmsCache.delDocument(id_, channelid);
				CmsCache.delDocument(document.getGlobalID());

				Log l = new Log();
				l.setTitle(document.getTitle());
				l.setUser(getUser());
				l.setItem(id_);
				//l.setLogType("删除文档");
				l.setLogAction(LogAction.document_delete);
				l.setFromType("channel");
				l.setFromKey(channelid + "");
				l.Add();

				/* 调用接口 */
				CallApi callapi = new CallApi();
				callapi.setAction(Action.document_delete);
				callapi.setItem(document);
				callapi.setGlobalID(document.getGlobalID());
				callapi.setActionUser(getUser());
				callapi.Start();

				/* 删除已经发布出去的文件 */
				DelApi delapi = new DelApi();
				// delapi.setGlobalID(document.getGlobalID());
				delapi.setSiteID(channel.getSiteID());
				delapi.setChannelID(channelid);
				delapi.setItemID(id_);
				delapi.setDelLocal(true);
				delapi.Start();

				/* 调用评论删除接口 */
				String channelcode = document.getChannel().getChannelCode();
				if (callComment(channelcode))
					new CallServices().call(document, "delete");

				// 对推荐的稿件联动撤稿
				if (!channel.getRecommendOut().equals(""))
					Delete2RecommendOut(document.getGlobalID(), 1);
			}
			PublishManager publishmanager = PublishManager.getInstance();
			publishmanager.DeleteDocumentPublish(channelid, getUser());
		}
	}

	// 撤稿
	public void Delete2(String itemid, int channelid) throws SQLException,
			MessageException, IOException, ParseException {
		Channel channel = CmsCache.getChannel(channelid);

		TableUtil datasource_tu = channel.getTableUtil();
		String[] ids = Util.StringToArray(itemid, ",");
		if (ids != null && ids.length > 0) {
			for (int i = 0; i < ids.length; i++) {
				int id_ = Util.parseInt(ids[i]);
				String Sql = "update " + channel.getTableName()
						+ " set Status=0 where id=" + id_;
				datasource_tu.executeUpdate(Sql);

				Document document = CmsCache.getDocument(id_, channelid);// new
				System.out.println("delete2:"+document.getTitle()+","+document.getGlobalID());															// Document(id_,channelid);
				new ItemSnap().UpdateStatus(document.getGlobalID(), 0);
				new RelatedItem().UpdateStatus(document.getGlobalID(), 0);

				CmsCache.delDocument(id_, channelid);
				CmsCache.delDocument(document.getGlobalID());

				Log l = new Log();
				l.setTitle(document.getTitle());
				l.setUser(getUser());
				l.setItem(id_);
				//l.setLogType("撤稿");
				l.setLogAction(LogAction.document_unpublish);
				l.setFromType("channel");
				l.setFromKey(channelid + "");
				l.Add();

				/* 调用接口 */
				CallApi callapi = new CallApi();
				callapi.setAction(Action.document_status);
				callapi.setItem(document);
				callapi.setGlobalID(document.getGlobalID());
				callapi.setActionUser(getUser());
				callapi.Start();

				System.out.println("delete2:"+document.getTitle()+","+document.getGlobalID());
				/* 删除已经发布出去的文件 */
				DelApi delapi = new DelApi();
				//delapi.setGlobalID(document.getGlobalID()); 不再使用globalid
				delapi.setSiteID(channel.getSiteID());
				delapi.setChannelID(channelid);
				delapi.setItemID(id_);
				delapi.setDelLocal(false);
				delapi.Start();

				// 对推荐的稿件联动撤稿，还包括有荐出字段的情况
				if (channel.getRecommendOut().length() > 0
						|| channel.isHasFieldRecommend())
					Delete2RecommendOut(document.getGlobalID(), 0);
			}
			PublishManager publishmanager = PublishManager.getInstance();
			publishmanager.DeleteDocumentPublish(channelid, getUser());
		}
	}

	// 删除或撤稿，用globalid flag=1 删除 =0 撤稿
	public void DeleteByGlobalIDs(String gids, int flag) throws SQLException,
			MessageException, IOException, ParseException {
		String[] ids = Util.StringToArray(gids, ",");
		if (ids != null && ids.length > 0) {
			for (int i = 0; i < ids.length; i++) {
				int id_ = Util.parseInt(ids[i]);

				ItemSnap is = new ItemSnap(id_);

				if (flag == 0)
					Delete2(is.getItemID() + "", is.getChannelID());
				else if (flag == 1)
					Delete(is.getItemID() + "", is.getChannelID());
			}
		}
	}

	// 对推荐的连动删除或撤稿 flag=1 删除 =0 撤稿
	public void Delete2RecommendOut(int globalid, int flag)
			throws MessageException, SQLException , IOException, ParseException{
		String listSql = "select * from recommend where GlobalID=" + globalid;
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(listSql);

		String gs = "";
		while (rs.next()) {
			int childglobalid = rs.getInt("ChildGlobalID");

			gs += (gs.equals("") ? "" : ",") + childglobalid;
		}

		tu.closeRs(rs);

		// System.out.println(listSql+","+gs);
		if (gs.length() > 0)
			DeleteByGlobalIDs(gs, flag);
	}

	// IncludeSubChannel 是否包含子频道
	public void Order(int itemid, int channelid, int direction, int number,
			boolean IncludeSubChannel) throws SQLException, MessageException {
		if (itemid == 0 || channelid == 0)
			return;

		Channel channel = CmsCache.getChannel(channelid);
		int categoryid = 0;
		if (channel.getType() == Channel.Category_Type)
			categoryid = channelid;

		String Sql = "";
		String TableName = channel.getTableName();
		int OrderNumber = 0;
		ResultSet Rs;
		TableUtil tu = channel.getTableUtil();
		TableUtil tu2 = channel.getTableUtil();
		TableUtil tu3 = new TableUtil();

		/*
		 * int n = 0; boolean needRepair = false; do{ needRepair =
		 * RepairOrderNumber(TableName); n ++; }while(needRepair && n<5);
		 */

		String Symbol1 = "";
		String Symbol2 = "";
		String Symbol3 = "";
		if (direction == 1)// Up,increase order number,选择该记录上方的记录做ordernumber交换
		{
			Symbol1 = ">";
			Symbol2 = "asc";
			Symbol3 = "max";
		} else if (direction == 0)// down,decrease order
									// number,选择该记录下方的记录做ordernumber交换
		{
			Symbol1 = "<";
			Symbol2 = "desc";
			Symbol3 = "min";
		} else
			return;

		int globalID = 0;
		Sql = "select OrderNumber,Category,GlobalID from " + TableName
				+ " where id=" + itemid;
		Rs = tu.executeQuery(Sql);
		if (Rs.next()) {
			OrderNumber = Rs.getInt("OrderNumber");
			categoryid = Rs.getInt("Category");
			globalID = Rs.getInt("GlobalID");
		}

		tu.closeRs(Rs);

		Sql = "select count(id) from " + TableName + " where OrderNumber="
				+ OrderNumber;
		Rs = tu.executeQuery(Sql);
		if (Rs.next()) {
			int count = Rs.getInt(1);
			if (count > 1) {
				System.out.println("ordernumber 重复,table:" + TableName
						+ ",ordernumber:" + OrderNumber);
			}
		}
		tu.closeRs(Rs);

		int ordernumber1 = 0;// 大点的数
		int ordernumber2 = 0;// 小点的数
		int nn = 0;
		Sql = "SELECT OrderNumber FROM " + TableName + " where OrderNumber"
				+ Symbol1 + OrderNumber;

		if (IncludeSubChannel) {
			Sql += " and ChannelCode like '" + channel.getChannelCode() + "%'";
		} else {
			if (categoryid > 0)
				Sql += " and Category=" + categoryid;
			else
				Sql += " and Category=0";
		}

		int changeTop1 = ChannelListMenuService.getByCodeS(channelid, "changeTop1");
		System.out.println(channelid+"==="+changeTop1);
		if(channel.getIsTop()==1||changeTop1==1){//默认列表页开启置顶/新版列表页开启置顶
			Sql += " and DocTop=0";
		}

		Sql += " and Active=1 order by OrderNumber " + Symbol2 + " limit "
				+ (number + 1);
		System.out.println("sql:" + Sql);
		Rs = tu.executeQuery(Sql);
		while (Rs.next()) {
			nn++;
			int nnn = Rs.getInt(1);
			System.out.println("nnn:" + nnn);
			if (nn == 1) {
				ordernumber1 = nnn;
				ordernumber2 = nnn;
			}
			if (direction == 1)// 找两个最大的数
			{
				if (nnn > ordernumber1) {
					ordernumber2 = ordernumber1;
					ordernumber1 = nnn;
				}
				if (nnn < ordernumber1 && nnn > ordernumber2)
					ordernumber2 = nnn;
			}
			if (direction == 0)// 找两个最小的数
			{
				if (nnn < ordernumber2) {
					ordernumber1 = ordernumber2;
					ordernumber2 = nnn;
				}
				if (nnn > ordernumber2 && nnn < ordernumber1)
					ordernumber1 = nnn;
			}
		}
		tu.closeRs(Rs);

		if (nn < (number + 1))// 说明移动到最低，或最高
		{
			if (direction == 1)
				ordernumber2 = ordernumber1 + 50;
			if (direction == 0)
				ordernumber2 = ordernumber1 - 50;
		}
		// System.out.println("ordernumber2:"+ordernumber2);
		if ((ordernumber1 - ordernumber2) == 1) {
			System.out.println("两个ordernumer相邻.ordernumber:" + ordernumber1);
			for (int i = 0; i < number; i++) {
				Sql = "select id,OrderNumber,GlobalID from " + TableName
						+ " where id!=" + itemid
						+ " and Active=1 and Category=" + categoryid;
				Sql += " and OrderNumber" + Symbol1 + OrderNumber
						+ " order by OrderNumber " + Symbol2;

				Rs = tu.executeQuery(Sql);
				// System.out.println(Sql);
				if (Rs.next()) {
					// 交换ordernumber值
					int j = Rs.getInt("id");
					int ordernumber = Rs.getInt("OrderNumber");
					int globalID_j = Rs.getInt("GlobalID");

					// System.out.println("O:"+OrderNumber+",o:"+ordernumber+",j:"+j);
					Sql = "update " + TableName + " set OrderNumber="
							+ OrderNumber + " where id=" + j;
					tu2.executeUpdate(Sql);
					Sql = "update item_snap set OrderNumber=" + OrderNumber
							+ " where GlobalID=" + globalID_j;
					tu3.executeUpdate(Sql);
					Sql = "update " + TableName + " set OrderNumber="
							+ ordernumber + " where id=" + itemid;
					tu2.executeUpdate(Sql);
					Sql = "update item_snap set OrderNumber=" + ordernumber
							+ " where GlobalID=" + globalID;
					tu3.executeUpdate(Sql);

					OrderNumber = ordernumber;
				} else {
					closeRs(Rs);
					break;
				}

				// System.out.println("i:"+i);
				tu.closeRs(Rs);
			}
		} else if (ordernumber2 > 0 && ordernumber1 > 0) {
			int nnn = ordernumber1
					+ Math.round((ordernumber2 - ordernumber1) / 2);
			System.out.println("nnn>>" + nnn);
			Sql = "update " + TableName + " set OrderNumber=" + nnn
					+ " where id=" + itemid;
			tu2.executeUpdate(Sql);
			Sql = "update item_snap set OrderNumber=" + nnn
					+ " where GlobalID=" + globalID;
			tu3.executeUpdate(Sql);

			Document document = CmsCache.getDocument(globalID);// new
																// Document(globalID);
			Log l = new Log();
			l.setTitle(document.getTitle());
			l.setUser(getUser());
			l.setItem(document.getId());
			//l.setLogType("排序");
			l.setLogAction(LogAction.document_order);
			l.setFromType("channel");
			l.setFromKey(channelid + "");
			l.Add();

			PublishManager publishmanager = PublishManager.getInstance();
			// System.out.println("channelid:"+channelid);
			publishmanager.DocumentPublish(channelid, User);
		}
		/*
		 * for (int i = 0; i < number; i++) { Sql =
		 * "select id,OrderNumber,GlobalID from " + TableName + " where id!=" +
		 * itemid + " and Active=1 and Category=" + categoryid; Sql +=
		 * " and OrderNumber" + Symbol1 + OrderNumber + " order by OrderNumber "
		 * + Symbol2;
		 * 
		 * Rs = executeQuery(Sql); //System.out.println(Sql); if (Rs.next()) {
		 * //交换ordernumber值 int j = Rs.getInt("id"); int ordernumber =
		 * Rs.getInt("OrderNumber"); int globalID_j = Rs.getInt("GlobalID");
		 * 
		 * //System.out.println("O:"+OrderNumber+",o:"+ordernumber+",j:"+j); Sql
		 * = "update " + TableName + " set OrderNumber=" + OrderNumber +
		 * " where id=" + j; executeUpdate(Sql); Sql =
		 * "update item_snap set OrderNumber=" + OrderNumber +
		 * " where GlobalID=" + globalID_j; executeUpdate(Sql); Sql = "update "
		 * + TableName + " set OrderNumber=" + ordernumber + " where id=" +
		 * itemid; executeUpdate(Sql); Sql = "update item_snap set OrderNumber="
		 * + ordernumber + " where GlobalID=" + globalID; executeUpdate(Sql);
		 * 
		 * OrderNumber = ordernumber; } else { closeRs(Rs); break; }
		 * 
		 * //System.out.println("i:"+i); closeRs(Rs); }
		 */
	}

	public void Approve(String itemid, int channelid) throws SQLException,MessageException {
		Channel channel = CmsCache.getChannel(channelid);
		TableUtil datasource_tu = channel.getTableUtil();
		String[] ids = Util.StringToArray(itemid, ",");
		if (ids != null && ids.length > 0) {
			for (int i = 0; i < ids.length; i++) {
				int id_ = Util.parseInt(ids[i]);
				String Sql = "update " + channel.getTableName() + " set Status=1 where id=" + id_;
				datasource_tu.executeUpdate(Sql);

				CmsCache.delDocument(id_, channelid);

				Document document = CmsCache.getDocument(id_, channelid);// new
																			// Document(id_,channelid);
				// System.out.println("approve gid:"+document.getGlobalID());
				new ItemSnap().UpdateStatus(document.getGlobalID(), 1);
				new RelatedItem().UpdateStatus(document.getGlobalID(), 1);

				CmsCache.delDocument(document.getGlobalID());

				int cid = channelid;
				if (document.getCategoryID() > 0)
					cid = document.getCategoryID();

				PublishManager publishmanager = PublishManager.getInstance();
				publishmanager.DocumentPublish(cid, document.getId(), getUser());

				/* 调用接口 */
				CallApi callapi = new CallApi();
				callapi.setAction(Action.document_status);
				callapi.setItem(document);
				callapi.setGlobalID(document.getGlobalID());
				callapi.setActionUser(getUser());
				callapi.Start();

				/*
				 * 给第一视频服务的代码注释掉 String channelcode =
				 * document.getChannel().getChannelCode();
				 * if(callComment(channelcode)) new
				 * CallServices().call(document,"");
				 */

				Log l = new Log();
				l.setTitle(document.getTitle());
				l.setUser(getUser());
				l.setItem(id_);
				//l.setLogType("审核通过");
				l.setLogAction(LogAction.document_publish);
				l.setFromType("channel");
				l.setFromKey(channelid + "");
				l.Add();
			}
		}
	}

	public String getContent() {
		if (CurrentPage <= 1)
			return Content;
		else {
			if ((CurrentPage - 1) <= ContentArray.size())
				return (String) ContentArray.get(CurrentPage - 1 - 1);
			else
				return "";
		}
	}

	public void Update() throws SQLException, MessageException {
	}

	public boolean canAdd() {
		return false;
	}

	public boolean canUpdate() {
		return false;
	}

	public boolean canDelete() {
		return false;
	}

	public int getChannelID() {
		return ChannelID;
	}

	public int getId() {
		return id;
	}

	public String getTitle() {
		return Title;
	}

	// html中的alt
	public String getHtmlTitle() {
		return Util.HTMLEncode(getTextTitle());
	}

	// 返回去除html标记的title
	public String getTextTitle() {
		String title = Title;
		String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式
		Pattern p_html = Pattern.compile(regEx_html,
				Pattern.CASE_INSENSITIVE);
		java.util.regex.Matcher m_html = p_html.matcher(title);
		title = m_html.replaceAll(""); // 过滤html标签
		return title;
	}

	public String getTitle(int titleword) {
		if (titleword > 0) {
			return substring(getTextTitle(), titleword);
		} else
			return Title;
	}

	public String getTitle(int titleword, String str) {
		if (titleword > 0) {
			return substring(getTextTitle(), titleword, str);
		} else
			return Title;
	}

	public void setChannelID(int i) {
		ChannelID = i;
	}

	public void setContent(String string) {
		Content = string;
	}

	public void setId(int i) {
		id = i;
	}

	public void setTitle(String string) {
		Title = string;
	}

	public HashMap<String, Field> getFieldDescArray() {
		return FieldDescArray;
	}

	public void setFieldDescArray(HashMap<String, Field> list) {
		FieldDescArray = list;
	}

	public String getValue(String field) {
		String value = "";
		/*
		 * if (FieldDescArray != null && FieldDescArray.size() > 0 &&
		 * !field.equals("")) { for (int i = 0; i < FieldDescArray.size(); i++)
		 * { Field fv = (Field) FieldDescArray.get(i);
		 * //if(fv.getFieldName().equalsIgnoreCase("photo"))
		 * System.out.println(id+":"+fv.getFieldName()+":"+fv.getFieldValue());
		 * if (fv.getName().equalsIgnoreCase(field)) { value = fv.getValue();
		 * break; } } }
		 */
		Field fv = FieldDescArray.get(field);
		if (fv != null)
			value = fv.getValue();

		return value;
	}

	public int getIntValue(String field) {
		int value = 0;

		Field fv = FieldDescArray.get(field);
		if (fv != null)
			value = fv.getIntValue();

		return value;
	}

	/**
	 * @return Returns the user.
	 */
	public int getUser() {
		return User;
	}

	/**
	 * @param user
	 *            The user to set.
	 */
	public void setUser(int user) {
		User = user;
	}

	/**
	 * @return Returns the userName.
	 */
	public String getUserName() {
		return UserName;
	}

	/**
	 * @param userName
	 *            The userName to set.
	 */
	public void setUserName(String userName) {
		UserName = userName;
	}

	// 返回用户的登录名
	public String getLoginUsername() throws MessageException, SQLException {
		String s = "";
		if (getUser() > 0)
			s = CmsCache.getUser(getUser()).getUsername();

		return s;
	}

	//0 没权限 1 更新成功 2 更新失败 3 敏感词
	public int AddDocument(HashMap request) throws SQLException, MessageException, IOException, ParseException {
		
		int categoryid = 0;
		if (!CmsCache.getUser(getUser()).hasChannelRight(ChannelID, 2))
			return 0;
		int insertid = 0;
		Channel channel = CmsCache.getChannel(ChannelID);
		String channelcode = channel.getChannelCode();
		String Sql = "";
		String FieldList = "";
		String ValueList = "";
		
		int status = Util.getIntParameter(request, "Status");
		int weight = Util.getIntParameter(request, "Weight");
		int recommendGlobalID = Util.getIntParameter(request,"RecommendGlobalID");
		int recommendChannelID = Util.getIntParameter(request,"RecommendChannelID");
		int recommendItemID = Util.getIntParameter(request, "RecommendItemID");
		int recommendType = Util.getIntParameter(request, "RecommendType");
		int pid = Util.getIntParameter(request, "ParentGlobalID");
		int totalpage = Util.getIntParameter(request, "Page");
		
		if (!CmsCache.getUser(getUser()).hasChannelRight(ChannelID, 3))
			status = 0;

		if (channel.getType() == Channel.Category_Type) {// 继承表单的频道
			categoryid = ChannelID;
		}
		
		//检查敏感词
		String s = ItemUtil2.checkWords(request);
		if(s.length()>0)
		{
			Message = s;
			return 3;
		}
				
		// System.out.println("lsh"+Util.getParameter(request,"Content2"));
		Sql = "insert into " + channel.getTableName() + " (";

		ArrayList<Field> fields = channel.getFieldInfo();
		if (fields != null && fields.size() > 0
				&& !Util.getParameter(request, "Title").equals("")) {
			
			// System.out.println("page:" +
			// Util.getIntParameter(request,"Page"));
			for (int i = 0; i < fields.size(); i++) {
				Field field = (Field) fields.get(i);
				String FieldName = field.getName();
				// System.out.println(FieldName);

				if (!FieldName.equals("id") && !FieldName.equals("User")
						&& !FieldName.endsWith("ModifiedUser")
						&& !FieldName.equals("CreateDate")
						&& !FieldName.equals("ModifiedDate")
						&& !FieldName.equals("GenerateFileDate")
						&& !FieldName.equals("Active")
						&& !FieldName.equals("TotalPage")
						&& !FieldName.equals("Status")
						&& !FieldName.equals("Category")
						&& !FieldName.equals("ChannelCode")
						&& !FieldName.equals("GlobalID")
						&& !FieldName.equals("ParentGlobalID")
						&& !FieldName.equals("OrderNumber")
						&& !FieldName.equals("Weight")) {
					if (FieldName.equals("IsPhotoNews")) {
						FieldList += (FieldList.equals("") ? "" : ",") + FieldName;
						ValueList += (ValueList.equals("") ? "" : ",") + ""	+ Util.getIntParameter(request, FieldName) + "";
					} else {
						String ftype = field.getFieldType();
						if (!(ftype.equals("group_parent") || ftype.equals("group_child") || ftype.equals("relation"))) {
							FieldList += (FieldList.equals("") ? "" : ",") + FieldName;

							if (FieldName.equals("PublishDate"))
							{
								String v = Util.getParameter(request,FieldName).trim();
								if(v.length()>0)
									v = "'" + SQLQuote(v) + "'";
								
								ValueList += (ValueList.equals("") ? "" : ",") + "UNIX_TIMESTAMP("	+ v + ")";
							}
							else if (field != null && (ftype.equals("checkbox") || ftype.equals("checkbox_dict"))) {
								// ValueList += (ValueList.equals("") ? "" :
								// ",") + "'" +
								// SQLQuote(Util.ArrayToString(request.getParameterValues(FieldName),","))
								// + "'";
								ValueList += (ValueList.equals("") ? "" : ",")
										+ "'"
										+ SQLQuote(Util.getParameter(request,
												FieldName)) + "'";
							} else if (ftype.equals("recommendout")) {
								// ValueList += (ValueList.equals("") ? "" :
								// ",") + "'" +
								// SQLQuote(Util.ArrayToString(request.getParameterValues(FieldName),","))
								// + "'";
								ValueList += (ValueList.equals("") ? "" : ",")
										+ "'"
										+ SQLQuote(Util.getParameter(request,
												FieldName)) + "'";
							} else if (field != null
									&& ftype.equalsIgnoreCase("datetime")) {
								if (SQLQuote(
										Util.getParameter(request, FieldName))
										.equals("")) {
									ValueList += (ValueList.equals("") ? ""
											: ",") + "null";
								} else {
									ValueList += (ValueList.equals("") ? ""
											: ",")
											+ "'"
											+ SQLQuote(Util.getParameter(
													request, FieldName)) + "'";
								}
							} else if (ftype.equals("number")) {
								ValueList += (ValueList.equals("") ? "" : ",")
										+ ""
										+ Util.getIntParameter(request,
												FieldName) + "";
							} else if (ftype.equals("float")) 
							{
								String num = Util.getParameter(request,FieldName);
								//float v = Util.parseFloat(num);
								//2015.4.23修改 使用float会出错，比如：304194.85
								double v = Util.parseDouble(num);
								ValueList += (ValueList.equals("") ? "" : ",") + "" + v + "";
							} else {
								if (field.getDataType() == 1)
									ValueList += (ValueList.equals("") ? ""
											: ",")
											+ (Util.getIntParameter(request,
													FieldName)) + "";
								else {
									String v = Util.getParameter(request,
											FieldName);
									if (FieldName.equals("Keyword"))
										v = v.replace("　", " ");
									ValueList += (ValueList.equals("") ? ""
											: ",") + "'" + SQLQuote(v) + "'";
								}
							}
						}
					}

				}
			}
			
			long time = System.currentTimeMillis() / 1000;
			int random = RandomUtil.getRandom(time);// new
													// java.util.Random().nextInt(999)+1;

			FieldList += (FieldList.equals("") ? "" : ",")
					+ "TotalPage,Category,ChannelCode,User,ModifiedUser,CreateDate,ModifiedDate,OrderNumber,Active,Weight,Status,Random";
			ValueList += (ValueList.equals("") ? "" : ",") + totalpage + ","
					+ categoryid + ",'" + channelcode + "'," + User + ","+ModifiedUser+","
					+ time + ",UNIX_TIMESTAMP(),0,1," + weight + "," + status
					+ "," + random;

			Sql += FieldList;
			Sql += ") values(";
			Sql += ValueList;
			Sql += ")";

			//System.out.println(Sql);
			// + Util.getParameter(request,"Title"));
			TableUtil tu = channel.getTableUtil();
			
			try{
			insertid = tu.executeUpdate_InsertID(Sql);
			}catch(SQLException e){
				System.out.println(Sql+"\r\n"+e.getMessage());
				return 2;
			}

			setId(insertid);

			for (int i = 2; i <= totalpage; i++) {
				Sql = "insert into document_content (";

				Sql += "Channel,Document,Content,Page,TotalPage";
				Sql += ") values(";
				Sql += "" + ChannelID + "";
				Sql += "," + insertid + "";
				Sql += ",'"
						+ SQLQuote(Util.getParameter(request, "Content" + i))
						+ "'";
				Sql += "," + i + "";
				Sql += "," + totalpage + "";

				Sql += ")";

				executeUpdate(Sql);
			}

			// 更新序数
			Sql = "update " + channel.getTableName()
					+ " set OrderNumber=id*100 where id=" + insertid;
			tu.executeUpdate(Sql);

			Document document = new Document(insertid, ChannelID);// 不需要从缓存中获取
			new ItemSnap().Add(document);// 加入全局库
			
			SolrUtil.addSolr(document);

			setGlobalID(document.getGlobalID());

			document.setRelatedItemsList(getRelatedItemsList());
			document.AddRelatedItems();// 添加相关文章

			// 处理父子文档关系
			if (pid > 0)
				ItemUtil.insertParentChild(pid, document.getGlobalID());

			// 处理父集字段
			ItemUtil.ParentChildItem_(fields, request, document.getGlobalID(),
					getChannel());

			// 处理关联字段
			// ItemUtil2.RelationFieldItem(fields,request,document.getGlobalID(),getChannel(),1);

			// System.out.println("recommendGlobalID:"+recommendGlobalID);
			// System.out.println("recommendChannelID:"+recommendChannelID);

			// 处理推荐
			if (recommendGlobalID > 0 || recommendChannelID > 0) {
				ItemUtil2.InsertRecommendRelation(recommendGlobalID,
						document.getGlobalID(), recommendType,
						recommendChannelID, recommendItemID, getUser());
			}

			Log l = new Log();
			l.setTitle(document.getTitle());
			l.setUser(getUser());
			l.setItem(insertid);
			//l.setLogType("添加文档");
			l.setLogAction(LogAction.document_add);
			l.setFromType("channel");
			l.setFromKey(ChannelID + "");
			l.Add();

			/* 调用接口 */
			CallApi callapi = new CallApi();
			callapi.setAction(Action.document_add);
			callapi.setItem(document);
			callapi.setGlobalID(document.getGlobalID());
			callapi.setActionUser(getUser());
			callapi.Start();

			// String channelcode = document.getChannel().getChannelCode();
			if (status == 1 && (callComment(channelcode)))
				new CallServices().call(document, "");

			PublishManager publishmanager = PublishManager.getInstance();
			if (status == 1) {
				publishmanager.DocumentPublish(ChannelID, insertid, User);
			} else
				publishmanager.OnlyDocumentPublish(ChannelID, insertid, User);

			// 处理荐出
			if (document.hasRecommendOutField)
				ItemUtil.RecommendOutFromField(document, getUser());
			//加入版本库
			ItemUtil2.AddDocVersion(document,channel);
		}

		return 1;
	}

	//0 没权限 1 更新成功 2 更新失败 3 敏感词
	public int UpdateDocument(HashMap request) throws SQLException,MessageException 
	{
		Channel channel = CmsCache.getChannel(ChannelID);
		// System.out.println("updateD:"+ChannelID);
		String Sql = "";
		String UpdateList = "";

		int ItemID = Util.getIntParameter(request, "ItemID");
		if (ItemID == 0)
			return 2;

		setId(ItemID);
		Document doc = CmsCache.getDocument(ItemID, ChannelID);// new
																// Document(ItemID,ChannelID);
		int oldstatus = doc.getStatus();
		setGlobalID(doc.getGlobalID());
		if (doc.getCategoryID() > 0)
			ChannelID = doc.getCategoryID();

		int status = Util.getIntParameter(request, "Status");
		int weight = Util.getIntParameter(request, "Weight");

		if (!CmsCache.getUser(getUser()).hasChannelRight(ChannelID, 2))
			return 0;
		
		if (!CmsCache.getUser(getUser()).hasChannelRight(ChannelID, 3))
			status = 0;

		//检查敏感词
		String s = ItemUtil2.checkWords(request);
		if(s.length()>0)
		{
			Message = s;
			return 3;
		}
		
		Sql = "update " + channel.getTableName() + " set ";
		ArrayList<Field> fields = channel.getFieldInfo();
		if (fields != null && fields.size() > 0
				&& !Util.getParameter(request, "Title").equals("")) {
			for (int i = 0; i < fields.size(); i++) {
				Field field = (Field) fields.get(i);
				String FieldName = field.getName();

				// 如果是禁止编辑
				if (field.getDisableEdit() == 1)
					continue;

				if (field.getIsHide() == 0 && !FieldName.equals("id")
						&& !FieldName.equals("ModifiedUser")//2016.5.6 whl 文章最后修改人
						&& !FieldName.equals("User")
						&& !FieldName.equals("CreateDate")
						&& !FieldName.equals("ModifiedDate")
						&& !FieldName.equals("GenerateFileDate")
						&& !FieldName.equals("Active")
						&& !FieldName.equals("TotalPage")
						&& !FieldName.equals("Status")
						&& !FieldName.equals("Category")
						&& !FieldName.equals("ChannelCode")
						&& !FieldName.equals("GlobalID")
						&& !FieldName.equals("OrderNumber")
						&& !FieldName.equals("Weight")) {
					// print(FieldName);
					if (FieldName.equals("IsPhotoNews")) {
						UpdateList += (UpdateList.equals("") ? "" : ",")
								+ FieldName + "="
								+ Util.getIntParameter(request, FieldName) + "";
					} else if (FieldName.equals("PublishDate")) {
						UpdateList += (UpdateList.equals("") ? "" : ",")
								+ FieldName
								+ "=UNIX_TIMESTAMP('"
								+ SQLQuote(Util
										.getParameter(request, FieldName)
										.trim()) + "')";
					} else {
						String ftype = field.getFieldType();
						if (!(ftype.equals("group_parent")
								|| ftype.equals("group_child") || ftype
									.equals("relation"))) {
							if (field != null
									&& (ftype.equals("checkbox") || ftype
											.equals("checkbox_dict"))) {
								// UpdateList += (UpdateList.equals("") ? "" :
								// ",") + FieldName + "='" +
								// SQLQuote(Util.ArrayToString(request.getParameterValues(FieldName),","))
								// + "'";
								UpdateList += (UpdateList.equals("") ? "" : ",")
										+ FieldName
										+ "='"
										+ SQLQuote(Util.getParameter(request,
												FieldName)) + "'";
							} else if (field != null
									&& field.getFieldType().equalsIgnoreCase(
											"datetime")) {
								if (SQLQuote(
										Util.getParameter(request, FieldName))
										.equals("")) {
									UpdateList += (UpdateList.equals("") ? ""
											: ",") + FieldName + "=null";
								} else {
									UpdateList += (UpdateList.equals("") ? ""
											: ",")
											+ FieldName
											+ "='"
											+ SQLQuote(Util.getParameter(
													request, FieldName)) + "'";
								}
							} else if (field.getFieldType().equals("number"))// 整数类型
							{
								UpdateList += (UpdateList.equals("") ? "" : ",")
										+ FieldName
										+ "="
										+ Util.getIntParameter(request,
												FieldName) + "";
							} else if (field.getFieldType().equals("float"))// 小数类型
							{
								String v = Util.getParameter(request, FieldName);
								//float vv = Util.parseFloat(v);
								//2015.4.23修改 使用float会出错，比如：304194.85
								double vv = Util.parseDouble(v);
								UpdateList += (UpdateList.equals("") ? "" : ",") + FieldName + "=" + vv + "";
							} else if (ftype.equals("recommendout")) 
							{
								// 表单中推荐
								// UpdateList += (UpdateList.equals("")?"":",")
								// + FieldName + "='" +
								// SQLQuote(Util.ArrayToString(request.getParameterValues(FieldName),","))
								// + "'";
								UpdateList += (UpdateList.equals("") ? "" : ",")
										+ FieldName
										+ "='"
										+ SQLQuote((Util.getParameter(request,
												FieldName))) + "'";
							} else {
								if (field.getDataType() == 1) {
									UpdateList += (UpdateList.equals("") ? ""
											: ",")
											+ FieldName
											+ "="
											+ (Util.getIntParameter(request,
													FieldName)) + "";
								} else {
									String v = Util.getParameter(request,
											FieldName);
									if (FieldName.equals("Keyword"))
										v = v.replace("　", " ");
									UpdateList += (UpdateList.equals("") ? ""
											: ",")
											+ FieldName
											+ "='"
											+ SQLQuote(v) + "'";
								}
							}
						}
					}
				}
			}

			UpdateList += (UpdateList.equals("") ? "" : ",")
					+ "ModifiedDate=UNIX_TIMESTAMP(),Weight=" + weight
					+ ",Status=" + status+",ModifiedUser="+ModifiedUser;

			int totalpage = Util.getIntParameter(request, "Page");

			TableUtil tu = channel.getTableUtil();


			Sql += UpdateList;
			Sql += ",TotalPage=" + totalpage;
			Sql += " where id=" + ItemID;
				// System.out.println("update sql:"+Sql);
			try{
				tu.executeUpdate(Sql);
			}catch(SQLException e){
				System.out.println(Sql+"\r\n"+e.getMessage());
				return 2;
			}
			

			if (totalpage > 1) {
				Sql = "delete from document_content where Channel=" + ChannelID
						+ " and Document=" + ItemID;
				executeUpdate(Sql);
			}

			for (int i = 2; i <= totalpage; i++) {
				Sql = "insert into document_content (";

				Sql += "Channel,Document,Content,Page,TotalPage";
				Sql += ") values(";
				Sql += "" + ChannelID + "";
				Sql += "," + ItemID + "";
				Sql += ",'"
						+ SQLQuote(Util.getParameter(request, "Content" + i))
						+ "'";
				Sql += "," + i + "";
				Sql += "," + totalpage + "";

				Sql += ")";

				executeUpdate(Sql);
			}

			
			Document document = new Document(ItemID, ChannelID);// 不需要从缓存获取
			new ItemSnap().Update(document);
			document.setRelatedItemsList(getRelatedItemsList());
			document.AddRelatedItems();// 添加相关文章

			CmsCache.delDocument(ItemID, ChannelID);
			CmsCache.delDocument(document.getGlobalID());

			// 处理父集字段
			ItemUtil.ParentChildItem_(fields, request, getGlobalID(),
					getChannel());

			// 处理关联字段
			// ItemUtil2.RelationFieldItem(fields,request,document.getGlobalID(),getChannel(),2);

			Log l = new Log();
			l.setTitle(document.getTitle());
			l.setUser(getUser());
			l.setItem(ItemID);
			//l.setLogType("编辑文档");
			l.setLogAction(LogAction.document_edit);
			l.setFromType("channel");
			l.setFromKey(ChannelID + "");
			l.Add();

			/* 调用接口 */
			CallApi callapi = new CallApi();
			if (status != oldstatus)
				callapi.setAction(Action.document_update_3);
			else
				callapi.setAction(Action.document_update_2);
			callapi.setItem(document);
			callapi.setGlobalID(document.getGlobalID());
			callapi.setActionUser(getUser());
			callapi.Start();

			String channelcode = document.getChannel().getChannelCode();
			if (status == 1 && (callComment(channelcode)))
				new CallServices().call(document, "");

			PublishManager publishmanager = PublishManager.getInstance();
			if (status == 1 || status != oldstatus) {// 状态发生变化或审核通过
				publishmanager.DocumentPublish(ChannelID, ItemID, User);
			} else
				publishmanager.OnlyDocumentPublish(ChannelID, ItemID, User);

			// 处理表单中的荐出
			if (document.hasRecommendOutField)
				ItemUtil.RecommendOutFromField(document, getUser());
			//加入版本库
			ItemUtil2.AddDocVersion(document,channel);
		}
		
		return 1;
	}

	public void UpdateDocument_(HttpServletRequest request)
			throws SQLException, MessageException {
		Channel channel = CmsCache.getChannel(ChannelID);
		// System.out.println("updateD:"+ChannelID);
		String Sql = "";
		String UpdateList = "";

		int ItemID = Util.getIntParameter(request, "ItemID");
		if (ItemID == 0)
			return;

		setId(ItemID);
		Document doc = CmsCache.getDocument(ItemID, ChannelID);// new
																// Document(ItemID,ChannelID);
		int oldstatus = doc.getStatus();
		setGlobalID(doc.getGlobalID());
		if (doc.getCategoryID() > 0)
			ChannelID = doc.getCategoryID();

		int status = Util.getIntParameter(request, "Status");
		int weight = Util.getIntParameter(request, "Weight");

		if (!CmsCache.getUser(getUser()).hasChannelRight(ChannelID, 3))
			status = 0;

		Sql = "update " + channel.getTableName() + " set ";
		ArrayList<Field> fields = channel.getFieldInfo();
		if (fields != null && fields.size() > 0
				&& !Util.getParameter(request, "Title").equals("")) {
			for (int i = 0; i < fields.size(); i++) {
				Field field = (Field) fields.get(i);
				String FieldName = field.getName();

				// 如果是禁止编辑
				if (field.getDisableEdit() == 1)
					continue;

				if (field.getIsHide() == 0 && !FieldName.equals("id")
						&& !FieldName.equals("User")
						&& !FieldName.equals("CreateDate")
						&& !FieldName.equals("ModifiedDate")
						&& !FieldName.equals("GenerateFileDate")
						&& !FieldName.equals("Active")
						&& !FieldName.equals("TotalPage")
						&& !FieldName.equals("Status")
						&& !FieldName.equals("Category")
						&& !FieldName.equals("ChannelCode")
						&& !FieldName.equals("GlobalID")
						&& !FieldName.equals("OrderNumber")
						&& !FieldName.equals("Weight")) {
					// print(FieldName);
					if (FieldName.equals("IsPhotoNews")) {
						UpdateList += (UpdateList.equals("") ? "" : ",")
								+ FieldName + "="
								+ Util.getIntParameter(request, FieldName) + "";
					} else if (FieldName.equals("PublishDate")) {
						UpdateList += (UpdateList.equals("") ? "" : ",")
								+ FieldName
								+ "=UNIX_TIMESTAMP('"
								+ SQLQuote(Util
										.getParameter(request, FieldName)
										.trim()) + "')";
					} else {
						String ftype = field.getFieldType();
						if (!(ftype.equals("group_parent")
								|| ftype.equals("group_child") || ftype
									.equals("relation"))) {
							if (field != null
									&& (ftype.equals("checkbox") || ftype
											.equals("checkbox_dict"))) {
								UpdateList += (UpdateList.equals("") ? "" : ",")
										+ FieldName
										+ "='"
										+ SQLQuote(Util.ArrayToString(request
												.getParameterValues(FieldName),
												",")) + "'";

							} else if (field != null
									&& field.getFieldType().equalsIgnoreCase(
											"datetime")) {
								if (SQLQuote(
										Util.getParameter(request, FieldName))
										.equals("")) {
									UpdateList += (UpdateList.equals("") ? ""
											: ",") + FieldName + "=null";
								} else {
									UpdateList += (UpdateList.equals("") ? ""
											: ",")
											+ FieldName
											+ "='"
											+ SQLQuote(Util.getParameter(
													request, FieldName)) + "'";
								}
							} else if (field.getFieldType().equals("number"))// 整数类型
							{
								UpdateList += (UpdateList.equals("") ? "" : ",")
										+ FieldName
										+ "="
										+ Util.getIntParameter(request,
												FieldName) + "";
							} else if (field.getFieldType().equals("float"))// 小数类型
							{
								String v = Util
										.getParameter(request, FieldName);
								float vv = Util.parseFloat(v);
								UpdateList += (UpdateList.equals("") ? "" : ",")
										+ FieldName + "=" + vv + "";
							} else if (ftype.equals("recommendout")) {
								// 表单中推荐
								UpdateList += (UpdateList.equals("") ? "" : ",")
										+ FieldName
										+ "='"
										+ SQLQuote(Util.ArrayToString(request
												.getParameterValues(FieldName),
												",")) + "'";
							} else {
								if (field.getDataType() == 1) {
									UpdateList += (UpdateList.equals("") ? ""
											: ",")
											+ FieldName
											+ "="
											+ (Util.getIntParameter(request,
													FieldName)) + "";
								} else {
									String v = Util.getParameter(request,
											FieldName);
									if (FieldName.equals("Keyword"))
										v = v.replace("　", " ");
									UpdateList += (UpdateList.equals("") ? ""
											: ",")
											+ FieldName
											+ "='"
											+ SQLQuote(v) + "'";
								}
							}
						}
					}
				}

			}

			UpdateList += (UpdateList.equals("") ? "" : ",")
					+ "ModifiedDate=UNIX_TIMESTAMP(),Weight=" + weight
					+ ",Status=" + status;

			int totalpage = Util.getIntParameter(request, "Page");

			TableUtil tu = channel.getTableUtil();

			if (!UpdateList.equals("")) {
				Sql += UpdateList;
				Sql += ",TotalPage=" + totalpage;
				Sql += " where id=" + ItemID;
				// System.out.println("update sql:"+Sql);
				tu.executeUpdate(Sql);
			}

			if (totalpage > 1) {
				Sql = "delete from document_content where Channel=" + ChannelID
						+ " and Document=" + ItemID;
				executeUpdate(Sql);
			}

			for (int i = 2; i <= totalpage; i++) {
				Sql = "insert into document_content (";

				Sql += "Channel,Document,Content,Page,TotalPage";
				Sql += ") values(";
				Sql += "" + ChannelID + "";
				Sql += "," + ItemID + "";
				Sql += ",'"
						+ SQLQuote(Util.getParameter(request, "Content" + i))
						+ "'";
				Sql += "," + i + "";
				Sql += "," + totalpage + "";

				Sql += ")";

				executeUpdate(Sql);
			}

			Document document = new Document(ItemID, ChannelID);// 不需要从缓存获取
			new ItemSnap().Update(document);
			document.setRelatedItemsList(getRelatedItemsList());
			document.AddRelatedItems();// 添加相关文章

			CmsCache.delDocument(ItemID, ChannelID);
			CmsCache.delDocument(document.getGlobalID());

			// 处理父集字段
			ItemUtil.ParentChildItem(fields, request, getGlobalID(),
					getChannel());

			// 处理关联字段
			// ItemUtil2.RelationFieldItem(fields,request,document.getGlobalID(),getChannel(),2);

			Log l = new Log();
			l.setTitle(document.getTitle());
			l.setUser(getUser());
			l.setItem(ItemID);
			l.setLogAction(LogAction.document_edit);
			//l.setLogType("编辑文档");
			l.setFromType("channel");
			l.setFromKey(ChannelID + "");
			l.Add();

			/* 调用接口 */
			CallApi callapi = new CallApi();
			if (status != oldstatus)
				callapi.setAction(Action.document_update_3);
			else
				callapi.setAction(Action.document_update_2);
			callapi.setItem(document);
			callapi.setGlobalID(document.getGlobalID());
			callapi.setActionUser(getUser());
			callapi.Start();

			String channelcode = document.getChannel().getChannelCode();
			if (status == 1 && (callComment(channelcode)))
				new CallServices().call(document, "");

			PublishManager publishmanager = PublishManager.getInstance();
			if (status == 1 || status != oldstatus) {// 状态发生变化或审核通过
				publishmanager.DocumentPublish(ChannelID, ItemID, User);
			} else
				publishmanager.OnlyDocumentPublish(ChannelID, ItemID, User);

			// 处理表单中的荐出
			if (document.hasRecommendOutField)
				ItemUtil.RecommendOutFromField(document, getUser());
		}
	}

	public void UpdateGolbalID(int globalID) throws MessageException,
			SQLException {
		Channel channel = CmsCache.getChannel(getChannelID());

		String Sql = "update " + channel.getTableName() + " set GlobalID="
				+ globalID + " where id=" + getId();

		channel.getTableUtil().executeUpdate(Sql);
	}

	public void UpdateWeight(int weight) throws MessageException, SQLException {
		Channel channel = CmsCache.getChannel(getChannelID());

		String Sql = "update " + channel.getTableName() + " set Weight="
				+ weight + " where id=" + getId();

		executeUpdate(Sql);

		PublishManager publishmanager = PublishManager.getInstance();
		publishmanager.DocumentPublish(getCategoryID() > 0 ? getCategoryID()
				: getChannelID(), User);
	}

	public String FormatDate(String pattern, String date) {
		String returnDate = "";
		// java.util.Calendar nowDate = new java.util.GregorianCalendar();
		DateFormat df = new SimpleDateFormat(pattern);

		Date TempDate = null;
		SimpleDateFormat ThisDateFormat = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");
		// 2003/09/19 加入setLenient(true),否则判断会不准确
		ThisDateFormat.setLenient(true);
		try {
			TempDate = ThisDateFormat.parse(date);
			returnDate = df.format(TempDate);
		} catch (ParseException e) {
			return "";
		}

		return returnDate;
	}

	// 用于截断文字
	public String substring(String str, int len) {
		return Util.substring(str, len, "...");
	}

	// 用于截断文字
	public String substring(String str, int len, String str1) {
		return Util.substring(str, len, str1);
	}

	public String UrlEncode(String str) throws UnsupportedEncodingException {
		if (str == null)
			return "";
		str = java.net.URLEncoder.encode(str, "utf-8");
		str = str.replace("%5C", "/");
		return str;
	}

	public String convertNewlines(String input) {
		if (input == null)
			return "";
		String result = StringUtils.replace(input, "\r\n", "<br>");
		return StringUtils.replace(result, "\n", "<br>");
	}

	// 插入广告
	public String AddAd(String str, String ad) {
		if (str == null || str.length() == 0)
			return "";

		int i = str.indexOf("<br /><br />");

		if (i == -1)
			i = str.indexOf("</p>");
		if (i == -1)
			i = str.indexOf("</P>");

		StringBuffer s = new StringBuffer();

		if (i == -1) {
			s.append(str);
			s.append(ad);
		} else {
			s.append(str.substring(0, i));
			s.append(ad);
			s.append(str.substring(i));
		}

		return s.toString();
	}

	public String getFileName() throws MessageException, SQLException {
		return getFileName("");
	}

	public String getFileName(String whereSql) throws MessageException,
			SQLException {
		String filename = "";
		Channel channel = CmsCache.getChannel(ChannelID);
		String FolderName = channel.getFullPath();
		String Sql = "select * from channel_template where Template!='' and TemplateType=2 and Channel="
				+ ChannelID;

		if (!whereSql.equals(""))
			Sql += " and " + whereSql;

		ResultSet Rs = executeQuery(Sql);

		if (Rs.next()) {
			int subfoldertype = Rs.getInt("SubFolderType");
			// String TemplateName = convertNull(Rs.getString("Template"));
			String TargetName = convertNull(Rs.getString("TargetName"));

			boolean absolute_path = false;
			if (TargetName.startsWith("/") || TargetName.startsWith("\\"))
				absolute_path = true;
			int index = TargetName.lastIndexOf("/");
			String FolderOnly = "";
			if (index != -1)
				FolderOnly = TargetName.substring(0, index + 1);

			index = TargetName.lastIndexOf(".");
			String TempFileName = "";
			if (index != -1)
				TempFileName = TargetName.substring(0, index);
			index = TempFileName.lastIndexOf("/");
			if (index != -1)
				TempFileName = TempFileName.substring(index + 1);
			String FileExt = "";
			index = TargetName.lastIndexOf(".");
			if (index != -1)
				FileExt = TargetName.substring(TargetName.lastIndexOf(".") + 1);

			String SubFolder = "";

			if (subfoldertype == 1)
				SubFolder = PublishDate_Year + "/";
			else if (subfoldertype == 2) {
				SubFolder = PublishDate_Year + "/" + PublishDate_Month + "/";
			} else if (subfoldertype == 3) {
				SubFolder = PublishDate_Year + "/" + PublishDate_Month + "/"
						+ PublishDate_Day + "/";
			} else if (subfoldertype == 4) {
				SubFolder = PublishDate_Year + "-" + PublishDate_Month + "-"
						+ PublishDate_Day + "/";
			}

			filename = ((!absolute_path) ? FolderName : FolderOnly)
					+ (FolderName.endsWith("/") ? "" : "/") + SubFolder
					+ TempFileName + "_" + id + "." + FileExt;
		} else
			throw new MessageException("没有设置内容页面模板!");

		return filename;
	}

	/*
	 * 立即发布一个文档
	 */
	public void Publish(String itemid, int channelid) throws MessageException,
			SQLException {
		String[] ids = Util.StringToArray(itemid, ",");
		if (ids != null && ids.length > 0) {
			for (int i = 0; i < ids.length; i++) {
				int id_ = Util.parseInt(ids[i]);

				if (id_ > 0) {
					PublishManager publishmanager = PublishManager
							.getInstance();
					publishmanager.OnlyDocumentPublish(channelid, id_,
							getUser());
				}
			}
		}
	}

	/**
	 * @return Returns the createDate.
	 */
	public String getCreateDate() {
		return CreateDate;
	}

	/**
	 * @param createDate
	 *            The createDate to set.
	 */
	public void setCreateDate(String createDate) {
		CreateDate = createDate;
	}

	public int getStatus() {
		return Status;
	}

	public String getStatusDesc() {
		String StatusDesc = "";
		if (getActive() == 1) {
			if (Status == 0)
				StatusDesc = "<font color=red>待审</font>";
			else if (Status == 1)
				StatusDesc = "<font color=blue>审批通过</font>";
		} else {
			StatusDesc = "<font color=blue>已删除</font>";
		}

		return StatusDesc;
	}

	public void setStatus(int i) {
		Status = i;
	}

	/**
	 * @return Returns the publishDate.
	 */
	public String getPublishDate() {
		return PublishDate;
	}

	/**
	 * @param publishDate
	 *            The publishDate to set.
	 */
	public void setPublishDate(String publishDate) {
		PublishDate = publishDate;
	}

	/**
	 * @return Returns the docFrom.
	 */
	public String getDocFrom() {
		return DocFrom;
	}

	/**
	 * @param docFrom
	 *            The docFrom to set.
	 */
	public void setDocFrom(String docFrom) {
		DocFrom = docFrom;
	}

	/**
	 * @return Returns the page.
	 */
	public int getTotalPage() {
		return TotalPage;
	}

	/**
	 * @param page
	 *            The page to set.
	 */
	public void setTotalPage(int page) {
		TotalPage = page;
	}

	/**
	 * @return Returns the docPage.
	 */
	public int getCurrentPage() {
		return CurrentPage;
	}

	/**
	 * @param docPage
	 *            The docPage to set.
	 */
	public void setCurrentPage(int docPage) {
		CurrentPage = docPage;
	}

	public boolean hasNext() {
		if (CurrentPage < TotalPage)
			return true;
		else
			return false;
	}

	public boolean hasPrevious() {
		if (CurrentPage > 1)
			return true;
		else
			return false;
	}

	/**
	 * @return Returns the isPhotoNews.
	 */
	public int getIsPhotoNews() {
		return IsPhotoNews;
	}

	/**
	 * @param isPhotoNews
	 *            The isPhotoNews to set.
	 */
	public void setIsPhotoNews(int isPhotoNews) {
		IsPhotoNews = isPhotoNews;
	}

	/**
	 * @return Returns the categoryID.
	 */
	public int getCategoryID() {
		return CategoryID;
	}

	/**
	 * @param categoryID
	 *            The categoryID to set.
	 */
	public void setCategoryID(int categoryID) {
		CategoryID = categoryID;
	}

	/**
	 * @return Returns the modifiedDate.
	 */
	public String getModifiedDate() {
		return ModifiedDate;
	}

	/**
	 * @param modifiedDate
	 *            The modifiedDate to set.
	 */
	public void setModifiedDate(String modifiedDate) {
		ModifiedDate = modifiedDate;
	}

	/**
	 * @return Returns the active.
	 */
	public int getActive() {
		return Active;
	}

	/**
	 * @param active
	 *            The active to set.
	 */
	public void setActive(int active) {
		Active = active;
	}

	/**
	 * @return Returns the indexFileExt.
	 */
	public String getIndexFileExt() {
		return IndexFileExt;
	}

	/**
	 * @param indexFileExt
	 *            The indexFileExt to set.
	 */
	public void setIndexFileExt(String indexFileExt) {
		IndexFileExt = indexFileExt;
	}

	/**
	 * @return Returns the indexFileName.
	 */
	public String getIndexFileName() {
		return IndexFileName;
	}

	/**
	 * @param indexFileName
	 *            The indexFileName to set.
	 */
	public void setIndexFileName(String indexFileName) {
		IndexFileName = indexFileName;
	}

	public String getHref() throws MessageException, SQLException {
		return getHref(getTemplateLabel());
	}

	// 文档的链接地址
	public String getHref(String templateLabel, int itemid)	throws MessageException, SQLException {
		// 获取和文档直接相关的频道(比如分类) 2011-09-08
		ChannelTemplate ct = getChannel().getChannelTemplates(2, templateLabel);

		if (ct.getTemplateFile().getType() == 1) {
			int cid = getChannelID();
			if (getCategoryID() > 0)
				cid = getCategoryID();
			return "/content.jsp?channel=" + cid + "&id=" + getId();
		} else
			return getHref(ct, itemid);
	}

	// 文档的链接地址
	//<option value="0">系统默认</option>
	//<option value="1">按年份命名，每年一个目录</option>
	//<option value="2">按年月命名，每月一个目录</option>
	//<option value="3">按年月日命名，每日一个目录</option>
	//<option value="4">按每天一个目录(如/2018-08-08/)</option>
	//<option value="6">按每天一个目录(如/20180808/)</option>
	//<option value="5">按文档指定目录</option>
	public String getHref(ChannelTemplate ct, int itemid) throws MessageException, SQLException {
		String href = "";

		//没有模板的情况
		if(ct.getId()==0)
			return "";

		String SubFolder = "";
		
		String PublishDate_Month_ = "";
		String PublishDate_Day_ = "";
		
		if(PublishDate_Month<10)
			PublishDate_Month_ = "0" + PublishDate_Month;
		else
			PublishDate_Month_ = PublishDate_Month + "";
		
		if(PublishDate_Day<10)
			PublishDate_Day_ = "0" +PublishDate_Day;
		else
			PublishDate_Day_ = PublishDate_Day + "";
		
		if (ct.getSubFolderType() == 1)
			SubFolder = PublishDate_Year + "/";
		else if (ct.getSubFolderType() == 2) {
			SubFolder = PublishDate_Year + "/" + PublishDate_Month + "/";
		} else if (ct.getSubFolderType() == 3) {
			SubFolder = PublishDate_Year + "/" + PublishDate_Month + "/" + PublishDate_Day + "/";
		} else if (ct.getSubFolderType() == 4) {
			SubFolder = PublishDate_Year + "-" + PublishDate_Month + "-" + PublishDate_Day + "/";
		} else if (ct.getSubFolderType() == 5) {
			SubFolder = getValue("TideCMS_Path") + "/";
		} else if (ct.getSubFolderType() == 6) {
			SubFolder = PublishDate_Year + "" + PublishDate_Month_ + "" + PublishDate_Day_ + "/";	
		}
		
		// print("subfolder:"+ct.getSubFolderType()+",filename:"+ct.getFileNameType());
		String filePreName = "";
		if (ct.getFileNameType() == 0) {
			if (ct.getItemFilePrefix().equals(""))
				filePreName = getId() + "";
			else
				filePreName = ct.getItemFilePrefix() + "_" + getId();
		} else if (ct.getFileNameType() == 1) {
			filePreName = getTitle();
		} else if (ct.getFileNameType() == 2) {
			int random = getRandom();
			filePreName = CreateDateL + "" + random;
		} else if (ct.getFileNameType() == 3) {
			String fieldname = "TideCMS_FileName";
			if (ct.getFileNameField().length() > 0)
				fieldname = ct.getFileNameField();
			filePreName = getValue(fieldname);
		} else if (ct.getFileNameType() == 4) {
			try {
				Velocity.init();
				VelocityContext context = new VelocityContext();
				context.put("util", new Util());
				context.put("item", this);
				StringWriter w = new StringWriter();
				String t = CmsCache.getParameterValue("sys_custom_filename");
				Velocity.evaluate(context, w, "mystring", t);
				filePreName = w + "";
				// System.out.println("execute:"+api.getTemplate());
			} catch (Exception e) {
				ErrorLog.SaveErrorLog("定制文件名规则错误.", e.getMessage(), 0, e);
			}
		}

		href = ((!ct.isAbsolutePath()) ? "" : ct.getFolderOnly())
				+ SubFolder
				+ filePreName
				+ "."
				+ (ct.getItemFileExt().equals("") ? "htm" : ct.getItemFileExt());

		return href;
	}

	// 文档的链接地址
	public String getHref(String templateLabel) throws MessageException,SQLException {
		return getHref(templateLabel, getId());
	}

	// 文档的链接地址
	public String getHref(int itemid) throws MessageException, SQLException {
		return getHref(getTemplateLabel(), itemid);
	}

	public String getFullHref() throws MessageException, SQLException {
		String href = getHref();
		// System.out.println(href);
		if (href.length()==0 || href.startsWith("/"))
			return href;
		else
			return getFullPath() + (getFullPath().endsWith("/") ? "" : "/")
					+ href;
	}

	public String getFullHref(String templateLabel) throws MessageException,SQLException {
		String href = getHref(templateLabel);
		if (href.startsWith("/"))
			return href;
		else
			return getFullPath() + (getFullPath().endsWith("/") ? "" : "/")
					+ href;
	}

	public String getFullHref(ChannelTemplate ct) throws MessageException,SQLException {
		String href = getHref(ct, getId());
		if (href.startsWith("/"))
			return href;
		else
			return getFullPath() + (getFullPath().endsWith("/") ? "" : "/")
					+ href;
	}

	// 完整的域名链接
	public String getHttpHref() throws MessageException, SQLException 
	{
		return Util.ClearPath(getChannel().getSite().getExternalUrl() + getFullHref());
	}

	// 完整的域名链接
	public String getHttpHref(String templateLabel) throws MessageException, SQLException 
	{
		return Util.ClearPath(getChannel().getSite().getExternalUrl() + getFullHref(templateLabel));
	}
	
	// 单个文档中的分页链接
	public String getDocPageHref(int page) throws MessageException,
			SQLException {
		String href = getFullHref();

		if (page > 1) {
			int i = href.lastIndexOf(".");
			if (i != -1) {
				href = href.substring(0, i) + "_" + page + href.substring(i);
			}
		}

		return href;
	}

	// 下一页分页链接
	public String getNextDocPageHref() throws MessageException, SQLException {
		return getDocPageHref(getCurrentPage() + 1);
	}

	// 上一页分页链接
	public String getPrevDocPageHref() throws MessageException, SQLException {
		return getDocPageHref(getCurrentPage() - 1);
	}

	// 下一篇文档链接
	public String getNextDocFullHref() throws MessageException, SQLException {
		return getFullPath()
				+ (getFullPath().endsWith("/") ? "" : "/")
				+ getHref(getPrevItemID(getOrderNumber(), getChannelID(),
						"next"));
	}

	// 上一篇文档链接
	public String getPrevDocFullHref() throws MessageException, SQLException {
		return getFullPath()
				+ (getFullPath().endsWith("/") ? "" : "/")
				+ getHref(getPrevItemID(getOrderNumber(), getChannelID(),
						"prev"));
	}
	
	//返回二维码地址
	public String getQRCode() throws MessageException, SQLException
	{
		String http = getChannel().getSite().getExternalUrl();
		if(http.length()==0)
			return "";
		
		if(getId()==0)
			return "";
		
		if(getFullHref().length()==0)
			return "";
		
		return http + "/qrcode/" + PublishDate_Year + "/" + PublishDate_Month + "/" + PublishDate_Day + "/" + getChannel().getId()+"_"+getId()+".png";
	}

	/**
	 * @return Returns the subFolderType.
	 */
	public int getSubFolderType() {
		return SubFolderType;
	}

	/**
	 * @param subFolderType
	 *            The subFolderType to set.
	 */
	public void setSubFolderType(int subFolderType) {
		SubFolderType = subFolderType;
	}

	/**
	 * @return Returns the publishDate_Day.
	 */
	public int getPublishDate_Day() {
		return PublishDate_Day;
	}

	/**
	 * @param publishDate_Day
	 *            The publishDate_Day to set.
	 */
	public void setPublishDate_Day(int publishDate_Day) {
		PublishDate_Day = publishDate_Day;
	}

	/**
	 * @return Returns the publishDate_Month.
	 */
	public int getPublishDate_Month() {
		return PublishDate_Month;
	}

	/**
	 * @param publishDate_Month
	 *            The publishDate_Month to set.
	 */
	public void setPublishDate_Month(int publishDate_Month) {
		PublishDate_Month = publishDate_Month;
	}

	/**
	 * @return Returns the publishDate_Year.
	 */
	public int getPublishDate_Year() {
		return PublishDate_Year;
	}

	/**
	 * @param publishDate_Year
	 *            The publishDate_Year to set.
	 */
	public void setPublishDate_Year(int publishDate_Year) {
		PublishDate_Year = publishDate_Year;
	}

	public void CopyDocuments(String itemid, int ChannelID_Source,
			int ChannelID_Dest, int type) throws SQLException, MessageException {
		ItemUtil.CopyDocuments(itemid, ChannelID_Source, ChannelID_Dest, type,
				getId(), getUser());
	}

	/**
	 * @return Returns the contentArray.
	 */
	public ArrayList<String> getContentArray() {
		return ContentArray;
	}

	/**
	 * @param contentArray
	 *            The contentArray to set.
	 */
	public void setContentArray(ArrayList<String> contentArray) {
		ContentArray = contentArray;
	}

	/**
	 * @return Returns the summary.
	 */
	public String getSummary() {
		return Summary;
	}

	/**
	 * @param summary
	 *            The summary to set.
	 */
	public void setSummary(String summary) {
		Summary = summary;
	}

	/**
	 * @return Returns the generatePageDate.
	 */
	public String getGeneratePageDate() {
		return GeneratePageDate;
	}

	/**
	 * @param generatePageDate
	 *            The generatePageDate to set.
	 */
	public void setGeneratePageDate(String generatePageDate) {
		GeneratePageDate = generatePageDate;
	}

	/**
	 * @return Returns the fullPath.
	 */
	public String getFullPath() {
		return FullPath;
	}

	/**
	 * @param fullPath
	 *            The fullPath to set.
	 */
	public void setFullPath(String fullPath) {
		FullPath = fullPath;
	}

	// 上一篇文档对象
	public Document getPrevDocument() throws SQLException, MessageException {
		int itemid = getPrevItemID();
		Document document = CmsCache.getDocument(itemid, getChannelID());// new
																			// Document(itemid,
																			// getChannelID());
		return document;
	}

	// 下一篇文档对象
	public Document getNextDocument() throws SQLException, MessageException {
		int itemid = getNextItemID();
		Document document = CmsCache.getDocument(itemid, getChannelID());// new
																			// Document(itemid,
																			// getChannelID());
		return document;
	}

	// 上一篇文档编号
	public int getPrevItemID() throws SQLException, MessageException {
		return getPrevItemID(getOrderNumber(), getChannelID(), "prev");
	}

	// 下一篇文档编号
	public int getNextItemID() throws SQLException, MessageException {
		return getPrevItemID(getOrderNumber(), getChannelID(), "next");
	}

	public int getPrevItemID(long ordernumber, int channelid, String action)
			throws SQLException, MessageException {
		int newid = 0;
		Channel channel = CmsCache.getChannel(channelid);

		String Symbol1 = "";
		String Symbol2 = "";
		if (action.equals("prev"))// Up,择该记录上方的记录
		{
			Symbol1 = ">";
			Symbol2 = "asc";
		} else if (action.equals("next")) // 选择该记录下方的记录
		{
			Symbol1 = "<";
			Symbol2 = "desc";
		} else
			return 0;

		String Sql = "select id from " + channel.getTableName()
				+ " where Active=1 ";

		if (channel.getType() == Channel.Category_Type)
			Sql += " and Category=" + channel.getId();
		else
			Sql += " and Category=0 ";

		Sql += " and Status=1 and OrderNumber";
		Sql += Symbol1 + ordernumber + " order by OrderNumber " + Symbol2
				+ ",id " + Symbol2 + " limit 0,1";

		// System.out.println(Sql);
		ResultSet Rs = executeQuery(Sql);
		if (Rs.next()) {
			newid = Rs.getInt("id");
		}
		closeRs(Rs);

		return newid;
	}

	public long getOrderNumber() {
		return OrderNumber;
	}

	public void setOrderNumber(long orderNumber) {
		OrderNumber = orderNumber;
	}

	public String getTemplateLabel() {
		return TemplateLabel;
	}

	public void setTemplateLabel(String templateLabel) {
		// 转换成小写
		TemplateLabel = templateLabel.toLowerCase();
	}

	public String getSubTitle() {
		return SubTitle;
	}

	public void setSubTitle(String subTitle) {
		SubTitle = subTitle;
	}

	public String getKeyword() {
		return Keyword;
	}

	public void setKeyword(String keyword) {
		Keyword = keyword;
	}

	public String getTag() {
		return Tag;
	}

	public void setTag(String tag) {
		Tag = tag;
	}

	public int getGlobalID() {
		return GlobalID;
	}

	public void setGlobalID(int globalID) {
		GlobalID = globalID;
	}

	public void AddRelatedItems() throws MessageException, SQLException {
		String sql = "";
		TableUtil tu = new TableUtil();

		String[] id_array = Util.StringToArray(RelatedItemsList, ",");
		// print(RelatedItemsList);
		// String[] title_array = Util.StringToArray(titlelist,",");

		// if(id_array.length!=title_array.length)
		// return;
		Parameter p = CmsCache.getParameter("sys_related_doc_twoway");

		sql = "delete from related_doc where GlobalID= " + GlobalID;
		tu.executeUpdate(sql);

		if (p.getIntValue() == 1) {
			sql = "delete from related_doc where RelatedGlobalID= " + GlobalID;
			tu.executeUpdate(sql);
		}

		int cid = 0;
		if (getCategoryID() > 0)
			cid = getCategoryID();
		else
			cid = getChannelID();

		for (int i = 0; i < id_array.length; i++) {
			int relatedGlobalID = Util.parseInt(id_array[i]);
			if (id != relatedGlobalID) {

				ItemSnap snap = new ItemSnap(relatedGlobalID);
				sql = "insert into related_doc(GlobalID,ChannelID,RelatedGlobalID,RelatedTitle,RelatedOrder,RelatedChannelID,RelatedItemID,RelatedStatus) ";
				sql += " values(" + GlobalID + "," + cid + ","
						+ relatedGlobalID + ",'" + SQLQuote(snap.getTitle())
						+ "'," + i + "," + snap.getChannelID() + ","
						+ snap.getItemID() + ",1)";
				// System.out.println(sql);
				tu.executeUpdate(sql);

				if (p.getIntValue() == 1) {
					// 双向关联
					int related_order = 1;
					sql = "select max(RelatedOrder) from related_doc where GlobalID="
							+ relatedGlobalID;
					ResultSet rs = tu.executeQuery(sql);
					if (rs.next()) {
						related_order = rs.getInt(1);
					}
					tu.closeRs(rs);

					sql = "insert into related_doc(GlobalID,ChannelID,RelatedGlobalID,RelatedTitle,RelatedOrder,RelatedChannelID,RelatedItemID,RelatedStatus) ";
					sql += " values(" + relatedGlobalID + ","
							+ snap.getChannelID() + "," + GlobalID + ",'"
							+ SQLQuote(getTitle()) + "'," + related_order + ","
							+ cid + "," + id + "," + Status + ")";
					// System.out.println(sql);
					tu.executeUpdate(sql);
				}
			}
		}
	}

	public String getRelatedItemsList() {
		return RelatedItemsList;
	}

	public void setRelatedItemsList(String relatedItemsList) {
		RelatedItemsList = relatedItemsList;
	}

	// 相关文章
	public ArrayList<RelatedItem> listRelatedDoc() throws SQLException,
			MessageException {
		return new ItemSnap(getGlobalID()).listRelatedDoc(0);
	}

	// 相关文章
	public ArrayList<RelatedItem> listRelatedDoc(int number)
			throws SQLException, MessageException {
		return new ItemSnap(getGlobalID()).listRelatedDoc(number);
	}

	// 获取文档所在的频道对象，也可能是分类频道
	public Channel getChannel() throws MessageException, SQLException {
		if (getCategoryID() > 0)
			return CmsCache.getChannel(getCategoryID());
		else
			return CmsCache.getChannel(getChannelID());
	}

	// 获取频道对象
	public int getTableChannelID() throws MessageException, SQLException {
		if (getCategoryID() > 0)
			return CmsCache.getChannel(getCategoryID()).getTableChannelID();
		else
			return CmsCache.getChannel(getChannelID()).getTableChannelID();
	}

	public ArrayList<Document> listChildItems() throws MessageException,SQLException {
		return ItemUtil.listChildItems(getGlobalID());
	}

	public ArrayList<Document> listLinkChildItems(int link_channelid) throws MessageException, SQLException {
		return ItemUtil.listLinkChildItems(getTableChannelID(), link_channelid,getGlobalID());
	}
	
	public ArrayList<Document> listLinkChildItems_() throws MessageException, SQLException {
		return ItemUtil.listLinkChildItems_(getTableChannelID(),getGlobalID());
	}

	// 针对某个频道取子文档
	public ArrayList<Document> listChildItems(int channelid) throws MessageException, SQLException {
		return ItemUtil.listChildItems(getGlobalID(), channelid,"");
	}

	// 针对某个频道取子文档,自定义sql语句
	public ArrayList<Document> listChildItems(int channelid,String wheresql) throws MessageException, SQLException {
		return ItemUtil.listChildItems(getGlobalID(), channelid,wheresql);
	}
	
	// 针对某个频道取子文档
	public ArrayList<Document> listChildItemsByItemID(int channelid) throws MessageException, SQLException {
		return ItemUtil.listChildItems(getId(), channelid,"");
	}

	// 针对某个频道取子文档，自定义sql语句
	public ArrayList<Document> listChildItemsByItemID(int channelid,String wheresql) throws MessageException, SQLException {
		return ItemUtil.listChildItems(getId(), channelid,wheresql);
	}
	
	public Document getParentItem() throws MessageException, SQLException {
		return ItemUtil.getParentItem(getGlobalID());
	}

	// 获取itemutil类，模板中使用
	public ItemUtil getItemUtil() {
		return new ItemUtil();
	}

	public void setRandom(int random) {
		Random = random;
	}

	public int getRandom() {
		return Random;
	}

	public void updateRandom(int random) throws MessageException, SQLException {
		String sql = "update " + getChannel().getTableName() + " set Random="
				+ random + " where id=" + id;

		TableUtil tu = new TableUtil();
		tu.executeUpdate(sql);

		setRandom(random);
	}

	public void setWeight(int weight) {
		Weight = weight;
	}

	public int getWeight() {
		return Weight;
	}

	public long getCreateDateL() {
		return CreateDateL;
	}

	public void setCreateDateL(long createDateL) {
		CreateDateL = createDateL;
	}

	public boolean callComment(String channelcode) throws MessageException,
			SQLException {
		return ItemUtil.callComment(channelcode);
	}

	public void setModifiedDateL(long modifiedDateL) {
		ModifiedDateL = modifiedDateL;
	}

	public long getModifiedDateL() {
		return ModifiedDateL;
	}

	public boolean isHasRecommendOutField() {
		return hasRecommendOutField;
	}

	public void setHasRecommendOutField(boolean hasRecommendOutField) {
		this.hasRecommendOutField = hasRecommendOutField;
	}

	public void setPublishDateL(long publishDateL) {
		PublishDateL = publishDateL;
	}

	public long getPublishDateL() {
		return PublishDateL;
	}

	public String getMessage() {
		return Message;
	}

	public void setMessage(String message) {
		Message = message;
	}

	public int getModifiedUser() {
		return ModifiedUser;
	}

	public void setModifiedUser(int modifiedUser) {
		ModifiedUser = modifiedUser;
	}

	public int getDocTop() {
		return DocTop;
	}

	public void setDocTop(int docTop) {
		DocTop = docTop;
	}

	public int getApproveStatus() {
		return ApproveStatus;
	}

	public void setApproveStatus(int approveStatus) {
		ApproveStatus = approveStatus;
	}
}