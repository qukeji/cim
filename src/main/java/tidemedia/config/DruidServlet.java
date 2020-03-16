package tidemedia.config;

import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class DruidServlet extends HttpServlet {

    public void init(ServletConfig servletConfig) {
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
    }


    public void destroy() {
        //log.info("second servlet destroy");
    }
}
