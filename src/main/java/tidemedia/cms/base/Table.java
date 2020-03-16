package tidemedia.cms.base;

import tidemedia.cms.system.CmsCache;
import tidemedia.cms.util.Util;
import tidemedia.tcenter.base.ApplicationContextProvider;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.util.LinkedList;

public abstract class Table {
    //private static ApplicationContext ac = new ClassPathXmlApplicationContext("dbconfig.xml");

	public Table()
	{
	    //ac = new ClassPathXmlApplicationContext("dbconfig.xml");
	}

	public Table(String dataSource) throws MessageException, SQLException
	{
	    //ac = new ClassPathXmlApplicationContext("dbconfig.xml");
		this.dataSource = dataSource;
	}
	
	private String		dataSource = "";
	private Connection connection;
	public PageControl pagecontrol;
	private int		retry = 0;//数据库连接次数

	public static boolean topsql_flag = false;
	public static String topsql = "";
	public static long topsql_time = 0;
	
	public static boolean listsql_flag = false;//是否记录sql运行时间链表，如果为true，当运行时间大于sql_list_time的sql语句会记录到链表中，最多不超过sql_list_number;
	public static LinkedList<String[]> listsql = new LinkedList<String[]>();
	public static long listsql_time = 0;
	public static int listsql_number = 50;
	
	/**
	 * Method Add.
	 * @throws MessageException
	 */
	public abstract void Add() throws SQLException, MessageException;
	public abstract void Delete(int id) throws SQLException, MessageException, IOException, ParseException;
	public abstract void Update() throws SQLException, MessageException;
	public abstract boolean canAdd();
	public abstract boolean canUpdate();
	public abstract boolean canDelete();

	//20191028 liyonghai 修改成使用框架的数据源
    public void createConnection() throws MessageException, SQLException
    {
        if(connection==null || connection.isClosed())
        {
            try{
                //if(dataSource=="") dataSource = "sns";
                if(dataSource.length()>0)
                {
                    //Context envCtx=new InitialContext();
                    //Context initctx=new InitialContext();
                    //Context envCtx=(Context) initctx.lookup("java:comp/env");//在webshere下面需要去掉
                    //connection = ((DataSource)envCtx.lookup(dataSource)).getConnection();
					DataSource datasource = (DataSource) ApplicationContextProvider.getBean("dbPool_"+dataSource);
					connection = datasource.getConnection();
                }
                else
                {
					DataSource datasource = (DataSource) ApplicationContextProvider.getBean("dbPool");
					connection = datasource.getConnection();
                }
                //connection = CmsCache.getDataSource().getConnection();//System.out.println("get a ");
            }catch(SQLException e)
            {
                e.printStackTrace(System.out);
                System.out.println("数据源连接出错，请检查数据源"+dataSource+"是否正确配置,"+e.getMessage());
            }
        }
        //Cannot connect to database
        if(connection==null)
        {
            if(retry<5) {
                Util.consumeTime(2*(retry+1));//2毫秒
                retry++;System.out.println("尝试次数："+retry);createConnection();
            }
            else{
                System.out.println("尝试次数2："+retry);
                throw new MessageException("连接数据库失败，请联系管理员!");
            }
        }
        else
            retry = 0;
    }
	
	public ResultSet executeQuery(String sql) throws SQLException, MessageException {
		if(connection==null|| connection.isClosed())
			createConnection();	
		
		long stime = System.currentTimeMillis();
		Statement stmt = connection.createStatement();
		
		ResultSet rs = null;
		try{
		rs = stmt.executeQuery(sql);
		}catch(Exception e)
		{
			print(e.getMessage());
			freeConnection();
			createConnection();
			stmt = connection.createStatement();
			rs = stmt.executeQuery(sql);
		}		

		long etime = System.currentTimeMillis();
		//System.out.println("slow sql,"+(etime-stime)+","+sql);
		if(CmsCache.slowquery)
		{			
			if(etime-stime>2000)
			{
				System.out.println("slow sql,"+(etime-stime)+","+sql);
			}
		}
		
		//sql 运行时间排行
		if(topsql_flag)
		{
			gotopsql(sql,etime-stime);
		}
		
		if(listsql_flag)
		{
			goListSql(sql,etime-stime);
		}
		
		return rs;
	}

	public int executeUpdate(String sql) throws SQLException, MessageException {
		if(connection==null|| connection.isClosed())
			createConnection();
		
		long stime = System.currentTimeMillis();
		Statement stmt = connection.createStatement();
		int i = 0;
		try
		{
			i = stmt.executeUpdate(sql);
		}catch(Exception e)
		{
			print(e.getMessage());
			freeConnection();
			createConnection();
			stmt = connection.createStatement();
			i = stmt.executeUpdate(sql);
		}
		
		stmt.close();
		freeConnection();
		
		long etime = System.currentTimeMillis();
		//System.out.println("slow sql,"+(etime-stime)+","+sql);
		if(CmsCache.slowquery)
		{
			if(etime-stime>2000)
			{
				System.out.println("slow sql,"+(etime-stime)+","+sql);
			}
		}
		
		//sql 运行时间排行
		if(topsql_flag)
		{
			gotopsql(sql,etime-stime);
		}
		
		return i;
	}

	public int executeUpdate_InsertID(String sql) throws SQLException, MessageException {
		if(connection==null|| connection.isClosed())
			createConnection();
		Statement stmt = connection.createStatement();
		int i = stmt.executeUpdate(sql,Statement.RETURN_GENERATED_KEYS);
		ResultSet Rs = stmt.getGeneratedKeys();
		if(Rs.next())
			i = Rs.getInt(1);
		stmt.close();
		freeConnection();
		

		
		return i;
	}

	public Connection getConn() throws MessageException, SQLException
	{
		createConnection();
		
		return connection;
	}
		
	public ResultSet List(String ListSql,String CountSql,int currentPage,int max_PerPage) throws SQLException, MessageException
	{//System.out.println("list begin....");
	
	   //System.out.println("ListSql="+ListSql);
	   //System.out.println("CountSql="+CountSql);
	   
	  pagecontrol = new PageControl();
	 
		ResultSet rs = executeQuery(CountSql);
		if(rs.next())
		{
			pagecontrol.rowsCount = rs.getInt(1);
		}
		else
		{
			pagecontrol.rowsCount = 0;
		}
		
		closeRs(rs);
		
		if(currentPage<1)
			throw new MessageException("Page Size cannn't less than 1!");
		pagecontrol.setCurrentPage(currentPage);
		pagecontrol.setRowsPerPage(max_PerPage);
		int totalpages = 0;
		if(max_PerPage!=0)
		{
			totalpages = Math.round(pagecontrol.getRowsCount()/pagecontrol.getRowsPerPage());
			if(pagecontrol.getRowsCount()>totalpages*pagecontrol.getRowsPerPage())
				totalpages ++;
		}
		else
		{
			if(pagecontrol.getRowsCount()==0)
				totalpages = 0;
			else
				totalpages = 1;			
		}
		pagecontrol.setMaxPages(totalpages);
		
		int start = (currentPage-1)*max_PerPage;
		ListSql += max_PerPage!=0?("  limit "+start+","+max_PerPage):"";
		rs = executeQuery(ListSql);

		//System.out.println("list end....");
		return rs;
	}

	public ResultSet List_es(String ListSql,String CountSql,int currentPage,int max_PerPage,int rowsCount) throws SQLException, MessageException
	{//System.out.println("list begin....");

		//System.out.println("ListSql="+ListSql);
		//System.out.println("CountSql="+CountSql);

		pagecontrol = new PageControl();

		if(rowsCount==0){//未进行ES查询
			ResultSet rs = executeQuery(CountSql);
			if(rs.next())
			{
				pagecontrol.rowsCount = rs.getInt(1);
			}
			else
			{
				pagecontrol.rowsCount = 0;
			}
			closeRs(rs);
		}else{
			pagecontrol.rowsCount = rowsCount ;
		}


		if(currentPage<1)
			throw new MessageException("Page Size cannn't less than 1!");
		pagecontrol.setCurrentPage(currentPage);
		pagecontrol.setRowsPerPage(max_PerPage);
		int totalpages = 0;
		if(max_PerPage!=0)
		{
			totalpages = Math.round(pagecontrol.getRowsCount()/pagecontrol.getRowsPerPage());
			if(pagecontrol.getRowsCount()>totalpages*pagecontrol.getRowsPerPage())
				totalpages ++;
		}
		else
		{
			if(pagecontrol.getRowsCount()==0)
				totalpages = 0;
			else
				totalpages = 1;
		}
		pagecontrol.setMaxPages(totalpages);

		if(rowsCount==0){
			int start = (currentPage-1)*max_PerPage;
			ListSql += max_PerPage!=0?("  limit "+start+","+max_PerPage):"";
		}
		ResultSet rs1 = executeQuery(ListSql);
		return rs1;
	}
	
	public boolean isExist(String sql) throws SQLException, MessageException {
			ResultSet rs = executeQuery(sql);
			if (rs.next()) {
				rs.close();
				return true;
			} else {
				rs.close();
				return false;
			}
	}

	public String convertNull(String input) {
		if (input == null)
			return "";
		else
			return input;
	}
	
	public String SQLQuote(String input)
	{
		//For MsSQL
		//Check if the string is null or zero length -- if so, return
		//what was sent in.
		if (input == null || input.length() == 0) {
			return input;
		}
		//Use a StringBuffer in lieu of String concatenation -- it is
		//much more efficient this way.
		StringBuffer buf = new StringBuffer(input.length() + 6);
		char ch = ' ';
		for (int i = 0; i < input.length(); i++) {
			ch = input.charAt(i);
			if (ch == '\'') {
				buf.append("\\'");
			}
			else if (ch == '"') {
				buf.append("\\\"");
			}			
			else if (ch == '\\') {
				buf.append("\\\\");
			}			
			else {
				buf.append(ch);
			}
		}
		return buf.toString();
		//return DeCode(buf.toString());	
	}

	public  String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("gb2312");
			String temp = new String(temp_t, "iso-8859-1");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}
		
	public void closeRs(ResultSet rs) throws SQLException
	{
		if(rs!=null)
		{
			try{
				Statement s = rs.getStatement();
				if(s!=null)
				{
					s.close();
					s = null;
				}
				
				rs.close();
				rs = null;
			}
			catch(SQLException e)
			{
				freeConnection();
			}
		}
		freeConnection();
	}
	
	public void finalize() throws SQLException
	{
		//System.out.println("finalize! "+this.toString());
		freeConnection();
	}

	public void freeConnection() throws SQLException
	{
		if(connection!=null)
		{
			connection.close();
			connection = null;
		}
	}
	
	//打印调试信息
	public void print(String s)
	{
		System.out.println(s);
	}
	
	public void gotopsql(String sql,long time)
	{
		if(time>topsql_time)
		{
			topsql = sql;
			topsql_time = time;
		}
	}
	
	public synchronized void goListSql(String sql,long time)
	{
		if(time>listsql_time)
		{
			listsql.add(new String[]{sql,time+""});
			
			if(listsql.size()>listsql_number)
				listsql.removeFirst();
		}
	}
}
