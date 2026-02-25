import 'package:flutter/material.dart';
import 'package:helloworld/screens/Dashboard.dart';
import '../auth/auth_service.dart';

class CaregiverAuthenticationPage extends StatefulWidget {
  final String username;
  final String password;

  const CaregiverAuthenticationPage({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  State<CaregiverAuthenticationPage> createState() =>
      _CaregiverAuthenticationPageState();
}

class _CaregiverAuthenticationPageState
    extends State<CaregiverAuthenticationPage> {
  bool isLoading = true;
  bool isSuccess = false;
  String caregiverName = "";
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    authenticate();
  }

  Future<void> authenticate() async {
    //call your AuthService(frontend mock)
    final result = await AuthService.login(widget.username, widget.password);

    setState(() {
      isLoading = false;
      isSuccess = result.success;
      caregiverName = result.caregiverName ?? "";
      errorMessage = result.message ?? "";
    });

    // If login succeeds, redirect to dashboard after short delay
    if (result.success) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                CaregiverDashboardPage(/*caregiverName: caregiverName*/),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    "Authenticating caregiver...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : isSuccess
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 80),
                  const SizedBox(height: 20),
                  Text(
                    "Welcome, $caregiverName",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Redirecting to dashboard...",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 80),
                  const SizedBox(height: 20),
                  Text(errorMessage, style: const TextStyle(color: Colors.red)),
                ],
              ),
      ),
    );
  }
}
