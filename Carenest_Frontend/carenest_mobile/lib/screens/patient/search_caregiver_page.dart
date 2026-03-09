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
    try {
      final uid = supabase.auth.currentUser!.id;

      // Load patient's location
      final patient = await supabase
          .from('patient_profiles')
          .select('location')
          .eq('auth_id', uid)
          .single();

      final patientLocation = patient['location'] as String?;

      // Load all active caregivers (include gender in the select)
      final data = await supabase
          .from('caregiver_profiles')
          .select(
              'id, name, email, phone, gender, experience_years, total_patients, profile_image_url, service_area, verified, hourly_rate, reviews(rating)')
          .eq('status', 'Active');

      List<Map<String, dynamic>> processedCaregivers = [];

      for (var doc in data) {
        final caregiver = Map<String, dynamic>.from(doc);
        final reviews = caregiver['reviews'] as List<dynamic>? ?? [];

        double avgRating = 0.0;
        if (reviews.isNotEmpty) {
          double sum = 0;
          for (var r in reviews) {
            sum += (r['rating'] as num).toDouble();
          }
          avgRating = sum / reviews.length;
        }

        caregiver['calculated_rating'] = avgRating;
        caregiver['review_count'] = reviews.length;

        processedCaregivers.add(caregiver);
      }

      processedCaregivers.sort((a, b) => (b['calculated_rating'] as double)
          .compareTo(a['calculated_rating'] as double));

      if (mounted) {
        setState(() {
          _caregivers = processedCaregivers;
          _patientLocation = patientLocation;
          _selectedFilterLocation = patientLocation;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _caregivers = [];
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get filteredCaregivers {
    var list = _caregivers;

    // Filter by selected location
    if (_selectedFilterLocation != null &&
        _selectedFilterLocation!.isNotEmpty) {
      list = list
          .where((c) =>
              (c['service_area'] ?? '')
                  .toString()
                  .toLowerCase() ==
              _selectedFilterLocation!.toLowerCase())
          .toList();
    }

    // Filter by gender
    if (_selectedFilterGender != null &&
        _selectedFilterGender!.isNotEmpty) {
      list = list
          .where((c) =>
              (c['gender'] ?? '')
                  .toString()
                  .toLowerCase() ==
              _selectedFilterGender!.toLowerCase())
          .toList();
    }

    // Then filter by search text
    if (searchText.isNotEmpty) {
      list = list
          .where((c) =>
              (c['name'] ?? '')
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              (c['service_area'] ?? '')
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    }

    return list;
  }

  Widget buildSearchBar() {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Search caregiver...',
        prefixIcon: Icon(Icons.search, color: AppTheme.primary),
      ),
      onChanged: (value) {
        setState(() {
          searchText = value;
        });
      },
    );
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedFilterLocation != null) count++;
    if (_selectedFilterGender != null) count++;
    return count;
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
