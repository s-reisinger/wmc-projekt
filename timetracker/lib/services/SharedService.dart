import 'package:timetracker/MyFlutterApiClient/lib/api.dart';

class SharedService {
  static EmployeeDto? loggedInUser;
  static final String basePath = 'http://localhost:5000';
}