package tidemedia.cms.plugin;

import java.sql.SQLException;
import java.util.ArrayList;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.ItemSnap;
import tidemedia.cms.util.Util;

public class TideApi {
	
	private int GlobalID 		= 0;
	private int	ChannelID 		= 0;
	private String ChannelCode 	= "";
	private boolean isPrefixChannelCode = false;//在xml中是带星号的channelcode
	private String Name			= "";//接口名称
	private String Action 		= "";//操作
	private String Url 			= "";//接口链接
	private String Method 		= "get";//发送方式,get or post,默认是get
	private String Template 		= "";//内容
	private ArrayList<String[]> fields		= new ArrayList<String[]>();//参数
	
	public TideApi()
	{
		
	}

	public int getGlobalID() {
		return GlobalID;
	}

	public void setGlobalID(int globalID) {
		GlobalID = globalID;
	}

	public String getUrl() {
		return Url;
	}

	public void setUrl(String url) {
		Url = url;
	}

	public void setMethod(String method) {
		Method = method;
	}

	public String getMethod() {
		return Method;
	}

	public void setFields(ArrayList<String[]> fields) {
		this.fields = fields;
	}

	public ArrayList<String[]> getFields() {
		return fields;
	}
	
	public void addField(String[] field)
	{
		getFields().add(field);
	}
	
	public ItemSnap getItemSnap() throws SQLException, MessageException
	{
		return new ItemSnap(GlobalID);
	}

	public void setChannelID(int channelID) {
		ChannelID = channelID;
	}

	public void setChannelID(String channelID) {
		ChannelID = Util.parseInt(channelID);
	}
	
	public int getChannelID() {
		return ChannelID;
	}

	public void setAction(String action) {
		//action为空
		if(action.length()>0)
			Action = ","+action+",";
		else
			Action = "";
	}

	public String getAction() {
		return Action;
	}

	public void setName(String name) {
		Name = name;
	}

	public String getName() {
		return Name;
	}

	public void setChannelCode(String channelCode) {
		ChannelCode = channelCode;
	}

	public String getChannelCode() {
		return ChannelCode;
	}

	public void setPrefixChannelCode(boolean isPrefixChannelCode) {
		this.isPrefixChannelCode = isPrefixChannelCode;
	}

	public boolean isPrefixChannelCode() {
		return isPrefixChannelCode;
	}

	public void setTemplate(String content) {
		Template = content;
	}

	public String getTemplate() {
		return Template;
	}

}
