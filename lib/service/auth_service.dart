import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

      return result.user;
    }on FirebaseAuthException catch(e){
      print('❌ Login Error: ${e.code} - ${e.message}');
    }
  }

  Future<User?> phoneLogin(String phoneNumber, Function(String verificationId) onCodeSent) async{
    try{
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (_){

          }
          , verificationFailed: (e){
            print("Error Came");
      }
          , codeSent: (String verificationId, int? token){
        onCodeSent(verificationId);
      }
          , codeAutoRetrievalTimeout: (e){
            print("Error CAme");
      });

          return null;
    }on FirebaseAuthException catch(e){
      print('Login Error Came: ${e.code}, ${e.message}');

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

  Future<User?> verifyOtp(
      String verificationId,
      String smsCode,
      ) async {

  }

}