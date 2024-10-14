import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerStyle extends StatefulWidget {
  final String email;
  final String username;
  final String image;

  const DrawerStyle({
    super.key,
    required this.email,
    required this.username,
    required this.image,
  });

  @override
  State<DrawerStyle> createState() => _DrawerStyleState();
}

class _DrawerStyleState extends State<DrawerStyle> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color.fromARGB(154, 167, 167, 185),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              child: Container(
                color: const Color.fromARGB(255, 42, 42, 42),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.image),
                        radius: 90,
                        backgroundColor: const Color.fromARGB(255, 20, 1, 119),
                      ),
                      const SizedBox(height: 15),
                      ListTile(
                        title: Text(
                          widget.username,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ListTile(
                        title: Text(
                          widget.email,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            ListTile(
              title: TextButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.home,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                label: const Text(
                  'الصفحة الرئيسية',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            ListTile(
              title: TextButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                label: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
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
