// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_trip_controle_panel/screen/auth_screen.dart';
import 'package:my_trip_controle_panel/screen/signup_screen.dart';
import 'package:my_trip_controle_panel/style/appbar.dart';
import 'package:my_trip_controle_panel/style/background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StyleAppBar(
        title: 'تسجيل الدخول',
      ),
      body: Background(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/image/logoApp.png',
                      width: 350,
                      height: 350,
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'البريد الالكتروني',
                        hintText: 'ادخل البريد الالكتروني',
                        fillColor: Colors.grey[100],
                        filled: true,
                        alignLabelWithHint: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 20,
                        ),
                      ),
                      controller: emailController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'يرجى ادخال البريد الالكتروني صحيح';
                        }
                        return null;
                      },
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        hintText: 'ادخل كلمة المرور',
                        fillColor: Colors.grey[100],
                        filled: true,
                        alignLabelWithHint: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 20,
                        ),
                        suffixIcon: SizedBox(
                          width: 24.0,
                          child: Align(
                            child: IconButton(
                              iconSize: 15,
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: isPasswordVisible
                                    ? const Color.fromARGB(255, 82, 177, 255)
                                    : const Color.fromARGB(255, 126, 126, 132),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى ادخال كلمة المرور صحيحة';
                        }
                        return null;
                      },
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isUploading)
                      const CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    if (!isUploading)
                      ElevatedButton(
                        onPressed: submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 92, 122, 205),
                          textStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Text('تسجيل دخول'),
                      ),
                    if (!isUploading)
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'ليس لدي حساب',
                          style: TextStyle(
                            color: Color.fromARGB(255, 78, 116, 255),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseAuth firebase = FirebaseAuth.instance;
  bool islogin = false;
  bool isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isUploading = false;

  void submit() async {
    final valid = formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    try {
      setState(() {
        isUploading = true;
      });
      await firebase.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
      );

      setState(() {
        isUploading = false;
      });
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 38, 35, 35),
          title: const Text(
            'خطأ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
            ),
          ),
          content: const Text(
            'حدث خطأ في التحقق',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 83, 0, 0),
                foregroundColor: Colors.black,
              ),
              child: const Text(
                'حسناً',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      );
    }
  }
}
