//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TotalDayTimeEntryDto {
  /// Returns a new [TotalDayTimeEntryDto] instance.
  TotalDayTimeEntryDto({
    this.employeeId,
    this.date,
    this.hours,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? employeeId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? date;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? hours;

  @override
  bool operator ==(Object other) => identical(this, other) || other is TotalDayTimeEntryDto &&
    other.employeeId == employeeId &&
    other.date == date &&
    other.hours == hours;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (employeeId == null ? 0 : employeeId!.hashCode) +
    (date == null ? 0 : date!.hashCode) +
    (hours == null ? 0 : hours!.hashCode);

  @override
  String toString() => 'TotalDayTimeEntryDto[employeeId=$employeeId, date=$date, hours=$hours]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.employeeId != null) {
      json[r'employeeId'] = this.employeeId;
    } else {
      json[r'employeeId'] = null;
    }
    if (this.date != null) {
      json[r'date'] = this.date!.toUtc().toIso8601String();
    } else {
      json[r'date'] = null;
    }
    if (this.hours != null) {
      json[r'hours'] = this.hours;
    } else {
      json[r'hours'] = null;
    }
    return json;
  }

  /// Returns a new [TotalDayTimeEntryDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TotalDayTimeEntryDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "TotalDayTimeEntryDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "TotalDayTimeEntryDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return TotalDayTimeEntryDto(
        employeeId: mapValueOfType<int>(json, r'employeeId'),
        date: mapDateTime(json, r'date', r''),
        hours: mapValueOfType<double>(json, r'hours'),
      );
    }
    return null;
  }

  static List<TotalDayTimeEntryDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TotalDayTimeEntryDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TotalDayTimeEntryDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TotalDayTimeEntryDto> mapFromJson(dynamic json) {
    final map = <String, TotalDayTimeEntryDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TotalDayTimeEntryDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TotalDayTimeEntryDto-objects as value to a dart map
  static Map<String, List<TotalDayTimeEntryDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TotalDayTimeEntryDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TotalDayTimeEntryDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

