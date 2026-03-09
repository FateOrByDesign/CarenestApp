import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/app_theme.dart';
// 1. ADDED THE IMPORT HERE
import '../../widgets/caregiver_navigationbar_mobile.dart';

class CaregiverProfilePage extends StatefulWidget {
  const CaregiverProfilePage({super.key});

  @override
  State<CaregiverProfilePage> createState() => _CaregiverProfilePageState();
}

class _CaregiverProfilePageState extends State<CaregiverProfilePage> {
  final supabase = Supabase.instance.client;
  bool _isLoading = true;
  bool _isEditing = false;
  Map<String, dynamic>? _profile;
  List<Map<String, dynamic>> _reviews = [];

  // Edit controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _serviceAreaController = TextEditingController();
  final _aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _serviceAreaController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final uid = supabase.auth.currentUser!.id;

      final profile = await supabase
          .from('caregiver_profiles')
          .select()
          .eq('auth_id', uid)
          .single();

      final caregiverId = profile['id'];

      // Load reviews
      final reviews = await supabase
          .from('reviews')
          .select('*, patient_profiles(name)')
          .eq('caregiver_id', caregiverId)
          .order('created_at', ascending: false)
          .limit(5);

      if (mounted) {
        setState(() {
          _profile = profile;
          _reviews = List<Map<String, dynamic>>.from(reviews);
          _nameController.text = profile['name'] ?? '';
          _phoneController.text = profile['phone'] ?? '';
          _serviceAreaController.text = profile['service_area'] ?? '';
          _aboutController.text = profile['about'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    try {
      final uid = supabase.auth.currentUser!.id;

      await supabase.from('caregiver_profiles').update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'service_area': _serviceAreaController.text.trim(),
        'about': _aboutController.text.trim(),
      }).eq('auth_id', uid);

      if (mounted) {
        setState(() {
          _profile!['name'] = _nameController.text.trim();
          _profile!['phone'] = _phoneController.text.trim();
          _profile!['service_area'] = _serviceAreaController.text.trim();
          _profile!['about'] = _aboutController.text.trim();
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
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
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
        // 2. ADDED NAV BAR HERE
        bottomNavigationBar: CaregiverNavigationBarMobile(currentIndex: 2),
      );
    }

    if (_profile == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: Text('Profile not found')),
        // 3. ADDED NAV BAR HERE
        bottomNavigationBar: const CaregiverNavigationBarMobile(currentIndex: 2),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      // 4. ADDED NAV BAR TO THE MAIN UI HERE
      bottomNavigationBar: const CaregiverNavigationBarMobile(currentIndex: 2),
      body: const Center(child: Text('Profile page')),
    );
  }
}
