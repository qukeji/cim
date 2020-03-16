package tidemedia.cms.outer;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.ItemSnap;
import tidemedia.cms.util.Util;

public class OuterItem {
	
	public OuterItem()
	{
		
	}

	public int addItem(int channelid,HashMap map) throws MessageException, SQLException
	{
		String tableName = "";
		TableUtil tu = new TableUtil();
		String sql = "select * from channel where id=" + channelid;
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next())
		{
			String serialNo = (tu.convertNull(rs.getString("SerialNo")));
			tableName = "channel_" + serialNo;
		}
		
		tu.closeRs(rs);
		
		if(tableName.length()>0)
		{
			return addItem(tableName,map);
		}
		else
			return 0;
	}
	
	public int addItem(String tableName,HashMap map) throws MessageException, SQLException
	{
		int id = 0;
		//map.put(key, value)
		String FieldList = "";
		String ValueList = "";
		
		ArrayList<String> tableFields = getTableFields(tableName);
		
		TableUtil tu = new TableUtil();
		
		Iterator ks = map.entrySet().iterator();
		for (int i = 0; i < map.size(); i++)
		{
			Map.Entry entry = (Map.Entry) ks.next();
			String name = (String) entry.getKey();
			String value = (String) entry.getValue();
			
			if(InArray(tableFields, name))
			{
				//该字段在表的列名中。
				FieldList += (FieldList.equals("") ? "" : ",") + name;
				ValueList += (ValueList.equals("") ? "" : ",")	+ "'" + tu.SQLQuote(value) + "'";
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
		
		FieldList += (FieldList.equals("") ? "" : ",") + "TotalPage,Category,User,CreateDate,ModifiedDate,Active,Weight,Status";
		ValueList += (ValueList.equals("") ? "" : ",") + 1 + "," + 0 + "," + 0 + ",UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),1," + 0 + "," + 0;


		String sql = "insert into " + tableName + " (" + FieldList + ") values(" + ValueList + ")";
		
		System.out.println(sql);
		
		int insertid  = tu.executeUpdate_InsertID(sql);
		
		//Document document = new Document(insertid,ChannelID);
		//new ItemSnap().Add(document);//加入全局库
		
		return id;
	}
	
	public HashMap parseFieldRequest(HttpServletRequest request)
	{
		HashMap map = new HashMap();
		
		Enumeration   e=(Enumeration)request.getParameterNames();
		while(e.hasMoreElements())     {   
		    String     parName=(String)e.nextElement();   
		    String	   value = Util.getParameter(request,parName);
		    
		    map.put(parName,value);
		 }
		
		return map;
	}
	
	public ArrayList<String> getTableFields(String tableName) throws MessageException, SQLException
	{
		ArrayList<String> array = new ArrayList<String>();
		
		String sql="select * from " + tableName + " limit 0,1";
		TableUtil tu=new TableUtil();
		ResultSet rs=tu.executeQuery(sql);
		ResultSetMetaData rsmd = rs.getMetaData();
		int  ColumnCount=rsmd.getColumnCount();

			for(int i=1;i<=ColumnCount;i++){
				String fieldName = rsmd.getColumnName(i);
				//System.out.println("--"+fieldName);
				array.add(fieldName);
			}

		tu.closeRs(rs);		
		
		return array;
	}
	
	public static boolean InArray(ArrayList<String> array, String str) {
		if (array == null || array.size() == 0 || str == null)
			return false;
		else {
			for (int i = 0; i < array.size(); i++) {
				if (array.get(i).equals(str))
					return true;
			}
			return false;
		}
	}	
}
