import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Patient Profile',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const PatientProfilePage(),
    );
  }
}

class PatientProfilePage extends StatelessWidget {
  const PatientProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with patient header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF38B2AC),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {},
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF38B2AC),
                      Color(0xFF2C7A7B),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Mr. J. Perera',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Patient ID: #PT12345',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildQuickStat(Icons.calendar_today, '45 years'),
                        const SizedBox(width: 24),
                        _buildQuickStat(Icons.transgender, 'Male'),
                        const SizedBox(width: 24),
                        _buildQuickStat(Icons.bloodtype, 'O+'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF38B2AC),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.message),
                          label: const Text('Message'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF38B2AC),
                            side: const BorderSide(
                              color: Color(0xFF38B2AC),
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Personal Information
                  _buildSectionTitle('Personal Information'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(Icons.person, 'Full Name', 'Jayantha Perera'),
                    _buildInfoRow(Icons.cake, 'Date of Birth', 'January 15, 1979'),
                    _buildInfoRow(Icons.phone, 'Phone', '+94 77 123 4567'),
                    _buildInfoRow(Icons.email, 'Email', 'j.perera@email.com'),
                    _buildInfoRow(Icons.location_on, 'Address', 'No. 45, Galle Road, Colombo 06'),
                  ]),
                  const SizedBox(height: 24),

                  // Medical Information
                  _buildSectionTitle('Medical Information'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(Icons.bloodtype, 'Blood Type', 'O Positive'),
                    _buildInfoRow(Icons.height, 'Height', '172 cm'),
                    _buildInfoRow(Icons.monitor_weight, 'Weight', '75 kg'),
                    _buildInfoRow(Icons.favorite, 'BMI', '25.4 (Overweight)'),
                  ]),
                  const SizedBox(height: 24),

                  // Allergies
                  _buildSectionTitle('Allergies'),
                  const SizedBox(height: 12),
                  _buildChipList([
                    'Penicillin',
                    'Peanuts',
                    'Latex',
                  ], Colors.red),
                  const SizedBox(height: 24),

                  // Current Medications
                  _buildSectionTitle('Current Medications'),
                  const SizedBox(height: 12),
                  _buildMedicationCard('Metformin', '500mg', 'Twice daily', Colors.blue),
                  const SizedBox(height: 8),
                  _buildMedicationCard('Lisinopril', '10mg', 'Once daily', Colors.orange),
                  const SizedBox(height: 8),
                  _buildMedicationCard('Aspirin', '81mg', 'Once daily', Colors.purple),
                  const SizedBox(height: 24),

                  // Medical Conditions
                  _buildSectionTitle('Medical Conditions'),
                  const SizedBox(height: 12),
                  _buildChipList([
                    'Type 2 Diabetes',
                    'Hypertension',
                    'High Cholesterol',
                  ], const Color(0xFF38B2AC)),
                  const SizedBox(height: 24),

                  // Emergency Contact
                  _buildSectionTitle('Emergency Contact'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(Icons.person, 'Name', 'Nimal Perera (Brother)'),
                    _buildInfoRow(Icons.phone, 'Phone', '+94 77 987 6543'),
                    _buildInfoRow(Icons.phone, 'Relationship', 'Brother'),
                  ]),
                  const SizedBox(height: 24),

                  // Insurance Information
                  _buildSectionTitle('Insurance Information'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(Icons.business, 'Provider', 'AIA Insurance'),
                    _buildInfoRow(Icons.credit_card, 'Policy Number', 'AIA-2024-12345'),
                    _buildInfoRow(Icons.event, 'Valid Until', 'December 31, 2024'),
                  ]),
                  const SizedBox(height: 24),

                  // Recent Visits
                  _buildSectionTitle('Recent Visits'),
                  const SizedBox(height: 12),
                  _buildVisitCard(
                    'General Checkup',
                    'Dr. Silva',
                    'Jan 15, 2026',
                    'Routine examination - All normal',
                  ),
                  const SizedBox(height: 8),
                  _buildVisitCard(
                    'Follow-up - Diabetes',
                    'Dr. Fernando',
                    'Dec 20, 2025',
                    'Blood sugar levels stable',
                  ),
                  const SizedBox(height: 8),
                  _buildVisitCard(
                    'Blood Pressure Check',
                    'Nurse Kamala',
                    'Nov 10, 2025',
                    'BP: 135/85 mmHg',
                  ),
                  const SizedBox(height: 24),

                  // Documents
                  _buildSectionTitle('Medical Documents'),
                  const SizedBox(height: 12),
                  _buildDocumentCard('Lab Results - Blood Test', 'Jan 15, 2026', Icons.description),
                  const SizedBox(height: 8),
                  _buildDocumentCard('X-Ray - Chest', 'Dec 20, 2025', Icons.image),
                  const SizedBox(height: 8),
                  _buildDocumentCard('Prescription', 'Dec 20, 2025', Icons.medical_services),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE6FFFA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFF38B2AC),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipList(List<String> items, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items.map((item) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.warning_amber, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  item,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMedicationCard(String name, String dosage, String frequency, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.medication,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$dosage • $frequency',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Active',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisitCard(String title, String doctor, String date, String notes) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                doctor,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            notes,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(String title, String date, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6FFFA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF38B2AC),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            color: const Color(0xFF38B2AC),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}