import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _handleReset() {
    if (_formKey.currentState!.validate()) {
      // Simulate sending email
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reset link sent! Check your email."),
          backgroundColor: AppTheme.primary,
        ),
      );

      //Go back to login after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // --- HEADER ICON ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    size: 64,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 32),

                // Following the same style as LoginScreen for consistency
                Text(
                  "Forgot Password?",
                  textAlign: TextAlign.center,
                  style: AppTheme.headingLarge,
                ),
                const SizedBox(height: 12),
                // when user clicks on forgot password, they will be taken to this screen where they can enter their email to receive a reset link
                Text(
                  "Please enter the email associated with your account.",
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyText,
                ),
                const SizedBox(height: 40),

                // --- EMAIL INPUT ---
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email Address",
                    hintText: "example@email.com",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    // Reusing the same validation logic as LoginScreen for consistency
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      //If the email doesn't contain an "@" sign, it's not valid
                      return 'Invalid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // --- SEND BUTTON ---
                ElevatedButton(
                  onPressed: _handleReset,
                  child: const Text("Send Reset Link"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}