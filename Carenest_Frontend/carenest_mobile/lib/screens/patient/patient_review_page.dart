import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/app_theme.dart';
import '../../widgets/carereceiver_navigationbar_mobile.dart';

class PatientReviewPage extends StatefulWidget {
  const PatientReviewPage({super.key});

  @override
  State<PatientReviewPage> createState() => _PatientReviewPageState();
}

class _PatientReviewPageState extends State<PatientReviewPage> {
  final supabase = Supabase.instance.client;

  int rating = 0;
  int onTimeRating = 0;
  int responseRating = 0;
  final TextEditingController commentController = TextEditingController();

  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _bookingId;
  Map<String, dynamic>? _bookingData;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          "Caregiver Review",
          style: AppTheme.headingMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBar:
          const CareReceiverNavigationBarMobile(currentIndex: 1),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary))
          : _bookingData == null
              ? const Center(child: Text("Booking details not found."))
              : const Center(child: Text("Review page")),
    );
  }
}
