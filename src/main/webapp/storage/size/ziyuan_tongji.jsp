 <%@page import="java.io.File"%>
<%@page import="tidemedia.cms.user.UserInfo"%>
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
				tidemedia.cms.video.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*,
				java.text.DecimalFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config1.jsp"%>
<%

int userid = getIntParameter(request,"userid");
UserInfo userinfo = new UserInfo(userid);
int companyid = userinfo.getCompany();
int company =  getIntParameter(request,"company");
if(company!=0){
	companyid=company;
}
String pic_tablename  = CmsCache.getChannel("photo").getTableName();//图片库频道
JSONObject json = new JSONObject();
Double pic_size = 0d;//图片大小
TableUtil tu = new TableUtil();
//查询图片文件大小
String sql = " select sum(Filesize) pic_size from "+pic_tablename;
if(companyid!=0){
	sql+= " where companyid = "+companyid;
}else{
	sql+= " where companyid !=0 ";
}
ResultSet rs = tu.executeQuery(sql);
if(rs.next()){
	pic_size= rs.getDouble("pic_size");
}
tu.closeRs(rs);
String pic_totle_size = String.format("%.1f",(pic_size)/1024/1024/1024 );
if("0.0".equals(pic_totle_size)){
	pic_totle_size="0";
}
json.put("pic_totle_size", pic_totle_size);
out.println(json.toString());
%>