package tidemedia;


import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.solr.SolrAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ImportResource;


@SpringBootApplication(exclude = {SolrAutoConfiguration.class,DataSourceAutoConfiguration.class})
@MapperScan(basePackages = {"tidemedia.tcenter.mapper"})
public class TcenterApplication  extends SpringBootServletInitializer{

    static{
        System.out.println("Tcenter 2019 start");
    }

    public static void main(String[] args) {
        SpringApplication.run(TcenterApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(TcenterApplication.class);
    }
}


