import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timetracker/MyFlutterApiClient/lib/api.dart';
import 'package:timetracker/services/SharedService.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late AppApi api;

  // Chosen date range (default: from 7 days ago to now).
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime toDate = DateTime.now();

  // This will store the list returned by your endpoint (daily hours).
  List<TotalDayTimeEntryDto> dailyHoursList = [];

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    final client = ApiClient(basePath: SharedService.basePath);
    api = AppApi(client);
    // Load data for the last 7 days automatically.
    _fetchData();
  }

  /// Calls GET /employees/{id}/totalHours, passing ?from= & ?to=
  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await api.employeesIdTotalHoursGet(
        SharedService.loggedInUser!.id!,
        from: fromDate,
        to: toDate,
      );

      setState(() {
        dailyHoursList = result ?? [];
      });
    } catch (err) {
      setState(() {
        errorMessage = 'Error: $err';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Opens a date picker for either fromDate or toDate, then fetches data.
  Future<void> _pickDate({required bool isFrom}) async {
    final initialDate = isFrom ? fromDate : toDate;
    final firstDate = DateTime.now().subtract(const Duration(days: 365));
    final lastDate = DateTime.now().add(const Duration(days: 365));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      // If you want the German month/day names in the picker:
      locale: const Locale('de', 'DE'),
    );

    if (picked != null) {
      setState(() {
        if (isFrom) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
      // Automatically fetch new data whenever a date is chosen
      _fetchData();
    }
  }

  /// Compute a total across all returned items
  double get totalHours {
    return dailyHoursList.fold(0.0, (sum, item) => sum + (item.hours ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    // German format, e.g. "31.03.2025"
    final dateFormatter = DateFormat('dd.MM.yyyy');

    final fromText = dateFormatter.format(fromDate);
    final toText = dateFormatter.format(toDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arbeitsstunden Übersicht'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Show any errors
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Row of 2 date pickers
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => _pickDate(isFrom: true),
                    child: Text('Von: $fromText'),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () => _pickDate(isFrom: false),
                    child: Text('Bis: $toText'),
                  ),
                ],
              ),

              // Show total hours for the selected range
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Gesamt: ${totalHours.toStringAsFixed(2)} Stunden',
                  style: const TextStyle(fontSize: 16),
                ),
              ),

              // Expand to show the list of daily items
              Expanded(
                child: ListView.builder(
                  itemCount: dailyHoursList.length,
                  itemBuilder: (context, index) {
                    final item = dailyHoursList[index];
                    // If the date is UTC in the DTO, convert it to local if needed.
                    final localDate = item.date?.toLocal() ?? DateTime.now();
                    final dateStr = dateFormatter.format(localDate);
                    final hours = item.hours?.toStringAsFixed(2) ?? '0.00';

                    return ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(dateStr),
                      subtitle: Text('$hours Stunden'),
                    );
                  },
                ),
              ),
            ],
          ),

          // Loading overlay
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
