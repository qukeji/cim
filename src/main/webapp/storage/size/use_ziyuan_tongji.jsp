<%@page import="tidemedia.cms.user.UserInfo"%>
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				org.json.JSONArray,
				org.json.JSONObject,
				java.io.*,
				java.sql.*,
				java.text.DecimalFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%!
public static String cmd1(String ss[], boolean print) {
	String OS = System.getProperty("os.name").toLowerCase();

	if(OS.indexOf("windows")>=0)
	{
		return "";//windows系统不执行了
	}
	String bufs = "";
	List<String> commend = new java.util.ArrayList<String>();
	ProcessBuilder builder = new ProcessBuilder();
	builder.command(commend);
	builder.redirectErrorStream(true);
	
	for (int i = 0; i < ss.length; i++) {
//		System.out.println("comment:"+ss[i]);
		commend.add(ss[i]);
	}

	String commend_desc = commend.toString().replace(", ", " ");

	try {
		Process process1 = builder.start();
		InputStream is2 = process1.getInputStream();
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf2 = new StringBuilder();
		String line2 = null;
		while ((line2 = br2.readLine()) != null)
			buf2.append(line2);
		bufs = buf2.toString();
		br2.close();
		is2.close();
		process1.destroy();
		if (print)
			System.out.println("bufs:" + bufs);
	} catch (Exception e) {
		//e.printStackTrace(System.out);
		System.out.println(e.getMessage() + "\r\n cmd:" + commend_desc);
	}	
	return bufs;
}
 %>
<%

JSONArray jsonArray = new JSONArray();
TableUtil tu = new TableUtil();
//查询租户对应站点目录文件大小
String sql = " select * from site where SiteType in(0,1) and company>0 group by company";
ResultSet rs = tu.executeQuery(sql);
while(rs.next()){
	JSONObject json = new JSONObject();
	int company = rs.getInt("company");
	String siteFolder = tu.convertNull(rs.getString("SiteFolder"));
	if("".equals(siteFolder)){
		continue;
	}
	json.put("siteFolder", siteFolder);
	json.put("company", company);
	jsonArray.put(json);
}
tu.closeRs(rs);
TableUtil tu1 = new TableUtil("user");
for(int i=0;i<jsonArray.length();i++){
	JSONObject json1 = jsonArray.getJSONObject(i);
	String order = json1.getString("siteFolder");
	String[] ss = {"/bin/sh","-c","du -s "+order};
	String result = cmd1(ss ,false);
		int a = result.indexOf("/");
		result=result.substring(0,a-1);
		Long file_size = Long.parseLong(result);
		tu1.executeUpdate("update company set useFileSpace="+file_size+" where id="+json1.getInt("company"));
		
	
}

%>