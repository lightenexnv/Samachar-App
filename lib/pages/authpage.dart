import 'package:flutter/material.dart';
import 'package:newsapp/controllers/auth_controller.dart';
import 'package:newsapp/pages/newsPage.dart';
import 'package:newsapp/pages/phoneauthpage.dart';

import 'WelcomePage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isPasswordVisible = false;
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final controller = AuthController();

  void login() async {
    try {
      final user = await controller.login(
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
      );

      if (user != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => newsPage()),
                (route) => false,
          );
        });
      }
    } catch (e) {
      debugPrint("Login error: $e");
    }
  }

  void signup() async {
    try {
      final user = await controller.register(
        emailCtrl.text.trim(),
        passCtrl.text.trim(),
      );

      if (user != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => newsPage()),
                (route) => false,
          );
        });
      }
    } catch (e) {
      debugPrint("Signup error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.blue,
        child: SafeArea(
          child: DefaultTabController(
            length: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IconButton(
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> WelcomePage())),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const TabBar(
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: "Login"),
                        Tab(text: "Signup"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _loginTab(context),
                        _signupTab(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginTab(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          _inputField("Email",controller: emailCtrl),
          const SizedBox(height: 16),
          _inputField("Password",controller: passCtrl ,isPasswordVisible: true),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
            GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> phoneAuth()));
                },
                child: Text("Login With Phone Number",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),))
          ],),
          const SizedBox(height: 10),
          Hero(
            tag: 'auth-button',
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: login,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signupTab(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Signup",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          _inputField("Email",controller: emailCtrl),
          const SizedBox(height: 16),
          _inputField("Password",controller: passCtrl,isPasswordVisible: true),
          const SizedBox(height: 30),
          Hero(
            tag: 'auth-button',
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: signup,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(
                      "Signup",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(String hint, {required TextEditingController controller, bool isPasswordVisible = false}) {
    return TextField(
      controller: controller,
      obscureText: isPasswordVisible ? !_isPasswordVisible : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        suffixIcon: isPasswordVisible
            ? IconButton(
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_off
                : Icons.visibility,
            color: Colors.white,
          ),
        )
            : null,
      ),
    );
  }
}
