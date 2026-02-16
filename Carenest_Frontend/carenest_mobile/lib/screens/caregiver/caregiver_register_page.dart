import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class RegisterCaregiverScreen extends StatefulWidget {
  const RegisterCaregiverScreen({super.key});

  @override
  State<RegisterCaregiverScreen> createState() => _RegisterCaregiverScreenState();
}

class _RegisterCaregiverScreenState extends State<RegisterCaregiverScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

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
        title: Text("Caregiver Sign Up", style: AppTheme.headingMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Join our team of professionals.", textAlign: TextAlign.center),
                const SizedBox(height: 30),

                // Full name field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  //Validation: A simple non-empty check, can be expanded to more complex validation
                  validator: (v) => v!.isEmpty ? "Name is required" : null,
                ),
                const SizedBox(height: 20),

                // Phone number field
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (v) => v!.isEmpty ? "Phone is required" : null,
                ),
                const SizedBox(height: 20),

                // Email input field
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email Address",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) => !v!.contains('@') ? "Invalid Email" : null,
                ),
                const SizedBox(height: 20),

                // Password input field with visibility toggle
                TextFormField(
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                  ),
                  validator: (v) => v!.length < 6 ? "Min 6 characters" : null,
                ),
                const SizedBox(height: 30),

                // --- Submit Button ---
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Navigate to Verification or Dashboard
                      Navigator.pushNamed(context, '/caregiver_dashboard');
                    }
                  },
                  child: const Text("Create Caregiver Account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}