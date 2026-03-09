import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'package:carenest_mobileapp/widgets/carereceiver_navigationbar_mobile.dart';

class RequestCarePage extends StatefulWidget {
  const RequestCarePage({Key? key}) : super(key: key);

  @override
  State<RequestCarePage> createState() => _RequestCarePageState();
}

class _RequestCarePageState extends State<RequestCarePage> {
  String? serviceType;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  //final TextEditingController durationController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final List<String> serviceTypes = ['Home care', 'Hospital Care'];

  //Date picker
  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  //Start time picker
  Future<void> pickStartTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => startTime = time);
    }
  }

  //End time picker
  Future<void> pickEndTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => endTime = time);
    }
  }

  //Toggle button used for Date and Time selection
  Widget buildDateTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return TextFormField(
      readOnly: true, // prevents keyboard from showing
      onTap: onTap, // open picker
      style: AppTheme.bodyText.copyWith(color: AppTheme.textDark),
      decoration: InputDecoration(
        hintText: value.isEmpty ? 'Select' : value, //New adding
        suffixIcon: icon != null ? Icon(icon, color: AppTheme.primary) : null,
      ),
      controller: TextEditingController(text: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Request Care',
          style: AppTheme.headingMedium.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(child: Text('Request care form')),
      bottomNavigationBar: const CareReceiverNavigationBarMobile(
        currentIndex: 1,
      ),
    );
  }
}
