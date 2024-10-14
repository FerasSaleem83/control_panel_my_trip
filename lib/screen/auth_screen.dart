import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_trip_controle_panel/screen/admin_screen.dart';
import 'package:my_trip_controle_panel/screen/login_screen.dart';
import 'package:my_trip_controle_panel/screen/splash_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUsers() async {
    User? user = FirebaseAuth.instance.currentUser;

    String userId = user!.uid;
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('information')
        .where('email', isEqualTo: user.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SplashScreen();
                  } else if (snapshot.hasError) {
                    return AlertDialog(
                      content: Text('error ${snapshot.error}'),
                    );
                  } else if (!FirebaseAuth
                      .instance.currentUser!.emailVerified) {
                    return AlertDialog(
                      title: const Text('خطأ'),
                      content: const Text(
                          'يرجى التحقق من بريدك الإلكتروني لإكمال التسجيل.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text('تم'),
                        ),
                      ],
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data!.docs.isNotEmpty) {
                    final userType = snapshot.data!.docs.first['type'];
                    if (userType == 'admin') {
                      return const AdminPage();
                    } else {
                      return AlertDialog(
                        title: const Text('خطأ'),
                        content: const Text('لا يوجد بيانات'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('تم'),
                          ),
                        ],
                      );
                    }
                  } else {
                    return const SplashScreen();
                  }
                },
              ),
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
