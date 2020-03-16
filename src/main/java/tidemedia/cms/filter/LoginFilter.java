package tidemedia.cms.filter;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.sql.SQLException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.util.Util;

public class LoginFilter implements Filter{

	public void destroy() {
	}

	public void doFilter(ServletRequest request, ServletResponse servletResponse,FilterChain arg2) throws IOException, ServletException 
	{
		HttpServletRequest rq = (HttpServletRequest)request;
		HttpServletResponse response = (HttpServletResponse)servletResponse;
		String servletPath = rq.getServletPath();
		System.out.println("rq:"+servletPath);
		String docPath = LoginFilterConfig.getRootPath();
		
		if(servletPath.endsWith(".jsp") || servletPath.startsWith("/p/"))
		{
			arg2.doFilter(request, response);
		}
		else
		{
			HttpSession session = rq.getSession(true);
			LoginUserInfo userinfo_session;
			try {
				userinfo_session = new LoginUserInfo();

				if(session.getAttribute("CMSUserInfo")!=null)
				{
					userinfo_session = (LoginUserInfo)session.getAttribute("CMSUserInfo");
				}
	
	
				if(userinfo_session==null || userinfo_session.getId()==0)
				{
					String username = Util.getCookieValue("Username",rq.getCookies());
					String username2 = Util.getCookieValue("Username2",rq.getCookies());
					if(!username2.equals("") && !username.equals(""))
					{System.out.println("fileter usernmae2:"+username2);
						LoginUserInfo userinfo = new LoginUserInfo();

						if(userinfo.Authorization(rq,response,username,username2,true))
						{
							response.sendRedirect(rq.getContextPath() + servletPath);
							return;
						}
					}
					
					response.sendRedirect(rq.getContextPath() + "/index.jsp");
				}
			} catch (MessageException e) {
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			String filename = docPath + servletPath;
			File file = new File(filename);
			
			if(file!=null && file.exists())
			{
				//response.setHeader("Content-Disposition", "inline; filename*='" + jiraEncoding + "'" + codedName + ";");
				OutputStream out = response.getOutputStream();
				if(!filename.endsWith(".shtml"))
				{
					InputStream in = new FileInputStream(file);
					byte buffer[];
					//boolean bytesWritten = false;
			        buffer = new byte[4096];
			        do
			        {
			            int bytesRead = in.read(buffer);
			            if(bytesRead == -1)
			                break;
			            out.write(buffer, 0, bytesRead);
			            //bytesWritten = true;
			        } while(true);
			        in.close();
			        out.close();
				}
				else
				{
					BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(filename),"utf-8"));
					String LineString;
					String TotalString = "";
					while ((LineString = in .readLine())!=null)
					{
						TotalString += LineString+"\r\n";
					}
					in.close();
					
					int index = -1;
					do
					{
						String s1 = "<!--#include virtual=\"";
						String s2 = "\" -->";
						index = TotalString.indexOf(s1);
						if(index!=-1)
						{
							int index2 = TotalString.indexOf(s2,index);
							if(index2!=-1)
							{
								String s = TotalString.substring(index+s1.length(),index2);
								System.out.println("include:"+s);
								String content = getIncludeContent(docPath,s);
								
								TotalString = TotalString.substring(0,index) + content + TotalString.substring(index2+s2.length());
							}
						}
					}while(index!=-1);
					
					out.write(TotalString.getBytes("utf-8"));
				}
			}
			else
				System.out.println("file not exist,"+filename);
		}
        
		/*
        PrintWriter out = response.getWriter();
        out.println("<html><head></head><body>");
        out.println("<h1>Sorry, page cannot be displayed!</h1>");
        out.println("</body></html>");
        out.flush();
        return;
		*/
		
		//arg2.doFilter(request, response);
	}

	public void init(FilterConfig arg0) throws ServletException {
	}

	public String getIncludeContent(String rootPath,String includeFileName)
	{
		String content = "";

			if(includeFileName.startsWith("/"))
			{
				int index1 = rootPath.lastIndexOf("\\");
				if(index1!=-1)
					rootPath = rootPath.substring(0,index1);
				System.out.println("path2:"+rootPath);
			}
			String newfilename = rootPath + "/" + includeFileName;
			
			String LineString;
			String TotalString = "";
			try {
				BufferedReader in;
				in = new BufferedReader(new InputStreamReader(new FileInputStream(newfilename),"utf-8"));

				while ((LineString = in .readLine())!=null)
				{
					TotalString += LineString+"\r\n";
				}
				in.close();

			} catch (IOException e) {
				
			}
			content = TotalString;

		return content;
	}
}
