package com.devopstraining.springapidemo.employeeapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/* Solution for Tomcat
https://www.baeldung.com/spring-boot-war-tomcat-deploy
https://stackoverflow.com/a/45593022
*/

@SpringBootApplication
public class SpringEmployeeappApplication extends SpringBootServletInitializer {

	public static void main(String[] args) {
		SpringApplication.run(SpringEmployeeappApplication.class, args);
	}

}
