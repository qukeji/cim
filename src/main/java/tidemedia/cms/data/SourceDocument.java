/*
 * Created on 2005-8-15
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package tidemedia.cms.data;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Random;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.system.Channel;

/**
 * @author Administrator
 *

 */
public class SourceDocument extends Table{

	private String Title = "";
	private String Summary = "";
	private String Content = "";
	private String DocFrom = "";
	private String CreateDate = "";
	private String ChannelName = "";
	private String FileName = "";
	
	private ArrayList ParentChannelNames = new ArrayList();	

	public SourceDocument() throws MessageException, SQLException {
		//super();
	}	
	/**
	 * @return Returns the content.
	 */
	public String getContent() {
		return Content;
	}
	/**
	 * @param content The content to set.
	 */
	public void setContent(String content) {
		Content = content;
	}
	/**
	 * @return Returns the date.
	 */
	public String getCreateDate() {
		return CreateDate;
	}
	/**
	 * @param date The date to set.
	 */
	public void setCreateDate(String date) {
		CreateDate = date;
	}
	/**
	 * @return Returns the summary.
	 */
	public String getSummary() {
		return Summary;
	}
	/**
	 * @param summary The summary to set.
	 */
	public void setSummary(String summary) {
		Summary = summary;
	}
	/**
	 * @return Returns the title.
	 */
	public String getTitle() {
		return Title;
	}
	/**
	 * @param title The title to set.
	 */
	public void setTitle(String title) {
		Title = title;
	}
	/**
	 * @return Returns the docFrom.
	 */
	public String getDocFrom() {
		return DocFrom;
	}
	/**
	 * @param docFrom The docFrom to set.
	 */
	public void setDocFrom(String docFrom) {
		DocFrom = docFrom;
	}
	/**
	 * @return Returns the channelName.
	 */
	public String getChannelName() {
		return ChannelName;
	}
	/**
	 * @param channelName The channelName to set.
	 */
	public void setChannelName(String channelName) {
		ChannelName = channelName;
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canAdd()
	 */
	public boolean canAdd() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canUpdate()
	 */
	public boolean canUpdate() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canDelete()
	 */
	public boolean canDelete() {
		return false;
	}
	
	public void Save() throws SQLException, MessageException
	{
		String Sql;
		ResultSet Rs;
		int ParentID = 0;

		if(ParentChannelNames!=null && ParentChannelNames.size()>0)
		{
			for(int i = 0;i<ParentChannelNames.size();i++)
			{
				String name = (String)ParentChannelNames.get(i);
				Sql = "select * from channel where Name='" + SQLQuote((name)) + "'";
				
				if(ParentID>0)
					Sql += " and Parent=" + ParentID;
				
				Rs = executeQuery(Sql);
				if(Rs.next())
				{
					ParentID = Rs.getInt("id");
				}
				else
				{
					ParentID = 0;
					break;
				}
			}
		}

		Sql = "select * from channel where Name='" + SQLQuote((ChannelName)) + "'";
		if(ParentID>0)
			Sql += " and Parent=" + ParentID;		
		//System.out.println(Sql);
		Rs = executeQuery(Sql);
		if(!Rs.next())
		{	
			ParentID=0;
		}
		closeRs(Rs);
		
		
		if(ParentID==0 && ParentChannelNames!=null && ParentChannelNames.size()>0)
		{
			for(int i = ParentChannelNames.size()-1;i>=0;i--)
			{
				String name = (String)ParentChannelNames.get(i);
				
				ChannelName = name + "_" + ChannelName;
				
				//System.out.println(i+ ":" + name + ":"+ChannelName);
			}
		}
		
		Sql = "select * from channel where Name='" + SQLQuote((ChannelName)) + "'";
		if(ParentID>0)
			Sql += " and Parent=" + ParentID;		
		//System.out.println(Sql);
		Rs = executeQuery(Sql);
		if(Rs.next())
		{			
		}
		else
		{
			Sql = "select * from channel where Name='临时数据'";
			ResultSet rs = executeQuery(Sql);
			if(rs.next())
			{
				Channel channel = new Channel();
				
				channel.setName(ChannelName);
				channel.setSerialNo(randomString(20));
				channel.setParent(rs.getInt("id"));
				channel.setIsDisplay(1);
				channel.setHref("");
				channel.setType(1);
				channel.Add();
			}
			closeRs(rs);
		}
		closeRs(Rs);
		
		Sql = "select * from channel where Name='" + SQLQuote((ChannelName)) + "'";
		if(ParentID>0)
			Sql += " and Parent=" + ParentID;
		//System.out.println(Sql);
		Rs = executeQuery(Sql);
		if(Rs.next())
		{
			int id = Rs.getInt("id");
			int type = Rs.getInt("Type");
			String serialno = convertNull(Rs.getString("SerialNo"));
			int category = 0;
			
			if(type==0)
			{
				//频道
			}
			else if(type==1)
			{
				//Category cg = new Category(id);
				Channel ch = new Channel(new Channel(id).getParentTableChannelID());
				serialno = ch.getSerialNo();
				category = id;
			}
			
			Sql = "insert into channel_" + serialno + " (Title,Content,Summary,";
			
			if(!FileName.equals(""))
				Sql += " File,";
			
			Sql += " Status,PublishDate,Category,DocFrom,Active,User,TotalPage)";
			Sql += " values(";

			Sql += "'" + SQLQuote(Title) + "'";
			Sql += ",'" + SQLQuote(Content) + "'";
			Sql += ",'" + SQLQuote(Summary) + "'";
			
			if(!FileName.equals(""))
				Sql += ",'" + SQLQuote(FileName) + "'";
			
			Sql += ",1";
			Sql += ",'" + SQLQuote(CreateDate) + "'";
			Sql += "," + category;
			Sql += ",'" + SQLQuote(DocFrom) + "'";
			Sql += ",1,1,1";
			
			Sql += ")";
			
			executeUpdate(Sql);
			//System.out.println(Title);
		}
		
		closeRs(Rs);
	}

	public  String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("GBK");
			String temp = new String(temp_t, "utf-8");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}

    public  String randomString(int length) {
        if (length < 1) {
            return null;
        }
        Random randGen = null;
        char[] numbersAndLetters = null;
        //Init of pseudo random number generator.
        if (randGen == null) {

                if (randGen == null) {
                    randGen = new Random();
                    //Also initialize the numbersAndLetters array
                    numbersAndLetters = ("abcdefghijklmnopqrstuvwxyz" +
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ").toCharArray();
                }
            
        }
        //Create a char buffer to put random letters and numbers in.
         
        char [] randBuffer = new char[length];
        for (int i=0; i<randBuffer.length; i++) {
            randBuffer[i] = numbersAndLetters[randGen.nextInt(51)];
        }
        return new String(randBuffer);
    }	
	/**
	 * @return Returns the fileName.
	 */
	public String getFileName() {
		return FileName;
	}
	/**
	 * @param fileName The fileName to set.
	 */
	public void setFileName(String fileName) {
		FileName = fileName;
	}
	
	public void addParentChannelName(String name)
	{
		ParentChannelNames.add(name);
	}
	/**
	 * @return Returns the parentChannelNames.
	 */
	public ArrayList getParentChannelNames() {
		return ParentChannelNames;
	}
	/**
	 * @param parentChannelNames The parentChannelNames to set.
	 */
	public void setParentChannelNames(ArrayList parentChannelNames) {
		ParentChannelNames = parentChannelNames;
	}
}
