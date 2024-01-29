package com.devopstraining.springapidemo.employeeapp.repository;

import com.devopstraining.springapidemo.employeeapp.model.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Long> {}
