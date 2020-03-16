<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.publish.*,
				java.sql.*,
				java.io.File,
				magick.*,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
System.setProperty("jmagick.systemclassloader","no");
//FileUtil.compressImage2("c:/a.jpg","c:/a_s.jpg",600,399);
ImageInfo info = new ImageInfo("c:/20104271272351285745_563.jpg");
MagickImage image = new MagickImage(info);
image.modulateImage("100,95,100");
//MagickImage sharpened1 = image.reduceNoiseImage(0.6);
MagickImage sharpened = image.sharpenImage(1.0, 5.0);
sharpened.setFileName("c:/20104271272351285745_563_sharp.jpg");
sharpened.writeImage(info);
%>