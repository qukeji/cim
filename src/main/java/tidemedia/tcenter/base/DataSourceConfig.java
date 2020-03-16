package tidemedia.tcenter.base;

import com.alibaba.druid.pool.DruidDataSource;
import com.alibaba.druid.spring.boot.autoconfigure.DruidDataSourceBuilder;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;

@Configuration
//@PropertySource("classpath:application.properties")
public class DataSourceConfig {

    @Primary
    @Bean(name="dbPool")
    @ConfigurationProperties("spring.datasource.druid.one")
    public DataSource dataSource1()
    {
        //System.out.println("datasource1");
        DruidDataSource d = DruidDataSourceBuilder.create().build();
        //System.out.println("datasource1 "+d.getMaxActive());
        return d;
    }

    @Primary
    @Bean(name="dbPool_user")
    @ConfigurationProperties("spring.datasource.druid.two")
    public DataSource dataSource2()
    {
        return DataSourceBuilder.create().type(DruidDataSource.class).build();
    }
}
