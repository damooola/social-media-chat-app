import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_chatapp/themes/theme_provider.dart';

class MyChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const MyChatBubble(
      {super.key, required this.message, required this.isCurrentUser});
  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      decoration: BoxDecoration(
          color: isCurrentUser
              ? isDarkMode
                  ? Colors.green.shade600
                  : Colors.green.shade500
              : isDarkMode
                  ? Colors.blue.shade600
                  : Colors.blue.shade300,
          borderRadius: BorderRadius.circular(12)),
      child: Text(
        message,
        style: TextStyle(
            color: isCurrentUser
                ? Theme.of(context).colorScheme.tertiary
                : isDarkMode
                    ? Theme.of(context).colorScheme.tertiary
                    : Colors.black),
      ),
    );
  }
}
