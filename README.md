## Project name
spring-api-employeapp - example Spring Boot API application with CI/CD process.

## Table of contents
- [Project name](#project-name)
- [Table of contents](#table-of-contents)
- [General info](#general-info)
- [Technologies](#technologies)
- [Setup](#setup)
  - [Development mode](#development-mode)
  - [Classical PROD](#classical-prod)
  - [GCP PROD](#gcp-prod)
- [Usage](#usage)

## General info
App is written basing on following howto:
https://www.javaguides.net/2019/01/springboot-postgresql-jpa-hibernate-crud-restful-api-tutorial.html
In one of next iterations, to improve pipeline an examples of DevSecOps practices were added.
Following analysis are performed. One of main requirements was to use tools that are easy available and free to use (or at least each one has free tier).
* SAST analysis using **Sonarqube**
* Licence compliance analysis using **Fossa**
* SCA analysis of Java package using **Trivy**
* SCA analysis of GCP image using **Trivy**
  * Currently stage is disabled because of issues: https://github.com/aquasecurity/trivy/discussions/5876
* DAST scan using **OwaspZAP**

Following guidelines might be useful to understand each analysis type: https://www.redhat.com/en/blog/application-analysis-devsecops-life-cycle

Tool that is not mentioned here but seems to be most powerful package available on market is Checkmarx (https://checkmarx.com/product/application-security-platform/)

## Technologies
* Backend: Java (SpringBoot)
* Database: H2 (test) and PostgreSQL (prod)
* CI/CD: Jenkins

## Setup

### Development mode

1. Clone git repository.
2. Go to root of repository and build application using Maven:
    ```
    mvn package
    ```
3. Run application with specific profile:
    ```
    java -jar target/employeeapp.war
    ```

### Classical PROD

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

### GCP PROD

1. Go to root of repository and build application using Maven:
    ```
    mvn package
    ```
2. For image creation process see following file [README.md](./packer/README.md)
3. For infrastructure creation process see following file [README.md](./infra/README.md)

## Usage

Application:
List of all endpoints is available at http://127.0.0.1:8080/actuator/

Example:
POST
```
curl -X POST -H "Content-Type: application/json" -d "{\"firstName\": \"test\", \"lastName\": \"testowy\", \"emailId\": \"testtestowy@nieistnieje.xyz\"}"  http://127.0.0.1:8080/api/v1/employees
```
GET
```
curl -X GET http://127.0.0.1:8080/api/v1/employees
```
