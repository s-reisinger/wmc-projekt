//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Employee {
  /// Returns a new [Employee] instance.
  Employee({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.passwordHash,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? id;

  String? firstName;

  String? lastName;

  String? email;

  String? passwordHash;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Employee &&
    other.id == id &&
    other.firstName == firstName &&
    other.lastName == lastName &&
    other.email == email &&
    other.passwordHash == passwordHash;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (firstName == null ? 0 : firstName!.hashCode) +
    (lastName == null ? 0 : lastName!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (passwordHash == null ? 0 : passwordHash!.hashCode);

  @override
  String toString() => 'Employee[id=$id, firstName=$firstName, lastName=$lastName, email=$email, passwordHash=$passwordHash]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.firstName != null) {
      json[r'firstName'] = this.firstName;
    } else {
      json[r'firstName'] = null;
    }
    if (this.lastName != null) {
      json[r'lastName'] = this.lastName;
    } else {
      json[r'lastName'] = null;
    }
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
    if (this.passwordHash != null) {
      json[r'passwordHash'] = this.passwordHash;
    } else {
      json[r'passwordHash'] = null;
    }
    return json;
  }

  /// Returns a new [Employee] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Employee? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Employee[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Employee[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Employee(
        id: mapValueOfType<int>(json, r'id'),
        firstName: mapValueOfType<String>(json, r'firstName'),
        lastName: mapValueOfType<String>(json, r'lastName'),
        email: mapValueOfType<String>(json, r'email'),
        passwordHash: mapValueOfType<String>(json, r'passwordHash'),
      );
    }
    return null;
  }

  static List<Employee> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Employee>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Employee.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Employee> mapFromJson(dynamic json) {
    final map = <String, Employee>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Employee.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Employee-objects as value to a dart map
  static Map<String, List<Employee>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Employee>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Employee.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

