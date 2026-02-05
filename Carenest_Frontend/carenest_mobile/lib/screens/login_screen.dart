import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passController = TextEditingController();

  // Mock Login Function to demonstrate the Exception Logic
  void _attemptLogin() {
    String password = _passController.text;

    // SIMULATED LOGIC: If password is empty or wrong
    if (password != "1234") {
      // Show the requested "Exception" Dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Login Failed"),
          content: const Text("Incorrect password. Do you need to reset it?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close box
              child: const Text("Try Again"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close box
                Navigator.pushNamed(context, '/reset_password'); // Go to Reset Page
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text("Reset Password"),
            ),
          ],
        ),
      );
    } else {
      // Success Logic (Navigate to Dashboard)
      print("Login Successful");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 80, color: Color(0xFF0056D2)),
            const SizedBox(height: 20),
            const Text("Welcome Back", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),

            // Email
            const TextField(decoration: InputDecoration(hintText: "Email", prefixIcon: Icon(Icons.email), border: OutlineInputBorder())),
            const SizedBox(height: 10),

            // Password
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(hintText: "Password (Try '1234' to pass)", prefixIcon: Icon(Icons.lock), border: OutlineInputBorder()),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _attemptLogin,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0056D2), foregroundColor: Colors.white),
                child: const Text("LOGIN"),
              ),
            ),

            const SizedBox(height: 20),

            // Register Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New to CareNest? "),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: const Text(
                    "Register Here",
                    style: TextStyle(color: Color(0xFF0056D2), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}