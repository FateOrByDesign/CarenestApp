import 'package:flutter/material.dart';

class RequestCarePage extends StatefulWidget {
  const RequestCarePage({Key? key}) : super(key: key);

  @override
  State<RequestCarePage> createState() => _RequestCarePageState();
}

class _RequestCarePageState extends State<RequestCarePage> {
  String? serviceType;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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

  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  void submitRequest() {
    if (serviceType == null ||
        selectedDate == null ||
        selectedTime == null ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Care request submitted successfully')),
    );

    // Clear form after submission
    setState(() {
      serviceType = null;
      selectedDate = null;
      selectedTime = null;
      durationController.clear();
      locationController.clear();
      notesController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFA),
      appBar: AppBar(
        backgroundColor: Colors.green, // your Figma primary color
        elevation: 0, // removes shadow
        centerTitle: true, // title centered
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () {
            Navigator.pop(context); // go back
          },
        ),
        title: const Text(
          'Request Care',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Type
            const Text(
              'Service Type',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: serviceType,
              hint: const Text('Select service type'),
              items: serviceTypes.map((service) {
                return DropdownMenuItem(value: service, child: Text(service));
              }).toList(),
              onChanged: (value) => setState(() => serviceType = value),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.lightGreen, width: 2),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue, // focused border color
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Date & Time
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: pickDate,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: selectedDate == null
                          ? Colors.white
                          : Colors.lightGreen,
                      side: BorderSide(color: Colors.lightGreen, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      selectedDate == null
                          ? 'Select Date'
                          : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      style: TextStyle(
                        color: selectedDate == null
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 35),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: pickTime,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: selectedTime == null
                          ? Colors.white
                          : Colors.lightGreen,
                      side: BorderSide(color: Colors.lightGreen, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      selectedTime == null
                          ? 'Select Time'
                          : selectedTime!.format(context),
                      style: TextStyle(
                        color: selectedTime == null
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Duration
            const Text(
              'Duration',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: durationController,
              decoration: InputDecoration(
                hintText: 'e.g. 8 hours',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.green, // border color when not focused
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // border color when focused
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Location
            const Text(
              'Location',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'Home address or Hospital name',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.lightGreen, // normal border color
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue, // focused border color
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Notes
            const Text(
              'Additional Notes',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: notesController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Enter additional notes...',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.lightGreen, // normal border color
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue, // focused border color
                    width: 2,
                  ),
                ),
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
            onPressed: () {
              // navigate to Update Care Status page
              Navigator.pushNamed(context, '/update');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // <-- change your color here
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                // optional: rounded corners
              ),
            ),
            child: const Text(
              'Request Care',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
