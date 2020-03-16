<%@page import="java.io.File"%>
<%@page import="tidemedia.cms.user.UserInfo"%>
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
				tidemedia.cms.video.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.util.Map.*,
				java.sql.*,
				java.text.DecimalFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
JSONArray jsonArray = new JSONArray();
JSONArray jsonArray1 = new JSONArray();
JSONArray jsonResult = new JSONArray();
JSONArray Result = new JSONArray();
String cms_api = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
String cmsUrl = cms_api+"/tcenter/storage/size/ziyuan_tongji.jsp?company=";
String vmsUrl = cms_api+"/vms/storage/size/ziyuan_tongji.jsp?company=";
TableUtil tu = new TableUtil("user");
String sql = " select * from company";
ResultSet rs = tu.executeQuery(sql);
while(rs.next()){
	int companyid = rs.getInt("id");
	jsonArray.put(companyid);
	jsonArray1.put(rs.getInt("useFileSpace"));
}
tu.closeRs(rs);
Map<Integer,Double> hashMap = new HashMap<Integer,Double>();
for(int i=0;i<jsonArray.length();i++){
	JSONObject json = new JSONObject();
	int id = jsonArray.getInt(i);
	Company company = new Company(id);
	int space = company.getSpace();
	String companyName = company.getName();
	String  vmsResult = Util.connectHttpUrl(vmsUrl+id);
	String cmsResult = Util.connectHttpUrl(cmsUrl+id);
	JSONObject cmsZiyuan = new JSONObject(cmsResult);
	JSONObject vmsZiyuan = new JSONObject(vmsResult);
	Double pic_total_ziyuan = cmsZiyuan.getDouble("pic_totle_size")+vmsZiyuan.getDouble("pic_totle_size");
	Double video_total_ziyuan = vmsZiyuan.getDouble("video_totle_size");
	Double fileSize = jsonArray1.getDouble(i)/1024/1024;
	json.put("id", id);
	json.put("companyName", companyName);
	json.put("companyPicSize", pic_total_ziyuan);
	json.put("companyVideoSize", video_total_ziyuan);
	json.put("companyFileSize", fileSize);
	json.put("useSize", pic_total_ziyuan+video_total_ziyuan+fileSize);
	json.put("companyTotalSize", space);
	hashMap.put(id, pic_total_ziyuan+video_total_ziyuan+fileSize);
	jsonResult.put(json);
}
ArrayList<Entry<Integer, Double>> arrayList = new ArrayList<Entry<Integer, Double>>(hashMap.entrySet());
//排序
Collections.sort(arrayList, new Comparator<Map.Entry<Integer, Double>>() {
    public int compare(Map.Entry<Integer, Double> map1, Map.Entry<Integer, Double> map2) {
        return map2.getValue().compareTo(map1.getValue()) ;
    }
});
for (Entry<Integer, Double> entry : arrayList) {
	for(int i=0;i<jsonResult.length();i++){
		JSONObject json1 = jsonResult.getJSONObject(i);
		if(json1.getInt("id")==entry.getKey()){
			json1.put("companyPicSize",String.format("%.1f",json1.getDouble("companyPicSize")));
			json1.put("companyVideoSize",String.format("%.1f",json1.getDouble("companyVideoSize")));
			json1.put("companyFileSize",String.format("%.1f",json1.getDouble("companyFileSize")));
			json1.put("useSize",String.format("%.1f",json1.getDouble("useSize")));
			Result.put(json1);
		}
	}
}
out.println(Result.toString());
%>
