<%@ page import="org.apache.axis.client.*,tidemedia.cms.base.*,java.sql.*,tidemedia.cms.system.*,net.sf.ehcache.*,tidemedia.cms.util.*"%>
<%
CacheManager cm = CacheManager.create();
Cache cc = cm.getCache("sampleCache1");
String key = "getchannel_" + Util.getCurrentDate("yyyy_MM_dd_HH");
out.println(CacheUtil.getIntValue(key));

CmsCache.ehcache = true;
%>
cc.put(new Element("o","oo"));
/*
ResultSet rs = tu.executeQuery(sql);
while(rs.next())
{
	int cid = rs.getInt("id");
	Channel channel = CmsCache.getChannel(cid);
	CacheUtil.put("channel_"+cid, channel);
	out.println(cid+"<br>");
}

tu.closeRs(rs);
*/

String[] servers = {"memcached:11211"};

Integer[] weights = {3};

// grab an instance of our connection pool
SockIOPool pool = SockIOPool.getInstance();

// set the servers and the weights
pool.setServers( servers );
pool.setWeights( weights );
pool.setInitConn( 5 );
pool.setMinConn( 5 );
pool.setMaxConn( 1000 );
pool.setMaxIdle( 1000 * 60 * 60 * 6 );
pool.setMaintSleep( 30 );

// set some TCP settings
// disable nagle
// set the read timeout to 3 secs
// and don’t set a connect timeout
pool.setNagle( false );
pool.setSocketTO( 3000 );
pool.setSocketConnectTO( 0 );

// initialize the connection pool
 pool.initialize();

MemCachedClient mcc = new MemCachedClient();
mcc.setCompressEnable( true );
mcc.setCompressThreshold( 64 * 1024 );

mcc.set("foo", "This is a test String" );
String bar = (String)mcc.get("foo");

out.println("bar:"+bar);

long start_time = System.currentTimeMillis();
int id = 4026;

long num = 10000;
for(int i = 0;i<num;i++)
{
	//Channel channel = CmsCache.getChannel(id);
	//String barkk = (String)mcc.get("foo");
}

long t = (System.currentTimeMillis()-start_time)/1000;
if(t<1) t = 1;
out.println("memcache速度："+(num/t) + "/秒<br>");

start_time = System.currentTimeMillis();
num = 10000000;
for(int i = 0;i<num;i++)
{
	Channel channel = CmsCache.getChannel(id);
}
t = (System.currentTimeMillis()-start_time)/1000;
if(t<1) t = 1;
out.println("本地速度："+(num/t) + "/秒("+(System.currentTimeMillis()-start_time)+")<br>");


Cache cache = CacheUtil.getCache();

start_time = System.currentTimeMillis();
num = 10000000;
//num = 1;
for(int i = 0;i<num;i++)
{
	Element o = cache.get("channel_"+id);
	Channel c = (Channel)o.getObjectValue();
	///out.println(id+":"+c.getName());
}

t = (System.currentTimeMillis()-start_time)/1000;
if(t<1) t = 1;
out.println("ehcache速度："+(num/t) + "/秒("+(System.currentTimeMillis()-start_time)+")<br>");
%>