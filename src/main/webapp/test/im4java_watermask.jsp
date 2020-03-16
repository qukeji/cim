<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				org.im4java.core.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>

<%
IMOperation op = new IMOperation();
op.gravity("SouthEast");
op.dissolve(25);
op.geometry(122,94,10,10);

/*
op.addImage("d:\\tomcat_demo\\webapps\\cms_btv\\test\\logo.png");
op.addImage("d:\\tomcat_demo\\webapps\\cms_btv\\test\\bg_login.png");
op.addImage("d:\\tomcat_demo\\webapps\\cms_btv\\test\\bg_login2.png");
CompositeCmd cmd = new CompositeCmd();
cmd.setSearchPath("C:\\Program Files\\ImageMagick-6.3.9-Q16\\");
*/

op.addImage("/tomcat2/webapps/cms/test/logo.png");
op.addImage("/tomcat2/webapps/cms/test/bg_login.png");
op.addImage("/tomcat2/webapps/cms/test/bg_login2.png");
CompositeCmd cmd = new CompositeCmd();
cmd.setSearchPath("/usr/local/bin/");

cmd.run(op);
%>