/*
 * Created on 2004-8-12
 *
 */
package tidemedia.cms.system;

import java.sql.SQLException;
import java.util.ArrayList;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.PageControl;
import tidemedia.cms.publish.Publish;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.Util;

/**
 * @author 李永海(yonghai2008@gmail.com)
 *
 */
public class Controller {
	
	private Channel 	channel;
	private int 		PublishMode;//发布模式
	private int 		ChannelID;
	private int 		ItemID;
	private int			ItemPage;//文档分页
	private int			IncludeChildChannel;//是否包含子频道内容，适用于索引页模板
	private String 		TemplateLabel = "";//需要应用的模板标识，用于区分多个模板的情况 用来获取内容页链接用
	private ChannelTemplate ct;//给列表页用
	
	public PageControl pagecontrol = new PageControl();
	
	public Controller()  {
		
	}

	/*初始化控制器对象
	 * 
	 */	
	public void init() throws MessageException, SQLException
	{
		initChannel();
	}

	/*初始化频道对象，每个Controller都有一个频道对象
	 * 
	 */
	public void initChannel() throws MessageException, SQLException
	{
		if(channel==null && ChannelID>0)
			channel =  CmsCache.getChannel(ChannelID);	
	}


	public UserInfo getUserInfo(int id) throws SQLException, MessageException
	{
		return new UserInfo(id);
	}
	
	public Channel getChannel()
	{
		return channel;
	}
	
	public Channel getChannel(String SerialNo) throws MessageException, SQLException
	{
		channel = CmsCache.getChannel(SerialNo);
		return channel;
	}

	public Channel getChannel(int channelid) throws MessageException, SQLException
	{
		channel = CmsCache.getChannel(channelid);
		return channel;
	}
	
	public int getChannelID() {
		return ChannelID;
	}

	public void setChannelID(int i) throws MessageException, SQLException {
		ChannelID = i;
	}

	public int getItemID() {
		return ItemID;
	}

	public void setItemID(int i) {
		ItemID = i;
	}

	public Document getItem() throws MessageException, SQLException
	{
		return getDocument();
	}
	
	//获取一条纪录
	public Document getDocument() throws MessageException, SQLException
	{
		Document item = new Document(ItemID,ChannelID);
		item.setCurrentPage(ItemPage);
		return item;
	}

	//获取文档对象
	public Document getDocument(int globalid) throws MessageException, SQLException
	{
		return CmsCache.getDocument(globalid);
	}
	
	//获取文档对象
	public Document getDocument(int itemid,int channelid) throws MessageException, SQLException
	{
		return CmsCache.getDocument(itemid, channelid);
	}
	
	public void publishPrevNextDoc(int need) throws MessageException, SQLException
	{
		//System.out.println("controller itemid:"+ItemID+",need:"+need);
		if(need==1)
		{
			Document doc = getDocument();
			//System.out.println("controller itemid:"+ItemID+",doc:"+doc.getId()+",title:"+doc.getTitle());
			int itemid_prev = doc.getPrevItemID();
			int itemid_next = doc.getNextItemID();
			
			Publish publish = new Publish();
			publish.setPublishType(Publish.ONLY_DOCUMENT_PUBLISH);
			publish.setChannelID(ChannelID);
			publish.setPublishAllItems(0);
			
			if(itemid_prev>0)
			{
				publish.addPublishItems(itemid_prev);
				publish.setPublishPrevNextDoc(false);
				publish.GenerateFile();
			}

			if(itemid_next>0)
			{
				publish.addPublishItems(itemid_next);
				publish.setPublishPrevNextDoc(false);
				publish.GenerateFile();
			}
			
			//System.out.println("controller itemid:"+ItemID+",itemid_prev:"+itemid_prev+",itemid_next:"+itemid_next);
		}
	}
	
	public ArrayList<Document> listItems() throws MessageException, SQLException
	{
		return listItems(0);
	}

	public ArrayList<Document> listItems(String fields) throws MessageException, SQLException
	{
		return listItems(fields,getIncludeChildChannel());
	}
	
	public ArrayList<Document> listItems(String fields,String whereSql) throws MessageException, SQLException
	{
		//分页列出频道下面的文档，带附加条件
		ArrayList<Document> arraylist = new ArrayList<Document>();
		arraylist = channel.listItems(pagecontrol,fields,whereSql);
		setDocumentTemplateLable(arraylist);
		return arraylist;
	}
	
	public ArrayList<Document> listItems(String fields,String whereSql,String orderSql) throws MessageException, SQLException
	{
		//分页列出频道下面的文档，带附加条件
		ArrayList<Document> arraylist = new ArrayList<Document>();
		arraylist = channel.listItems(pagecontrol,fields,whereSql,orderSql);
		setDocumentTemplateLable(arraylist);
		return arraylist;
	}
	
	public ArrayList<Document> listItems(String fields,int includesubchannel) throws MessageException, SQLException
	{
		//分页列出频道下面的文档
		ArrayList<Document> arraylist = new ArrayList<Document>();
		arraylist = channel.listItems(pagecontrol,fields,getIncludeChildChannel());
		setDocumentTemplateLable(arraylist);
		return arraylist;
	}
	
	public ArrayList<Document> listItems(int includesubchannel) throws MessageException, SQLException
	{
		//分页列出频道下面的文档
		ArrayList<Document> arraylist = new ArrayList<Document>();
		arraylist = channel.listItems(pagecontrol,"",getIncludeChildChannel());
		setDocumentTemplateLable(arraylist);
		return arraylist;
	}	
	
	public ArrayList<Document> listAllItems() throws MessageException, SQLException
	{
		//全部记录
		ArrayList<Document> arraylist = new ArrayList<Document>();
		arraylist = channel.listAllItems();
		setDocumentTemplateLable(arraylist);
		return arraylist;
	}
	
	public ArrayList<Document> listTopItems(int number) throws MessageException, SQLException
	{
		//最前面几条记录
		ArrayList<Document> arraylist = new ArrayList<Document>();
		arraylist = channel.listTopItems(number);
		setDocumentTemplateLable(arraylist);
		return arraylist;
	}

	public ArrayList<Document> listTopItems(int number,int includesubchannel) throws MessageException, SQLException
	{
		//最前面几条记录
		ArrayList<Document> arraylist = new ArrayList<Document>();
		arraylist = channel.listTopItems(number,false,includesubchannel,"");
		setDocumentTemplateLable(arraylist);
		return arraylist;
	}
	
	public ArrayList<Document> listTopItems(int number,boolean notincludephoto) throws MessageException, SQLException
	{
		//最前面几条记录 notincludephoto==true 不包括图片新闻
		ArrayList<Document> arraylist = new ArrayList<Document>();
		arraylist = channel.listTopItems(number,notincludephoto,1,"");
		setDocumentTemplateLable(arraylist);
		return arraylist;
	}
	
	public ArrayList<Document> listTopPhotoItems(int number) throws MessageException, SQLException
	{
		//本频道最前面几条图片新闻
		ArrayList<Document> arraylist = new ArrayList<Document>();
		arraylist = channel.listTopPhotoItems(number);
		setDocumentTemplateLable(arraylist);
		return arraylist;
	}	

	//取头条，按查询条件
	public ArrayList<Document> listTopItems(int number,String sql) throws MessageException, SQLException
	{
		//最前面几条记录
		ArrayList<Document> arraylist = new ArrayList<Document>();
		arraylist = channel.listTopItems(number,sql);
		setDocumentTemplateLable(arraylist);
		return arraylist;
	}
	
	//取头条，按查询条件
	public ArrayList<Document> listTopItems(int number,int includesubchannel,String sql) throws MessageException, SQLException
	{
		//最前面几条记录
		ArrayList<Document> arraylist = new ArrayList<Document>();
		arraylist = channel.listTopItems(number,false,includesubchannel,sql);
		setDocumentTemplateLable(arraylist);
		return arraylist;
	}
	
	public int getTotalNumber()
	{
		//总共记录数
		return pagecontrol.getRowsCount();
	}
	
	public int getCurrentPage()
	{
		//当前页数，从1开始
		return pagecontrol.getCurrentPage();		
	}

	public int getPageNumber()
	{
		//总共页数，从1开始
		return pagecontrol.getMaxPages();			
	}
	
	public boolean hasPrevious()
	{
		//是否有前一页
		return pagecontrol.hasPrevious();
	}
	
	public int getPreviousPage()
	{
		return getCurrentPage()-1; 
	}
	
	public boolean hasNext()
	{
		//是否有后一页
		return pagecontrol.hasNext();
	}	
	
	public int getNextPage()
	{
		return getCurrentPage()+1;
	}
	
	//	上一页链接
	public String getPrevPageHref() throws MessageException, SQLException
	{
		String href = "";

		if(ct==null) ct = CmsCache.getChannel(getChannelID()).getChannelTemplates(1, getTemplateLabel());
		
		if(getPreviousPage()>1)
			href = ct.getIndexFilePrefix() + "_" + getPreviousPage() + "." + (ct.getIndexFileExt().equals("")?"htm":ct.getIndexFileExt());
		else
			href = ct.getIndexFilePrefix() + "." + (ct.getIndexFileExt().equals("")?"htm":ct.getIndexFileExt());	
		
		return href;
	}
	
	//下一页链接
	public String getNextPageHref() throws MessageException, SQLException
	{
		String href = "";

		if(ct==null) ct = CmsCache.getChannel(getChannelID()).getChannelTemplates(1, getTemplateLabel());
		
		if(PublishMode==2)
		{
			href = ct.getIndexFilePrefix() + "_" + getNextPage() + "." + (ct.getIndexFileExt().equals("")?"htm":ct.getIndexFileExt());
		}
		else if(PublishMode==1)
		{
			href = ct.getIndexFilePrefix() + ".jsp?Page=" + getNextPage();
		}		
		return href;
	}

	public String getPageHref(int page) throws MessageException, SQLException
	{
		String href = "";

		if(ct==null)
			ct = CmsCache.getChannel(getChannelID()).getChannelTemplates(1, getTemplateLabel());
		
		if(PublishMode==2)
		{//System.out.println("id:"+ct.getId()+"temp:"+ct.getTargetName() + "prefix:"+ct.getIndexFilePrefix());
			if(page>1)
				href = ct.getIndexFilePrefix() + "_" + page + "." + (ct.getIndexFileExt().equals("")?"htm":ct.getIndexFileExt());
			else
				href = ct.getIndexFilePrefix() + "." + (ct.getIndexFileExt().equals("")?"htm":ct.getIndexFileExt());
		}
		else if(PublishMode==1)
		{
			href = ct.getIndexFilePrefix() + ".jsp?Page=" + page;
		}		
		return href;
	}
	
/*	//分类索引页面链接
	public String getCategoryIndexHref() throws MessageException, SQLException
	{
		return getCategoryIndexHref(CategoryID);
	}*/
	
	//分类索引页面链接
	public String getCategoryIndexHref(int categoryid) throws MessageException, SQLException
	{
		String href = "";

		//Category category = new Category(categoryid);
		
		//在有分类的情况下，IndexFileName对应的是分类索引文件名
		/*if(PublishMode==2)
		{
			href = IndexFileName + "." + (IndexFileExt.equals("")?"htm":IndexFileExt);
		}
		else if(PublishMode==1)
		{
			href = IndexFileName + "(" + ").jsp";
		}*/
		
		return href;
	}
	

	public int getPublishMode() {
		return PublishMode;
	}

	public void setPublishMode(int i) {
		PublishMode = i;
	}
	
	/**
	 * @return Returns the itemPage.
	 */
	public int getItemPage() {
		return ItemPage;
	}
	/**
	 * @param itemPage The itemPage to set.
	 */
	public void setItemPage(int itemPage) {
		ItemPage = itemPage;
	}
	
	public Util  getUtil()
	{
		return new tidemedia.cms.util.Util();
	}

	public ItemUtil  getItemUtil()
	{
		return new tidemedia.cms.system.ItemUtil();
	}	
	
	//批量设置文档对象的模板标识
	private void setDocumentTemplateLable(ArrayList<Document> arraylist)
	{
		if(arraylist!=null)
		{
			for(int i = 0;i<arraylist.size();i++)
			{
				Document item = (Document)arraylist.get(i);
				item.setTemplateLabel(getTemplateLabel());
			}
		}
	}

	/**
	 * @param category The category to set.
	 */
/*	public void setCategory(Category category) {
		this.category = category;
	}*/
	/**
	 * @param channel The channel to set.
	 */
	public void setChannel(Channel channel) {
		this.channel = channel;
	}

	public String getTemplateLabel() {
		return TemplateLabel;
	}

	public void setTemplateLabel(String templateLabel) {
		TemplateLabel = templateLabel;
	}
	
	public int getIncludeChildChannel() {
		return IncludeChildChannel;
	}

	public void setIncludeChildChannel(int includeChildChannel) {
		IncludeChildChannel = includeChildChannel;
	}

	public void setChannelTemplate(ChannelTemplate channelTemplate) {
		this.ct = channelTemplate;
	}

	public ChannelTemplate getChannelTemplate() {
		return ct;
	}	
}
