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
      title: 'Schedule Page',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const SchedulePage(),
    );
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF38B2AC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Schedule',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: const Color(0xFF38B2AC),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Daily'),
                Tab(text: 'Weekly'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDailySchedule(),
          _buildWeeklySchedule(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF38B2AC),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Visit',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildDailySchedule() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Date selector
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 7,
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index - 3));
                  final isSelected = index == 3;
                  return _buildDateCard(date, isSelected);
                },
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF38B2AC), Color(0xFF2C7A7B)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem('Total Visits', '5', Icons.event),
                      Container(width: 1, height: 40, color: Colors.white38),
                      _buildSummaryItem('Completed', '2', Icons.check_circle),
                      Container(width: 1, height: 40, color: Colors.white38),
                      _buildSummaryItem('Pending', '3', Icons.pending),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Morning section
                _buildTimeSection('Morning', '8:00 AM - 12:00 PM'),
                const SizedBox(height: 12),
                _buildVisitCard(
                  'Mr. J. Perera',
                  'Colombo 06',
                  '8:00 AM - 9:00 AM',
                  '3.5 km away',
                  'completed',
                  'General checkup and medication review',
                ),
                const SizedBox(height: 8),
                _buildVisitCard(
                  'Mrs. K. Silva',
                  'Colombo 03',
                  '10:00 AM - 11:00 AM',
                  '5.2 km away',
                  'completed',
                  'Post-surgery care and wound dressing',
                ),
                const SizedBox(height: 24),

                // Afternoon section
                _buildTimeSection('Afternoon', '12:00 PM - 5:00 PM'),
                const SizedBox(height: 12),
                _buildVisitCard(
                  'Mr. R. Fernando',
                  'Colombo 04',
                  '2:00 PM - 3:00 PM',
                  '2.8 km away',
                  'upcoming',
                  'Diabetes management and insulin check',
                ),
                const SizedBox(height: 8),
                _buildVisitCard(
                  'Mrs. A. Dissanayake',
                  'Colombo 05',
                  '4:00 PM - 5:00 PM',
                  '4.1 km away',
                  'upcoming',
                  'Physical therapy session',
                ),
                const SizedBox(height: 24),

                // Evening section
                _buildTimeSection('Evening', '5:00 PM - 8:00 PM'),
                const SizedBox(height: 12),
                _buildVisitCard(
                  'Mr. S. Wickramasinghe',
                  'Colombo 07',
                  '6:00 PM - 7:00 PM',
                  '6.5 km away',
                  'upcoming',
                  'Blood pressure monitoring',
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySchedule() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildWeekDayCard('Monday, Feb 8', 5, 3, 2),
        const SizedBox(height: 12),
        _buildWeekDayCard('Tuesday, Feb 9', 4, 0, 4),
        const SizedBox(height: 12),
        _buildWeekDayCard('Wednesday, Feb 10', 6, 0, 6),
        const SizedBox(height: 12),
        _buildWeekDayCard('Thursday, Feb 11', 3, 0, 3),
        const SizedBox(height: 12),
        _buildWeekDayCard('Friday, Feb 12', 7, 0, 7),
        const SizedBox(height: 12),
        _buildWeekDayCard('Saturday, Feb 13', 2, 0, 2),
        const SizedBox(height: 12),
        _buildWeekDayCard('Sunday, Feb 14', 0, 0, 0),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildDateCard(DateTime date, bool isSelected) {
    final dayName = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = date;
        });
      },
      child: Container(
        width: 60,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF38B2AC) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF38B2AC) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 2),
            if (date.day == DateTime.now().day)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFF38B2AC),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection(String title, String time) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF38B2AC),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          time,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildVisitCard(
    String patientName,
    String location,
    String time,
    String distance,
    String status,
    String description,
  ) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'completed':
        statusColor = Colors.green;
        statusText = 'Completed';
        statusIcon = Icons.check_circle;
        break;
      case 'upcoming':
        statusColor = Colors.orange;
        statusText = 'Upcoming';
        statusIcon = Icons.schedule;
        break;
      case 'in_progress':
        statusColor = Colors.blue;
        statusText = 'In Progress';
        statusIcon = Icons.play_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Pending';
        statusIcon = Icons.pending;
    }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FFFA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF38B2AC),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.directions_walk, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[700]),
                const SizedBox(width: 6),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text('Navigate'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF38B2AC),
                    side: const BorderSide(color: Color(0xFF38B2AC)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: Text(status == 'completed' ? 'View' : 'Start Visit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B2AC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDayCard(String day, int totalVisits, int completed, int pending) {
    final hasVisits = totalVisits > 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasVisits ? const Color(0xFF38B2AC) : Colors.grey[200]!,
          width: hasVisits ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: hasVisits ? const Color(0xFF38B2AC) : Colors.grey[400],
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: hasVisits ? const Color(0xFF2D3748) : Colors.grey[600],
                  ),
                ),
              ),
              if (hasVisits)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6FFFA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalVisits visits',
                    style: const TextStyle(
                      color: Color(0xFF38B2AC),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          if (hasVisits) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                _buildWeekStatChip('Completed', completed, Colors.green),
                const SizedBox(width: 8),
                _buildWeekStatChip('Pending', pending, Colors.orange),
              ],
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _tabController.index = 0;
                });
              },
              icon: const Icon(Icons.visibility, size: 16),
              label: const Text('View Schedule'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF38B2AC),
                padding: EdgeInsets.zero,
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'No visits scheduled',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeekStatChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF38B2AC),
              onPrimary: Colors.white,
              onSurface: Color(0xFF2D3748),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}