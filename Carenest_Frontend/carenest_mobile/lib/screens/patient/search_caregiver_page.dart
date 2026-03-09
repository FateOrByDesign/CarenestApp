import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/app_theme.dart';
import '../../core/locations.dart';
import '../../widgets/carereceiver_navigationbar_mobile.dart';

class CaregiverSearchPage extends StatefulWidget {
  const CaregiverSearchPage({super.key});

  @override
  State<CaregiverSearchPage> createState() => _CaregiverSearchPageState();
}

class _CaregiverSearchPageState extends State<CaregiverSearchPage> {
  final supabase = Supabase.instance.client;
  String searchText = '';
  String? expandedName;
  bool _isLoading = true;
  List<Map<String, dynamic>> _caregivers = [];
  String? _patientLocation;
  String? _selectedFilterLocation;
  String? _selectedFilterGender;

  final _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Find Caregiver',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary))
          : const Center(child: Text('Search page')),
      bottomNavigationBar:
          const CareReceiverNavigationBarMobile(currentIndex: 1),
    );
  }
}
