<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				tidemedia.cms.page.*,
				java.sql.*,
				java.io.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
String file	=	getParameter(request,"file");
int channelid	=	getIntParameter(request,"channelid");//父频道id

int import_channel	=	getIntParameter(request,"ImportChannel");
int import_template = getIntParameter(request,"ImportTemplate");
int import_document	=	getIntParameter(request,"ImportDocument");
int import_public	= getIntParameter(request,"ImportPublicTemplate");

ChannelImport channel_import = new ChannelImport();
channel_import.setChannelid(channelid);
channel_import.setFilename(file);
channel_import.setUserid(userinfo_session.getId());

if(import_document==1) channel_import.setImport_document(true);else channel_import.setImport_document(false);
if(import_template==1) channel_import.setImport_template(true);else channel_import.setImport_template(false);
if(import_channel==1) channel_import.setImport_channel(true);else channel_import.setImport_channel(false);
if(import_public==1) channel_import.setImport_public(true);else channel_import.setImport_public(false);

String result = channel_import.start();

out.println(result);
%>
