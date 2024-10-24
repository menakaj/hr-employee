import ballerina/http;
import ballerina/os;
import ballerina/io;

listener http:Listener employeeListener = new(9090);

type Employee record {
    int id;
    string name;
    string address;
};

type EmployeeList record {
    int count;
    Employee[] employees;
};




string serviceUrl = os:getEnv("CHOREO_PROJECTPROXY_SERVICEURL");
string consumerKey = os:getEnv("CHOREO_PROJECTPROXY_CONSUMERKEY");
string consumerSecret = os:getEnv("CHOREO_PROJECTPROXY_CONSUMERSECRET");
string tokenUrl = os:getEnv("CHOREO_PROJECTPROXY_TOKENURL");

Employee[] employees = [{id: 1, name: tokenUrl, address: serviceUrl},
                           {id: 2, name: consumerSecret, address: "Kandy"},
                           {id: 3, name: consumerKey, address: "Galle"}];

service /employee/v1 on employeeListener {
    resource function get bookings2() returns EmployeeList {
        io:println(serviceUrl, consumerKey, consumerSecret, tokenUrl);
        EmployeeList employeeList = {count: 3, employees: employees};
        return employeeList;
    }

    resource function get employees/[int empID]() returns Employee|http:NotFound {
        Employee[] listResult = from Employee employee in employees where employee.id == empID select employee;

        if (listResult.length() == 0) {
            http:NotFound notFound = {body:  "Employee not found"};
            return notFound;
        }
        return listResult[0];
    }

    resource function post employee(@http:Payload Employee employee) returns Employee|http:BadRequest {
        Employee[] listResult = from Employee emp in employees where emp.id == employee.id select emp;

        if (listResult.length() == 0) {
            employees.push(employee);
            return employee;
        }
        http:BadRequest badRequest = {body: "Employee already exists"};
        return badRequest;
        
    }
}
