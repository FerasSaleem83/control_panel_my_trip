// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_trip_controle_panel/screen/auth_screen.dart';
import 'package:my_trip_controle_panel/screen/login_screen.dart';
import 'package:my_trip_controle_panel/style/appbar.dart';
import 'package:my_trip_controle_panel/style/background.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StyleAppBar(title: 'انشاء حساب جديد'),
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
                      width: 250,
                      height: 250,
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
                        labelText: 'اسم المستخدم',
                        hintText: 'ادخل اسم المستخدم',
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
                      controller: usernameController,
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى ادخال اسم مستخدم صحيح';
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
                          width: 24.0, // Adjust the width as needed
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
                    RadioListTile<UserType>(
                      title: const Text(
                        'مستخدم',
                        style: TextStyle(color: Colors.black),
                      ),
                      activeColor: const Color.fromARGB(255, 0, 179, 255),
                      value: UserType.user,
                      groupValue: userType,
                      onChanged: (value) {
                        setState(() {
                          userType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    RadioListTile<UserType>(
                      title: const Text(
                        'ادمن',
                        style: TextStyle(color: Colors.black),
                      ),
                      activeColor: const Color.fromARGB(255, 0, 179, 255),
                      value: UserType.admin,
                      groupValue: userType,
                      onChanged: (value) {
                        setState(() {
                          userType = value!;
                        });
                      },
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
                        child: const Text('انشاء حساب'),
                      ),
                    if (!isUploading)
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'لدي حساب بالفعل',
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
  bool isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool isUploading = false;
  UserType? userType;

  void submit() async {
    final valid = formKey.currentState!.validate();
    if (!valid) {
      return;
    }

    try {
      setState(() {
        isUploading = true;
      });
      if (userType == UserType.admin) {
        final UserCredential userCredential =
            await firebase.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .collection('information')
            .doc(userCredential.user!.uid)
            .set({
          'userId': userCredential.user!.uid,
          'username': usernameController.text.trim(),
          'image':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/User_icon-cp.svg/828px-User_icon-cp.svg.png',
          'email': emailController.text.trim(),
          'type': 'admin'
        });
        await userCredential.user!.sendEmailVerification();

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 38, 35, 35),
            title: const Text(
              'نجح',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            content: const Text(
              'تم تسجيل الحساب بنجاح. يرجى التحقق من بريدك الإلكتروني لإكمال التسجيل',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'حسنًا',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        );

        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
        );
      } else {
        final UserCredential userCredential =
            await firebase.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .collection('information')
            .doc(userCredential.user!.uid)
            .set({
          'userId': userCredential.user!.uid,
          'username': usernameController.text.trim(),
          'image':
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/User_icon-cp.svg/828px-User_icon-cp.svg.png',
          'email': emailController.text.trim(),
          'type': 'user'
        });

        // Send email verification
        await userCredential.user!.sendEmailVerification();

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: const Color.fromARGB(255, 38, 35, 35),
            title: const Text(
              'نجح',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            content: const Text(
              'تم تسجيل الحساب بنجاح. يرجى التحقق من بريدك الإلكتروني لإكمال التسجيل',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.black,
                ),
                child: const Text(
                  'حسنًا',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        );
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
        );
      }
    } catch (e) {
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
              onPressed: () {
                Navigator.of(context).pop();
              },
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

      setState(() {
        isUploading = false;
      });
    }
  }
}

enum UserType { user, admin }
