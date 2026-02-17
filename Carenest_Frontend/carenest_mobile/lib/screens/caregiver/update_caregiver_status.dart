import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateCareStatusPage extends StatefulWidget {
  final int visitId;
  final String patientName;

  const UpdateCareStatusPage({
    Key? key,
    required this.visitId,
    required this.patientName,
  }) : super(key: key);

  @override
  State<UpdateCareStatusPage> createState() => _UpdateCareStatusPageState();
}

class _UpdateCareStatusPageState extends State<UpdateCareStatusPage> {
  String? selectedStatus;
  final TextEditingController notesController = TextEditingController();
  bool isLoading = false;

  final List<String> statusList = ['Pending', 'In Progress', 'Completed'];

  Future<void> updateCareStatus() async {
    if (selectedStatus == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a status')));
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse('http://YOUR_API_URL/api/visit/update-status');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'visit_id': widget.visitId,
        'status': selectedStatus,
        'care_notes': notesController.text,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Care status updated successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update status')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark,
        title: Text(
          'Update Care Status',
          style: AppTheme.headingMedium.copyWith(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // go back to previous screen
          },
        ),
      ),

      // centers the title
      //backgroundColor: Colors.white,

      // fill color for the top section
      // optional: shadow under AppBar
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info
            Center(
              child: SizedBox(
                width: 300, // decrease width (change value if needed)
                height: 120, // increase height
                child: Card(
                  elevation: 3, //shadow
                  color: AppTheme.softGreen, // backgroundd color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: ListTile(
                    /*contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),*/
                    leading: const Icon(Icons.person, size: 40),
                    title: Text(
                      widget.patientName,
                      style: AppTheme.headingMedium,
                    ),

                    subtitle: Text(
                      'Visit ID: ${widget.visitId}',
                      style: AppTheme.bodyText,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Status Dropdown
            Text('Care Status', style: AppTheme.headingMedium),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              hint: const Text('Select status'),
              items: statusList.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status, style: AppTheme.bodyText),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedStatus = value);
              },
              decoration: const InputDecoration(
                hintText: 'Select status',
                enabledBorder: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            Text('Care Notes', style: AppTheme.headingMedium),
            const SizedBox(height: 14),
            TextField(
              controller: notesController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Enter care notes...',
                enabledBorder: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // Update Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            onPressed: isLoading ? null : updateCareStatus,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text('Update Status'),
          ),
        ),
      ),
    );
  }
}
