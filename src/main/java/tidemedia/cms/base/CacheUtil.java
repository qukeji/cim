package tidemedia.cms.base;

import java.sql.SQLException;

import tidemedia.cms.system.Document;
import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

public class CacheUtil {
	public static Cache getCache()
	{
		CacheManager cm = CacheManager.create();
		Cache c = cm.getCache("sampleCache1");
		return c;
	}
	
	public static String getStringValue(String key)
	{
		CacheManager cm = CacheManager.create();
		Cache c = cm.getCache("sampleCache1");
		Element e = c.get(key);
		
		if(e==null)
			return "";
		else
			return (String)e.getValue();
	}	
	
	public static int getIntValue(String key)
	{
		CacheManager cm = CacheManager.create();
		Cache c = cm.getCache("sampleCache1");
		Element e = c.get(key);
		
		if(e==null)
			return 0;
		else
			return ((Integer)e.getValue());
	}
	
	public static Element get(String key)
	{
		CacheManager cm = CacheManager.create();
		Cache c = cm.getCache("sampleCache1");
		Element e = c.get(key);
		return e;
	}
	
	//
	public static int increment(String key)
	{
		int num = CacheUtil.getIntValue(key)+1;
		//CacheUtil.put(key,num);
		CacheUtil.put(key,num,false,0,86400*30);
		return num;
	}
	
	//24*60*60=86400
	public static int increment(String key,int t)
	{
		int num = CacheUtil.getIntValue(key)+1;
		CacheUtil.put(key,num,false,0,t);
		return num;
	}
	
	public static void put(String key,Object o)
	{
		Cache c = getCache();
		c.put(new Element(key,o));
	}
	
	//Boolean eternal,Integer timeToIdleSeconds,Integer timeToLiveSeconds
	//external 缓存是否持久，如果为true，永驻内存  timeToIdleSeconds 当缓存闲置n秒后销毁  timeToLiveSeconds 当缓存存活n秒后销毁
	public static void put(String key,Object o,boolean e,int t1,int t2)
	{
		Cache c = getCache();
		c.put(new Element(key,o,e,t1,t2));
	}
	
	public static void remove(String key)
	{
		getCache().remove(key);
	}
	
	//根据文档编号和频道编号获取文档对象
	public static Document getDocument(int itemid,int channelid) throws SQLException, MessageException
	{
		net.sf.ehcache.Element e = get("item_"+channelid+"_"+itemid);
		if(e==null)
		{
			Document o = new Document(itemid,channelid);
			put("item_"+channelid+"_"+itemid,o,false,432000,432000);//86400  1天 432000 5天
			return o;
		}
		else
			return (Document)e.getObjectValue();
	}
	
	public static void removeDocument(int itemid,int channelid)
	{
		remove("item_"+channelid+"_"+itemid);
	}
	
	//根据GlobalID获取文档对象
	public static Document getDocument(int gid) throws SQLException, MessageException
	{
		net.sf.ehcache.Element e = get("item_gid_"+gid);
		if(e==null)
		{
			Document o = new Document(gid);
			put("item_gid_"+gid,o,false,432000,432000);//86400  1天 432000 5天
			return o;
		}
		else
			return (Document)e.getObjectValue();
	}
	
	public static void removeDocument(int gid)
	{
		remove("item_gid_"+gid);
	}	
}
