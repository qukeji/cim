package tidemedia.cms.filter;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Properties;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

/**
 * 
 * 拦截防止sql注入、xss注入
 */
public class XssFilter implements Filter {

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest,
	 * javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain filterChain) throws IOException, ServletException {

		XssHttpServletRequestWrapper xssRequest = new XssHttpServletRequestWrapper(
				(HttpServletRequest) request);
		//System.out.println(request.getParameter("Title")+"Xss输出标题");
		boolean isExtra=isExtraRequest(((HttpServletRequest)request).getServletPath());
		if(isExtra){
			filterChain.doFilter(request, response);
		}else{
			filterChain.doFilter(xssRequest, response);
		}

	}

	public boolean isExtraRequest(String reqUrl) throws IOException {

		InputStream is = null;
		is = this.getClass().getClassLoader()
				.getResourceAsStream("tidemedia/cms/filter/sys.properties");
		if (is != null) {
			BufferedReader in2 = new BufferedReader(new InputStreamReader(is));
			String y = "";
			while ((y = in2.readLine()) != null) {// 一行一行读

				if (y.indexOf(reqUrl) != -1) {
					//
					//System.out.println(y);
					is.close();
					in2.close();
					return true;
				}
			}
			in2.close();
			is.close();
		}

		return false;
	}

	@Override
	public void destroy() {

	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {

	}

	public static void main(String[] args) throws IOException {
		new XssFilter().isExtraRequest("hello");
	}

}