import 'auth_result.dart';

class AuthService {
  static Future<AuthResult> login(String username, String password) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // 🔹 TEMP FRONTEND LOGIN
    if (username == "perera" && password == "12345") {
      return AuthResult.success(
        caregiverName: "Perera",
        token: "dummy_token_123",
      );
    }

    return AuthResult.failure(message: "Invalid username or password");
  }
}
