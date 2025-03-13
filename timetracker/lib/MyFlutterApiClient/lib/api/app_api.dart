//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AppApi {
  AppApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /employees/{id}/timeentries' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [DateTime] day:
  Future<Response> employeesIdTimeentriesGetWithHttpInfo(int id, { DateTime? day, }) async {
    // ignore: prefer_const_declarations
    final path = r'/employees/{id}/timeentries'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (day != null) {
      queryParams.addAll(_queryParams('', 'day', day));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [DateTime] day:
  Future<List<TimeEntryDto>?> employeesIdTimeentriesGet(int id, { DateTime? day, }) async {
    final response = await employeesIdTimeentriesGetWithHttpInfo(id,  day: day, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<TimeEntryDto>') as List)
        .cast<TimeEntryDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /employees/{id}/totalHours' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [DateTime] from:
  ///
  /// * [DateTime] to:
  Future<Response> employeesIdTotalHoursGetWithHttpInfo(int id, { DateTime? from, DateTime? to, }) async {
    // ignore: prefer_const_declarations
    final path = r'/employees/{id}/totalHours'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (from != null) {
      queryParams.addAll(_queryParams('', 'from', from));
    }
    if (to != null) {
      queryParams.addAll(_queryParams('', 'to', to));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [DateTime] from:
  ///
  /// * [DateTime] to:
  Future<List<TotalDayTimeEntryDto>?> employeesIdTotalHoursGet(int id, { DateTime? from, DateTime? to, }) async {
    final response = await employeesIdTotalHoursGetWithHttpInfo(id,  from: from, to: to, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<TotalDayTimeEntryDto>') as List)
        .cast<TotalDayTimeEntryDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'POST /employees' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [AddEmployeeDto] addEmployeeDto:
  Future<Response> employeesPostWithHttpInfo({ AddEmployeeDto? addEmployeeDto, }) async {
    // ignore: prefer_const_declarations
    final path = r'/employees';

    // ignore: prefer_final_locals
    Object? postBody = addEmployeeDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json', 'text/json', 'application/*+json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [AddEmployeeDto] addEmployeeDto:
  Future<Employee?> employeesPost({ AddEmployeeDto? addEmployeeDto, }) async {
    final response = await employeesPostWithHttpInfo( addEmployeeDto: addEmployeeDto, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Employee',) as Employee;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /isWorking' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] employeeId:
  Future<Response> isWorkingGetWithHttpInfo({ int? employeeId, }) async {
    // ignore: prefer_const_declarations
    final path = r'/isWorking';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (employeeId != null) {
      queryParams.addAll(_queryParams('', 'employeeId', employeeId));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] employeeId:
  Future<bool?> isWorkingGet({ int? employeeId, }) async {
    final response = await isWorkingGetWithHttpInfo( employeeId: employeeId, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /login' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] email:
  ///
  /// * [String] password:
  Future<Response> loginPostWithHttpInfo({ String? email, String? password, }) async {
    // ignore: prefer_const_declarations
    final path = r'/login';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (email != null) {
      queryParams.addAll(_queryParams('', 'email', email));
    }
    if (password != null) {
      queryParams.addAll(_queryParams('', 'password', password));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] email:
  ///
  /// * [String] password:
  Future<bool?> loginPost({ String? email, String? password, }) async {
    final response = await loginPostWithHttpInfo( email: email, password: password, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /timeEntry/start' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] employeeId:
  Future<Response> timeEntryStartPostWithHttpInfo({ int? employeeId, }) async {
    // ignore: prefer_const_declarations
    final path = r'/timeEntry/start';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (employeeId != null) {
      queryParams.addAll(_queryParams('', 'employeeId', employeeId));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] employeeId:
  Future<bool?> timeEntryStartPost({ int? employeeId, }) async {
    final response = await timeEntryStartPostWithHttpInfo( employeeId: employeeId, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /timeEntry/stop' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] employeeId:
  ///
  /// * [String] comment:
  Future<Response> timeEntryStopPostWithHttpInfo({ int? employeeId, String? comment, }) async {
    // ignore: prefer_const_declarations
    final path = r'/timeEntry/stop';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (employeeId != null) {
      queryParams.addAll(_queryParams('', 'employeeId', employeeId));
    }
    if (comment != null) {
      queryParams.addAll(_queryParams('', 'comment', comment));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] employeeId:
  ///
  /// * [String] comment:
  Future<bool?> timeEntryStopPost({ int? employeeId, String? comment, }) async {
    final response = await timeEntryStopPostWithHttpInfo( employeeId: employeeId, comment: comment, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /timeentries/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  Future<Response> timeentriesIdDeleteWithHttpInfo(int id,) async {
    // ignore: prefer_const_declarations
    final path = r'/timeentries/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] id (required):
  Future<bool?> timeentriesIdDelete(int id,) async {
    final response = await timeentriesIdDeleteWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'bool',) as bool;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /timeentries/{id}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [TimeEntryDto] timeEntryDto:
  Future<Response> timeentriesIdPutWithHttpInfo(int id, { TimeEntryDto? timeEntryDto, }) async {
    // ignore: prefer_const_declarations
    final path = r'/timeentries/{id}'
      .replaceAll('{id}', id.toString());

    // ignore: prefer_final_locals
    Object? postBody = timeEntryDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json', 'text/json', 'application/*+json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [int] id (required):
  ///
  /// * [TimeEntryDto] timeEntryDto:
  Future<TimeEntryDto?> timeentriesIdPut(int id, { TimeEntryDto? timeEntryDto, }) async {
    final response = await timeentriesIdPutWithHttpInfo(id,  timeEntryDto: timeEntryDto, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TimeEntryDto',) as TimeEntryDto;
    
    }
    return null;
  }
}
