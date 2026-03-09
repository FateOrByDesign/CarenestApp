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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(child: Text('Update status form')),
      bottomNavigationBar: const CaregiverNavigationBarMobile(currentIndex: 0),
    );
  }
}
