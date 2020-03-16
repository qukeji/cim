/*
 * Created on 2004-8-13
 *
 */
package tidemedia.cms.system;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.PageControl;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.service.channel.ChannelListFastSearchService;
import tidemedia.tcenter.service.channel.ChannelListHeaderService;
import tidemedia.tcenter.service.channel.ChannelListMenuService;
import tidemedia.tcenter.service.channel.ChannelListSearchService;

import java.io.IOException;
import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;


/**
 * @author 李永海(yonghai2008@gmail.com)
 * 
 */
public class Channel extends Table implements Serializable {

	/**
	 * 序列化id
	 */
	private static final long serialVersionUID = 152006850101337678L;

	public static final int Channel_Type = 0;//独立表单频道
	public static final int Category_Type = 1;//继承表单频道
	public static final int Page_Type = 2;//页面
	public static final int Application_Type = 3;//应用
	public static final int MirrorChannel_Type = 4;//镜像
	public static final int Site_Type = 5;//站点
	public static final int User_Type = 6;//用户
	
	public static final int	Content_Channel_Type2 = 8;//内容中心频道
	public static final int	Source_Channel_Type2 = 9;//稿源频道
	
	public static final int	ChannelNormal = 0;//普通频道
	public static final int	ChannelPhoto = 1;//图片频道
	public static final int ChannelPhotoCollect = 2;//图片集合频道
	public static final int	ChannelSpecial = 3;//专题频道
	
	private int 		id;
	private int 		ActionUser;
	private String 		Name = "";
	private String 		FolderName = "";
	private String 		ImageFolderName = "";// 图片上传目录
	private int			ImageFolderType = 0;//图片目录规则
	private String 		FullPath = "";
	private String 		SerialNo = "";
	private String 		OldSerialNo = "";
	private int 		Parent;
	private int 		OrderNumber;
	private String 		Href = "";// 链接
	private String 		Attribute1 = "";// 引用频道
	private String 		Attribute2 = "";// 引用频道对应关系
	private String 		RecommendOut = "";//荐出频道
	private String 		RecommendOutRelation = "";//荐出频道对应关系
	private String		Extra1 = "";//附加属性
	private String		Extra2 = "";//附加属性
	private String 		ChannelCode = "";//频道代码
	private String		ListJS = "";//列表页脚本
	private String		DocumentJS = "";//内容页脚本
	private String		ListProgram = "";//列表页程序
	private String		ListSearchField = "";//列表页搜索字段
	private String		ListShowField = "";//列表页显示字段
	private String		DocumentProgram = "";//内容页程序
	private String		DataSource = "";//数据源
	private String		ListSql = "";//sql语句
	private String		Icon = "";//图标
	private int 		IsDisplay = 1;
	private int			IsWeight = 0;//是否使用权重
	private int			IsComment = 0;//是否显示评论
	private int			IsClick = 0;//是否显示点击数
	private int			IsShowDraftNumber = 0;//是否显示草稿数
	private int			IsListAll = 0;//列表页是否包含子频道内容
	private int			IsTop	= 0;//是否置顶
	private int			IsPublishFile = 0;//审核文件发布（附加模板）
	private int			IsImportWord = 0;//是否导入word
	private int			IsExportExcel = 0;//是否导出excel
	private int			ApproveScheme = 0;//发布方案编号
	private int			company = 0;//租户编号
	private String		application = "";
	private int 		Version=0;//是否开启版本/1未开启 0开启 默认为1
	


	private int			ViewType = 0;//默认视图类型，0 文字 1 详细 2 图片 
	private int 		CanCategory = 0;
	private int 		Type;
	// Type==0 独立表单频道 Type==1 继承表单的频道 或 分类 Type==2 页面 Type==3 应用 Type==4 镜像频道 Type==5 站点
	private int			Type2;
	// 频道的附加属性 0 普通频道 8 内容管理频道
	private int 		SiteID;
	private int 		ChannelType_ForAdd = 0;// 2005-11-17 去掉频道类型的选择

	// <option value="1">图片新闻类型</option>
	// <option value="2">图片广告类型</option>
	// <option value="3">文字链接类型</option>
	private int 		TemplateInherit = 0;// 频道是否继承上级模板 1 继承 0 不继承

	private int 		ParentTableChannelID = 0;// 继承表单的频道的表单频道

	private String 		TableName = "";// 对应的表名
	private int			TableChannelID = 0;//对应的独立表单频道编号，ParentTableChannelID以后作废，2012-3-31
	private int 		LinkChannelID;//镜像到的频道
	private int			CopyFromID;//复制频道的源地址
	private boolean		hasFieldRecommend = false;//是否有推荐字段

	private ArrayList<Field> FieldInfo = null;//字段集合
	private ArrayList<FieldGroup> FieldGroupInfo = null;//表单组集合
	private ArrayList<Integer> childChannelIDs = null;//子频道集合 不包括在导航中不出现的
	private ArrayList<Integer> childAllChannelIDs = new ArrayList();//所有的子频道集合
	private ArrayList<Integer> MirrorChannelIDs = null;//镜像频道集合
	private ArrayList<ChannelTemplate> channelTemplates = null;//模板集合
	
	private ArrayList attributes = new ArrayList();//频道的扩展属性

	private int IsListConfig = 0;//是否继承列表配置 (0: 是  1:否  默认值0)

	private Company companyInfo = new Company();//租户对象20200303添加
	
	// private ArrayList FieldDescArray = new ArrayList();

	public Channel() throws MessageException, SQLException {
		super();
	}

	public Channel(int id) throws MessageException, SQLException {
		
		String Sql = "select * from channel where id=" + id;

		if (id == 0)
			Sql = "select * from channel where Parent=-1 and Type="+ Channel.Site_Type;
		
		if(id==-1)
		{
			setId(-1);
			setChildChannelIDs();
		}
		else
		{
			initChannel(Sql);
		}
	}

	public void initChannel(String Sql) throws SQLException, MessageException {
		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(Sql);
		if (Rs.next()) {
			setId(Rs.getInt("id"));
			setType(Rs.getInt("Type"));
			setType2(Rs.getInt("Type2"));
			setSiteID(Rs.getInt("Site"));
			setName(convertNull(Rs.getString("Name")));
			setFolderName(convertNull(Rs.getString("FolderName")));
			setImageFolderName(convertNull(Rs.getString("ImageFolderName")));
			setImageFolderType((Rs.getInt("ImageFolderType")));
			setSerialNo(convertNull(Rs.getString("SerialNo")));
			setOldSerialNo(convertNull(Rs.getString("SerialNo")));
			setChannelCode(convertNull(Rs.getString("ChannelCode")));
			setListJS(convertNull(Rs.getString("ListJS")));
			setDocumentJS(convertNull(Rs.getString("DocumentJS")));
			setListProgram(convertNull(Rs.getString("ListProgram")));
			setListSearchField(convertNull(Rs.getString("ListSearchField")));
			setListShowField(convertNull(Rs.getString("ListShowField")));
			setDocumentProgram(convertNull(Rs.getString("DocumentProgram")));
			setListSql(convertNull(Rs.getString("ListSql")));
			setIcon(convertNull(Rs.getString("Icon")));
			setParent(Rs.getInt("Parent"));
			setOrderNumber(Rs.getInt("OrderNumber"));
			setIsDisplay(Rs.getInt("IsDisplay"));
			setIsWeight(Rs.getInt("IsWeight"));
			setIsComment(Rs.getInt("IsComment"));
			setIsClick(Rs.getInt("IsClick"));
			setIsShowDraftNumber(Rs.getInt("IsShowDraftNumber"));
			setIsListAll(Rs.getInt("IsListAll"));
			setIsTop(Rs.getInt("IsTop"));
			setIsPublishFile(Rs.getInt("IsPublishFile"));
			setIsExportExcel(Rs.getInt("IsExportExcel"));
			setIsImportWord(Rs.getInt("IsImportWord"));
			setViewType(Rs.getInt("ViewType"));
			setCanCategory(Rs.getInt("CanCategory"));
			setTemplateInherit(Rs.getInt("TemplateInherit"));
			setApproveScheme(Rs.getInt("ApproveScheme"));
			setCompany(Rs.getInt("company"));
			setApplication(convertNull(Rs.getString("application")));
			setVersion(Rs.getInt("Version"));
			setIsListConfig(Rs.getInt("IsListConfig"));
			setCompanyInfo(CmsCache.getCompany(Rs.getInt("company")));//租户对象20200303添加
			if(getType()== Channel.Category_Type)
				setDataSource(CmsCache.getChannel(getParent()).getDataSource());
			else
				setDataSource(convertNull(Rs.getString("DataSource")));
			
			setCopyFromID(Rs.getInt("CopyFromID"));
			
			if(Type== Channel.Page_Type)//如果是页面
			{
				setFullPath(CmsCache.getChannel2(Parent).getFullPath());
			}
			else
				setFullPath(convertNull(Rs.getString("FullPath")));
			
			setHref(convertNull(Rs.getString("Href")));
			setExtra1(convertNull(Rs.getString("Extra1")));
			setExtra2(convertNull(Rs.getString("Extra2")));
			setLinkChannelID(Rs.getInt("LinkChannel"));
			ChannelRecommend channelRecommend = new ChannelRecommend();
			String Attribute1 = convertNull(Rs.getString("Attribute1"));
			String RecommendOut = convertNull(Rs.getString("RecommendOut"));

			if(!Attribute1.equals("***")){
				Attribute1 = channelRecommend.getInSerialNo(id);
			}
			setAttribute1(Attribute1);
			setAttribute2(convertNull(Rs.getString("Attribute2")));

			if(!RecommendOut.equals("***")){
				RecommendOut = channelRecommend.getOutSerialNo(id);
			}
			setRecommendOut(RecommendOut);
			setRecommendOutRelation(convertNull(Rs.getString("RecommendOutRelation")));

		}
		else{tu.closeRs(Rs);throw new MessageException("This channel is not exist! "+Sql);}
		
		tu.closeRs(Rs);

		if(getId()>0)
		{
			initTableName();
			ChannelUtil.initFieldGroupInfo(this);
			ChannelUtil.initFieldInfo(this);
			setChildChannelIDs();
			initMirrorChannelIDs();
			ChannelUtil.initChannelTemplates(this);
			//initAttribute();
		}
		
	}

	public void initParentTableChannel(int channelid) throws SQLException, MessageException {
		String Sql = "select * from channel where id=" + channelid;

		ResultSet Rs = executeQuery(Sql);

		if (Rs.next()) {
			int i = Rs.getInt("id");
			int type = Rs.getInt("Type");
			int parent = Rs.getInt("Parent");
			if (type == Channel.Channel_Type || type == Channel.Site_Type) {
				setTableName("channel_" + convertNull(Rs.getString("SerialNo")));
				setTableChannelID(i);
				setParentTableChannelID(i);
				closeRs(Rs);
			} else if (type == Channel.Category_Type || type == Channel.Page_Type) {
				closeRs(Rs);
				initParentTableChannel(parent);
			}
		}
	}

	public void initTableName() throws SQLException, MessageException
	{
		if (Type == Channel.Channel_Type || Type == Channel.Application_Type || Type == Channel.Site_Type)
		{
			setTableName("channel_" + getSerialNo());
			setTableChannelID(getId());
		}
		else if (Type == Channel.Category_Type || Type == Channel.Page_Type)// 继承表单
			initParentTableChannel(getParent());
		else if(Type == Channel.MirrorChannel_Type)
		{
			Channel c = CmsCache.getChannel(getLinkChannelID());
			setTableName(c.getTableName());
			setTableChannelID(c.getId());
		}
	}
	
	public void Add() throws SQLException, MessageException {

		String Sql = "";
		// String Path = "";

		String ch = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789";
		if (Type == 0) {// 频道要检查标识名
			for (int i = 0; i < SerialNo.length(); i++) {
				boolean exist = false;
				for (int j = 0; j < ch.length(); j++) {
					if (SerialNo.charAt(i) == ch.charAt(j)) {
						exist = true;
					}
				}

				if (!exist)
					throw new MessageException("具有独立表单的频道的标识名必须由英文字母，数字或下划线组成!", 4);
			}
		}

		Sql = "select * from channel where SerialNo='" + SQLQuote(SerialNo)
				+ "'";
		// System.out.println(Sql);
		if (isExist(Sql)) {
			throw new MessageException("标识名已经被使用!", 4);
		}

		if(getParent()!=-1)
		{
			Channel parentChannel = CmsCache.getChannel(getParent());
	
			// 设置完整路径
			if (getFolderName().startsWith("/"))
				FullPath = getFolderName();
			else {
				if (getFolderName().equals(""))
					FullPath = parentChannel.getFullPath();
				else
					FullPath = parentChannel.getFullPath()
							+ ((parentChannel.getFullPath().endsWith("/")) ? "" : "/")
							+ getFolderName();
			}// fullpath = fullpath.replace("//","/");
			
			//路径后面带上/
			if(!FullPath.endsWith("/")) FullPath += "/";
			
			setSiteID(parentChannel.getSiteID());
		}
		
		if(Parent==0) Parent = -1;

		Sql = "insert into channel (";

		Sql += "Name,FolderName,ImageFolderName,ImageFolderType,FullPath,SerialNo,Href,";
		Sql += "Attribute1,Attribute2,RecommendOut,RecommendOutRelation,Extra1,Extra2,";
		Sql += "ListJS,DocumentJS,ListProgram,DocumentProgram,ListSearchField,ListShowField,DataSource,Icon,Parent,IsDisplay,";
		Sql += "IsWeight,IsComment,IsClick,IsShowDraftNumber,IsListAll,IsTop,ViewType,CanCategory,Type,Type2,IsPublishFile,";
		Sql += "IsExportExcel,IsImportWord,";
		Sql += "Site,LinkChannel,CopyFromID,TemplateInherit,CreateDate,Status,ApproveScheme,company,application,Version,IsListConfig";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Name) + "'";
		Sql += ",'" + SQLQuote(FolderName) + "'";
		Sql += ",'" + SQLQuote(ImageFolderName) + "'";
		Sql += "," + ImageFolderType + "";
		Sql += ",'" + SQLQuote(FullPath) + "'";
		Sql += ",'" + SQLQuote(SerialNo) + "'";
		Sql += ",'" + SQLQuote(Href) + "'";
		Sql += ",'" + SQLQuote(Attribute1) + "'";
		Sql += ",'" + SQLQuote(Attribute2) + "'";
		Sql += ",'" + SQLQuote(RecommendOut) + "'";
		Sql += ",'" + SQLQuote(RecommendOutRelation) + "'";
		Sql += ",'" + SQLQuote(Extra1) + "'";
		Sql += ",'" + SQLQuote(Extra2) + "'";
		Sql += ",'" + SQLQuote(ListJS) + "'";
		Sql += ",'" + SQLQuote(DocumentJS) + "'";
		Sql += ",'" + SQLQuote(ListProgram) + "'";
		Sql += ",'" + SQLQuote(DocumentProgram) + "'";
		Sql += ",'" + SQLQuote(ListSearchField) + "'";
		Sql += ",'" + SQLQuote(ListShowField) + "'";
		Sql += ",'" + SQLQuote(DataSource) + "'";
		Sql += ",'" + SQLQuote(Icon) + "'";
		Sql += "," + Parent + "";
		Sql += "," + IsDisplay + "";
		Sql += "," + IsWeight + "";
		Sql += "," + IsComment + "";
		Sql += "," + IsClick + "";
		Sql += "," + IsShowDraftNumber + "";
		Sql += "," + IsListAll + "";
		Sql += "," + IsTop + "";
		Sql += "," + ViewType + "";
		Sql += "," + CanCategory + "";
		Sql += "," + Type + "";
		Sql += ",0";
		Sql += "," + IsPublishFile + "";
		Sql += "," + IsExportExcel + "";
		Sql += "," + IsImportWord + "";
		
		Sql += "," + SiteID + "";
		Sql += "," + LinkChannelID + "";
		Sql += "," + CopyFromID + "";
		Sql += "," + TemplateInherit + "";
		
		Sql += ",now(),0";
		Sql += "," + ApproveScheme;
		Sql += "," + company;
		Sql += ",'" + SQLQuote(application) + "'";
		Sql += "," + Version;
		Sql += "," + IsListConfig;
		Sql += ")";

		// 目录在需要的时候才创建
		/*
		 * if(Type==0) { File file = new File(Path); file.mkdir(); }
		 */
		//System.out.println(Sql);
		int insertid = executeUpdate_InsertID(Sql);//executeUpdate(Sql);
		setId(insertid);
		initTableName();
		
		Sql = "update channel set OrderNumber=id where OrderNumber is null or OrderNumber=0";
		executeUpdate(Sql);
		
		String code = getParentChannel().getChannelCode();
		if(code.length()>0)
		{
			if(code.endsWith("_"))
				ChannelCode = code;
			else
				ChannelCode = code + "_";
		}
		ChannelCode += insertid + "_";
		
		Sql = "update channel set ChannelCode = '" + ChannelCode + "' where id=" + insertid;
		executeUpdate(Sql);

		// 创建数据表
		if (Type == Channel.Channel_Type || Type== Channel.Site_Type) {
			if(SerialNo.equalsIgnoreCase("video")){
				//createVideoTable(); 专门创建的video频道，暂时去除 2015/3/12
				createChannelTable();
			}else{
			    createChannelTable();
			}
		}
		
		if (Type == 3) {createAppTable();}

		//处理模板继承
		if (TemplateInherit == 1) {
				ChannelTemplate ct = new ChannelTemplate();
				ct.setChannelID(insertid);
				ct.InheritTemplate();
		}
		
		CmsCache.delChannel(Parent);
		if(getType()!= Channel.Site_Type)
			new Log().ChannelLog(LogAction.channel_add, insertid, ActionUser,SiteID);

		if(IsListConfig==1){
			ChannelListHeaderService.addHeaderList(insertid);//生成列表项目

			ChannelListMenuService.addMenuList(insertid);//生成功能菜单

			ChannelListSearchService.addSearchList(insertid);//生成搜索项目

			ChannelListFastSearchService.addSearchList(insertid);//生成快捷检索
		}
		
		Tree.inited = false;//需要重新初始化频道数量
	}

	public void Update() throws SQLException, MessageException {
		String Sql = "";

		if (Type == 0) {// 频道要检查标识名
			String ch = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789";			
			for (int i = 0; i < SerialNo.length(); i++) {
				boolean exist = false;
				for (int j = 0; j < ch.length(); j++) {
					if (SerialNo.charAt(i) == ch.charAt(j)) {
						exist = true;
					}
				}
	
				if (!exist)
					throw new MessageException("标识名必须由英文字母组成!", 4);
			}
		}

		Sql = "select * from channel where SerialNo='" + SQLQuote(SerialNo)
				+ "' and id!=" + id;
		if (isExist(Sql)) {
			throw new MessageException("标识名已经被使用!", 4);
		}

		Sql = "update channel set ";

		Sql += "Name='" + SQLQuote(Name) + "'";
		Sql += ",ImageFolderName='" + SQLQuote(ImageFolderName) + "'";
		Sql += ",ImageFolderType=" + ImageFolderType + "";
		Sql += ",Icon='" + SQLQuote(Icon) + "'";
		if (!isRootChannel()) {
			Sql += ",SerialNo='" + SQLQuote(SerialNo) + "'";
			Sql += ",Href='" + SQLQuote(Href) + "'";
			Sql += ",Attribute1='" + SQLQuote(Attribute1) + "'";
			Sql += ",Attribute2='" + SQLQuote(Attribute2) + "'";
			Sql += ",Extra1='" + SQLQuote(Extra1) + "'";
			Sql += ",Extra2='" + SQLQuote(Extra2) + "'";
			Sql += ",ListJS='" + SQLQuote(ListJS) + "'";
			Sql += ",DocumentJS='" + SQLQuote(DocumentJS) + "'";
			Sql += ",ListProgram='" + SQLQuote(ListProgram) + "'";
			Sql += ",ListSearchField='" + SQLQuote(ListSearchField) + "'";
			Sql += ",ListShowField='" + SQLQuote(ListShowField) + "'";
			Sql += ",DocumentProgram='" + SQLQuote(DocumentProgram) + "'";
			Sql += ",RecommendOut='" + SQLQuote(RecommendOut) + "'";
			Sql += ",RecommendOutRelation='" + SQLQuote(RecommendOutRelation) + "'";			
			Sql += ",IsDisplay=" + IsDisplay + "";
			Sql += ",IsWeight=" + IsWeight + "";
			Sql += ",IsComment=" + IsComment + "";
			Sql += ",IsClick=" + IsClick + "";
			Sql += ",IsShowDraftNumber=" + IsShowDraftNumber + "";
			Sql += ",IsListAll=" + IsListAll + "";
			Sql += ",IsTop=" + IsTop + "";
			Sql += ",IsPublishFile=" + IsPublishFile + "";
			Sql += ",IsExportExcel=" + IsExportExcel + "";
			Sql += ",IsImportWord=" + IsImportWord + "";
			Sql += ",ViewType=" + ViewType + "";
			Sql += ",TemplateInherit=" + TemplateInherit + "";
			Sql += ",CanCategory=" + CanCategory + "";
			Sql += ",ApproveScheme=" + ApproveScheme;
			Sql += ",company=" + company;
			Sql += ",application='" + SQLQuote(application) + "'";
			Sql += ",Version=" + Version;
			Sql += ",IsListConfig=" + IsListConfig;
		}

		Sql += " where id=" + id;

		executeUpdate(Sql);

		if (!SerialNo.equals(OldSerialNo) && getType() == 0 && !isRootChannel()) {// 如果改变了标识号，则要修改对应的表名，还有表单字段描述
			Sql = "ALTER TABLE channel_" + OldSerialNo + " RENAME channel_"
					+ SerialNo;

			executeUpdate(Sql);
			
			//Sql = "update field_desc set Channel='" + SQLQuote(SerialNo)
			//		+ "' where Channel='" + SQLQuote(OldSerialNo) + "'";

			//executeUpdate(Sql);
		}

		new Log().ChannelLog(LogAction.channel_edit, id, ActionUser,SiteID);
		
		CmsCache.delChannel(id);
	}
	
	public void createAppTable() throws SQLException, MessageException {
		String Sql = "";

		Sql += "CREATE TABLE channel_" + SerialNo + "(";
		Sql += "  id int(11) NOT NULL auto_increment,";
		Sql += "  Title	varchar(200) not null,";
		Sql += "  Content	mediumtext,";
		Sql += "  UNIQUE KEY id (id)";
		Sql += ")";

		executeUpdate(Sql);

		setTableName("channel_" + SerialNo);
		Sql = "insert into field_desc(Channel,FieldName,Description,FieldType,FieldLevel,IsHide,OrderNumber,Style,Size,Other,DefaultValue,ChannelID) values('"
				+ SerialNo
				+ "','Title','"
				+ SQLQuote("标题")
				+ "','text',1,0,1"
				+ ",''," + "10," + "''," + "''" +","+id+ ")";

		executeUpdate(Sql);

		Sql = "insert into field_desc(Channel,FieldName,Description,FieldType,FieldLevel,IsHide,OrderNumber,Style,Size,Other,DefaultValue,ChannelID) values('"
				+ SerialNo
				+ "','Content','"
				+ SQLQuote("内容")
				+ "','textarea',1,0,2" + ",''" + ",10" + ",''" + ",''" + ","+id+")";

		executeUpdate(Sql);
	}

	public void createChannelTable() throws SQLException, MessageException {
		ChannelUtil.createChannelTable(SerialNo,getId(),getTableUtil());
	}
	
	
	public void createVideoTable() throws SQLException, MessageException {
		ChannelUtil.createVideoTable(SerialNo,getId(),getTableUtil());
	}

	public void Delete(int id) throws SQLException, MessageException {
		//删除稿件审核表数据
		ApproveDocument.DeleteByChannel(id);
		//删除频道配置，推荐配置表数据
		ChannelUtil.selectCcIds(id);
		ChannelUtil.Delete(id, getActionUser());
	}

	// 更新频道的完整路径
	public void UpdateFullPath() throws SQLException, MessageException {
		// 设置完整路径
		if (getFolderName().startsWith("/"))
			FullPath = getFolderName();
		else {
			Channel channel = CmsCache.getChannel(getParent());
			if (getFolderName().equals(""))
				FullPath = channel.getFullPath();
			else
				FullPath = channel.getFullPath()
						+ ((channel.getFullPath().endsWith("/")) ? "" : "/")
						+ getFolderName();
		}
		
		//路径后面带上/
		if(!FullPath.endsWith("/")) FullPath += "/";

		String Sql = "";

		Sql = "update channel set ";

		Sql += "FullPath='" + SQLQuote(FullPath) + "'";
		Sql += ",FolderName='" + SQLQuote(FolderName) + "'";

		Sql += " where id=" + id;

		executeUpdate(Sql);

		CmsCache.delChannel(id);
		UpdateChildChannelFullPath(id);
		
		Tree.inited = false;//需要重新初始化频道数量
	}

	// 更新频道下的所有子频道的完整路径
	public void UpdateChildChannelFullPath(int channelid) throws SQLException, MessageException {
		String Sql = "";

		Sql = "select * from channel where Parent=" + channelid;

		ResultSet Rs = executeQuery(Sql);

		while (Rs.next()) {
			int i = Rs.getInt("id");
			//System.out.println("lsh"+i);
			Channel channel = CmsCache.getChannel(i);

			channel.UpdateFullPath();

			CmsCache.delChannel(i);
		}

		closeRs(Rs);
	}

	public void UpdateCanCategory() throws SQLException, MessageException {
		String Sql = "";

		Sql = "update channel set ";

		Sql += "CanCategory=" + CanCategory + "";

		Sql += " where id=" + id;

		executeUpdate(Sql);
	}

	public void UpdateChannelCode(int channelid) throws MessageException, SQLException
	{
		TableUtil tu = new TableUtil();
		String sql = "select * from channel where Parent=" + channelid;
		ResultSet rs = tu.executeQuery(sql);
		while(rs.next())
		{
			int id_ = rs.getInt("id");
			UpdateTheChannelCode(id_);
			
			UpdateChannelCode(id_);
		}
		tu.closeRs(rs);
	}
	
	public void UpdateTheChannelCode(int channelid) throws MessageException, SQLException
	{
		TableUtil tu1 = new TableUtil();
		Channel ch = CmsCache.getChannel(channelid);
		String code = ch.getParentChannel().getChannelCode();
		String channelCode = ((code.length()>0)?(code):"") + channelid + "_";
		String sql = "update channel set ChannelCode='" + channelCode + "' where id=" + channelid;
		
		tu1.executeUpdate(sql);
		ch.setChannelCode(channelCode);
		
		sql = "update item_snap set ChannelCode='" + channelCode + "' where ChannelID=" + channelid;
		tu1.executeUpdate(sql);
	}
	
	public void UpdateField(int channelid,String s) throws MessageException, SQLException
	{
		TableUtil tu = new TableUtil();
		Channel ch = new Channel(channelid);
		
		if(ch.getType()== Channel.Channel_Type)
		{
		TableUtil tu1 = new TableUtil();
		
		String sql = "ALTER TABLE " + ch.getTableName() + " " + s;
		try{tu1.executeUpdate(sql);}catch(Exception e)
		{if(e.getMessage().indexOf("Duplicate column")==-1){throw new MessageException(e.getMessage());}}
		}
		
		String sql = "select * from channel where Parent=" + channelid;
		ResultSet rs = tu.executeQuery(sql);
		while(rs.next())
		{
			int id_ = rs.getInt("id");
			
			UpdateField(id_,s);
		}
		tu.closeRs(rs);
	}
	
	public void UpdateField(int channelid,String s,String fieldname,String field,String type,int level,int hide) throws MessageException, SQLException
	{
		TableUtil tu = new TableUtil();
		Channel ch = new Channel(channelid);
		
		if(ch.getType()== Channel.Channel_Type)
		{
		TableUtil tu1 = new TableUtil();
		
		String sql = "ALTER TABLE " + ch.getTableName() + " " + s;
		try{tu1.executeUpdate(sql);
  		sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
		sql += channelid + ",'"+field+"','" + SQLQuote(fieldname) + "','" + type + "',"+level+","+hide+")";
		tu1.executeUpdate(sql);
		}catch(Exception e)
		{if(e.getMessage().indexOf("Duplicate column")==-1){throw new MessageException(e.getMessage());}}
		}
		
		String sql = "select * from channel where Parent=" + channelid;
		ResultSet rs = tu.executeQuery(sql);
		while(rs.next())
		{
			int id_ = rs.getInt("id");
			
			UpdateField(id_,s,fieldname,field,type,level,hide);
		}
		tu.closeRs(rs);
	}
	
	public void UpdateTemplateInherit(int flag) throws SQLException, MessageException {
		String Sql = "";

		Sql = "update channel set ";
		Sql += "TemplateInherit=" + flag + "";

		Sql += " where id=" + id;

		executeUpdate(Sql);
		
		CmsCache.delChannel(id);
	}
	
	public String getParentFolderName(int channelid) throws SQLException,
            MessageException {
		String foldername = "";
		int parent = 0;
		String Sql = "select * from channel where id=" + channelid;

		ResultSet Rs = executeQuery(Sql);
		if (Rs.next()) {
			foldername = convertNull(Rs.getString("FolderName"));
			parent = Rs.getInt("Parent");
		}

		closeRs(Rs);

		if (parent != 0 && parent != -1) {
			if (foldername.startsWith("/"))
				foldername = getParentFolderName(parent) + foldername;
			else
				foldername = getParentFolderName(parent) + "/" + foldername;
		}

		return foldername;
	}

	public ArrayList<Channel> getParentTree() throws MessageException, SQLException {
		ArrayList<Channel> arraylist = new ArrayList<Channel>();
		ArrayList<Channel> arraylist1 = new ArrayList<Channel>();

		Channel channel = CmsCache.getChannel(id);
		arraylist.add(channel);

		while (!channel.isRootChannel()) {
			channel = CmsCache.getChannel(channel.getParent());
			arraylist.add(channel);
		}

		for (int i = arraylist.size(); i > 0; i--)
			arraylist1.add(arraylist.get(i - 1));

		return arraylist1;
	}
	
	//返回频道的完整名称，带父级频道，比如：演示网站>少儿>首页管理>海报轮播
	public String getParentChannelPath() throws MessageException, SQLException
	{
		String path = "";
		ArrayList<Channel> arraylist = getParentTree();
		if(arraylist!=null && arraylist.size()>0)
		{
			for(int i = 0;i<arraylist.size();i++)
			{
				Channel ch = (Channel)arraylist.get(i);
				
				path += ch.getName() + ((i<arraylist.size()-1)?">":"");
			}
		}
		
		arraylist = null;
		
		return path;
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

	public String getFolderName() {
		return FolderName;
	}

	public int getId() {
		return id;
	}

	public String getName() {
		return Name;
	}

	public int getParent() {
		return Parent;
	}

	public void setFolderName(String string) {
		FolderName = string.replace("\\", "/");// 替换"\"
	}

	public void setId(int i) {
		id = i;
	}

	public void setName(String string) {
		Name = string;
	}

	public void setParent(int i) {
		Parent = i;
	}

	public int getOrderNumber() {
		return OrderNumber;
	}

	public void setOrderNumber(int i) {
		OrderNumber = i;
	}

	public int getIsDisplay() {
		return IsDisplay;
	}

	public void setIsDisplay(int i) {
		IsDisplay = i;
	}

	public void setIsDisplay(String i) {
		if (i != null && i.equals("1"))
			IsDisplay = 1;
		else
			IsDisplay = 0;
	}

	public int getType() {
		return Type;
	}

	public void setType(int i) {
		Type = i;
	}

	public boolean hasShowRight(UserInfo user, int channelid) throws SQLException, MessageException
	{
		boolean right = user.hasChannelShowRight(channelid);
		//System.out.println(channelid+","+right);
		return right;
		//return user.hasChannelRight(channelid, ChannelPrivilegeItem.CanList) || user.hasChannelRight(channelid, 0);
	}

	// 是否具有指定权限
	public boolean hasRight(UserInfo user, int permtype) throws SQLException, MessageException
	{
		return user.hasChannelRight(id, permtype);
	}

	//是否是站点频道
	public boolean isRootChannel() {
		if (Parent == -1)
			return true;
		else
			return false;
	}

	public boolean isTableChannel() {
		if (getType() == 0 || getType() == 3)
			return true;
		else
			return false;
	}

	public Channel getRootChannel() throws MessageException, SQLException {
		return new Channel(0);
	}

	public ArrayList<Channel> listSubChannels() throws SQLException, MessageException {
		return listSubChannels(0);
	}

	//给前台使用，只列出在导航中出现的频道
	public ArrayList<Channel> listSubChannels(int type) throws SQLException, MessageException {
		ArrayList<Channel> arraylist = new ArrayList<Channel>();
		String Sql = "select * from channel where Parent=" + id
				+ " and IsDisplay=1 ";
		if (type > 0)
			Sql += " and Type=" + type;

		Sql += " order by OrderNumber,id";

		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(Sql);
		while (Rs.next()) {
			int i = Rs.getInt("id");
			Channel channel = CmsCache.getChannel(i);
			arraylist.add(channel);
		}
		tu.closeRs(Rs);
		return arraylist;
	}

	public ArrayList<Channel> listAllSubChannels(int type) throws SQLException, MessageException {
		// 列出频道下所有子频道和子分类
		ArrayList<Channel> arraylist = new ArrayList<Channel>();
		String Sql = "";
		Sql = "select * from channel where Parent=" + id + " ";
		if (type != -1)
			Sql += " and Type=" + type;
		Sql += " order by OrderNumber,id";

		TableUtil tu = new TableUtil();
		
		ResultSet Rs = tu.executeQuery(Sql);
		while (Rs.next()) {
			int i = Rs.getInt("id");
			Channel ch = CmsCache.getChannel(i);
			arraylist.add(ch);

			listAllSubChannels_(arraylist, i, type);
		}
		tu.closeRs(Rs);

		return arraylist;
	}

	public ArrayList<Channel> listAllSubChannels() throws SQLException, MessageException {
		// 列出频道下所有子频道和子分类
		ArrayList<Channel> arraylist = new ArrayList<Channel>();
		String Sql = "select * from channel where Parent=" + id
				+ " order by OrderNumber,id";
		ResultSet Rs = executeQuery(Sql);
		while (Rs.next()) {
			int i = Rs.getInt("id");
			Channel ch = CmsCache.getChannel(i);
			arraylist.add(ch);

			listAllSubChannels_(arraylist, i, -1);
		}
		closeRs(Rs);

		return arraylist;
	}

	public ArrayList<Channel> listAllSubChannels_(ArrayList<Channel> arraylist, int id, int type)	throws SQLException, MessageException {
		String Sql = "select * from channel where Parent=" + id + " ";
		if (type != -1)
			Sql += " and Type=" + type;
		Sql += " order by OrderNumber,id";

		TableUtil tu = new TableUtil();
		
		ResultSet Rs = tu.executeQuery(Sql);
		while (Rs.next()) {
			int i = Rs.getInt("id");
			Channel ch = CmsCache.getChannel(i);
			arraylist.add(ch);

			listAllSubChannels_(arraylist, i, type);
		}
		tu.closeRs(Rs);

		return arraylist;
	}

	public String listAllSubChannelIDsString() throws SQLException, MessageException {
		// 列出频道下所有子频道和子分类
		ArrayList<Integer> arraylist = listAllSubChannelIDs();

		if (arraylist == null || arraylist.size() == 0)
			return "";
		
		String ids = "";
		
		for (int i = 0; i < arraylist.size(); i++) {
			Integer integer = (Integer) arraylist.get(i);
			ids += (ids.equals("") ? "" : ",") + integer;
		}
		return ids;
	}
	
	
	public ArrayList<Integer> listAllSubChannelIDs() throws SQLException, MessageException {
		// 列出频道下所有子频道和子分类
		ArrayList<Integer> arraylist = new ArrayList<Integer>();

		if (childAllChannelIDs == null || childAllChannelIDs.size() == 0)
			return new ArrayList<Integer>();
		
		for (int i = 0; i < childAllChannelIDs.size(); i++) {
			Integer integer = (Integer) childAllChannelIDs.get(i);
			arraylist.add(integer);
			listAllSubChannelIDs_(arraylist, integer.intValue());
		}
		return arraylist;
	}

	public void listAllSubChannelIDs_(ArrayList<Integer> arraylist, int channelid)	throws SQLException, MessageException {
		Channel ch = CmsCache.getChannel(channelid);
		ArrayList<Integer> ids = ch.getAllChildChannelIDs();
		if (ids == null || ids.size() == 0)
			return;
		
		for (int i = 0; i < ids.size(); i++) {
			Integer integer = (Integer) ids.get(i);
			arraylist.add(integer);
			listAllSubChannelIDs_(arraylist, integer.intValue());
		}
	}

	public int getDefaultSubChannelID() throws SQLException, MessageException {
		// 获取频道下面的第一个频道的编号
		int i = 0;
		String Sql = "select * from channel where Parent=" + id + " ";
		ResultSet Rs = executeQuery(Sql);
		if (Rs.next()) {
			i = Rs.getInt("id");
		}
		closeRs(Rs);

		return i;
	}

	public ArrayList<Document> listAllItems() throws SQLException, MessageException {
		// 全部评审通过的记录
		String Sql = "select * from " + getTableName() + " where Status=1 and Active=1 ";

		if (getType() == 1)
			Sql += " and Category=" + getId();

		Sql += " order by OrderNumber Desc,id desc";

		return generatorArrayList(Sql);
	}

	//
	public ArrayList<Document> generatorArrayList(String Sql) throws SQLException, MessageException
	{
		TableUtil tu = getTableUtil();
		ArrayList<Document> arraylist = new ArrayList<Document>();
		ResultSet Rs = tu.executeQuery(Sql);
		while (Rs.next()) {
			int i = Rs.getInt("id");
			int Category = Rs.getInt("Category");
			int chid = id;
			if(Category>0)
				chid = Category;
				
			Document item = CmsCache.getDocument(i,chid);
			// System.out.println(item.getValue("Photo"));
			// item.setId(i);
			// item.setTitle(convertNull(Rs.getString("Title")));
			// System.out.println(item.getTitle());
			arraylist.add(item);
		}
		
		tu.closeRs(Rs);

		return arraylist;
	}

	public ArrayList<Document> listTopItems(int number) throws SQLException, MessageException
	{
		// 最上面几条记录
		return ChannelUtil.listTopItems(this,number,false,1,"");
	}

	public ArrayList<Document> listTopItems(int number, String sql) throws SQLException, MessageException
	{
		// 最上面几条记录
		return ChannelUtil.listTopItems(this,number,false,1,sql);
	}
	
	public ArrayList<Document> listTopItems(int number, boolean notincludephoto, int includesubchannel, String sql) throws SQLException, MessageException
	{
		return ChannelUtil.listTopItems(this, number, notincludephoto, includesubchannel, sql);
	}
	
	//从lucene库中搜索
	//2018.8.1 liyonghai 注释
	/*public ArrayList<Document> listTopItems(int number,String channelids,String order) throws SQLException,MessageException
	{
		return ChannelUtil.listTopItems(number, channelids,order);
	}*/
	
	public ArrayList<Document> listTopGlobalItems(int number, boolean includesubchannel) throws MessageException, SQLException
	{
		return ChannelUtil.listTopGlobalItems(number, includesubchannel,getChannelCode());
	}
	
	public ArrayList<Document> listTopPhotoItems(int number) throws SQLException, MessageException {
		// 本频道最上面几条图片新闻
		return ChannelUtil.listTopPhotoItems(this, number);
	}

	public ArrayList<Document> listItems(PageControl pc, String fields, int includesubchannel) throws SQLException, MessageException {
		// 分页列出某一频道下通过审核的文档
		
		Channel channel = CmsCache.getChannel(getId());
		
		String ids = "";
		
		//ALTER TABLE item_snap ADD INDEX index_4(OrderNumber,ChannelID,Status) 准备建立新索引
		//去掉条件Active=1 2012-09-12 从use index(index_3)改成use index(index_4) 2012-09-19
		String Sql = "select ItemID from item_snap where Status=1 ";
		String Sql2 = "select ItemID from item_snap use index(index_2) where Status=1 ";
		
		//Sql2 = "select ItemID from item_snap where Status=1 ";
		
 		if(channel.getType()== Channel.MirrorChannel_Type)
		{
 			if(includesubchannel==0)//不包含子频道内容
 				Sql += " and ChannelCode='" + channel.getLinkChannel().getChannelCode() + "'";
 			else
 				Sql = Sql2 + " and ChannelCode like '" + channel.getLinkChannel().getChannelCode() + "%'";
		}
 		else
 		{
 			if(includesubchannel==0)//不包含子频道内容
 			{
 				//Sql += " and ChannelCode='" + channel.getChannelCode() + "'";
 				Sql += " and ChannelID=" + channel.getId() + "";//2012-09-19修改，提高效率
 			}
 			else
 			{
 				//如果子频道数量少于50
 				ArrayList<Integer> childs = channel.listAllSubChannelIDs();
 				if(childs!=null && childs.size()<50)
 				{
 					String child_ids = channel.getId()+"";
 					for(int i = 0;i<childs.size();i++)
 					{
 						child_ids += "," + (Integer)childs.get(i);
 					}
 					Sql += " and ChannelID in (" + child_ids + ")";
 					//System.out.println(Sql);
 				}
 				else
 				{
 					Sql = Sql2 + " and ChannelCode like '" + channel.getChannelCode() + "%'";
 				}
 			}
 		}
 		
 		Sql += " order by OrderNumber Desc";
 		//去掉ItemID desc 2012-09-12
 		//Sql += " order by OrderNumber Desc,ItemID desc ";
		int start = (pc.getCurrentPage()-1)*pc.getRowsPerPage();
		Sql += pc.getRowsPerPage()!=0?("  limit "+start+","+pc.getRowsPerPage()):"";
		
		TableUtil tu1 = new TableUtil();
		ResultSet rs = tu1.executeQuery(Sql);
		//print(Sql);
		while(rs.next())
		{
			int id_ = rs.getInt("ItemID");
			ids += (ids.equals("")?"":",") + id_;
		}
		tu1.closeRs(rs);
 		

		String s_fields = "id,Title,GlobalID,PublishDate,Category,CreateDate,Random,IsPhotoNews,Summary";
		if (!fields.equals(""))
		{
			if(fields.equals("*"))
			{
				s_fields = "*";
			}
			else
				s_fields = s_fields + "," + fields;
		}
		
		//String ListSql = "select " + s_fields + " from " + channel.getTableName() + " where Status=1 and Active=1 ";
		String ListSql = "select " + s_fields + " from " + channel.getTableName() + " where Status=1 ";//去掉Active=1条件，2012-09-19

		if(ids.equals("")) ids = "0";
		ListSql += " and id in(" + ids + ")";
		ListSql += " order by OrderNumber Desc,id desc";
		//print(ListSql);
		return ChannelUtil.listItems(fields, ListSql,channel);
	}
	
	public ArrayList<Document> listItems(PageControl pc, String fields, String whereSql) throws SQLException, MessageException {
		// 分页列出某一频道下通过审核的文档
		String orderSql = " order by OrderNumber Desc,id desc";
		return listItems(pc,fields,whereSql,orderSql);
	}
	
	public ArrayList<Document> listItems(PageControl pc, String fields, String whereSql, String orderSql) throws SQLException, MessageException {
		// 分页列出某一频道下通过审核的文档
		Channel channel = CmsCache.getChannel(getId());
		String s_fields = "id,Title,GlobalID,PublishDate,Category,CreateDate,Random,IsPhotoNews,Summary";
		if (!fields.equals(""))
		{
			if(fields.equals("*"))
				s_fields = "*";
			else
				s_fields = s_fields + "," + fields;
		}
		
		String ListSql = "select " + s_fields + " from " + channel.getTableName() + " where Status=1";

		if(channel.getType()== Channel.Category_Type)
			ListSql += " and Category=" + channel.getId();
		
		whereSql = whereSql.trim();
		if(whereSql.length()>0)
		{
			if(whereSql.startsWith("and") || whereSql.startsWith("AND"))
				whereSql = " " + whereSql;
			else
				whereSql = " and " + whereSql;//如果不写and，就补充一个
		}
		orderSql = " " + orderSql.trim();
		ListSql += whereSql;
		ListSql += orderSql;
		int start = (pc.getCurrentPage()-1)*pc.getRowsPerPage();
		ListSql += pc.getRowsPerPage()!=0?("  limit "+start+","+pc.getRowsPerPage()):"";
		//System.out.println(ListSql);
		return ChannelUtil.listItems(fields, ListSql,channel);
	}
	
	public String getSerialNo() {
		return SerialNo;
	}

	public void setSerialNo(String string) {
		SerialNo = string;
	}

	public String getSerialNo(int id) throws MessageException, SQLException {
		String SerialNo = "";

		TableUtil tu = new TableUtil();
		String Sql = "select * from channel where id="+id;
		ResultSet Rs = tu.executeQuery(Sql);
		while (Rs.next()) {
			SerialNo = convertNull(Rs.getString("SerialNo"));
		}
		tu.closeRs(Rs);

		return SerialNo;
	}

	public Document getDocument(int itemid) throws MessageException,SQLException {
		Document document = CmsCache.getDocument(itemid, id);//new Document(itemid, id);

		return document;
	}

	public ResultSetMetaData getColumn() throws SQLException, MessageException {
		TableUtil datasource_tu = getTableUtil();
		String Sql = "select * from " + getTableName() + " limit 1";
		// System.out.println("getColumn()"+Sql);
		ResultSet Rs = datasource_tu.executeQuery(Sql);

		ResultSetMetaData rsmd = Rs.getMetaData();

		datasource_tu.closeRs(Rs);

		return rsmd;
	}

	public void setFieldInfo(ArrayList fieldinfo) throws MessageException, SQLException {
		FieldInfo = fieldinfo;
	}
	
	public ArrayList<Field> getFieldInfo() throws MessageException, SQLException {
		if(FieldInfo==null)	ChannelUtil.initFieldInfo(this);
		
		return FieldInfo;
	}


	

	
	// 从字段信息集合中获取某个特定的字段对象
	public Field getFieldByFieldName(String fieldname) throws MessageException, SQLException
	{
		if (FieldInfo == null || FieldInfo.size() == 0)
			ChannelUtil.initFieldInfo(this);
		
		if (FieldInfo == null || FieldInfo.size() == 0)
			return null;
		
		//System.out.println(FieldInfo.size());
		for (int i = 0; i < FieldInfo.size(); i++) {
			Field fd = (Field) FieldInfo.get(i);
			if (fieldname.equals(fd.getName())) {
				return fd;
			}
		}
		return null;
	}
	
	public void Order(int action) throws SQLException, MessageException
	{
		ChannelUtil.Order(action,OrderNumber,getParent(),getId());
	}

	/**
	 * @return Returns the canCategory.
	 */
	public int getCanCategory() {
		return CanCategory;
	}

	/**
	 * @param canCategory
	 *            The canCategory to set.
	 */
	public void setCanCategory(int canCategory) {
		this.CanCategory = canCategory;
	}

	public void setCanCategory(String i) {
		if (i != null && i.equals("1"))
			CanCategory = 1;
		else
			CanCategory = 0;
	}

	/**
	 * 返回频道的完整路径
	 */
	public String getFullPath() {
		String p = Util.ClearPath(FullPath);
		return p;
	}

	/**
	 * @param fullPath
	 *            The fullPath to set.
	 */
	public void setFullPath(String fullPath) {
		FullPath = fullPath;
	}

	// 编辑内容时，是否需要显示的字段
	public boolean isShowField(String field) {
		if (field.equalsIgnoreCase("id"))
			return false;
		if (field.equalsIgnoreCase("Category"))
			return false;
		if (field.equalsIgnoreCase("User"))
			return false;
		if (field.equalsIgnoreCase("CreateDate"))
			return false;
		if (field.equalsIgnoreCase("Status"))
			return false;
		//if (field.equalsIgnoreCase("PublishDate"))
		//	return false;
		//if (field.equalsIgnoreCase("DocFrom"))
		//	return false;
		if (field.equalsIgnoreCase("Title"))
			return false;
		if (field.equalsIgnoreCase("TotalPage"))
			return false;
		if (field.equalsIgnoreCase("Weight"))
			return false;

		return true;
	}

	public void CopyFormToSubChannel() throws SQLException, MessageException {
		ChannelUtil.CopyFormToSubChannel(SerialNo, getId());
	}

	/**
	 * @return Returns the oldSerialNo.
	 */
	public String getOldSerialNo() {
		return OldSerialNo;
	}

	/**
	 * @param oldSerialNo
	 *            The oldSerialNo to set.
	 */
	public void setOldSerialNo(String oldSerialNo) {
		OldSerialNo = oldSerialNo;
	}

	/**
	 * @return Returns the channelType_ForAdd.
	 */
	public int getChannelType_ForAdd() {
		return ChannelType_ForAdd;
	}

	/**
	 * @param channelType_ForAdd
	 *            The channelType_ForAdd to set.
	 */
	public void setChannelType_ForAdd(int channelType_ForAdd) {
		ChannelType_ForAdd = channelType_ForAdd;
	}

	/**
	 * @return Returns the imageFolderName.
	 */
	public String getImageFolderName() {
		return ImageFolderName;
	}

	/**
	 * @param imageFolderName
	 *            The imageFolderName to set.
	 */
	public void setImageFolderName(String imageFolderName) {
		ImageFolderName = imageFolderName;
	}

	/**
	 * @return Returns the href.
	 */
	public String getHref() {
		return Href;
	}

	/**
	 * @param href
	 *            The href to set.
	 */
	public void setHref(String href) {
		Href = href;
	}

	// 是否有子分类或子频道
	public boolean hasChild() throws SQLException, MessageException {
		if(childChannelIDs!=null && childChannelIDs.size()>0) return true;
		else return false;
	}

	// 是否有子分类或子频道
	public boolean hasChild(int childid) throws SQLException, MessageException {
		return CmsCache.getChannel(childid).hasChild();
	}

	// 是否有子分类或子频道，带上权限验证，使用childAllChannelIDs，包括不在导航中显示的频道
	public boolean hasChild(UserInfo user) throws SQLException, MessageException {
		for(int i = 0;i<childAllChannelIDs.size();i++)
		{
			int channelid = childAllChannelIDs.get(i);
			//System.out.println("haschild user:"+user.getId()+",channel:"+channelid+",result:"+hasShowRight(user, channelid));
			if(hasShowRight(user, channelid))
			{
				return true;
			}
		}
		
		return false;		
	}
	
	// 是否有子分类或子频道，带上权限验证
	public boolean hasChild(UserInfo user, int childid) throws SQLException, MessageException {
		return CmsCache.getChannel(childid).hasChild(user);
	}
	
	/**
	 * @return Returns the templateInherit.
	 */
	public int getTemplateInherit() {
		return TemplateInherit;
	}

	/**
	 * @param templateInherit
	 *            The templateInherit to set.
	 */
	public void setTemplateInherit(int templateInherit) {
		TemplateInherit = templateInherit;
	}

	/**
	 * @return Returns the parentTableChannel.
	 */
	public int getParentTableChannelID() {
		return ParentTableChannelID;
	}

	public Channel getParentTableChannel() throws MessageException,SQLException {
		return CmsCache.getChannel(getParentTableChannelID());
	}

	/**
	 * @param parentTableChannel
	 *            The parentTableChannel to set.
	 */
	public void setParentTableChannelID(int parentTableChannel) {
		ParentTableChannelID = parentTableChannel;
	}

	/**
	 * @return Returns the tableName.
	 */
	public String getTableName() {
		return TableName;
	}

	/**
	 * @param tableName
	 *            The tableName to set.
	 */
	public void setTableName(String tableName) {
		TableName = tableName;
	}

	public String getIndexFile() throws SQLException, MessageException {
		return ChannelUtil.getIndexFile(getId());
	}

	public Channel getParentChannel() throws MessageException, SQLException {
		return CmsCache.getChannel(getParent());
	}

	public int getSiteBySerialNo(String SerialNo) throws SQLException,
            MessageException {

		String Sql = "select id from channel where SerialNo='" + SerialNo + "'";
		ResultSet Rs = null;
		int id = 0;

		Rs = executeQuery(Sql);

		if (Rs.next()) {
			id = Rs.getInt("id");
		}
		return id;
	}

	public void Order_Table(int action, String FieldName) throws SQLException,
            MessageException {
		String Sql = "";

		String Symbol1 = "";
		String Symbol2 = "";

		//String Table = getTableName();
		if (getType() == 4) {
			// /Table = "Channel_" + getSiteID() + "_webuser";
		}

		Sql = "select OrderNumber,id from field_desc where Channel='"
				+ SerialNo + "' and FieldName='" + FieldName + "'";
		//System.out.println(Sql);
		ResultSet Rs = executeQuery(Sql);
		int Order = 0;
		int id_field = 0;
		if (Rs.next()) {
			Order = Rs.getInt("OrderNumber");
			id_field = Rs.getInt("id");
		}
		closeRs(Rs);

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

		Sql = "select * from field_desc where OrderNumber" + Symbol1 + Order
				+ " and Channel='" + SerialNo + "' order by OrderNumber "
				+ Symbol2 + " limit 1";

		Rs = executeQuery(Sql);

		if (Rs.next()) {
			int i = Rs.getInt("id");
			int ordernumber = Rs.getInt("OrderNumber");

			Sql = "update field_desc set OrderNumber=" + Order + " where id="
					+ i;
			//System.out.println(Sql);
			executeUpdate(Sql);

			Sql = "update field_desc set OrderNumber=" + ordernumber
					+ " where id=" + id_field;
			//System.out.println(Sql);
			executeUpdate(Sql);
		}

		closeRs(Rs);
	}
	
	public int getThisId(int id) throws SQLException, MessageException {
		String Sql = "select id from channel where Parent="+id;
		int thisid=0;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next()){
			thisid = Rs.getInt("id");
		}
		return thisid;
		
	}
	
	//判断是否是租户公共频道，比如UGC,VMS等，特定的application(举例)和以public_开头的application
	public boolean isShareChannel()
	{
		//pgc内容库||大屏||选题||审片||文稿||公共频道
		if(application.startsWith("pgc_")||application.startsWith("workorder")||application.startsWith("screen")||application.startsWith("task")||application.startsWith("shenpian")||application.startsWith("shengao")||application.startsWith("public_")){
			return true ;
		}
		return false;
	}

	public String getAttribute1() throws MessageException, SQLException {
		
		if(Attribute1.equals("***"))
		{
			//继承属性
			Channel ch = getParentChannel();
			if(ch==null)
				return "";
			else
				return ch.getAttribute1();
		}
		return Attribute1;
	}

	public void setAttribute1(String attribute1) {
		Attribute1 = attribute1;
	}
	
	
	//获取ChannelID对应频道的Attribute2
	public String getAttribute2(int ChannelID) throws MessageException, SQLException {
		if(Attribute1.equals("***"))
		{
			//继承属性
			Channel ch = getParentChannel();
			if(ch==null)
				return "";
			else
				return ch.getAttribute2(ChannelID);
		}
		//独立
		if(ChannelID > 0){
			ChannelRecommend channelRecommend = new ChannelRecommend();
			String Relationship = channelRecommend.getAttribute2Relationship(ChannelID,id);
			return Relationship;
		}
		return "";
	}
	
	public String getAttribute2() throws MessageException, SQLException {
		if(Attribute2.equals("***"))
		{
			//继承属性
			Channel ch = getParentChannel();
			if(ch==null)
				return "";
			else
				return ch.getAttribute2();
		}
		return  Attribute2;
	}

	public void setAttribute2(String attribute2) {
		Attribute2 = attribute2;
	}
	
	public String getAutoSerialNo() throws MessageException, SQLException
	{
		//自动生成serialno
		return ChannelUtil.getAutoSerialNo(getSerialNo());
	}
	
	public boolean checkSerialNo(String no) throws SQLException, MessageException
	{//检查标识是否已经被使用		
		String sql = "select * from channel where SerialNo='" + SQLQuote(no) + "'";
		if (!isExist(sql)) {
			return false;
		}
		else
			return true;
	}
	
	public void setChildChannelIDs() throws SQLException, MessageException
	{
		childChannelIDs = new ArrayList<Integer>();
		childAllChannelIDs = new ArrayList<Integer>();
		String Sql = "select id,IsDisplay from channel where Parent=" + id;
		Sql += " order by OrderNumber,id";
		ResultSet Rs = executeQuery(Sql);
		while (Rs.next()) {
			int i = Rs.getInt("id");
			int display = Rs.getInt("IsDisplay");
			
			if(display==1)
				childChannelIDs.add(new Integer(i));
			
			childAllChannelIDs.add(new Integer(i));
		}
		closeRs(Rs);
	}
	
	public void initMirrorChannelIDs() throws SQLException, MessageException
	{
		MirrorChannelIDs = new ArrayList<Integer>();
		String Sql = "select * from channel where LinkChannel=" + id	+ " and IsDisplay=1 ";
		Sql += " order by OrderNumber,id";
		ResultSet Rs = executeQuery(Sql);
		while (Rs.next()) {
			int i = Rs.getInt("id");
			MirrorChannelIDs.add(new Integer(i));
		}
		closeRs(Rs);
	}
	
	//是否拥有镜像频道
	public boolean hasMirrorChannel()
	{
		if(MirrorChannelIDs!=null && MirrorChannelIDs.size()>0) return true;
		else return false;
	}
	
	//不包含IsDisplay=0的
	public ArrayList<Integer> getChildChannelIDs() throws MessageException, SQLException {
		if(childChannelIDs==null)	setChildChannelIDs();
		return childChannelIDs;
	}

	public ArrayList<Integer> getAllChildChannelIDs() throws MessageException, SQLException {
		if(childAllChannelIDs==null)	setChildChannelIDs();
		return childAllChannelIDs;
	}
	
	public int getActionUser() {
		return ActionUser;
	}

	public void setActionUser(int actionUser) {
		ActionUser = actionUser;
	}

	public int getLinkChannelID() {
		return LinkChannelID;
	}

	public void setLinkChannelID(int linkChannelID) {
		LinkChannelID = linkChannelID;
	}

	public ArrayList<Integer> getMirrorChannelIDs() {
		return MirrorChannelIDs;
	}

	public void setMirrorChannelIDs(ArrayList<Integer> mirrorChannelIDs) {
		MirrorChannelIDs = mirrorChannelIDs;
	}
	
	public Channel getLinkChannel() throws MessageException, SQLException {
		return CmsCache.getChannel(getLinkChannelID());
	}

	public ArrayList<FieldGroup> getFieldGroupInfo() {
		return FieldGroupInfo;
	}

	public void setFieldGroupInfo(ArrayList<FieldGroup> fieldGroupInfo) {
		FieldGroupInfo = fieldGroupInfo;
	}
	
	public ArrayList<Field> getFieldsByGroup(int fieldGroup, int notIncludeDefault) throws MessageException, SQLException
	{
		ArrayList<Field> arraylist = new ArrayList<Field>();
		
		ArrayList<Field> fields = getFieldInfo();
		int size = fields.size();
		for (int i = 0; i < size; i++) 
		{
			Field field = (Field) fields.get(i);
			int groupid = field.getGroupID();
			if(groupid==fieldGroup ||(groupid==0 && notIncludeDefault==0))
				arraylist.add(field);
		}
		
		return arraylist;
	}

	public int getSiteID() {
		return SiteID;
	}

	public void setSiteID(int site) {
		SiteID = site;
	}
	
	public Site getSite() throws MessageException, SQLException {
		return CmsCache.getSite(SiteID);
	}
	
	public boolean isVideoChannel()
	{
		if(getTableName().equals("channel_video"))
			return true;
		else
			return false;
	}
	
	//指定频道编号
	public int getNumber(int status,int channelid) throws MessageException, SQLException
	{
		int num = 0;
		Channel channel = CmsCache.getChannel(channelid);
		if(channel.getType()!=0 && channel.getType()!=1) return 0;
		
		String Sql = "select count(*) from " + channel.getTableName() + " where Active!=0 and Status=" + status;
		if(channel.getType()==1)
			Sql += " and Category=" + channelid;
		
		TableUtil tu = getTableUtil();
		ResultSet rs = tu.executeQuery(Sql);
		if (rs.next())
			num = rs.getInt(1);
		tu.closeRs(rs);
		
		return num;
	}

	public int getNumber(int status) throws MessageException, SQLException
	{
		int num = 0;
		if(getType()!=0 && getType()!=1) return 0;
		String Sql = "select count(*) from " + getTableName() + " where Active!=0 and Status=" + status;
		if(getType()==1)
			Sql += " and Category=" + getId();
		
		TableUtil tu = getTableUtil();
		ResultSet rs = tu.executeQuery(Sql);
		if (rs.next())
			num = rs.getInt(1);
		tu.closeRs(rs);
		return num;
	}
	
	public ArrayList<ChannelTemplate> getChannelTemplates() {
		return channelTemplates;
	}

	public void setChannelTemplates(ArrayList<ChannelTemplate> channelTemplates) {
		this.channelTemplates = channelTemplates;
	}	
	
	public ArrayList<ChannelTemplate> getChannelTemplates(int type) {
		ArrayList<ChannelTemplate> temp = new ArrayList<ChannelTemplate>();
		
		for(int i = 0;i<channelTemplates.size();i++)
		{
			ChannelTemplate ct = (ChannelTemplate)channelTemplates.get(i);
			
			if(ct.getTemplateType()==type && ct.getTemplateID()>0)
				temp.add(ct);
		}
		return temp;
	}	
	
	//获取指定类型，指定标识的模板
	public ChannelTemplate getChannelTemplates(int type, String label)
	{
		ArrayList<ChannelTemplate> lists = getChannelTemplates(type);
		int size = lists.size();
		ChannelTemplate ct2 = null;
		
		//print("type:"+type+","+size + "_" + label);
		
		for(int i = 0;i<size;i++)
		{
			ChannelTemplate ct = (ChannelTemplate)lists.get(i);
			
			if(ct.getTemplateType()==type)
			{
				if(type== ChannelTemplate.ListTemplateType && size==1)//获取列表页模板，且列表页模板只有一个
					return ct;
					
				if(ct.getLabel().equals("") && label.equals(""))
					return ct;

				if(ct.getLabel().endsWith("*"))
					ct2 = ct;
				
				if(ct.getLabel().equals(label) || ct.getLabel().equals(label + "*"))
					return ct;
			}
		}

		if(label.equals("") && ct2!=null)
			return ct2;
		
		ChannelTemplate ct = null;
		try {
			ct = new ChannelTemplate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return ct;
	}

	public String getChannelCode() {
		return ChannelCode;
	}

	public void setChannelCode(String channelCode) {
		ChannelCode = channelCode;
	}
	
	public void UpdateItemSnap(int channelid) throws MessageException, SQLException, IOException, ParseException {
		Channel ch = CmsCache.getChannel(channelid);
		String Sql = "SELECT * FROM " + ch.getTableName()+" where GlobalID is null;";
		TableUtil tu01 = new TableUtil();
		ResultSet rsrs = tu01.executeQuery(Sql);
		while(rsrs.next())
		{
			int itemid = rsrs.getInt("id");

			Document document = CmsCache.getDocument(itemid, channelid);//new Document(itemid,channelid);
			new ItemSnap().Add(document);//加入全局库
		}
		tu01.closeRs(rsrs);
		tu01 = null;		
	}

	public void updateType2(int type2) throws SQLException, MessageException
	{
		String Sql = "";
		if(type2== Channel.Content_Channel_Type2)
		{
			Sql = "update channel set Type2=0 where Type2=" + Channel.Content_Channel_Type2 + " and Site=" + getSiteID();
			executeUpdate(Sql);
		}
		
		Sql = "update channel set Type2=" + type2 + " where id="+id;
		//print(Sql);
		executeUpdate(Sql);
	}
	
	public void setRecommendOut(String recommendOut) {
		RecommendOut = recommendOut;
	}

	public String getRecommendOut() throws MessageException, SQLException {
		if(RecommendOut.equals("***"))
		{
			//继承属性
			Channel ch = getParentChannel();
			if(ch==null)
				return "";
			else
				return ch.getRecommendOut();
		}
		return RecommendOut;
	}

	public void setRecommendOutRelation(String recommendOutRelation) {
		RecommendOutRelation = recommendOutRelation;
	}
	
	//获取RelationID对应频道的RecommendOutRelation
	public String getRecommendOutRelation(int RelationID) throws MessageException, SQLException {
		if(RecommendOut.equals("***"))
		{
			//继承属性
			Channel ch = getParentChannel();
			if(ch==null)
				return "";
			else
				return ch.getRecommendOutRelation(RelationID);
		}
		//独立
		if(RelationID > 0){
			ChannelRecommend channelRecommend = new ChannelRecommend();
			String Relationship = channelRecommend.getRecommendOutRelationship(id, RelationID);
			return Relationship;
		}
		return "";
	}
	
	public String getRecommendOutRelation() throws MessageException, SQLException {
		if(RecommendOutRelation.equals("***"))
		{
			//继承属性
			Channel ch = getParentChannel();
			if(ch==null)
				return "";
			else
				return ch.getRecommendOutRelation();
		}
		return RecommendOutRelation;
	}

	public void setType2(int type2) {
		Type2 = type2;
	}

	public int getType2() {
		return Type2;
	}

	public void setExtra1(String extra1) {
		Extra1 = extra1;
	}

	public String getExtra1() {
		return Extra1;
	}

	public void setExtra2(String extra2) {
		Extra2 = extra2;
	}

	public String getExtra2() {
		return Extra2;
	}
	
	public String getRealImageFolder() throws MessageException, SQLException
	{
		return ChannelUtil.getRealImageFolder(this);
	}

	public void setIsWeight(int isWeight) {
		IsWeight = isWeight;
	}

	public int getIsWeight() {
		return IsWeight;
	}

	public void setIsComment(int isComment) {
		IsComment = isComment;
	}

	public int getIsComment() {
		return IsComment;
	}

	public void setIsClick(int isClick) {
		IsClick = isClick;
	}

	public int getIsClick() {
		return IsClick;
	}

	public int getIsShowDraftNumber() {
		return IsShowDraftNumber;
	}

	public void setIsShowDraftNumber(int isShowDraftNumber) {
		IsShowDraftNumber = isShowDraftNumber;
	}

	public String getListJS() throws MessageException, SQLException {
		if(ListJS.equals("***"))
		{
			//继承属性
			Channel ch = getParentChannel();
			if(ch==null)
				return "";
			else
				return ch.getListJS();
		}
		
		return ListJS;
	}

	public void setListJS(String listJS) {
		ListJS = listJS;
	}

	public String getDocumentJS() throws MessageException, SQLException {
		if(DocumentJS.equals("***"))
		{
			//继承属性
			Channel ch = getParentChannel();
			if(ch==null)
				return "";
			else
				return ch.getDocumentJS();
		}
		
		return DocumentJS;
	}

	public void setDocumentJS(String documentJS) {
		DocumentJS = documentJS;
	}

	public void setListProgram(String listProgram) {
		ListProgram = listProgram;
	}

	public String getListProgram() throws MessageException, SQLException {
		if(ListProgram.equals("***"))
		{
			//继承属性
			Channel ch = getParentChannel();
			if(ch==null)
				return "";
			else
				return ch.getListProgram();
		}
		
		return ListProgram;
	}

	public void setDocumentProgram(String documentProgram) {
		DocumentProgram = documentProgram;
	}

	public String getDocumentProgram() throws MessageException, SQLException {
		if(DocumentProgram.equals("***"))
		{
			//继承属性
			Channel ch = getParentChannel();
			if(ch==null)
				return "";
			else
				return ch.getDocumentProgram();
		}
		
		return DocumentProgram;
	}

	public void setDataSource(String dataSource) {
		DataSource = dataSource;
	}

	public String getDataSource() {
		return DataSource;
	}
	
	//获取该频道对应的数据源
	public TableUtil getTableUtil() throws MessageException, SQLException
	{
		if(getDataSource().length()>0)
			return new TableUtil(getDataSource());
		else
			return new TableUtil();
	}

	public void setCopyFromID(int copyFromID) {
		CopyFromID = copyFromID;
	}

	public int getCopyFromID() {
		return CopyFromID;
	}
	
	//增加一个连带发布，可以在模板中调用
	public void PublishChannel(int channelid) throws MessageException, SQLException
	{
		ChannelUtil.PublishChannel(channelid);
	}

	//增加一个连带发布，可以在模板中调用
	public void PublishDocument(int itemid) throws MessageException, SQLException
	{
		ChannelUtil.PublishDocument(getId(),itemid);
	}
	
	public void setHasFieldRecommend(boolean hasFieldRecommend) {
		this.hasFieldRecommend = hasFieldRecommend;
	}

	public boolean isHasFieldRecommend() {
		return hasFieldRecommend;
	}

	public void setListSql(String sql) {
		ListSql = sql;
	}

	public String getListSql() {
		return ListSql;
	}

	public void setIcon(String icon) {
		Icon = icon;
	}

	public String getIcon() {
		return Icon;
	}

	public void setImageFolderType(int imageFolderType) {
		ImageFolderType = imageFolderType;
	}

	public int getImageFolderType() {
		return ImageFolderType;
	}

	public int getIsListAll() {
		return IsListAll;
	}

	public void setIsListAll(int isListAll) {
		IsListAll = isListAll;
	}

	public int getViewType() {
		return ViewType;
	}

	public void setViewType(int viewType) {
		ViewType = viewType;
	}

	public int getTableChannelID() {
		return TableChannelID;
	}

	public void setTableChannelID(int tableChannelID) {
		TableChannelID = tableChannelID;
	}

	public int getIsTop() {
		return IsTop;
	}

	public void setIsTop(int isTop) {
		IsTop = isTop;
	}
	
	public int getIsPublishFile() {
		return IsPublishFile;
	}

	public void setIsPublishFile(int isPublishFile) {
		IsPublishFile = isPublishFile;
	}	
	
	//返回ChannelUtil类，供模板使用
	public ChannelUtil getChannelUtil()
	{
		return new ChannelUtil();
	}
	
	//根据频道编号，返回频道类，供模板使用
	public Channel getChannel(int channelid) throws MessageException
	{
		return CmsCache.getChannel(channelid);
	}

	public String getListSearchField() {
		return ListSearchField;
	}

	public void setListSearchField(String listSearchField) {
		ListSearchField = listSearchField;
	}

	public String getListShowField() {
		return ListShowField;
	}

	public void setListShowField(String listShowField) {
		ListShowField = listShowField;
	}

	public int getIsImportWord() {
		return IsImportWord;
	}

	public void setIsImportWord(int isImportWord) {
		IsImportWord = isImportWord;
	}

	public int getIsExportExcel() {
		return IsExportExcel;
	}

	public void setIsExportExcel(int isExportExcel) {
		IsExportExcel = isExportExcel;
	}

	public int getApproveScheme() {
		return ApproveScheme;
	}

	public void setApproveScheme(int approveScheme) {
		ApproveScheme = approveScheme;
	}

	public int getCompany() {
		return company;
	}

	public void setCompany(int company) {
		this.company = company;
	}

	public String getApplication() {
		return application;
	}

	public void setApplication(String application) {
		this.application = application;
	}

	public int getVersion() {
		return Version;
	}

	public void setVersion(int Version) {
		this.Version = Version;
	}

	public int getIsListConfig() {
		return IsListConfig;
	}

	public void setIsListConfig(int isListConfig) {
		IsListConfig = isListConfig;
	}

	public Company getCompanyInfo() {
		return companyInfo;
	}

	public void setCompanyInfo(Company companyInfo) {
		this.companyInfo = companyInfo;
	}
}
