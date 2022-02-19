package com.devopstraining.springapidemo.employeeapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.devopstraining.springapidemo.employeeapp.model.Employee;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Long>{

}