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

  final TextEditingController durationController = TextEditingController();
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

  //Submit request
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

    // Placeholder for API call
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Request submitted!')));
  }

  Widget buildCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Card(
      color: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primary, size: 28),
                const SizedBox(width: 12),
                Text(title, style: AppTheme.headingMedium),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      //currentIndex: CareReceiverNavigationBarMobile.findCareIndex,
      //child: Scaffold(
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Service Type
            buildCard(
              icon: Icons.medical_services,
              title: 'Service Type',
              child: DropdownButtonFormField<String>(
                value: serviceType,
                hint: const Text('Select service type'),
                items: serviceTypes
                    .map(
                      (service) => DropdownMenuItem(
                        value: service,
                        child: Text(service),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => serviceType = value),
                decoration: const InputDecoration(hintText: 'Select status'),
              ),
            ),
            const SizedBox(height: 16),

            //Date
            buildCard(
              icon: Icons.calendar_today,
              title: 'Select Date',
              child: buildDateTimeField(
                label: 'Select Date',
                value: selectedDate == null
                    ? 'Select Date'
                    : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                icon: Icons.calendar_today,
                onTap: pickDate,
              ),
            ),
            const SizedBox(height: 16),

            //Time
            buildCard(
              icon: Icons.access_time,
              title: 'Select Time',
              child: Row(
                children: [
                  Expanded(
                    child: buildDateTimeField(
                      label: 'Start Time',
                      value: startTime == null
                          ? ''
                          : startTime!.format(context),
                      onTap: pickStartTime,
                      icon: Icons.access_time,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: buildDateTimeField(
                      label: 'End Time',
                      value: endTime == null ? '' : endTime!.format(context),
                      onTap: pickEndTime,
                      icon: Icons.access_time,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Location Card
            buildCard(
              icon: Icons.location_on,
              title: 'Location',
              //child: Column(
              child: TextFormField(
                controller: locationController,
                decoration: const InputDecoration(hintText: 'Enter location'),
              ),
            ),

            const SizedBox(height: 16),

            // Notes Card
            buildCard(
              icon: Icons.note_alt,
              title: 'Additional Notes',
              child: TextFormField(
                controller: notesController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter additional notes',
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Request Care Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
                onPressed: submitRequest,
                child: const Text('Request Care'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),

      //New navigation bar
      bottomNavigationBar: const CareReceiverNavigationBarMobile(
        currentIndex: 1,
      ),
    );
  }
}
