package tidemedia.cms.filter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.apache.tools.ant.types.CommandlineJava.SysProperties;

/**
 * xss过滤
 */
public class XssHttpServletRequestWrapper extends HttpServletRequestWrapper {
	HttpServletRequest orgRequest = null;

	public XssHttpServletRequestWrapper(HttpServletRequest request) {
		super(request);
		orgRequest = request;
	}

	/**
	 * 覆盖getParameter方法，将参数名和参数值都做xss过滤。
	 * 如果需要获得原始的值，则通过super.getParameterValues(name)来获取
	 * getParameterNames,getParameterValues和getParameterMap也可能需要覆盖
	 */
	@Override
	public String getParameter(String name) {

		String value = super.getParameter(name);
		if (value != null) {
			if (!name.contains("Summary") && !name.contains("Content")) {
				value = xssEncode(value);
			}
		}
		return value;
	}

	@Override
	public String[] getParameterValues(String name) {

		String[] resultValue ={};
		String[] value = super.getParameterValues(name);
		resultValue=value;
		for (int i = 0; i < value.length; i++) {
			if (value[i] != null) {
				if (!name.contains("Summary") && !name.contains("Content")) {
					resultValue[i] = xssEncode(value[i]);
				}
			}
		}

		return resultValue;
	}

	/**
	 * 覆盖getHeader方法，将参数名和参数值都做xss过滤。 如果需要获得原始的值，则通过super.getHeaders(name)来获取
	 * getHeaderNames 也可能需要覆盖
	 */
	@Override
	public String getHeader(String name) {

		String value = super.getHeader(xssEncode(name));
		if (value != null) {
			value = xssEncode(value);
		}
		return value;
	}

	/**
	 * 将容易引起xss漏洞的半角字符直接替换成全角字符
	 * 
	 * @param s
	 * @return
	 */
	private static String xssEncode(String s) {
		if (s == null || "".equals(s)) {
			return s;
		}
		s = s.replaceAll("<[s|S][c|C][r|R][i|I][p|P][t|T]>", "&lt;script&gt;");
		return s;
	}

	/**
	 * 获取最原始的request
	 * 
	 * @return
	 */
	public HttpServletRequest getOrgRequest() {
		return orgRequest;
	}

	/**
	 * 获取最原始的request的静态方法
	 * 
	 * @return
	 */
	public static HttpServletRequest getOrgRequest(HttpServletRequest req) {
		if (req instanceof XssHttpServletRequestWrapper) {
			return ((XssHttpServletRequestWrapper) req).getOrgRequest();
		}

		return req;
	}

	public static void main(String[] args) {
		System.out.println(xssEncode("Title"));
		// System.out.println(XssHttpServletRequestWrapper.xssEncode("<script>alert(1)</script>"));
	}
}