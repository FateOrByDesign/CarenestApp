import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import 'package:carenest_mobileapp/widgets/caregiver_navigationbar_mobile.dart';

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
  //bool isLoading = false;

  final List<String> statusList = ['In Progress', 'Completed'];

  void updateCareStatus() async {
    if (selectedStatus == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a status')));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Care status updated successfully')),
    );
    Navigator.pop(context);
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
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Update Care Status',
          style: AppTheme.headingMedium.copyWith(color: Colors.white),
        ),
        //centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // go back to previous screen
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppTheme.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 38,
                      color: AppTheme.textDark,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.patientName, style: AppTheme.headingLarge),
                        const SizedBox(height: 4),
                        Text(
                          'Visit ID: ${widget.visitId}',
                          style: AppTheme.bodyText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Care Status Card
            buildCard(
              icon: Icons.medical_services,
              title: 'Care Status',
              child: DropdownButtonFormField<String>(
                value: selectedStatus,
                hint: const Text('Select status'),
                items: statusList.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) => setState(() => selectedStatus = value),
                decoration: const InputDecoration(hintText: 'Select status'),
              ),
            ),

            const SizedBox(height: 30),

            //Care notes
            buildCard(
              icon: Icons.note_alt,
              title: 'Care Notes',
              child: TextFormField(
                controller: notesController,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Enter care notes...',
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
                onPressed: updateCareStatus,
                child: const Text('Update Status'),
              ),
            ),
          ],
        ),
      ),
      //New navigation bar
      bottomNavigationBar: const CaregiverNavigationBarMobile(currentIndex: 0),
    );
  }
}
