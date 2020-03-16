package tidemedia.cms.util;

import java.io.File;
import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ImageFilter implements Filter {

	public void destroy() {
		
	}

	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
		try {  
			HttpServletRequest request = (HttpServletRequest) req;  
	        HttpServletResponse response = (HttpServletResponse) res;  
	        request.setCharacterEncoding("UTF-8");  
	        response.setContentType("text/html;charset=UTF-8"); 
	        
	        //域名 tcenter2.tidemedia.com        
	        String domain = request.getServerName();
			//服务器上的绝对地址
			String realPath = request.getSession().getServletContext().getRealPath("")+request.getServletPath();
        	//说明访问的图片后缀名是png,jpg
        	File file = new File(realPath);
        	String fileName = file.getName();//文件名
               	
        	String dir = "/oem/";        	
        	String newPath = dir + domain.substring(0,domain.indexOf(".")) + "/" + fileName;
        	File newFile = new File(newPath);
        	    		
        	if(!realPath.contains(dir)&&newFile.exists()){//图片不是oem目录下文件并且带oem文件存在
        		String basePath = request.getScheme()+"://"+domain+"/tcenter/oem/"+domain.substring(0,domain.indexOf(".")) + "/" + fileName;
        		System.out.println("oem:"+basePath+"<br>");
        		response.sendRedirect(basePath);
        	}else{
        		chain.doFilter(request, response);
        	}	        	
        	
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void init(FilterConfig arg0) throws ServletException {
		
	}

}
