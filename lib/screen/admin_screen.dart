import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:my_trip_controle_panel/screen/places.dart';
import 'package:my_trip_controle_panel/screen/restaurants.dart';
import 'package:my_trip_controle_panel/screen/splash_screen.dart';
import 'package:my_trip_controle_panel/style/appbar.dart';
import 'package:my_trip_controle_panel/style/background.dart';
import 'package:my_trip_controle_panel/style/drawer.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> futureBuilder;

  @override
  void initState() {
    super.initState();
    futureBuilder = getUsers();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUsers() async {
    User user = FirebaseAuth.instance.currentUser!;
    String userId = user.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(userId)
        .collection('information')
        .doc(userId)
        .get();

    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: futureBuilder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: const Text('خطأ'),
              content: Text('الخطأ هو: ${snapshot.error}'),
            );
          } else if (snapshot.data == null) {
            return const AlertDialog(
              title: Text('خطأ'),
              content: Text('لا يوجد بيانات'),
            );
          } else {
            String email = snapshot.data!['email'];
            String username = snapshot.data!['username'];
            String imageuser = snapshot.data!['image'];
            return Scaffold(
              drawer: DrawerStyle(
                email: email,
                username: username,
                image: imageuser,
              ),
              appBar: const StyleAppBar(title: 'صفحة الآدمن'),
              body: Background(
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'My Trip',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset(
                            'assets/image/logoApp.png',
                            width: 220,
                            height: 220,
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Places(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  padding: const EdgeInsets.all(16),
                                  shape: const CircleBorder(),
                                  foregroundColor:
                                      const Color.fromARGB(255, 0, 0, 0)),
                              child: const Text(
                                'الأماكن',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Restaurants(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  padding: const EdgeInsets.all(16),
                                  shape: const CircleBorder(),
                                  foregroundColor:
                                      const Color.fromARGB(255, 0, 0, 0)),
                              child: const Text(
                                'المطاعم',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
