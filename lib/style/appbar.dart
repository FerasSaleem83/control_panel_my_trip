import 'package:flutter/material.dart';

class StyleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? actionBar;
  const StyleAppBar({super.key, required this.title, this.actionBar});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color.fromARGB(255, 38, 35, 35),
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      actions: actionBar != null ? [actionBar!] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
