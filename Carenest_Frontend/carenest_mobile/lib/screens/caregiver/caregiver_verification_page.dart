import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/app_theme.dart';

enum VerificationState { upload, submitting, pending, rejected }

class CaregiverVerificationPage extends StatefulWidget {
  final int caregiverId;
  final String? applicationStatus;

  const CaregiverVerificationPage({
    super.key,
    required this.caregiverId,
    this.applicationStatus,
  });

  @override
  State<CaregiverVerificationPage> createState() =>
      _CaregiverVerificationPageState();
}

class _CaregiverVerificationPageState
    extends State<CaregiverVerificationPage> {
  final supabase = Supabase.instance.client;
  late VerificationState _currentState;

  PlatformFile? _nicFrontFile;
  PlatformFile? _nicBackFile;
  PlatformFile? _policeReportFile;

  bool _isUploading = false;
  bool _isCheckingStatus = false;
  String? _rejectionReason;

  @override
  void initState() {
    super.initState();
    if (widget.applicationStatus == 'Pending') {
      _currentState = VerificationState.pending;
    } else if (widget.applicationStatus == 'Rejected') {
      _currentState = VerificationState.rejected;
      _loadRejectionReason();
    } else {
      _currentState = VerificationState.upload;
    }
  }

  /// Check if the caregiver has been approved and navigate accordingly
  Future<void> _checkVerificationStatus() async {
    setState(() => _isCheckingStatus = true);

    try {
      // Check caregiver_profiles.verified
      final profile = await supabase
          .from('caregiver_profiles')
          .select('verified')
          .eq('id', widget.caregiverId)
          .maybeSingle();

      if (profile != null && profile['verified'] == true) {
        // Caregiver is now verified — go to dashboard!
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your account has been verified! Welcome!'),
              backgroundColor: AppTheme.primary,
            ),
          );
          Navigator.pushNamedAndRemoveUntil(
              context, '/caregiver_dashboard', (route) => false);
        }
        return;
      }

      // Check application status for rejection
      final app = await supabase
          .from('caregiver_applications')
          .select('status, rejection_reason')
          .eq('caregiver_id', widget.caregiverId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (mounted && app != null) {
        if (app['status'] == 'Approved') {
          // Application approved but profile not yet updated — navigate anyway
          Navigator.pushNamedAndRemoveUntil(
              context, '/caregiver_dashboard', (route) => false);
          return;
        } else if (app['status'] == 'Rejected') {
          setState(() {
            _currentState = VerificationState.rejected;
            _rejectionReason = app['rejection_reason'];
            _isCheckingStatus = false;
          });
          return;
        }
      }

      // Still pending
      if (mounted) {
        setState(() => _isCheckingStatus = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your application is still under review'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCheckingStatus = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error checking status: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  Future<void> _loadRejectionReason() async {
    try {
      final app = await supabase
          .from('caregiver_applications')
          .select('rejection_reason')
          .eq('caregiver_id', widget.caregiverId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (mounted && app != null) {
        setState(() {
          _rejectionReason = app['rejection_reason'];
        });
      }
    } catch (_) {}
  }

  Future<void> _handleLogout() async {
    await supabase.auth.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
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
          'Verification',
          style: AppTheme.headingMedium.copyWith(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: const Center(child: Text('Verification page')),
    );
  }
}
