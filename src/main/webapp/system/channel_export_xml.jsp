<%@ page import="java.io.*,tidemedia.cms.util.*,tidemedia.cms.system.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%

int channelid	=	getIntParameter(request,"channelid");//原频道id
int document_export	=	getIntParameter(request,"ExportDocument");
int doc_number	=	getIntParameter(request,"DocumentNumber");
int IncludeSubChannel = getIntParameter(request,"IncludeSubChannel");
int actionuser = userinfo_session.getId();
ChannelExport export = new ChannelExport();
export.setChannelid(channelid);
export.setInclude_sub_channel(IncludeSubChannel);
if(document_export==1) export.setDocument_export(true);else export.setDocument_export(false);
export.setDoc_number(doc_number);
String zip = export.export();

File zipfile = new File(zip);
if(zipfile.exists()){
	FileUtil fileUtil =new FileUtil();
	fileUtil.setActionuser(actionuser);
			fileUtil.downloadFile(request,response,zip,"csv/downloadable",channelid+".zip",0);
}else{
	out.println("文章导出数据量过大，等导入完成后手动下载zip文件："+zip);
}

%>