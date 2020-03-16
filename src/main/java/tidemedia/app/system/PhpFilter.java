package tidemedia.app.system;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;

    public class PhpFilter implements Filter {
    	
    	public void init(FilterConfig filterConfig) throws ServletException {

    	}

        public void doFilter(ServletRequest request, ServletResponse response,
    			FilterChain chain) throws IOException, ServletException {
        	
        	HttpServletRequest req = (HttpServletRequest) request;
			HttpServletResponse resp = (HttpServletResponse) response;
			req.setCharacterEncoding("UTF-8");
			resp.setContentType("text/html;charset=UTF-8");
			
            String  parameter=req.getQueryString();//获取参数
            
            String  filepath=req.getServletContext().getRealPath("")+req.getServletPath();//获取文件服务器路径
            
            File file=new File(filepath);
            if(file.exists()){//如果文件存在放行
            	chain.doFilter(req,resp);//放行
            }else {
                String servletname=file.getName().replace(".jsp",".php");//替换jsp为php
                
                //转发到post请求页面
                req.getRequestDispatcher("phpforjava.jsp?servletname="+servletname+"&"+parameter).forward(req, resp);
            }
        }
        
        public void destroy() {
        }
    }