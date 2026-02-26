import 'package:flutter/material.dart';
import 'package:carenest_mobileapp/screens/caregiver/caregiver_dashboard_page.dart';
import '../../auth/auth_service.dart';
import 'package:carenest_mobileapp/core/app_theme.dart';
import 'package:carenest_mobileapp/screens/patient/request_caregiver.dart'; // adjust path if needed
import 'dart:ui';

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

    if (!mounted) return;

    setState(() {
      isLoading = false;
      isSuccess = result.success;
      caregiverName = result.caregiverName ?? "";
      errorMessage = result.message ?? "";
    });

    // If login succeeds, redirect to dashboard after short delay
    if (result.success) {
      Future.delayed(const Duration(seconds: 4), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                CaregiverDashboardPage(/*caregiverName: caregiverName*/),
          ),
        );
      });
    } else {
      //Redirect to login after 3 seconds if failed
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const RequestCarePage(), // change to your login page name
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
            : Stack(
                children: [
                  // Background Care Page
                  const RequestCarePage(),

                  // Blur Effect
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(color: Colors.black.withOpacity(0.2)),
                  ),

                  // Centered Error Box
                  Center(
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 20,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppTheme.error,
                            size: 80,
                          ),
                          const SizedBox(height: 20),

                          Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: AppTheme.headingMedium.copyWith(
                              color: AppTheme.error,
                            ),
                          ),

                          const SizedBox(height: 25),

                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RequestCarePage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.error,
                            ),
                            child: const Text("Try Again"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
