# RequestsLibrary Documentation

## Overview

RequestsLibrary is a Robot Framework library that provides powerful HTTP client capabilities for testing REST APIs. Built on top of the popular Python `requests` library, it offers a clean, intuitive interface for making HTTP requests and handling responses in automated tests.

## Installation

```bash
pip install robotframework-requests
```

## Basic Usage

### Importing the Library

```robot
*** Settings ***
Library    RequestsLibrary
```

### Making Simple Requests

```robot
*** Test Cases ***
Simple GET Request
    ${response}=    GET    https://httpbin.org/get
    Status Should Be    200
    ${json}=    Set Variable    ${response.json()}
    Should Contain    ${json}    url

POST Request with Data
    ${data}=    Create Dictionary    key=value    another=thing
    ${response}=    POST    https://httpbin.org/post    data=${data}
    Status Should Be    200
    ${json}=    Set Variable    ${response.json()}
    Should Contain    ${json}    form
```

## Core Keywords

### HTTP Methods

- `GET`: Make HTTP GET requests
- `POST`: Make HTTP POST requests
- `PUT`: Make HTTP PUT requests
- `DELETE`: Make HTTP DELETE requests
- `HEAD`: Make HTTP HEAD requests
- `OPTIONS`: Make HTTP OPTIONS requests
- `PATCH`: Make HTTP PATCH requests

### Session Management

```robot
*** Test Cases ***
Session Based Requests
    Create Session    github    https://api.github.com
    ${response}=    GET On Session    github    /users/robotframework
    Status Should Be    200
    ${user_data}=    Set Variable    ${response.json()}
    Should Be Equal    ${user_data}[login]    robotframework
```

## Authentication

### Basic Authentication

```robot
*** Test Cases ***
Basic Auth Example
    ${auth}=    Create List    username    password
    ${response}=    GET    https://httpbin.org/basic-auth/user/pass    auth=${auth}
    Status Should Be    200
```

### Digest Authentication

```robot
*** Test Cases ***
Digest Auth Example
    ${auth}=    Create List    username    password
    ${response}=    GET    https://httpbin.org/digest-auth/auth/user/pass    auth=${auth}
    Status Should Be    200
```

### Bearer Token Authentication

```robot
*** Test Cases ***
Bearer Token Example
    ${headers}=    Create Dictionary    Authorization=Bearer your_token_here
    ${response}=    GET    https://api.example.com/protected    headers=${headers}
    Status Should Be    200
```

## Request Parameters

### Query Parameters

```robot
*** Test Cases ***
Query Parameters Example
    ${params}=    Create Dictionary    key1=value1    key2=value2
    ${response}=    GET    https://httpbin.org/get    params=${params}
    Status Should Be    200
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal    ${json}[args][key1]    value1
```

### Headers

```robot
*** Test Cases ***
Custom Headers Example
    ${headers}=    Create Dictionary    
    ...    Content-Type=application/json
    ...    User-Agent=RobotFramework-Test
    ${response}=    GET    https://httpbin.org/headers    headers=${headers}
    Status Should Be    200
```

### Request Body

```robot
*** Test Cases ***
JSON Body Example
    ${data}=    Create Dictionary    
    ...    name=Test User
    ...    email=test@example.com
    ${response}=    POST    
    ...    https://httpbin.org/post
    ...    json=${data}
    Status Should Be    200
```

## Response Handling

### Status Code Verification

```robot
*** Test Cases ***
Status Code Examples
    ${response}=    GET    https://httpbin.org/status/200
    Status Should Be    200
    
    ${response}=    GET    https://httpbin.org/status/404
    Status Should Be    404
```

### Response Content

```robot
*** Test Cases ***
Response Content Examples
    ${response}=    GET    https://httpbin.org/json
    
    # Access JSON data
    ${json}=    Set Variable    ${response.json()}
    Should Contain    ${json}    slideshow
    
    # Access text content
    ${text}=    Set Variable    ${response.text}
    Should Not Be Empty    ${text}
    
    # Access headers
    ${content_type}=    Get From Dictionary    ${response.headers}    Content-Type
    Should Contain    ${content_type}    application/json
```

### Response Headers

```robot
*** Test Cases ***
Response Headers Example
    ${response}=    GET    https://httpbin.org/headers
    
    # Check specific header
    ${content_type}=    Get From Dictionary    ${response.headers}    Content-Type
    Should Be Equal    ${content_type}    application/json
    
    # Get all headers
    Log    ${response.headers}
```

## Advanced Features

### File Upload

```robot
*** Test Cases ***
File Upload Example
    ${files}=    Create Dictionary    
    ...    file=${CURDIR}/testfile.txt
    ${response}=    POST    
    ...    https://httpbin.org/post
    ...    files=${files}
    Status Should Be    200
```

### Streaming Responses

```robot
*** Test Cases ***
Streaming Response Example
    ${response}=    GET    https://httpbin.org/stream/5    stream=${True}
    
    # Iterate over response lines
    FOR    ${line}    IN    @{response.iter_lines()}
        Log    ${line}
    END
```

### Timeout Handling

```robot
*** Test Cases ***
Timeout Example
    ${response}=    GET    
    ...    https://httpbin.org/delay/2
    ...    timeout=5
    Status Should Be    200
```

### Proxy Configuration

```robot
*** Test Cases ***
Proxy Example
    ${proxies}=    Create Dictionary    
    ...    http=http://proxy.example.com:8080
    ...    https=https://proxy.example.com:8080
    ${response}=    GET    
    ...    https://httpbin.org/get
    ...    proxies=${proxies}
    Status Should Be    200
```

## Error Handling

### Exception Handling

```robot
*** Test Cases ***
Error Handling Example
    Run Keyword And Expect Error    
    ...    requests.exceptions.ConnectionError:*
    ...    GET    https://nonexistent-domain.example.com
    
    Run Keyword And Expect Error    
    ...    requests.exceptions.Timeout:*
    ...    GET    https://httpbin.org/delay/10    timeout=1
```

### Response Validation

```robot
*** Keywords ***
Validate JSON Response
    [Arguments]    ${response}    ${expected_status}=200
    Status Should Be    ${expected_status}
    ${json}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${json}
    [Return]    ${json}

*** Test Cases ***
Validated Response Example
    ${response}=    GET    https://httpbin.org/json
    ${data}=    Validate JSON Response    ${response}
    Should Contain    ${data}    slideshow
```

## Best Practices

### 1. Use Sessions for Multiple Requests

```robot
*** Test Cases ***
Session Best Practice
    # Create session once
    Create Session    api    https://api.example.com
    
    # Reuse session for multiple requests
    ${response1}=    GET On Session    api    /users/1
    ${response2}=    GET On Session    api    /users/2
    ${response3}=    GET On Session    api    /users/3
```

### 2. Proper Error Handling

```robot
*** Test Cases ***
Robust Error Handling
    ${response}=    GET    https://api.example.com/data
    Run Keyword If    ${response.status_code} == 404
    ...    Log    Resource not found
    ...    ELSE IF    ${response.status_code} == 500
    ...    Fail    Server error occurred
    ...    ELSE IF    ${response.status_code} != 200
    ...    Fail    Unexpected status code: ${response.status_code}
```

### 3. Response Validation

```robot
*** Keywords ***
Validate Response Schema
    [Arguments]    ${response}    ${schema_file}
    ${json}=    Set Variable    ${response.json()}
    # Add schema validation logic here
    # This could use JSONSchema validation
    [Return]    ${json}
```

## Integration with Design Patterns

### Library-Keyword Pattern / Object Service

```robot
*** Settings ***
Library    RequestsLibrary
Resource    resources/apis/users_service.resource

*** Test Cases ***
Test User Service
    ${user_data}=    Create User Data
    ${response}=    Create User    ${user_data}
    ${user_id}=    Set Variable    ${response.json()}[id]
    
    ${response}=    Get User    ${user_id}
    Status Should Be    200
    
    ${updated_data}=    Update User Data    ${user_data}
    ${response}=    Update User    ${user_id}    ${updated_data}
    Status Should Be    200
    
    ${response}=    Delete User    ${user_id}
    Status Should Be    204
```

### Factory Pattern

```robot
*** Keywords ***
Create API Request
    [Arguments]    ${method}    ${url}    ${data}=${None}    ${headers}=${None}
    ${request}=    Create Dictionary
    ...    method=${method}
    ...    url=${url}
    ...    data=${data}
    ...    headers=${headers}
    [Return]    ${request}

*** Test Cases ***
Factory Pattern Example
    ${request}=    Create API Request    GET    https://api.example.com/users
    ${response}=    GET    ${request}[url]
    Status Should Be    200
```

## Common Use Cases

### REST API Testing

```robot
*** Test Cases ***
Complete CRUD Operations
    # Create
    ${user_data}=    Create Dictionary
    ...    name=John Doe
    ...    email=john@example.com
    ${response}=    POST
    ...    https://api.example.com/users
    ...    json=${user_data}
    Status Should Be    201
    ${user_id}=    Set Variable    ${response.json()}[id]
    
    # Read
    ${response}=    GET    https://api.example.com/users/${user_id}
    Status Should Be    200
    Should Be Equal    ${response.json()}[name]    John Doe
    
    # Update
    ${updated_data}=    Create Dictionary
    ...    name=John Smith
    ${response}=    PUT
    ...    https://api.example.com/users/${user_id}
    ...    json=${updated_data}
    Status Should Be    200
    
    # Delete
    ${response}=    DELETE    https://api.example.com/users/${user_id}
    Status Should Be    204
```

### Authentication Testing

```robot
*** Test Cases ***
Authentication Flow
    # Login
    ${credentials}=    Create Dictionary
    ...    username=testuser
    ...    password=testpass
    ${response}=    POST
    ...    https://api.example.com/login
    ...    json=${credentials}
    Status Should Be    200
    ${token}=    Set Variable    ${response.json()}[token]
    
    # Use token for authenticated requests
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    ${response}=    GET
    ...    https://api.example.com/protected
    ...    headers=${headers}
    Status Should Be    200
```

## Troubleshooting

### Common Issues

1. **Connection Errors**
   ```robot
   Run Keyword And Expect Error
   ...    requests.exceptions.ConnectionError:*
   ...    GET    https://unreachable-api.example.com
   ```

2. **Timeout Issues**
   ```robot
   ${response}=    GET    https://slow-api.example.com    timeout=30
   ```

3. **SSL Certificate Issues**
   ```robot
   ${response}=    GET    https://self-signed.example.com    verify=${False}
   ```

### Debugging Tips

```robot
*** Test Cases ***
Debug Example
    # Enable logging
    ${response}=    GET    https://httpbin.org/get
    
    # Log request details
    Log    Request URL: ${response.url}
    Log    Request Headers: ${response.request.headers}
    Log    Response Status: ${response.status_code}
    Log    Response Headers: ${response.headers}
    Log    Response Body: ${response.text}
```

## Conclusion

RequestsLibrary is a powerful and flexible tool for API testing in Robot Framework. Its intuitive interface, combined with the robust capabilities of the underlying `requests` library, makes it an excellent choice for testing REST APIs, web services, and other HTTP-based applications.

When used with the design patterns implemented in this project (Library-Keyword Pattern, Factory Pattern, etc.), RequestsLibrary provides a solid foundation for building maintainable, scalable, and efficient automated test suites.