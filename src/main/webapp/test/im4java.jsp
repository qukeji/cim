<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				org.im4java.core.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>

<%
String filename = "/web/html/images/b001.jpg";
		int[] ii = {0,0};
		String path = "";
		try {path = CmsCache.getParameterValue("sys_im4java_path");} catch (Exception e1) {} 
		out.println(path);
		IdentifyCmd cmd = new IdentifyCmd();
		IMOperation op = new IMOperation();

		op.addImage(filename);
		if(path.length()>0)	cmd.setSearchPath(path);

		ArrayListOutputConsumer output = new ArrayListOutputConsumer();
		cmd.setOutputConsumer(output);

			cmd.run(op);
			ArrayList<String> cmdOutput = output.getOutput();
			
			String o = "";
			for(int i = 0;i<cmdOutput.size();i++)
				o += (String)cmdOutput.get(i);

			out.println("o:"+o);
			String[] s = Util.StringToArray(o," ");
			if(s.length>3)
			{
				String size = s[2];
				int index = size.indexOf("x");
				ii[0] = Util.parseInt(size.substring(0, index));
				ii[1] = Util.parseInt(size.substring(index+1));
			}
%>