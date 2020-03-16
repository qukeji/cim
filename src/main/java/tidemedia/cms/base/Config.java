package tidemedia.cms.base;

public class Config {
private String database;
private String customer;
private String channelCache = "ture";
private String cookieLogin = "false";
private String cacheapi	= "";
private String startQuartz = "true";
private String product = "";
private String active = "0";//1 代表主系统  0代表备系统，后台引擎不运行

public String getCustomer() {
	return customer;
}
public void setCustomer(String customer) {
	this.customer = customer;
}
public String getDatabase() {
	return database;
}
public void setDatabase(String database) {
	this.database = database;
}
public void setChannelCache(String channelCache) {
	this.channelCache = channelCache;
}
public String getChannelCache() {
	return channelCache;
}
public void setCookieLogin(String cookieLogin) {
	this.cookieLogin = cookieLogin;
}
public String getCookieLogin() {
	return cookieLogin;
}
public String getCacheapi() {
	return cacheapi;
}
public void setCacheapi(String cacheapi) {
	this.cacheapi = cacheapi;
}
public String getStartQuartz() {
	return startQuartz;
}
public void setStartQuartz(String startQuartz) {
	this.startQuartz = startQuartz;
}
public String getProduct() {
	return product;
}
public void setProduct(String product) {
	this.product = product;
}
public String getActive() {
	return active;
}
public void setActive(String active) {
	this.active = active;
}
}
