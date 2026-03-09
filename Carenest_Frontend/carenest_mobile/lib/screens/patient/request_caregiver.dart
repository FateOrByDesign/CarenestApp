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
