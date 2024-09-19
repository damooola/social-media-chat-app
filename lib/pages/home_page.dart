import 'package:flutter/material.dart';
import 'package:sm_chatapp/services/auth/auth_service.dart';
import 'package:sm_chatapp/services/chat/chat_service.dart';

import '../components/my_drawer.dart';
import '../components/my_user_tile.dart';
import 'chat_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // initialise chat and auth servyies
  final AuthService authService = AuthService();
  final ChatService chatService = ChatService();

  void tapUserTile(BuildContext context, Map<String, dynamic> userData) {
    Navigator.push(
        context,
        //go to chat page
        MaterialPageRoute(
          builder: (context) => ChatPage(
            receiverEmail: userData["email"],
            receiverID: userData["uid"],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 5,
        title: Text(
          "Home",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        currentUserEmail: authService.getCurrentUser()!.email!,
      ),
      body: _buildUserList(),
    );
  }

  // build a list of users except for current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
        stream: chatService.getUsersStream(),
        builder: (context, snapshot) {
          // see is there is erorrs
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading..."));
          }
          // use a listview builder instead
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final userData = snapshot.data![index];
              return _userListItem(userData, context);
            },
          );
          //alternative way of displaying the list of users by using a listview
          /* return ListView(
            children: snapshot.data!
                .map<Widget>(
                     (userData) => _buildUserListItem(userData, context))
                 .toList(),
           ); */
        });
  }

// individual user tile for users
  Widget _userListItem(Map<String, dynamic> userData, BuildContext context) {
    // display all users except current user
    if (userData["email"] != authService.getCurrentUser()!.email) {
      return MyUserTile(
        text: userData["email"],
        //tap user tile
        onTap: () => tapUserTile(context, userData),
      );
    } else {
      return Container();
    }
  }
}
