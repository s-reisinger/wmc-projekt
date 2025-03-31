import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timetracker/MyFlutterApiClient/lib/api.dart';
import 'package:timetracker/services/SharedService.dart';

class TimeTrackingPage extends StatefulWidget {
  const TimeTrackingPage({Key? key}) : super(key: key);

  @override
  State<TimeTrackingPage> createState() {
    return _TimeTrackingPageState();
  }
}

class _TimeTrackingPageState extends State<TimeTrackingPage> {
  // For demo purposes, fixed employeeId.
  final EmployeeDto? employee = SharedService.loggedInUser;

  // The selected date; defaults to today.
  DateTime selectedDate = DateTime.now();

  // Whether the user is currently working (ongoing entry) today.
  bool isWorking = false;

  // Loading indicator.
  bool isLoading = false;

  // Controllers for start time, end time, and comment fields.
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  // List of time entries for the selected day.
  List<TimeEntryDto> timeEntries = [];

  // If the user taps a finished entry for editing, we store it here.
  TimeEntryDto? _selectedEntry;

  // Determines if we are in editing mode (i.e. a finished entry was manually selected).
  bool editingMode = false;

  late AppApi api;

  @override
  void initState() {
    super.initState();
    final client = ApiClient(basePath: SharedService.basePath);
    api = AppApi(client);
    _loadData();
  }

  /// Returns true if [selectedDate] is today.
  bool get isToday {
    final now = DateTime.now();
    return DateTime(selectedDate.year, selectedDate.month, selectedDate.day) ==
        DateTime(now.year, now.month, now.day);
  }

  /// Determines the main button label.
  String get buttonLabel {
    if (!isToday) {
      return 'Speichern';
    }
    // Today:
    if (isWorking) {
      return editingMode ? 'Speichern' : 'Gehen';
    } else if (editingMode) {
      return 'Speichern';
    }
    return 'Kommen';
  }

  bool get canEditFields {
    if (!isToday) return true;
    return editingMode;
  }

  /// Loads data:
  /// 1. If today, checks whether the user is working.
  /// 2. Loads time entries for the selected date.
  /// 3. For today and if working, auto-selects the ongoing entry only if no finished entry was selected.
  Future<void> _loadData() async {
    if (employee == null) {
      context.go('/');
    }
    setState(() => isLoading = true);
    try {
      if (isToday) {
        isWorking = (await api.isWorkingGet(employeeId: employee!.id)) ?? false;
      } else {
        isWorking = false;
      }

      final adjustedDay = _shiftMidnightToUtc(selectedDate);
      timeEntries =
          (await api.employeesIdTimeentriesGet(
            employee!.id!,
            day: adjustedDay,
          )) ??
          [];

      if (isToday && isWorking) {
        if (_selectedEntry == null || _selectedEntry!.end == null) {
          try {
            final ongoing = timeEntries.firstWhere((e) => e.end == null);
            _selectEntry(ongoing);
          } catch (e) {}
        }
      } else {
        _clearMainFields();
      }
    } catch (e) {
      debugPrint('Error while loading data: $e');
    }
    setState(() => isLoading = false);
  }

  void _clearMainFields() {
    startTimeController.clear();
    endTimeController.clear();
    commentController.clear();
    _selectedEntry = null;
    editingMode = false;
  }

  DateTime _shiftMidnightToUtc(DateTime localDate) {
    // If we only care about the date portion, strip out any hour/minute/second
    final localMidnight = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );
    // Add the timezone offset before converting to UTC
    return localMidnight.add(localMidnight.timeZoneOffset).toUtc();
  }

  /// Called when tapping the left arrow.
  void _onLeftDate() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
    _clearMainFields();
    _loadData();
  }

  /// Called when tapping the right arrow (disallowed if selectedDate is today).
  void _onRightDate() {
    final today = DateTime.now();
    if (selectedDate.isBefore(DateTime(today.year, today.month, today.day))) {
      setState(() {
        selectedDate = selectedDate.add(const Duration(days: 1));
      });
      _clearMainFields();
      _loadData();
    }
  }

  /// Opens the date picker.
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 2);
    final lastDate = DateTime(now.year, now.month, now.day); // disallow future
    final newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('de', 'DE'),
    );
    if (newDate != null && newDate != selectedDate) {
      setState(() {
        selectedDate = newDate;
      });
      _clearMainFields();
      _loadData();
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timeOfDay != null) {
      final date = DateTime(0, 0, 0, timeOfDay.hour, timeOfDay.minute);
      controller.text = DateFormat('HH:mm').format(date);
    }
  }

  /// Main button press handler.
  Future<void> _onMainButtonPressed() async {
    if (!isToday || editingMode) {
      return _saveEntryForOlderDay();
    } else {
      if (isWorking) {
        return _stopWorking();
      } else {
        return _startWorking();
      }
    }
  }

  /// Calls POST /timeEntry/start.
  Future<void> _startWorking() async {
    setState(() => isLoading = true);
    try {
      await api.timeEntryStartPost(employeeId: employee!.id);
      isWorking = true;
      commentController.clear();
      _clearMainFields();
      await _loadData();
    } catch (e) {
      debugPrint('Error starting work: $e');
    }
    setState(() => isLoading = false);
  }

  /// Calls POST /timeEntry/stop.
  Future<void> _stopWorking() async {
    setState(() => isLoading = true);
    try {
      final comment = commentController.text.trim();
      await api.timeEntryStopPost(employeeId: employee!.id, comment: comment);
      isWorking = false;
      _clearMainFields();
      await _loadData();
    } catch (e) {
      debugPrint('Error stopping work: $e');
    }
    setState(() => isLoading = false);
  }

  /// For past dates or editing a finished entry, saves the entry.
  Future<void> _saveEntryForOlderDay() async {
    setState(() => isLoading = true);
    try {
      final startText = startTimeController.text.trim();
      final endText = endTimeController.text.trim();
      final comment = commentController.text.trim();
      final startDateTime = _combineDateAndTime(selectedDate, startText);
      final endDateTime = _combineDateAndTime(selectedDate, endText);

      if (_selectedEntry == null) {
        // CREATE (POST)
        await api.appEmployeesEmployeeIdTimeentriesPost(
          employee!.id!,
          timeEntryDto: TimeEntryDto(
            id: -1,
            employeeId: employee!.id,
            start: startDateTime,
            // Convert to UTC if your backend expects it
            end: endDateTime,
            comment: comment,
          ),
        );
      } else {
        // EDIT (PUT) ...
        await api.timeentriesIdPut(
          _selectedEntry!.id!,
          timeEntryDto: TimeEntryDto(
            id: _selectedEntry!.id,
            employeeId: employee!.id,
            start: startDateTime,
            end: endDateTime,
            comment: comment,
          ),
        );
      }
      _clearMainFields();
      await _loadData();
    } catch (e) {
      debugPrint('Error saving entry: $e');
    }
    setState(() => isLoading = false);
  }

  /// Creates a new empty entry.
  Future<void> _createEmptyEntry() async {
    setState(() {
      // Reset the working flag and clear any selection.
      isWorking = false;
      _clearMainFields();
      editingMode = false;
    });
    // Optionally, reload the data if needed.
    await _loadData();
  }

  /// Combines a date with a "HH:mm" string.
  DateTime _combineDateAndTime(DateTime date, String hhmm) {
    try {
      final parts = hhmm.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (_) {
      return date;
    }
  }

  /// When an entry is tapped, fill the fields and set editing mode if finished.
  void _selectEntry(TimeEntryDto entry) {
    _selectedEntry = entry;
    startTimeController.text = _formatTime(entry.start);
    endTimeController.text = _formatTime(entry.end);
    commentController.text = entry.comment ?? '';
    editingMode = entry.end != null;
    setState(() {});
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    // Convert from UTC to local if necessary:
    final local = dt.toLocal();
    return DateFormat('HH:mm').format(local);
  }

  /// Formats a DateTime as 'dd.MM.yyyy HH:mm' (German).
  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('dd.MM.yyyy HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('dd.MM.yyyy').format(selectedDate);
    final today = DateTime.now();
    final bool disableRightArrow =
        !selectedDate.isBefore(DateTime(today.year, today.month, today.day));
    return Scaffold(
      appBar: AppBar(title: const Text('Time Tracking')),
      // Add a FloatingActionButton to create a new empty entry.
      floatingActionButton: FloatingActionButton(
        onPressed: _createEmptyEntry,
        tooltip: 'Neue Zeiterfassung',
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Text(
                'Hallo, ${employee == null ? '' : employee!.firstName}',
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: _onLeftDate,
                  ),
                  TextButton(onPressed: _pickDate, child: Text(dateLabel)),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: disableRightArrow ? null : _onRightDate,
                  ),
                ],
              ),
              // Start and End fields on the same row.
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: startTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Startzeit',
                        ),
                        onTap:
                            canEditFields
                                ? () => _pickTime(startTimeController)
                                : null,
                        enabled: canEditFields,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: endTimeController,
                        decoration: const InputDecoration(labelText: 'Endzeit'),
                        onTap:
                            canEditFields
                                ? () => _pickTime(endTimeController)
                                : null,
                        enabled: canEditFields,
                      ),
                    ),
                  ),
                ],
              ),
              // Comment field.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(labelText: 'Kommentar'),
                  enabled: (buttonLabel != 'Kommen'),
                ),
              ),
              const SizedBox(height: 8),
              // Main action button.
              ElevatedButton(
                onPressed: isLoading ? null : _onMainButtonPressed,
                child: Text(buttonLabel),
              ),
              // List of time entries.
              Expanded(
                child: ListView.builder(
                  itemCount: timeEntries.length,
                  itemBuilder: (context, index) {
                    final entry = timeEntries[index];
                    final startStr = _formatDateTime(entry.start);
                    final endStr = _formatDateTime(entry.end);
                    final comment = entry.comment ?? '';
                    return ListTile(
                      title: Text('$startStr → $endStr'),
                      subtitle: Text(comment),
                      onTap: () => _selectEntry(entry),
                    );
                  },
                ),
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
