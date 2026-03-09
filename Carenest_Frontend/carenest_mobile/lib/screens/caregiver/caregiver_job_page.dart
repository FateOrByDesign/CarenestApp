import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/app_theme.dart';
import '../../../widgets/caregiver_navigationbar_mobile.dart';

class CaregiverJobRequestsPage extends StatefulWidget {
  const CaregiverJobRequestsPage({super.key});

  @override
  State<CaregiverJobRequestsPage> createState() =>
      _CaregiverJobRequestsPageState();
}

class _CaregiverJobRequestsPageState extends State<CaregiverJobRequestsPage> {
  final supabase = Supabase.instance.client;

  bool _isLoading = true;
  List<Map<String, dynamic>> requests = [];

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    try {
      final uid = supabase.auth.currentUser!.id;

      // 1. Get the caregiver's profile ID
      final profile = await supabase
          .from('caregiver_profiles')
          .select('id')
          .eq('auth_id', uid)
          .single();

      final caregiverId = profile['id'];

      // 2. Fetch pending bookings and join with patient_profiles
      final data = await supabase
          .from('bookings')
          .select('*, patient_profiles(name, age, address)')
          .eq('caregiver_id', caregiverId)
          .eq('status', 'Pending')
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          requests = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading requests: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _sendNotificationToPatient(
      Map<String, dynamic> booking, String title, String description) async {
    try {
      final patientId = booking['patient_id'];
      final patient = await supabase
          .from('patient_profiles')
          .select('auth_id')
          .eq('id', patientId)
          .single();

      final now = DateTime.now();
      await supabase.from('notifications').insert({
        'user_auth_id': patient['auth_id'],
        'title': title,
        'description': description,
        'type': 'booking',
        'related_booking': booking['id'],
        'date':
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        'time':
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00',
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          "Job Requests",
          style: AppTheme.headingMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppTheme.primary,
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : requests.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "No pending requests right now.",
              style: AppTheme.bodyText.copyWith(fontSize: 16),
            ),
          ],
        ),
      )
          : const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Loading requests...')),
      ),
      bottomNavigationBar: const CaregiverNavigationBarMobile(currentIndex: 1),
    );
  }
}
