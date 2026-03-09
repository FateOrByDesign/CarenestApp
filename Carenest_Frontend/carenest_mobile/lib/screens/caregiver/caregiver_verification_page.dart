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

  Future<void> _pickFile(String documentType) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final file = result.files.single;

      // Validate file size (max 5MB)
      if (file.size > 5 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File must be under 5MB'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
        return;
      }

      setState(() {
        switch (documentType) {
          case 'nic_front':
            _nicFrontFile = file;
            break;
          case 'nic_back':
            _nicBackFile = file;
            break;
          case 'police_report':
            _policeReportFile = file;
            break;
        }
      });
    }
  }

  Future<String> _uploadFile(
      PlatformFile file, String docType, int caregiverId) async {
    final fileExt = file.extension ?? 'jpg';
    final filePath =
        'caregiver_$caregiverId/${docType}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';

    await supabase.storage.from('documents').uploadBinary(
      filePath,
      file.bytes!,
      fileOptions: const FileOptions(upsert: true),
    );

    final publicUrl =
        supabase.storage.from('documents').getPublicUrl(filePath);

    return publicUrl;
  }

  Future<void> _submitDocuments() async {
    if (_nicFrontFile == null ||
        _nicBackFile == null ||
        _policeReportFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload all 3 documents'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _currentState = VerificationState.submitting;
    });

    try {
      final caregiverId = widget.caregiverId;

      // Upload files to Supabase Storage
      final nicFrontUrl =
          await _uploadFile(_nicFrontFile!, 'nic_front', caregiverId);
      final nicBackUrl =
          await _uploadFile(_nicBackFile!, 'nic_back', caregiverId);
      final policeReportUrl =
          await _uploadFile(_policeReportFile!, 'police_report', caregiverId);

      // Get caregiver profile data
      final profile = await supabase
          .from('caregiver_profiles')
          .select('name, email, phone, nic')
          .eq('id', caregiverId)
          .single();

      // Delete any previous rejected application for this caregiver
      await supabase
          .from('caregiver_applications')
          .delete()
          .eq('caregiver_id', caregiverId);

      // Insert new application
      await supabase.from('caregiver_applications').insert({
        'caregiver_id': caregiverId,
        'name': profile['name'],
        'email': profile['email'],
        'phone': profile['phone'],
        'nic': profile['nic'],
        'submitted_date': DateTime.now().toIso8601String().split('T')[0],
        'status': 'Pending',
        'doc_nic_front': nicFrontUrl,
        'doc_nic_back': nicBackUrl,
        'doc_certificate': policeReportUrl,
      });

      // Also insert into caregiver_documents
      await supabase.from('caregiver_documents').insert([
        {
          'caregiver_id': caregiverId,
          'type': 'nic_front',
          'document_url': nicFrontUrl
        },
        {
          'caregiver_id': caregiverId,
          'type': 'nic_back',
          'document_url': nicBackUrl
        },
        {
          'caregiver_id': caregiverId,
          'type': 'police_report',
          'document_url': policeReportUrl
        },
      ]);

      if (mounted) {
        setState(() {
          _currentState = VerificationState.pending;
          _isUploading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentState = VerificationState.upload;
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
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
