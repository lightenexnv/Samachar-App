import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';

class AuthController {
  final AuthService _service = AuthService();

  Future<User?> register(String email, String password)async{
    return await _service.signUp(email, password);
  }

  Future<User?> login(String email, String password) async{
    return await _service.login(email, password);
  }

  Future<void> logout() async {
    await _service.logout();
  }
}