class AuthResult {
  /// Indicates whether authentication was successful
  final bool success;

  /// Caregiver name returned after successful login
  final String? caregiverName;

  /// Authentication token (for future backend integration)
  final String? token;

  /// Error message if login fails
  final String? message;

  AuthResult({
    required this.success,
    this.caregiverName,
    this.token,
    this.message,
  });

  /// Factory constructor for success response
  factory AuthResult.success({
    required String caregiverName,
    required String token,
  }) {
    return AuthResult(
      success: true,
      caregiverName: caregiverName,
      token: token,
    );
  }

  /// Factory constructor for failure response
  factory AuthResult.failure({required String message}) {
    return AuthResult(success: false, message: message);
  }
}
