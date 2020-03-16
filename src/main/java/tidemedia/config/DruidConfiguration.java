package tidemedia.config;

import com.alibaba.druid.support.http.StatViewServlet;
import com.alibaba.druid.support.http.WebStatFilter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.servlet.Servlet;

/**
 * druid监控界面设置
 */
@Configuration

public class DruidConfiguration {

    @Value("${spring.datasource.druid.monitor.stat-view-servlet.username}")
    private String username = "";
    @Value("${spring.datasource.druid.monitor.stat-view-servlet.password}")
    private String password = "";
    @Value("${spring.datasource.druid.monitor.stat-view-servlet.allow}")
    private String allow = "";
    @Value("${spring.datasource.druid.monitor.stat-view-servlet.url}")
    private String url = "";

    @Bean
    public ServletRegistrationBean druidStatViewServle() {
        boolean can = true;
        if(username==null || password==null || username.length()==0 || password.length()==0)
            can = false;

        if(password.length()<8)
            can = false;

        if(url==null || url.length()==0)
            can = false;

        if(!can)
        {
            System.out.println("druid监控关闭");
            ServletRegistrationBean<Servlet> registration = new ServletRegistrationBean<>();
            // 创建自定义的Servlet对象
            DruidServlet servlet = new DruidServlet();
            // 注册Servlet
            registration.setServlet(servlet);
            // 设置Servlet名称
            registration.setName("test_servlet");
            // 设置Servlet配置规则
            registration.addUrlMappings("/test_servlet");
            return registration;
        }

        System.out.println("druid监控开启");

        //注册服务
        ServletRegistrationBean servletRegistrationBean = new ServletRegistrationBean(
                new StatViewServlet(), url);
        // 白名单(为空表示,所有的都可以访问,多个IP的时候用逗号隔开)
        servletRegistrationBean.addInitParameter("allow", allow);
        // 设置登录的用户名和密码
        servletRegistrationBean.addInitParameter("loginUsername", username);
        servletRegistrationBean.addInitParameter("loginPassword", password);
        // 是否能够重置数据.
        servletRegistrationBean.addInitParameter("resetEnable", "false");
        return servletRegistrationBean;
    }

    @Bean
    public FilterRegistrationBean druidStatFilter() {
        boolean can = true;
        if(username==null || password==null || username.length()==0 || password.length()==0)
            can = false;

        if(password.length()<8)
            can = false;

        if(url==null || url.length()==0)
            can = false;

        if(!can)
        {
            FilterRegistrationBean registration = new FilterRegistrationBean<>();
            DruidFilter filter = new DruidFilter();
            registration.setFilter(filter);
            registration.addUrlPatterns("/test_servlet/*");
            return registration;
        }

        FilterRegistrationBean filterRegistrationBean = new FilterRegistrationBean(
                new WebStatFilter());
        // 添加过滤规则
        filterRegistrationBean.addUrlPatterns("/*");
        // 添加不需要忽略的格式信息
        filterRegistrationBean.addInitParameter("exclusions", "*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*");

        return filterRegistrationBean;

    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}