package tidemedia.tcenter.base;



import com.google.common.base.Optional;
import com.google.common.base.Predicate;
import com.google.common.base.Function;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import springfox.documentation.RequestHandler;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
public class SwaggerConfig {
    // 定义分隔符,配置Swagger多包
    private static final String splitor = ";";

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder().title("融合媒体业务平台")
                .description("tcenter接口文档")
                .version("1.0.0")
                .build();
    }
    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.basePackage("tidemedia.tcenter.controller")) //指定提供接口所在的基包
                //.apis(basePackage("tidemedia.tcenter.controller"+splitor+"tidemedia.tcenter.controller.photo"+splitor+"tidemedia.tcenter.controller.video")) //这里写的是API接口所在的包位置
                .paths(PathSelectors.any())
                .build();
    }

    /**
     * 重写basePackage方法，使能够实现多包访问，复制贴上去
     * @author  teavamc
     * @date 2019/1/26
     * @return com.google.common.base.Predicate<springfox.documentation.RequestHandler>
     */
//    public static Predicate<RequestHandler> basePackage(final String basePackage) {
//        return input -> declaringClass(input).transform(handlerPackage(basePackage)).or(true);
//    }
//
//    private static Function<Class<?>, Boolean> handlerPackage(final String basePackage)     {
//        return input -> {
//            // 循环判断匹配
//            for (String strPackage : basePackage.split(splitor)) {
//                boolean isMatch = input.getPackage().getName().startsWith(strPackage);
//                if (isMatch) {
//                    return true;
//                }
//            }
//            return false;
//        };
//    }
//
//    private static Optional<? extends Class<?>> declaringClass(RequestHandler input) {
//        return Optional.fromNullable(input.declaringClass());
//    }
}