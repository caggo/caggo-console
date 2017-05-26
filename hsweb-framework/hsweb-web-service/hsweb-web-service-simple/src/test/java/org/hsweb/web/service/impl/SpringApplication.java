package org.hsweb.web.service.impl;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * Created by shanbiao.jsb on 17-4-20.
 */
@Configuration
@EnableAutoConfiguration
@ComponentScan(basePackages = {"org.hsweb.web"})
@EnableTransactionManagement(proxyTargetClass = true)
//@MapperScan("org.hsweb.web.dao")
public class SpringApplication {

}
