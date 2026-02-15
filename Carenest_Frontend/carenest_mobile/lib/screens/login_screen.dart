import 'package:flutter/material.dart';
import '../core/app_theme.dart'; // importing the custom theme 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Key to track the form state (for validation)
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture user typing
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isObscure = true; // To toggle password visibility

  void _handleLogin() {
    // Check if the form is valid (Calls the 'validator' functions below)
    if (_formKey.currentState!.validate()) {

      // Simulate a successful login action
      print("Email is valid: ${_emailController.text}");
      print("Password: ${_passController.text}");

      // Navigate to the Gatekeeper (which decides Caregiver vs Patient)
      Navigator.pushReplacementNamed(context, '/dashboard_gate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the background color from the Theme
      backgroundColor: AppTheme.background,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey, // Attach the key here
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Icon at the top (using a built-in icon for simplicity)
                  const Icon(
                    Icons.health_and_safety,
                    size: 80,
                    color: AppTheme.primary, // Uses Teal color
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Welcome Back",
                    textAlign: TextAlign.center,
                    style: AppTheme.headingLarge, // Uses Poppins Bold
                  ),
                  Text(
                    "Sign in to continue to CareNest",
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyText, // Uses Grey Inter text
                  ),
                  const SizedBox(height: 40),

                  // Email Input Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    // The Theme automatically styles this!
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      hintText: "example@email.com",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    // VALIDATION LOGIC HERE:
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Email must contain "@" sign';
                      }
                      return null; // Valid!
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Input with visibility toggle
                  TextFormField(
                    controller: _passController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/reset_password'),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Login Button (uses the ElevatedButton style from AppTheme)
                  ElevatedButton(
                    onPressed: _handleLogin,
                    // The style is automatically pulled from AppTheme
                    child: const Text("Login"),
                  ),

                  const SizedBox(height: 24),

                  // Registration Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: AppTheme.bodyText),
                      GestureDetector(
                        // Navigate to the Role Selection page for new users
                        onTap: () => Navigator.pushNamed(context, '/role_select'),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins', // Matches your theme font
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}