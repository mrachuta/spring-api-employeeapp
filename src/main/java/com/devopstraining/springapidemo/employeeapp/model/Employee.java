package com.devopstraining.springapidemo.employeeapp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;

@Entity
@Table(name = "employees")
public class Employee {

  private long id;
  private String firstName;
  private String lastName;
  private String emailId;

  public Employee() {}

  public Employee(String firstName, String lastName, String emailId) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.emailId = emailId;
  }

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  public long getId() {
    return id;
  }

  public void setId(long id) {
    this.id = id;
  }

  @Column(name = "first_name", nullable = false)
  @NotBlank(message = "first_name can't be blank or null")
  public String getFirstName() {
    return firstName;
  }

  public void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  @Column(name = "last_name", nullable = false)
  @NotBlank(message = "last_name can't be blank or null")
  public String getLastName() {
    return lastName;
  }

  public void setLastName(String lastName) {
    this.lastName = lastName;
  }

  @Column(name = "email_address", nullable = false, unique = true)
  @NotBlank(message = "email_address can't be blank or null")
  public String getEmailId() {
    return emailId;
  }

  public void setEmailId(String emailId) {
    this.emailId = emailId;
  }

  @Override
  public String toString() {
    return "Employee [id="
        + id
        + ", firstName="
        + firstName
        + ", lastName="
        + lastName
        + ", emailId="
        + emailId
        + "]";
  }
}
