## Project name
spring-api-employeapp - example Spring Boot API application with CI/CD process.

## Table of contents
- [Project name](#project-name)
- [Table of contents](#table-of-contents)
- [General info](#general-info)
- [Technologies](#technologies)
- [Setup](#setup)
- [Usage](#usage)

## General info
App is written basing on following howto:
https://www.javaguides.net/2019/01/springboot-postgresql-jpa-hibernate-crud-restful-api-tutorial.html

## Technologies
* Backend: Java (SpringBoot)
* Database: H2 (test) and PostgreSQL (prod)
* CI/CD: Jenkins

## Setup

Local:

1. Clone git repository.
2. Go to root of repository and build application using Maven:
    ```
    mvn package
    ```
3. Run application with specific profile:
    ```
    java -jar target/employeeapp.war
    ```

Prod:

1. Set following environment variables (replace placeholders @TEXT@ by proper values)
   ```
   export DATABASE_HOST=@HOST@
   export DATABASE_PORT=@PORT@
   export DATABASE_NAME=@NAME@
   export DATABASE_USERNAME=@USER@
   export DATABASE_PASSWORD=@PASS@
   ```
2. Go to root of repository and build application using Maven:
    ```
    mvn package
    ```
3. Run application with specific profile:
    ```
    java -jar target/employeeapp.war --spring.profiles.active=prod
    ```

## Usage

Application:
List of all endpoints is available at http://127.0.0.1:8080/actuator/
