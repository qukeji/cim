<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.report.*,
				java.io.*,java.net.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
* 用途：工作量统计导出 报表 
* 1,蒋泽银 20160328 创建
* 2,
* 3,
* 4,
* 5,
*/
String type = getParameter(request,"type");
String where = getParameter(request,"where");
String path = ReportUtil.getDowanFileName(type,where);
File file = new File(path);  
String newName = "file";
if("person".equalsIgnoreCase(type))
{
   newName = "个人发稿量";		
}else if("depart".equalsIgnoreCase(type))
{
  newName = "部门发稿量";
}else if("column".equalsIgnoreCase(type))
{
  newName = "频道发稿量";
}else if("site".equalsIgnoreCase(type)){
  newName = "站点发稿量";
}
newName+="_"+Util.getCurrentDate("yyyyMMddHHmmss");
String suffix = file.getName().substring(file.getName().lastIndexOf("."));

// 取得文件名。  
String filename =newName+suffix;
String userAgent = request.getHeader("User-Agent");
byte[] bytes = userAgent.contains("MSIE") ? filename .getBytes() : filename .getBytes("UTF-8"); // filename .getBytes("UTF-8")处理safari的乱码问题
filename = new String(bytes , "ISO-8859-1");
// 以流的形式下载文件。  
InputStream fis = new BufferedInputStream(new FileInputStream(path));  
byte[] buffer = new byte[fis.available()];  
fis.read(buffer);  
fis.close();  
// 清空response  
response.reset();  
// 设置response的Header  
response.addHeader("Content-Disposition", "attachment;filename="  
		+ new String(filename.getBytes()));  
response.addHeader("Content-Length", "" + file.length());  
OutputStream toClient = new BufferedOutputStream(  
		response.getOutputStream());  
response.setContentType("application/vnd.ms-excel;charset=utf-8");  
toClient.write(buffer);  
toClient.flush();  
toClient.close();
file.delete();
%>
