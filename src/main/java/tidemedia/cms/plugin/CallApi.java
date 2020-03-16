package tidemedia.cms.plugin;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;

import org.springframework.aop.interceptor.SimpleTraceInterceptor;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.*;
import tidemedia.cms.util.Util;
import tidemedia.cms.util.WordUtil;

public class CallApi extends Table implements Runnable{
	
	private int 		GlobalID 	= 0;//文档全局编号
	private int			Action 		= 0;//动作
	private int			ActionUser	= 0;//操作者
	private boolean 	checkOnlyAction = false;//仅检查动作
	private String		appendParameter = "";//附加参数
	private boolean 	printApi 		= false;//是否打印接口信息
	private String 		url 		= "";//调用地址，如果设置url，直接调用
	
	private Document 	item 		= null;

	private HttpServletRequest hsRequest = null;
	private Thread 	runner;
	
	public CallApi() throws MessageException, SQLException {
		super();
	}

	public void Start()
	{
	    runner = new Thread(this);
	    runner.start();	 
	    //System.out.println("runner.getId():"+runner.getId());
	}
	
	public void run()
	{
		if(url.length()>0)
		{
			Util.connectHttpUrl(url);
			return;
		}
		
		ArrayList<TideApi> arraylist = CmsCache.getTideapis();
		//System.out.println("api size:"+arraylist.size()+",runnerid:"+runner.getId()+",action:"+Action);
		if(arraylist!=null && arraylist.size()>0)
		{
			for(int i = 0;i<arraylist.size();i++)
			{
				TideApi api = arraylist.get(i);
				//System.out.println(api.getName());
				if(checkApi(api))
				{
					//System.out.println(":"+api.getName()+",code:"+getChannelCode()+",api code:"+api.getChannelCode());
					try {
						executeApi(api);
					} catch (MessageException e) {
						e.printStackTrace();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}
		}
		
		//执行一下非常规接口或动作
		if(item!=null)
		{
			//System.out.println("item.getChannelID():"+item.getChannelID());
			//敏感词库
			if(item.getChannelID()==14142)
			{
				WordUtil.initSensitiveword();//设置需要更新词库
			}
		}
	}
	
	//是否调用API
	public boolean checkApi(TideApi api)
	{
		//action为空，代表不判断action
		//System.out.println("api action:"+api.getAction()+":"+getAction());
		//System.out.println("result:"+api.getAction().contains(","+getAction()+","));
		if(api.getAction().length()>0 && !api.getAction().contains(","+getAction()+","))//判断动作
			return false;
		
		if(isCheckOnlyAction())
			return true;
		
		if(api.getChannelID()==0)
		{
			String s[] = Util.StringToArray(api.getChannelCode(),",");
			for(int i=0;s!=null && i<s.length;i++)
			{
				String ss = s[i];
				if(ss.equals(getChannelCode()))
					return true;
				else
				{
					if(ss.endsWith("*"))
					{
						ss = ss.substring(0,ss.length()-1);
						if(getChannelCode().startsWith(ss))
							return true;
					}
				}
			}
			//String apiChannelCode = ","+api.getChannelCode()+",";				
			//if(apiChannelCode.contains(","+getChannelCode()+",") || apiChannelCode.contains(","+getChannelCode()+"*,"))
			//	return true;
			
			//不检查channelid
			//System.out.println(api.getName()+":"+api.isPrefixChannelCode()+":"+getChannelCode());
			/*
			if(api.isPrefixChannelCode())
			{
				String apiChannelCode = ","+api.getChannelCode()+",";				
				if(apiChannelCode.contains(","+getChannelCode()+",") || apiChannelCode.contains(","+getChannelCode()+"*,"))
					return true;
			}
			else
			{
				if(getChannelCode().equals(api.getChannelCode()))
					return true;
			}
			*/
		}
		else
		{
			//System.out.println("getChannelID():"+getChannelID()+",api channelid:"+api.getChannelID());
			if(getChannelID()==api.getChannelID())
				return true;
		}
		
		return false;
	}
	
	public void executeApi(TideApi api) throws MessageException, SQLException {
		if(api==null)
			return;
		
		//接口可以不调用url，而是执行模板语句
		//System.out.println("url:"+api.getUrl()+","+api.getMethod());
		//if(api.getUrl().equals(""))
		//	return;
		
		//Log.SystemLog("接口调用", "调用接口开始："+api.getName());
		
		if(api.getMethod().equals("get"))//get发送方式
		{
			executeGetApi(api);
		}
		else if(api.getMethod().equals("post"))//post发送方式
		{
			executePostApi(api);
		}
		else if(api.getMethod().equals("velocity"))//post发送方式
		{
			executeVelocityApi(api);
		}
		
		//Log.SystemLog("接口调用", "调用接口结束："+api.getName());
	}
	
	public void executeVelocityApi(TideApi api)
	{
        try {
        	//System.out.println("execute:"+api.getTemplate());
        	if(item!=null)
        	{
	    		Velocity.init();
	    		VelocityContext context = new VelocityContext();
	    		context.put("util", new Util());
	    		context.put("item", item);
	    		context.put("action",getAction());
	    		context.put("tidecms",new Tidecms());
	    		StringWriter w = new StringWriter();
				Velocity.evaluate(context, w, "mystring", api.getTemplate());
        	}
			//System.out.println("execute:"+api.getTemplate());
		} catch (Exception e) {
			ErrorLog.SaveErrorLog("API模板错误.",api.getName()+","+e.getMessage(),0,e);
		}
	}
	
	public void executeGetApi(TideApi api) throws MessageException, SQLException
	{
		String content = "";
		String sCurrentLine = "";
		java.net.URL l_url;
		String url = "";
		try {
		url = api.getUrl();
		
		String outs = getParameter(api);
		if(url.indexOf("?")!=-1)
		{
			if(!outs.equals("") && !outs.startsWith("&"))
				url += "&" + outs;
		}
		else
			url += "?" + outs;

		if(url.indexOf("?")==-1 && getAppendParameter().indexOf("?")==-1)
			url += "?"+getAppendParameter();
		else
			url += getAppendParameter();
		
		url = url.replace("action_user=*", "action_user="+getActionUser());
		url = url.replace("action=*", "action="+getAction());
		url = url.replace("channelid=*", "channelid="+getChannelID());
		url = url.replace("companyid=*", "companyid="+getCompanyID());
		
		if(isPrintApi())
			System.out.println(url);
		//System.out.println(url);
		l_url = new java.net.URL(url);
		java.net.HttpURLConnection con = (java.net.HttpURLConnection) l_url.openConnection();
		HttpURLConnection.setFollowRedirects(true);
		con.setInstanceFollowRedirects(false);
		con.connect(); 
		java.io.InputStream l_urlStream = con.getInputStream(); 
		java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream)); 
		while ((sCurrentLine = l_reader.readLine()) != null) 
		{
			content+=sCurrentLine; 
		}
		
		if(isPrintApi())
			System.out.println(content);
		
		} catch (MalformedURLException e) {
			System.out.println(url + " cann't connect");
			//e.printStackTrace(System.out);
		} catch (IOException e) {
			System.out.println(url + " cann't connect");
			//e.printStackTrace(System.out);
		} 		
	}
	public void executePostApi(TideApi api) throws MessageException, SQLException
	{
		URL url;
		try {
			url = new URL(api.getUrl());
			java.net.HttpURLConnection connection = (java.net.HttpURLConnection) url.openConnection();
			connection.setDoOutput(true);  
			connection.setUseCaches(false);
			connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded");  
			connection.setRequestMethod("POST");
			connection.connect();
			OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream(), "utf-8");
			
			String outs = getParameter(api);
			//print(outs);
			out.write(outs);
			out.flush();
			
			java.io.InputStream l_urlStream = connection.getInputStream(); 
			java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream)); 
			while ((l_reader.readLine()) != null) 
			{
				//content+=sCurrentLine; 
			}		

			
			out.close();
			out = null;
			connection.disconnect();
			connection = null;
		} catch (MalformedURLException e) {
			String ErrorMessage = "接口：" + api.getUrl();
			ErrorLog.SaveErrorLog("接口调用错误.",ErrorMessage,-1,e);
		} catch (IOException e) {
			String ErrorMessage = "接口：" + api.getUrl();
			ErrorLog.SaveErrorLog("接口调用错误.",ErrorMessage,-1,e);
		} 
	}
	
	public String getParameter(TideApi api) throws MessageException, SQLException
	{
		//tidecms_action 对应action
		String outs = "";
		TableUtil tu = getItem().getChannel().getTableUtil();
		if(api.getFields()!=null && api.getFields().size()>0)
		{//print("fields size:"+api.getFields().size());
			ArrayList<String[]> fields = api.getFields();
			String fs = "";
			for(int i = 0;i<fields.size();i++)
			{
				String[] s = (String[]) fields.get(i);
				//System.out.println("s2:"+s[2]);
				if(s[2].equals("Field"))
					fs += (fs.equals("")?"":",") + s[1];
			}
			
			try
			{
				if(!fs.equals(""))
				{
					String table = getItem().getChannel().getTableName();
					String sql = "select " + fs + " from " + table + " where GlobalID=" + getGlobalID();
					if(getGlobalID()==0)//globalid 不存在
					{
						sql = "select " + fs + " from " + table + " where id=" + getItem().getId();
					}
//System.out.println(sql);
					ResultSet rs = tu.executeQuery(sql);
					if(rs.next())
					{
						for(int i = 0;i<fields.size();i++)
						{
							String[] s = (String[]) fields.get(i);
							String name = s[0];
							String value = s[1];

							if(s[2].equals("Field"))
								outs += (outs.equals("")?"":"&") + name + "=" + URLEncoder.encode(convertNull(rs.getString(value)),"utf-8");
						}
					}

					tu.closeRs(rs);
				}

				for(int i = 0;i<fields.size();i++)
				{
					String[] s = (String[]) fields.get(i);
					String name = s[0];
					String value = s[1];
					//print("name:"+name+",value:"+value);
					if(s[2].equals("") || s[2].equalsIgnoreCase("String"))
					{
						if(name.equals("tidecms_action"))						
							outs += (outs.equals("")?"":"&") + name + "=" + getAction();					
						else
							outs += (outs.equals("")?"":"&") + name + "=" + value;
					}
				}

			}catch(SQLException e)
			{
				String ErrorMessage = "接口：" + api.getUrl();
				if(e.getMessage().indexOf("Unknown column")!=-1)
					ErrorMessage += "\r\n错误信息：字段不存在.";
				ErrorLog.SaveErrorLog("接口调用错误.",ErrorMessage,-1,e);				
			} catch (MessageException e) {
				String ErrorMessage = "接口：" + api.getUrl();
				ErrorLog.SaveErrorLog("接口调用错误.",ErrorMessage,-1,e);
			} catch (UnsupportedEncodingException e) {
				String ErrorMessage = "接口：" + api.getUrl();
				ErrorLog.SaveErrorLog("接口调用错误.",ErrorMessage,-1,e);
			}
		}
		//System.out.println("outs:"+outs);
		return outs;
	}
	
	public String connectHttpUrl(String url,boolean print)
	{
		String content = "";
		String sCurrentLine = "";
		java.net.URL l_url;
		try {
			l_url = new java.net.URL(url);
		if(print)	System.out.println(url);
		java.net.HttpURLConnection con = (java.net.HttpURLConnection) l_url.openConnection();
		HttpURLConnection.setFollowRedirects(true);
		con.setInstanceFollowRedirects(false);
		con.connect(); 
		java.io.InputStream l_urlStream = con.getInputStream(); 
		java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream)); 
		while ((sCurrentLine = l_reader.readLine()) != null) 
		{ 
			content+=sCurrentLine; 
		}		
		if(print)	System.out.println(content);
		} catch (MalformedURLException e) {
			System.out.println("cann't connect");
			//e.printStackTrace(System.out);
		} catch (IOException e) {
			System.out.println("cann't connect");
			//e.printStackTrace(System.out);
		} 
		
		return content;
	}
	
	@Override
	public void Add() throws SQLException, MessageException {
		
	}

	@Override
	public void Delete(int id) throws SQLException, MessageException {
		
	}

	@Override
	public void Update() throws SQLException, MessageException {
		
	}

	@Override
	public boolean canAdd() {
		return false;
	}

	@Override
	public boolean canDelete() {
		return false;
	}

	@Override
	public boolean canUpdate() {
		return false;
	}

	public int getGlobalID() {
		return GlobalID;
	}

	public void setGlobalID(int globalID) {
		GlobalID = globalID;
	}

	//获取租户id
	public int getCompanyID(){
		try {
			if(item==null){
				int company = new ItemSnap(GlobalID).getChannel().getSite().getCompany();
				return company;
			}
			else{
				int company = item.getChannel().getSite().getCompany();
				return company;
			}
		} catch (Exception e) {
			System.out.println("callapi,getcompanyid:"+e.getMessage());
			return 0;
		}
	}

	public int getChannelID()
	{
		try {
			if(item==null)
				return new ItemSnap(GlobalID).getChannelID();
			else
				return item.getChannelID();
		} catch (Exception e) {
			System.out.println("callapi,getchannelid:"+e.getMessage());
			return 0;
		}
	}

	public String getChannelCode()
	{
		try {
			if(item==null)
				return new ItemSnap(GlobalID).getChannelCode();
			else
				return item.getChannel().getChannelCode();
		} catch (Exception e) {
			return "";
		}
	}
	
	public int getAction() {
		return Action;
	}

	public void setAction(int action) {
		Action = action;
	}

	public void setActionUser(int actionUser) {
		ActionUser = actionUser;
	}

	public int getActionUser() {
		return ActionUser;
	}

	public void setCheckOnlyAction(boolean checkOnlyAction) {
		this.checkOnlyAction = checkOnlyAction;
	}

	public boolean isCheckOnlyAction() {
		return checkOnlyAction;
	}

	public void setAppendParameter(String appendParameter) {
		this.appendParameter = appendParameter;
	}

	public String getAppendParameter() {
		return appendParameter;
	}

	public void setPrintApi(boolean printApi) {
		this.printApi = printApi;
	}

	public boolean isPrintApi() {
		return printApi;
	}
	
	public Document getItem() {
		return item;
	}

	public void setItem(Document item) {
		this.item = item;
	}	
/*

32      * 反射机制下的方法调用
33      * @param className Object    实例
34      * @param methodName String   方法名
35      * @param parameterClasses Class[]   参数类型
36      * @param parameterObjects Object[]   参数内容
37      * @return Object   返回值
38      
39     private Object reflectClassFunByInstance(Object instance,
40                                              String methodName,
41                                              Class[] parameterClasses,
42                                              Object[] parameterObjects)
43     {
44         if(instance == null)
45         {
46             logger.error("Instance is null !");
47             return null;
48         }
49
50         Method method = null;
51         try
52         {
53             method = instance.getClass().getMethod(methodName,
54                 parameterClasses);
55             return method.invoke(instance, parameterObjects);
56         }
57         catch(Exception ex)
58         {
59             logger.error("Didn't find the method : ", ex);
60         }
61
62         return null;
63     }
 */

	public void setHsRequest(HttpServletRequest hsRequest) {
		this.hsRequest = hsRequest;
	}

	public HttpServletRequest getHsRequest() {
		return hsRequest;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
}
