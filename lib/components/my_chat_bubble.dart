import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_chatapp/services/chat/chat_service.dart';
import 'package:sm_chatapp/themes/theme_provider.dart';

class MyChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageID;
  final String userID;
  const MyChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.messageID,
      required this.userID});

  //show options
  void _showOptions(BuildContext context, String messageID, String userID) {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            //report message button
            ListTile(
              title: const Text("Report"),
              leading: const Icon(Icons.flag),
              onTap: () {
                Navigator.pop(context);
                _reportMessage(context, messageID, userID);
              },
            ),
            //block user button
            ListTile(
              title: const Text("Block"),
              leading: const Icon(Icons.block),
              onTap: () {
                Navigator.pop(context);
                _blockUser(context, userID);
              },
            ),
            //cancel button
            ListTile(
              title: const Text("Cancel"),
              leading: const Icon(Icons.cancel),
              onTap: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  //report message
  void _reportMessage(BuildContext context, String messageID, String userID) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Report Message"),
              content:
                  const Text("Are you sure you want to report this message?"),
              actions: [
                // cancel button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    )),

                // report button
                TextButton(
                    onPressed: () {
                      ChatService().reportUser(messageID, userID);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Message Reported")));
                    },
                    child: Text(
                      "Report",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    )),
              ],
            ));
  }

  //block user
  void _blockUser(BuildContext context, String userID) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Block User"),
              content: const Text("Are you sure you want to block this user?"),
              actions: [
                // cancel button
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    )),

                // block button
                TextButton(
                    onPressed: () {
                      // block user
                      ChatService().blockUser(userID);
                      // dismiss the dialog box
                      Navigator.pop(context);
                      // dismiss the chat page
                     Navigator.pop(context);
                      // inform user after block
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User Blocked!")));
                    },
                    child: Text(
                      "Block",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    )),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          // show options
          _showOptions(context, messageID, userID);
        }
      },
      child: Container(
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
      ),
    );
  }
}
