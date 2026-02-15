import 'package:flutter/material.dart';
import 'package:newsapp/controllers/auth_controller.dart';

class phoneAuth extends StatefulWidget {
  phoneAuth({super.key});

  @override
  State<phoneAuth> createState() => _phoneAuthState();
}


class _phoneAuthState extends State<phoneAuth> {

  void login() async {
    if (verificationId == null) {
      await controller.phoneLogin(
        phnCtrl.text,
            (verId) {
          setState(() {
            verificationId = verId;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP Sent")),
          );
        },
      );
    } else {
      final user = await controller.verifyOtp(
        verificationId!,
        otpCtrl.text,
      );

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful")),
        );
      }
    }
  }

  final controller = AuthController();
  final phnCtrl = TextEditingController();
  final otpCtrl = TextEditingController();

  String? verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.blue,
        child: SafeArea(child: Padding(padding: const EdgeInsets.all(24),child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IconButton(
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context)
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  Text("Login",style:
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),),
                  const SizedBox(height: 30),
                  _inputField("Phone Number", controller: phnCtrl),
                  const SizedBox(height: 16),
                  _inputField("Enter Otp", controller: otpCtrl),
                  const SizedBox(height: 10),
                  Hero(
                    tag: 'auth-button',
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: (){
                          login();
                        },
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
              )
            ],
          ),)),
      ),
    );
  }
}

Widget _inputField(String hint, {required TextEditingController controller}) {
  return TextField(
    controller: controller,
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
    ),
  );
}
