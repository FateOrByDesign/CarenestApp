import 'package:flutter/material.dart';
import 'package:carenest_mobile/core/app_theme.dart'; // ✅ Your existing AppTheme

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Caregiver Profile',
      theme: AppTheme.themeData, // ✅ Uses your AppTheme
      home: const CaregiverProfilePage(),
    );
  }
}

class CaregiverProfilePage extends StatelessWidget {
  const CaregiverProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primary, // ✅ AppTheme color
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {},
            ),
            actions: [
              IconButton(icon: const Icon(Icons.edit, color: Colors.white), onPressed: () {}),
              IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {}),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primary,     // ✅ AppTheme color
                      AppTheme.primaryDark, // ✅ AppTheme color
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Stack(
                      children: [
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
                            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                            ),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // ✅ AppTheme text style
                    const Text('Kavindu Rathnayake', style: AppTheme.headingLarge),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.verified, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'VERIFIED CAREGIVER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildQuickStat(Icons.star, '4.9'),
                        const SizedBox(width: 24),
                        _buildQuickStat(Icons.work, '3 Years'),
                        const SizedBox(width: 24),
                        _buildQuickStat(Icons.people, '45 Patients'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Body Content ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Stats Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('This Month', 'LKR 45k', Icons.account_balance_wallet, AppTheme.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard('Today\'s Visits', '2', Icons.event, Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // About
                  // ✅ AppTheme text style
                  const Text('About Me', style: AppTheme.headingMedium),
                  const SizedBox(height: 12),
                  _buildCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Experienced and compassionate caregiver with 3+ years of experience providing quality care to elderly and special needs patients. Specialized in diabetes management, post-surgery care, and daily living assistance.',
                        style: AppTheme.bodyText, // ✅ AppTheme text style
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Personal Information
                  const Text('Personal Information', style: AppTheme.headingMedium),
                  const SizedBox(height: 12),
                  _buildCard(
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.person,       'Full Name',      'Kavindu Rathnayake'),
                        _buildInfoRow(Icons.badge,        'License Number', 'CG-2021-7845'),
                        _buildInfoRow(Icons.phone,        'Phone',          '+94 77 123 4567'),
                        _buildInfoRow(Icons.email,        'Email',          'kavindu.r@healthcare.lk'),
                        _buildInfoRow(Icons.location_on,  'Service Area',   'Colombo District'),
                        _buildInfoRow(Icons.calendar_today,'Joined',        'January 2021'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Specializations
                  const Text('Specializations', style: AppTheme.headingMedium),
                  const SizedBox(height: 12),
                  _buildCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          'Diabetes Care',
                          'Elderly Care',
                          'Post-Surgery Care',
                          'Wound Dressing',
                          'Medication Management',
                          'Physical Therapy Support',
                        ].map((item) => _buildChip(item)).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Certifications
                  const Text('Certifications', style: AppTheme.headingMedium),
                  const SizedBox(height: 12),
                  _buildCertCard('Certified Nursing Assistant (CNA)', 'Sri Lanka Medical Council', 'Valid until Dec 2026', Icons.workspace_premium),
                  const SizedBox(height: 8),
                  _buildCertCard('First Aid & CPR', 'Red Cross Society', 'Valid until Jun 2025', Icons.medical_services),
                  const SizedBox(height: 8),
                  _buildCertCard('Diabetes Care Specialist', 'Healthcare Institute', 'Issued Jan 2023', Icons.health_and_safety),
                  const SizedBox(height: 24),

                  // Languages
                  const Text('Languages', style: AppTheme.headingMedium),
                  const SizedBox(height: 12),
                  _buildCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildLanguageRow('Sinhala', 'Native'),
                          const SizedBox(height: 12),
                          _buildLanguageRow('English', 'Fluent'),
                          const SizedBox(height: 12),
                          _buildLanguageRow('Tamil', 'Conversational'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Availability
                  const Text('Availability', style: AppTheme.headingMedium),
                  const SizedBox(height: 12),
                  _buildCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildAvailabilityRow('Monday - Friday', '8:00 AM - 6:00 PM', true),
                          const Divider(height: 24),
                          _buildAvailabilityRow('Saturday', '9:00 AM - 3:00 PM', true),
                          const Divider(height: 24),
                          _buildAvailabilityRow('Sunday', 'Not Available', false),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Performance Metrics
                  const Text('Performance Metrics', style: AppTheme.headingMedium),
                  const SizedBox(height: 12),
                  _buildCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildMetricRow('On-time Rate',        '98%',    0.98, Colors.green),
                          const SizedBox(height: 16),
                          _buildMetricRow('Completion Rate',     '100%',   1.0,  AppTheme.primary),
                          const SizedBox(height: 16),
                          _buildMetricRow('Patient Satisfaction','4.9/5.0',0.98, Colors.orange),
                          const SizedBox(height: 16),
                          _buildMetricRow('Response Time',       '< 5 min',0.95, Colors.blue),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reviews
                  const Text('Patient Reviews', style: AppTheme.headingMedium),
                  const SizedBox(height: 12),
                  _buildReviewCard('Mrs. K. Silva',   5, 'Jan 20, 2026', 'Excellent care and very professional. Kavindu is patient, kind, and always on time. Highly recommended!'),
                  const SizedBox(height: 8),
                  _buildReviewCard('Mr. R. Fernando', 5, 'Jan 15, 2026', 'Very knowledgeable about diabetes management. Helped me understand my condition better.'),
                  const SizedBox(height: 8),
                  _buildReviewCard('Mrs. A. Perera',  4, 'Jan 10, 2026', 'Great caregiver with good communication skills. Very satisfied with the service.'),
                  const SizedBox(height: 24),

                  // Documents
                  const Text('Documents', style: AppTheme.headingMedium),
                  const SizedBox(height: 12),
                  _buildDocumentCard('National ID',           Icons.credit_card),
                  const SizedBox(height: 8),
                  _buildDocumentCard('Medical License',       Icons.medical_information),
                  const SizedBox(height: 8),
                  _buildDocumentCard('Background Check',      Icons.verified_user),
                  const SizedBox(height: 8),
                  _buildDocumentCard('Insurance Certificate', Icons.security),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Bar ───────────────────────────────────────────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.message),
                  label: const Text('Message'),
                  // ✅ Auto-styled by AppTheme via ThemeData
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: const Text('Share Profile'),
                  // ✅ Auto-styled by AppTheme — Green, White text, Rounded corners
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helper Widgets ───────────────────────────────────────────────

  Widget _buildQuickStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  /// Generic white card wrapper
  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            // ✅ AppTheme text style
            Text(label, style: AppTheme.labelSmall),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight, // ✅ AppTheme color
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: AppTheme.primary), // ✅ AppTheme color
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTheme.labelSmall),   // ✅ AppTheme text style
                const SizedBox(height: 2),
                Text(value, style: AppTheme.bodyMedium),   // ✅ AppTheme text style
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1), // ✅ AppTheme color
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary, width: 1), // ✅ AppTheme color
      ),
      child: Text(label, style: AppTheme.chipText), // ✅ AppTheme text style
    );
  }

  Widget _buildCertCard(String name, String issuer, String validity, IconData icon) {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight, // ✅ AppTheme color
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppTheme.primary, size: 24), // ✅ AppTheme color
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,     style: AppTheme.bodyMedium),  // ✅ AppTheme text style
                  const SizedBox(height: 4),
                  Text(issuer,   style: AppTheme.bodySmall),   // ✅ AppTheme text style
                  const SizedBox(height: 2),
                  Text(validity, style: AppTheme.labelSmall),  // ✅ AppTheme text style
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageRow(String language, String proficiency) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight, // ✅ AppTheme color
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.language, size: 20, color: AppTheme.primary), // ✅ AppTheme color
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(language, style: AppTheme.bodyMedium)), // ✅ AppTheme text style
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,       // ✅ AppTheme color
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(proficiency, style: AppTheme.primaryLabel), // ✅ AppTheme text style
        ),
      ],
    );
  }

  Widget _buildAvailabilityRow(String day, String time, bool available) {
    return Row(
      children: [
        Icon(
          available ? Icons.check_circle : Icons.cancel,
          color: available ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(day,  style: AppTheme.bodyMedium)), // ✅ AppTheme text style
        Text(time, style: AppTheme.bodySmall),                   // ✅ AppTheme text style
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTheme.bodyMedium), // ✅ AppTheme text style
            Text(value, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(String name, int rating, String date, String review) {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primaryLight, // ✅ AppTheme color
                  child: Text(
                    name[0],
                    style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTheme.bodyMedium),  // ✅ AppTheme text style
                      const SizedBox(height: 2),
                      Text(date, style: AppTheme.labelSmall),  // ✅ AppTheme text style
                    ],
                  ),
                ),
                Row(
                  children: List.generate(5, (i) => Icon(
                    i < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  )),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(review, style: AppTheme.bodyText), // ✅ AppTheme text style
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentCard(String title, IconData icon) {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight, // ✅ AppTheme color
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primary, size: 24), // ✅ AppTheme color
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: AppTheme.bodyMedium)), // ✅ AppTheme text style
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.check_circle, size: 14, color: Colors.green),
                  SizedBox(width: 4),
                  Text(
                    'Verified',
                    style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}