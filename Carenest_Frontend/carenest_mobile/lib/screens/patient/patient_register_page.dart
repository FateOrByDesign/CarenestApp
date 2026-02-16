import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
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
        title: Text("Patient Sign Up", style: AppTheme.headingMedium),
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
                const Text("Find the perfect care for you.", textAlign: TextAlign.center),
                const SizedBox(height: 30),

                // --- 1. Full Name ---
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Your Name",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) => v!.isEmpty ? "Name is required" : null,
                ),
                const SizedBox(height: 20),

                // --- 2. Phone Number ---
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: (v) => v!.isEmpty ? "Phone is required" : null,
                ),

                // --- 2. Email ---
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email Address",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) => !v!.contains('@') ? "Invalid Email" : null,
                ),
                const SizedBox(height: 20),

                // --- 3. Password ---
                TextFormField(
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: "Create Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                  ),
                  validator: (v) => v!.length < 6 ? "Min 6 characters" : null,
                ),
                const SizedBox(height: 30),

                // --- 4. Submit Button ---
                ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.surface,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, '/patient_dashboard');
                    }
                  },
                  child: const Text("Create Patient Account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}