import 'package:flutter/material.dart';

class PatientDetailsPage extends StatelessWidget {
  const PatientDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Patient Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Name: Mr. J. Perera'),
            Text('Age: 72'),
            Text('Condition: Post-surgery'),
            Text('Mobility: Low'),
            SizedBox(height: 20),
            Text(
              'Care Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('- Needs assistance while walking'),
            Text('- Medication twice a day'),
          ],
        ),
      ),
    );
  }
}
