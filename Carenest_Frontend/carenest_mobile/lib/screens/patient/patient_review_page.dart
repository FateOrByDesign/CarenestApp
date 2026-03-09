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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && _bookingId == null) {
      _bookingId = args.toString();
      _fetchBookingDetails();
    } else if (args == null && _isLoading) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> _fetchBookingDetails() async {
    try {
      final data = await supabase
          .from('bookings')
          .select('*, caregiver_profiles(name), patient_profiles(name)')
          .eq('id', _bookingId!)
          .single();

      if (mounted) {
        setState(() {
          _bookingData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to load session details: $e"),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: AppTheme.bodyText.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTheme.bodyText),
          ),
        ],
      ),
    );
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
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Session Details ──
                      Text("Session Details", style: AppTheme.headingMedium),
                      const SizedBox(height: 12),
                      Card(
                        color: AppTheme.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                              color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              detailRow("Date",
                                  _bookingData!['date'] ?? "N/A"),
                              detailRow("Time",
                                  "${_bookingData!['start_time']} - ${_bookingData!['end_time'] ?? 'Ongoing'}"),
                              detailRow(
                                  "Caregiver",
                                  _bookingData!['caregiver_profiles']
                                          ?['name'] ??
                                      "Unknown"),
                              detailRow("Service",
                                  _bookingData!['service_type'] ?? "N/A"),
                              detailRow("Location",
                                  _bookingData!['location'] ?? "N/A"),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }
}
