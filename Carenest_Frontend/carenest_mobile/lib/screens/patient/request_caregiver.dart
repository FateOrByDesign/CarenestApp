import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../caregiver/update_caregiver_status.dart';

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

  final TextEditingController durationController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  final List<String> serviceTypes = ['Home care', 'Hospital Care'];

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

  Future<void> pickStartTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => startTime = time);
    }
  }

  Future<void> pickEndTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => endTime = time);
    }
  }

  void submitRequest() {
    if (serviceType == null ||
        selectedDate == null ||
        startTime == null ||
        endTime == null ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // TEMP values (later replace with API response)
    final int visitId = 1;
    final String patientName = 'Test Patient';

    Navigator.push(
      //for conect next page through button
      context,
      MaterialPageRoute(
        builder: (context) =>
            UpdateCareStatusPage(visitId: visitId, patientName: patientName),
      ),
    );
  }

  Widget buildToggleButton({
    required VoidCallback onPressed,
    required String text,
    required IconData icon,
    bool isSelected = false,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: AppTheme.primary),
      label: Text(
        text,
        style: AppTheme.bodyText.copyWith(color: AppTheme.textDark),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: AppTheme.surface,
        side: BorderSide(
          color: isSelected
              ? AppTheme
                    .primary // ✅ green when selected
              : Colors.grey.withOpacity(0.3), // idle border
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFA),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark, // your Figma primary color
        elevation: 0, // removes shadow
        centerTitle: true, // title centered
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () {
            Navigator.pop(context); // go back
          },
        ),
        title: Text(
          'Request Care',
          style: AppTheme.headingMedium.copyWith(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Type
            Text('Service Type', style: AppTheme.headingMedium),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: serviceType,
              hint: const Text('Select service type'),
              items: serviceTypes.map((service) {
                return DropdownMenuItem(value: service, child: Text(service));
              }).toList(),
              onChanged: (value) => setState(() => serviceType = value),
              decoration: const InputDecoration(
                hintText: 'Select service type',
                enabledBorder: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // Date
            Text('Select Date', style: AppTheme.headingMedium),
            const SizedBox(height: 14),
            buildToggleButton(
              onPressed: pickDate,
              text: selectedDate == null
                  ? 'Select Date'
                  : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
              icon: Icons.calendar_today,
              isSelected: selectedDate != null,
            ),

            const SizedBox(height: 30),

            // Start & End Time
            Text('Select Time', style: AppTheme.headingMedium),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: buildToggleButton(
                    onPressed: pickStartTime,
                    text: startTime == null
                        ? 'Start Time'
                        : startTime!.format(context),
                    icon: Icons.access_time,
                    isSelected: startTime != null,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: buildToggleButton(
                    onPressed: pickEndTime,
                    text: endTime == null
                        ? 'End Time'
                        : endTime!.format(context),
                    icon: Icons.access_time,
                    isSelected: endTime != null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Location
            Text('Location', style: AppTheme.headingMedium),
            const SizedBox(height: 14),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'Home address or Hospital name',
              ),
            ),

            const SizedBox(height: 30),

            // Notes
            Text('Additional Notes', style: AppTheme.headingMedium),

            const SizedBox(height: 14),
            TextFormField(
              controller: notesController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Enter care status',
                enabledBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),

      // Submit Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: submitRequest,
            child: const Text('Request Care'),
          ),
        ),
      ),
    );
  }
}
