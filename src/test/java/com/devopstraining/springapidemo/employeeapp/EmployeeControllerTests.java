package com.devopstraining.springapidemo.employeeapp;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.junit.runner.RunWith;
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

import com.devopstraining.springapidemo.employeeapp.model.Employee;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = SpringEmployeeappApplication.class, webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class EmployeeControllerTests {
     @Autowired
     private TestRestTemplate restTemplate;

     @LocalServerPort
     private int port;

     private String getRootUrl() {
         return "http://localhost:" + port;
     }

     @Test
     public void contextLoads() {
        assertTrue(true);
     }

     @Test
     public void testGetIndex() {
     HttpHeaders headers = new HttpHeaders();
        HttpEntity<String> entity = new HttpEntity<String>(null, headers);
        ResponseEntity<String> response = restTemplate.exchange(getRootUrl() + "/",
        HttpMethod.GET, entity, String.class);  
        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

     @Test
     public void testGetAllEmployees() {
     HttpHeaders headers = new HttpHeaders();
        HttpEntity<String> entity = new HttpEntity<String>(null, headers);
        ResponseEntity<String> response = restTemplate.exchange(getRootUrl() + "/api/v1/employees",
        HttpMethod.GET, entity, String.class);  
        assertNotNull(response.getBody());
    }

    @Test
    public void testGetEmployeeById() {
        Employee employee = restTemplate.getForObject(getRootUrl() + "/api/v1/employees/1", Employee.class);
        System.out.println(employee.getFirstName());
        assertNotNull(employee);
    }

    @Test
    public void testCreateEmployee() {
        Employee employee = new Employee();
        employee.setEmailId("admin@test.pl");
        employee.setFirstName("admin");
        employee.setLastName("admin");
        ResponseEntity<Employee> postResponse = restTemplate.postForEntity(getRootUrl() + "/api/v1/employees", employee, Employee.class);
        assertNotNull(postResponse);
        assertNotNull(postResponse.getBody());
    }

    @Test
    public void testUpdateEmployee() {
        int id = 1;
        Employee employee = restTemplate.getForObject(getRootUrl() + "/api/v1/employees/" + id, Employee.class);
        employee.setFirstName("admin1");
        employee.setLastName("admin2");
        restTemplate.put(getRootUrl() + "/api/v1/employees/" + id, employee);
        Employee updatedEmployee = restTemplate.getForObject(getRootUrl() + "/api/v1/employees/" + id, Employee.class);
        assertNotNull(updatedEmployee);
    }

    @Test
    public void testDeleteEmployee() {
         int id = 2;
         Employee employee = restTemplate.getForObject(getRootUrl() + "/api/v1/employees/" + id, Employee.class);
         assertNotNull(employee);
         restTemplate.delete(getRootUrl() + "/api/v1/employees/" + id);
         try {
              employee = restTemplate.getForObject(getRootUrl() + "/api/v1/employees/" + id, Employee.class);
         } catch (final HttpClientErrorException e) {
              assertEquals(HttpStatus.NOT_FOUND, e.getStatusCode());
         }
    }
}