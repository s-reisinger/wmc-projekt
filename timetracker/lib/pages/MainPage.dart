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

  /// Loads data
  Future<void> _loadData() async {
    if (employee == null) {
      context.go('/');
      return;
    }
    setState(() => isLoading = true);

    try {
      if (isToday) {
        isWorking = (await api.isWorkingGet(employeeId: employee!.id)) ?? false;
      } else {
        isWorking = false;
      }

      final adjustedDay = _shiftMidnightToUtc(selectedDate);
      timeEntries = (await api.employeesIdTimeentriesGet(
        employee!.id!,
        day: adjustedDay,
      )) ??
          [];

      if (isToday && isWorking) {
        if (_selectedEntry == null || _selectedEntry!.end == null) {
          try {
            final ongoing = timeEntries.firstWhere((e) => e.end == null);
            _selectEntry(ongoing);
          } catch (_) {}
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
    // If we only care about the date portion, strip out any hour/minute
    final localMidnight = DateTime(
      localDate.year,
      localDate.month,
      localDate.day,
    );
    // Add the timezone offset before converting to UTC
    return localMidnight.add(localMidnight.timeZoneOffset).toUtc();
  }

  void _onLeftDate() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
    });
    _clearMainFields();
    _loadData();
  }

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
            end: endDateTime,
            comment: comment,
          ),
        );
      } else {
        // EDIT (PUT)
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

  Future<void> _createEmptyEntry() async {
    setState(() {
      isWorking = false;
      _clearMainFields();
      editingMode = false;
    });
    await _loadData();
  }

  Future<void> _confirmDelete(TimeEntryDto entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eintrag löschen'),
        content: const Text('Möchten Sie diesen Eintrag wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Call the DELETE endpoint
      try {
        setState(() => isLoading = true);
        await api.timeentriesIdDelete(entry.id!);
        await _loadData();
      } catch (e) {
        debugPrint('Error deleting entry: $e');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _selectEntry(TimeEntryDto entry) {
    _selectedEntry = entry;
    startTimeController.text = _formatTime(entry.start);
    endTimeController.text = _formatTime(entry.end);
    commentController.text = entry.comment ?? '';
    editingMode = entry.end != null;
    setState(() {});
  }

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

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final local = dt.toLocal();
    return DateFormat('HH:mm').format(local);
  }

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
                style: const TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    onPressed: _onLeftDate,
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: Text(dateLabel),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: disableRightArrow ? null : _onRightDate,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: startTimeController,
                        decoration:
                        const InputDecoration(labelText: 'Startzeit'),
                        onTap: canEditFields
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
                        decoration:
                        const InputDecoration(labelText: 'Endzeit'),
                        onTap: canEditFields
                            ? () => _pickTime(endTimeController)
                            : null,
                        enabled: canEditFields,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(labelText: 'Kommentar'),
                  enabled: (buttonLabel != 'Kommen'),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: isLoading ? null : _onMainButtonPressed,
                child: Text(buttonLabel),
              ),
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
                      // If the entry is completed (end != null), show a delete icon
                      trailing: (entry.end != null)
                          ? IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDelete(entry),
                      )
                          : null,
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
