<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.publish.*,
				java.sql.*,
				java.io.File,
				magick.*,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>

<%
System.setProperty("jmagick.systemclassloader","no");
		MagickImage scaled = null; 
String file1 = "/data/www/html3/pic/news/images/2012/4/15/20124151334479613406_17.jpg";
String file2 = "/data/www/html3/pic/news/images/2012/4/15/20124151334479613406_17_ss.jpg";
//,170,114,1);
ImageInfo info = new ImageInfo(file1);  
			 MagickImage image = new MagickImage(info);   
			 Dimension imageDim = image.getDimension(); 
int width1 = imageDim.width;
int height1 = imageDim.height;
out.println("width:"+width1);
%>
