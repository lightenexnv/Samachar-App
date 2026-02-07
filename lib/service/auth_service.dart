import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUp(String email , String password) async{
    try{
      final UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      return result.user;
    }on FirebaseAuthException catch(e){
      print("");
    }
  }

  Future<User?> login(String email, String password) async {
    try{
      final UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(e){
      print('❌ Login Error: ${e.code} - ${e.message}');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      print('✅ User logged out successfully');
    } catch (e) {
      print('❌ Logout Error: $e');
    }
  }
}