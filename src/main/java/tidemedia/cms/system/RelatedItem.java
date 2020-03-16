package tidemedia.cms.system;

import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;

public class RelatedItem extends Table{

	public RelatedItem() throws MessageException, SQLException {
		super();
	}

	private int id;
	private int GlobalID = 0;//相关新闻的GlobalID
	private String Title;//相关文章的标题
	private int	ChannelID;//相关文章的频道
	private int ItemID;//相关文章的编号

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return Title;
	}

	public String getTitle(int titleword) {
		if(titleword>0)
		{
			return substring(Title,titleword);
		}
		else
			return Title;
	}

	public String getTitle(int titleword,String str) {
		if(titleword>0)
		{
			return substring(Title,titleword,str);
		}
		else
			return Title;
	}
	
	//用于截断文字
	public String substring(String str,int len)
	{
		if(str==null)
			return "";
		
		if(str.length()<=len)
			return str;
		else
		{
			str = str.substring(0,len) + "...";
		}
		
		return str;
	}
	
	//用于截断文字
	public String substring(String str,int len,String str1)
	{
		if(str==null)
			return "";
		
		if(str.length()<=len)
			return str;
		else
		{
			str = str.substring(0,len) + str1;
		}
		
		return str;
	}
	
	public void setTitle(String title) {
		Title = title;
	}

	public void Add() throws SQLException, MessageException {
		
	}

	public void Delete(int id) throws SQLException, MessageException 
	{
		String Sql = "delete from related_doc where GlobalID=" + id + " or RelatedGlobalID=" + id;
		executeUpdate(Sql);
	}

	public void Update() throws SQLException, MessageException {
		
	}

	public boolean canAdd() {
		return false;
	}

	public boolean canDelete() {
		return false;
	}

	public boolean canUpdate() {
		return false;
	}

	public int getGlobalID() {
		return GlobalID;
	}

	public void setGlobalID(int globalID) {
		GlobalID = globalID;
	}

	public int getChannelID() {
		return ChannelID;
	}

	public void setChannelID(int channelID) {
		ChannelID = channelID;
	}

	public int getItemID() {
		return ItemID;
	}

	public void setItemID(int itemID) {
		ItemID = itemID;
	}
	
	public Channel getChannel() throws MessageException, SQLException
	{
		return CmsCache.getChannel(ChannelID);
	}
	
	//更新状态
	public void UpdateStatus(int globalID,int status) throws SQLException, MessageException {
		String Sql = "";
		
		Sql = "update related_doc set ";
		Sql += "RelatedStatus=" + status + "";
		
		Sql += " where RelatedGlobalID=" + globalID;
		
		executeUpdate(Sql);	
	}
	
	public String getHref() throws SQLException, MessageException {
		return new Document(GlobalID).getHref();
	}

	public String getHttpHref() throws SQLException, MessageException {
		Document item = new Document(GlobalID);
		String href = item.getValue("Href");
		if(href.equals(""))
			return item.getHttpHref();
		else
			return href;
	}
	
	public String getFullHref() throws SQLException, MessageException
	{
		return getFullHref("");
	}
	
	public String getFullHref(String TemplateLabel) throws SQLException, MessageException
	{
		Document doc = new Document(GlobalID);
		doc.setTemplateLabel(TemplateLabel);

		return doc.getFullHref();
	}
}
