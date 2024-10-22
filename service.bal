import ballerina/http;

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

Employee[] employees = [{id: 1, name: "John_v2", address: "V2"},
                           {id: 2, name: "Doe_v2", address: "V2"},
                           {id: 3, name: "Smith_v2_1", address: "V2_1"}];

service /employee/v1 on employeeListener {
    resource function get employees() returns EmployeeList {
        EmployeeList employeeList = {count: 3, employees: employees};
        return employeeList;
    }

    resource function get employees2() returns EmployeeList {
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
