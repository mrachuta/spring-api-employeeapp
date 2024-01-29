package com.devopstraining.springapidemo.employeeapp;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import com.devopstraining.springapidemo.employeeapp.model.Employee;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.web.client.HttpClientErrorException;

@RunWith(SpringRunner.class)
@SpringBootTest(
    classes = SpringEmployeeappApplication.class,
    webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class EmployeeControllerTests {
  @Autowired private TestRestTemplate restTemplate;

  @LocalServerPort private int port;

  private String getRootUrl() {
    return "http://localhost:" + port;
  }

  @Test
  public void contextLoads() {
    assertTrue(true);
  }

  @Test
  public void testAGetIndex() {
    HttpHeaders headers = new HttpHeaders();
    HttpEntity<String> entity = new HttpEntity<String>(null, headers);
    ResponseEntity<String> response =
        restTemplate.exchange(getRootUrl() + "/", HttpMethod.GET, entity, String.class);
    assertEquals(HttpStatus.OK, response.getStatusCode());
  }

  @Test
  public void testBCreateEmployee() {
    Employee employee = new Employee();
    employee.setEmailId("admin@test.pl");
    employee.setFirstName("admin");
    employee.setLastName("admin");
    ResponseEntity<Employee> response =
        restTemplate.postForEntity(getRootUrl() + "/api/v1/employees", employee, Employee.class);
    assertEquals(HttpStatus.OK, response.getStatusCode());
  }

  @Test
  public void testCGetEmployeeById() {
    HttpHeaders headers = new HttpHeaders();
    HttpEntity<String> entity = new HttpEntity<String>(null, headers);
    ResponseEntity<String> response =
        restTemplate.exchange(
            getRootUrl() + "/api/v1/employees/1", HttpMethod.GET, entity, String.class);
    assertEquals(HttpStatus.OK, response.getStatusCode());
  }

  @Test
  public void testDCreateEmployeeNullFirstName() {
    Employee employee = new Employee();
    employee.setEmailId("admin@test.pl");
    employee.setFirstName(null);
    employee.setLastName("admin");
    ResponseEntity<Employee> response =
        restTemplate.postForEntity(getRootUrl() + "/api/v1/employees", employee, Employee.class);
    assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
  }

  @Test
  public void testECreateEmployeeEmptyLastName() {
    Employee employee = new Employee();
    employee.setEmailId("admin@test.pl");
    employee.setFirstName("admin");
    employee.setLastName(null);
    ResponseEntity<Employee> response =
        restTemplate.postForEntity(getRootUrl() + "/api/v1/employees", employee, Employee.class);
    assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
  }

  @Test
  public void testFCreateEmployeeNullEmailId() {
    Employee employee = new Employee();
    employee.setEmailId(null);
    employee.setFirstName("admin");
    employee.setLastName("admin");
    ResponseEntity<Employee> response =
        restTemplate.postForEntity(getRootUrl() + "/api/v1/employees", employee, Employee.class);
    assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
  }

  @Test
  public void testGCreateEmployeeEmptyEmailId() {
    Employee employee = new Employee();
    employee.setEmailId("");
    employee.setFirstName("admin");
    employee.setLastName("admin");
    ResponseEntity<Employee> response =
        restTemplate.postForEntity(getRootUrl() + "/api/v1/employees", employee, Employee.class);
    assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
  }

  @Test
  public void testHCreateEmployeeWithDuplicatedEmail() {
    Employee employee = new Employee();
    employee.setEmailId("admin@test.pl");
    employee.setFirstName("admincopy");
    employee.setLastName("admincopy");
    ResponseEntity<Employee> response =
        restTemplate.postForEntity(getRootUrl() + "/api/v1/employees", employee, Employee.class);
    assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
  }

  @Test
  public void testIUpdateEmployee() {
    int id = 1;
    Employee employee =
        restTemplate.getForObject(getRootUrl() + "/api/v1/employees" + id, Employee.class);
    employee.setFirstName("admin1");
    employee.setLastName("admin2");
    employee.setEmailId("admin@test.pl");
    HttpEntity<Employee> requestEntity = new HttpEntity<>(employee);
    ResponseEntity<Employee> response =
        restTemplate.exchange(
            getRootUrl() + "/api/v1/employees/" + id,
            HttpMethod.PUT,
            requestEntity,
            Employee.class);
    assertEquals(HttpStatus.OK, response.getStatusCode());
  }

  @Test
  public void testJUpdateNonExistingEmployee() {
    int id = 2;
    try {
      Employee employee =
          restTemplate.getForObject(getRootUrl() + "/api/v1/employees" + id, Employee.class);
      employee.setFirstName("admin1");
      employee.setLastName("admin2");
      employee.setEmailId("admin@test.pl");
      HttpEntity<Employee> requestEntity = new HttpEntity<>(employee);
      ResponseEntity<Employee> response =
          restTemplate.exchange(
              getRootUrl() + "/api/v1/employees/" + id,
              HttpMethod.PUT,
              requestEntity,
              Employee.class);
    } catch (final HttpClientErrorException e) {
      assertEquals(HttpStatus.NOT_FOUND, e.getStatusCode());
    }
  }

  @Test
  public void testKGetAllEmployees() {
    HttpHeaders headers = new HttpHeaders();
    HttpEntity<String> entity = new HttpEntity<String>(null, headers);
    ResponseEntity<String> response =
        restTemplate.exchange(
            getRootUrl() + "/api/v1/employees", HttpMethod.GET, entity, String.class);
    assertEquals(HttpStatus.OK, response.getStatusCode());
  }

  @Test
  public void testLDeleteEmployee() {
    int id = 2;
    Employee employee =
        restTemplate.getForObject(getRootUrl() + "/api/v1/employees/" + id, Employee.class);
    assertNotNull(employee);
    restTemplate.delete(getRootUrl() + "/api/v1/employees/" + id);
    try {
      employee =
          restTemplate.getForObject(getRootUrl() + "/api/v1/employees/" + id, Employee.class);
    } catch (final HttpClientErrorException e) {
      assertEquals(HttpStatus.NOT_FOUND, e.getStatusCode());
    }
  }
}
