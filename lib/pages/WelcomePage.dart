import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapp/main.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/pages/newsPage.dart';
import 'package:newsapp/controllers/auth_controller.dart';
import 'authpage.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            const Text(
              "To Neil Samachar🖐️",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white
              ),
            ),
            const SizedBox(height: 10),

            Hero(
              tag: 'news-button',
              child: Material(
                color: Colors.blue,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      final user = FirebaseAuth.instance.currentUser;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => user == null ? const AuthPage() : const newsPage(),
                        ),
                      );
                    },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "Start Exploring",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
