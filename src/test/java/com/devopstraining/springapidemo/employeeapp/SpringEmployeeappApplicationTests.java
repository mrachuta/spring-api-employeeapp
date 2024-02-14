package com.devopstraining.springapidemo.employeeapp;

import org.junit.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class SpringEmployeeappApplicationTests {

  // Hint from https://stackoverflow.com/a/62747586
  @Test(expected = Test.None.class)
  void contextLoads() {}
}
