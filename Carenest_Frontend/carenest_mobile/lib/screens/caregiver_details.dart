import 'package:flutter/material.dart';

class CaregiverDetailsPage extends StatelessWidget {
  const CaregiverDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caregiver Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Caregiver Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Name: Kavindu Silva'),
            Text('Experience: 3 years'),
            Text('Specialization: Elder care'),
            SizedBox(height: 20),
            Text(
              'Contact Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Phone: 077-1234567'),
            Text('Email: kavindu@carenest.lk'),
          ],
        ),
      ),
    );
  }
}
