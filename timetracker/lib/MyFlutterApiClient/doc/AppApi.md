# openapi.api.AppApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**appEmployeesEmployeeIdTimeentriesPost**](AppApi.md#appemployeesemployeeidtimeentriespost) | **POST** /App/employees/{employeeId}/timeentries | 
[**employeesIdTimeentriesGet**](AppApi.md#employeesidtimeentriesget) | **GET** /employees/{id}/timeentries | 
[**employeesIdTotalHoursGet**](AppApi.md#employeesidtotalhoursget) | **GET** /employees/{id}/totalHours | 
[**employeesPost**](AppApi.md#employeespost) | **POST** /employees | 
[**isWorkingGet**](AppApi.md#isworkingget) | **GET** /isWorking | 
[**loginPost**](AppApi.md#loginpost) | **POST** /login | 
[**timeEntryStartPost**](AppApi.md#timeentrystartpost) | **POST** /timeEntry/start | 
[**timeEntryStopPost**](AppApi.md#timeentrystoppost) | **POST** /timeEntry/stop | 
[**timeentriesIdDelete**](AppApi.md#timeentriesiddelete) | **DELETE** /timeentries/{id} | 
[**timeentriesIdPut**](AppApi.md#timeentriesidput) | **PUT** /timeentries/{id} | 


# **appEmployeesEmployeeIdTimeentriesPost**
> TimeEntryDto appEmployeesEmployeeIdTimeentriesPost(employeeId, timeEntryDto)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AppApi();
final employeeId = 56; // int | 
final timeEntryDto = TimeEntryDto(); // TimeEntryDto | 

try {
    final result = api_instance.appEmployeesEmployeeIdTimeentriesPost(employeeId, timeEntryDto);
    print(result);
} catch (e) {
    print('Exception when calling AppApi->appEmployeesEmployeeIdTimeentriesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **employeeId** | **int**|  | 
 **timeEntryDto** | [**TimeEntryDto**](TimeEntryDto.md)|  | [optional] 

### Return type

[**TimeEntryDto**](TimeEntryDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeesIdTimeentriesGet**
> List<TimeEntryDto> employeesIdTimeentriesGet(id, day)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AppApi();
final id = 56; // int | 
final day = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final result = api_instance.employeesIdTimeentriesGet(id, day);
    print(result);
} catch (e) {
    print('Exception when calling AppApi->employeesIdTimeentriesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **day** | **DateTime**|  | [optional] 

### Return type

[**List<TimeEntryDto>**](TimeEntryDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeesIdTotalHoursGet**
> List<TotalDayTimeEntryDto> employeesIdTotalHoursGet(id, from, to)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AppApi();
final id = 56; // int | 
final from = 2013-10-20T19:20:30+01:00; // DateTime | 
final to = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final result = api_instance.employeesIdTotalHoursGet(id, from, to);
    print(result);
} catch (e) {
    print('Exception when calling AppApi->employeesIdTotalHoursGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**List<TotalDayTimeEntryDto>**](TotalDayTimeEntryDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **employeesPost**
> Employee employeesPost(addEmployeeDto)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AppApi();
final addEmployeeDto = AddEmployeeDto(); // AddEmployeeDto | 

try {
    final result = api_instance.employeesPost(addEmployeeDto);
    print(result);
} catch (e) {
    print('Exception when calling AppApi->employeesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **addEmployeeDto** | [**AddEmployeeDto**](AddEmployeeDto.md)|  | [optional] 

### Return type

[**Employee**](Employee.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **isWorkingGet**
> bool isWorkingGet(employeeId)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AppApi();
final employeeId = 56; // int | 

try {
    final result = api_instance.isWorkingGet(employeeId);
    print(result);
} catch (e) {
    print('Exception when calling AppApi->isWorkingGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **employeeId** | **int**|  | [optional] 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **loginPost**
> EmployeeDto loginPost(email, password)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AppApi();
final email = email_example; // String | 
final password = password_example; // String | 

try {
    final result = api_instance.loginPost(email, password);
    print(result);
} catch (e) {
    print('Exception when calling AppApi->loginPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **email** | **String**|  | [optional] 
 **password** | **String**|  | [optional] 

### Return type

[**EmployeeDto**](EmployeeDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **timeEntryStartPost**
> bool timeEntryStartPost(employeeId)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AppApi();
final employeeId = 56; // int | 

try {
    final result = api_instance.timeEntryStartPost(employeeId);
    print(result);
} catch (e) {
    print('Exception when calling AppApi->timeEntryStartPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **employeeId** | **int**|  | [optional] 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **timeEntryStopPost**
> bool timeEntryStopPost(employeeId, comment)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AppApi();
final employeeId = 56; // int | 
final comment = comment_example; // String | 

try {
    final result = api_instance.timeEntryStopPost(employeeId, comment);
    print(result);
} catch (e) {
    print('Exception when calling AppApi->timeEntryStopPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **employeeId** | **int**|  | [optional] 
 **comment** | **String**|  | [optional] 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **timeentriesIdDelete**
> bool timeentriesIdDelete(id)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AppApi();
final id = 56; // int | 

try {
    final result = api_instance.timeentriesIdDelete(id);
    print(result);
} catch (e) {
    print('Exception when calling AppApi->timeentriesIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

**bool**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **timeentriesIdPut**
> TimeEntryDto timeentriesIdPut(id, timeEntryDto)



### Example
```dart
import 'package:openapi/api.dart';

final api_instance = AppApi();
final id = 56; // int | 
final timeEntryDto = TimeEntryDto(); // TimeEntryDto | 

try {
    final result = api_instance.timeentriesIdPut(id, timeEntryDto);
    print(result);
} catch (e) {
    print('Exception when calling AppApi->timeentriesIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **timeEntryDto** | [**TimeEntryDto**](TimeEntryDto.md)|  | [optional] 

### Return type

[**TimeEntryDto**](TimeEntryDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json, text/json, application/*+json
 - **Accept**: text/plain, application/json, text/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

