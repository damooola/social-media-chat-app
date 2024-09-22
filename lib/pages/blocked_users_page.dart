import 'package:flutter/material.dart';
import 'package:sm_chatapp/components/my_app_bar.dart';
import 'package:sm_chatapp/components/my_user_tile.dart';
import 'package:sm_chatapp/services/auth/auth_service.dart';
import 'package:sm_chatapp/services/chat/chat_service.dart';

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});

  final chatService = ChatService();
  final authService = AuthService();

  //unblock user dialog
  void _showUnBlockUserBox(BuildContext context, String blockedUserID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Unblock User"),
        content: const Text("Are you sure you want to unblock this user?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              )),
          TextButton(
              onPressed: () {
                chatService.unblockUser(blockedUserID);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User unblocked!")));
              },
              child: Text(
                "Unblock",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // get current user id
    final currentUserID = authService.getCurrentUser()!.uid;

    return Scaffold(
      appBar: const MyAppBar(text: "Blocked Users"),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService.getBlockedUserstream(currentUserID),
        builder: (context, snapshot) {
          // error handling
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }

          // loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: Center(
              child: CircularProgressIndicator(),
            ));
          }

          final blockedUsers = snapshot.data ?? [];
          //no blocked users
          if (blockedUsers.isEmpty) {
            return const Center(
              child: Text("No blocked users"),
            );
          }

          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return MyUserTile(
                  text: user["email"],
                  onTap: () => _showUnBlockUserBox(context, user["uid"]));
            },
          );
        },
      ),
    );
  }
}
