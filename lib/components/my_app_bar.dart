import 'package:flutter/material.dart';

// implement preferredSizedWidget for reuseable AppBar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  const MyAppBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      elevation: 5,
      title: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      centerTitle: true,
    );
  }

// define a valuw for the size
// kToolbarHeight is a constant that represents the default height of an app bar.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
