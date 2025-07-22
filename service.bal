import ballerina/http;
import ballerina/uuid;

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

Employee[] employees = [{id: 1, name: "John", address: "Colombo"},
                           {id: 2, name: "Doe", address: "Kandy"},
                           {id: 3, name: "Smith", address: "Galle"}];

service /employee/v1 on employeeListener {
    resource function get employees() returns EmployeeList {
        EmployeeList employeeList = {count: employees.length(), employees: employees};
        // Generate 100 random employees with long names and addresses
        // Generate a long random name and address
        foreach int i in 0...1000 {
            string name = string `${uuid:createType4AsString()} ${i}`;
            string address = string `${uuid:createType4AsString()} ${i}`;
            Employee employee = {id: i + 4, name: name, address: address};
            employees.push(employee);
        }
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
